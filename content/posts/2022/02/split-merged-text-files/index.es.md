---
title: "Partiendo varios ficheros de texto que habían sido unidos en un único fichero"
slug: partir-ficheros-texto-unidos
date: 2022-02-27T21:25:54+01:00
categories: [sysadmin]
tags: [bash]
summary: Cómo partir otra vez usando herramientas POSIX unos ficheros de texto que habían sido unidos en un único fichero.
---

Recientemente le pedí a un cliente que me enviara unos ficheros de <i lang="en">log</i> de varios servidores para investigar un problema y lo que hicieron fue algo como esto:

```bash
for h in host1 host2 host3
do
    echo $h
    ssh $h cat /var/log/application.log
done > log_bundle.txt
```

Así que el resultado es un único gran fichero de texto con contenidos como:

```
[contenidos del log de host1]
Connection to host1 closed.
[contenidos del log de host2]
Connection to host2 closed.
[contenidos del log de host3]
Connection to host3 closed.
```

Y así para decenas de <i lang="en">hosts</i>.

Por suerte, cada porción del fichero que venía de un equipo distinto terminaba con línea de [`ssh`](https://www.unix.com/man-page/posix/1/ssh/) "<span lang="en">Connection to host<em>N</em> closed</span>" que permite saber dónde termina cada uno de los ficheros unidos.

Aún así, este resultado no era práctico porque el problema que necesitaba investigar afectaba a distintos componentes a lo largo de varios <i lang="en">hosts</i> y necesitaba ser capaz de usar [`grep`](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/grep.html) con cada fichero individualmente para ver dónde apareció el problema y seguir su pista a través de varios componentes y equipos y abrir sus logs por separado para cruzar las referencias.

Así que, en conclusión, necesitaba _desunir_ los ficheros que habían sido unidos en un único fichero de texto.

Por suerte, la línea marcando cuándo la conexión SSH se cerraba me permitió encontrar dónde terminaba cada uno de los ficheros unidos y encontré esta solución para desunir los ficheros usando un sencillo <i lang="en">script</i> de Bash:

```bash
#!/usr/bin/env bash

# Esta variable establece el número de línea del fichero original
# en el que buscaremos cada fichero. Empezamos en la línea 1.
offset=1
# Buscar la siguiente línea que indica que una conexión SSH fue
# terminada empezando desde $offset.
# Esto devolverá la línea encontrada prefijada con el número de línea.
# El parámetro `-m1` es una extensión GNU de `grep` indicando que
# la búsqueda terminará tras la primera coincidencia.
# Para una alternativa estrictamente POSIX, se puede eliminar `m1`
# y redirigir la salida de grep a `head -n1`:
# file_end=$(tail -n +$offset merged.log | grep -n "^Connection to .* closed.$" | head -n1)
file_end=$(tail -n +$offset merged.log | grep -nm1 "^Connection to .* closed.$")
# Empezaar el bucle que itera sobre el fichero y parte sus
# contenidos hasta que no se encuentran más líneas que indican
# el final de una conexión SSH.
while [ -n "$file_end" ]
do
    # De la salida devuelta por grep, extraer el número de línea
    # a una variable
    end_line=$(echo "$file_end" | cut -d : -f 1)
    # De la salida devuelta por grep, extraer el nombre de host
    # SSH a otra variable
    hostname=$(echo "$file_end" | cut -d \  -f 3)
    # Extraer la porción del fichero original entre $offset y
    # $end_line a otro fichero
    tail -n +$offset merged.log | head -n $((end_line-1)) > "$hostname.log"
    # Sumar $end_line a $offset para avanzar a la siguiente porción
    # del fichero original
    offset=$((offset+end_line))
    # Y buscar dónde termina buscando la siguiente línea de
    # conexión SSH terminada
    file_end=$(tail -n +$offset merged.log | grep -nm1 "^Connection to .* closed.$")
done
```
