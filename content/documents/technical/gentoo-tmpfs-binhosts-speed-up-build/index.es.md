---
title: "Instalar paquetes más rápido en Gentoo con tmpfs y binhosts"
slug: documentos/tecnicos/gentoo-tmpfs-binhosts-acelerar-compilacion
date: 2023-03-27T11:17:20+02:00
tags: [gentoo,linux,floss]
images: [/por-que-gentoo/gentoo-logo.svg]
summary: Cómo usar tmpfs y binhosts para que los paquetes se instalen más rápido en Gentoo
showtoc: True
---
No voy a hablar de métodos ya ampliamente conocidos y documentados como [distcc](https://wiki.gentoo.org/wiki/Distcc/es) y [ccache](https://wiki.gentoo.org/wiki/Ccache). Ya están documentados en la documentación oficial de Gentoo y no hay razón para repetir lo mismo aquí.

Además, desde mi punto de vista, el proceso para activar esas características no es simple y el resultado no hace que compense.

## tmpfs

Hay otra forma no oficial y no tan documentada de acelerar las compilaciones: usar [tmpfs](https://es.wikipedia.org/wiki/Tmpfs) para el directorio de compilación ([`PORTAGE_TMPDIR`](https://wiki.gentoo.org/wiki//etc/portage/make.conf#PORTAGE_TMPDIR)). tmpfs usa la memoria RAM como un sistema de ficheros, lo que permite accesos mucho más rápidos. Como el acceso a disco es una de las cosas que más impacto tienen en los tiempos de compilación, cambiar estos accesos a memoria RAM consigue una importante mejora en los tiempos de compilación de manera bastante simples.

Los pasos necesarios son bastante sencillos:

1. Añadir una nueva entrada en `/etc/fstab` que monta un nuevo sistema de ficheros `tmpfs` que será el que usaremos para compilar paquetes:
   ```
   tmpfs /var/tmp/portage-tmpfs  tmpfs size=4G,mode=775,gid=portage,uid=portage
   ```
   El valor que ponemos en `size` es el tamaño que tendrá ese nuevo sistema de ficheros, lo que limitará el tamaño de los paquetes que se pueden compilar en ese sistema de ficheros (más sobre esto más adelante).
2. Montar el nuevo sistema de ficheros:
   ```
   mount /var/tmp/portage-tmpfs
   ```
3. Cambiar el valor de `PORTAGE_TMPDIR` en `/etc/portage/make.conf` para que use el nuevo sistema de ficheros:
   ```
   PORTAGE_TMPDIR=/var/tmp/portage-tmpfs
   ```

Eso es todo. A partir de ahora, los paquetes que se compilen con Portage usaran `tmpfs` con un notable incremento de velocidad.

### Excepciones

Sin embargo, como mencioné en el primer paso, el tamaño de los paquetes que podemos compilar en `tmpfs` estará limitado por el tamaño que proporcionemos en el parámetro `size`, lo que puede no ser suficiente para los paquetes más grandes como `dev-qt/qtwebengine`, `dev-lang/mono` o `dev-lang/spidermonkey`.

Para solucionar eso, podemos añadir una excepción para que determinados paquetes sigan usando el disco duro en vez de `tmpfs` usando `package.env`:

1. Creamos un nuevo fichero `/etc/portage/env/notmpfs` que restablece `PORTAGE_TMPDIR` a su valor original en el disco duro en vez del nuevo directorio en `tmpfs`:
   ```
   PORTAGE_TMPDIR=/var/tmp/portage
   ```
2. En otro fichero `/etc/portage/package.env/notmpfs` listamos los paquetes que queremos que usen las variables de entorno del fichero `notmpfs` del paso anterior:
   ```
   app-office/libreoffice notmpfs
   app-emulation/virtualbox notmpfs
   dev-lang/mono notmpfs
   dev-lang/rust notmpfs
   dev-lang/spidermonkey notmpfs
   dev-qt/qtwebengine notmpfs
   www-client/firefox notmpfs
   ```

Listo. Esos paquetes usarán un directorio distinto para compilar.

## Paquetes binarios

Otra cosa que podemos hacer para acelerar la instalación de paquetes es, simplemente, no compilarlos.

Aunque una de las principales características de Gentoo es que todos los paquetes se compilan y no se ofrecen paquetes precompilados oficialmente, sin embargo ofrece también la posibilidad de generar paquetes binarios con los paquetes que se compilan de forma que puedan ser reutilizados.

Esto es útil por ejemplo si usas Gentoo en varias máquinas parecidas o que usan la misma arquitectura, de forma que los paquetes se compilarían solo en una de las máquinas y se reutilizarían en las demás. Sin embargo, los paquetes pueden no ser reutilizables si los [USE flags](https://wiki.gentoo.org/wiki/USE_flag) o dependencias cambian entre máquinas.

Para más información, consulta la documentación oficial sobre [paquetes binarios en Gentoo](https://wiki.gentoo.org/wiki/Binary_package_guide/es).

Además, puedes evitar totalmente la compilación de paquetes si usas un binhost o repositorio de paquetes binarios, pero tenemos que estar seguros de que es un repositorio de confianza en el que los paquetes compilados no han sido modificados con código malicioso. Además, algunos paquetes podrían estar compilados con opciones incompatibles con tu sistema como una versión más nueva de glibc o distinto [CHOST](https://wiki.gentoo.org/wiki/CHOST).

### Lista de repositorios binarios

Algunos repositorios disponibles para la arquitectura AMD64:

* Aunque todavía está en pruebas, Gentoo ofrece un [repositorio de paquetes binarios](https://gentoo.osuosl.org/experimental/amd64/binpkg/default/linux/17.1/x86-64/).
* [Pentoo](https://pentoo.osuosl.org/Packages/)
* [Redcore Linux](http://mirrors.redcorelinux.org/redcorelinux/amd64/packages/)
* [Calculate Linux](https://mirror.calculate-linux.org/)
* Yo también tengo [mi propio binhost](https://binpkgs.chuso.net/amd64/)
* [f1r.eu](https://tbz.f1r.eu/packages/seed-lxc-pdns/). No sé realmente quién mantiene estos repositorios y algunos de ellos están compilados con una version de `sys-libs/glibc` en `~amd64`, así que úsalos con cuidado

Para ARM64 no conozco ningún otro repositorio binario más que [el mío propio](https://binpkgs.chuso.net/arm64/) que actualizo cuando compilo [Pinetoo](http://pinetoo.org) para el PinePhone.
