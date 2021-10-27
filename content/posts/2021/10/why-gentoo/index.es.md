---
title: "Por qué elijo Gentoo"
slug: por-que-gentoo
date: 2021-10-27T20:17:24+02:00
categories: [gentoo-linux]
tags: [gentoo,linux,floss]
images: [/por-que-gentoo/gentoo-logo.svg]
summary: Llevo usando Gentoo Linux dede hace 20 años. ¿Por qué? Porque no puedo vivir sin Linux y no he encontrado otra distribución que me guste tanto. Y aquí cuento por qué.
---
Empecé a usar Linux hace 23 años.

Durante los primeros años, estuve usando diferentes distribuciones hasta que tres años después compré una revista de Linux que traía un CD de instalación para una distribución bastante nueva y desconocida llamada Gentoo.

{{< figure src="por-que-gentoo/gentoo-logo.svg" link="https://gentoo.org" class="alignright" width="200" >}}

No tardé en enamorarme de Gentoo e incluso empezar a [contribuir](https://chu.so/gentoo-contribs) poco después.  
Probé otras distribuciones después, pero no ocuparon el lugar de Gentoo en mi corazón todavía.  
Entre otras distribuciones que probé, se encuentra Arch Linux, de la que me gustó la rapidez de su gestor de paquetes (especialmente en comparación con el de Gentoo) y su excelente documentación, pero todavía sigo con Gentoo, lo siento.

Creo que es por su nivel de personalización.  
Mucha gente elige Linux porque le da a los usuarios la posibiidad de hacer muchas elecciones. Como elegir entre KDE, GNOME, XFCE, etc. No puedes hacer elecciones así con Windows o MacOS.  
**Gentoo toma esta libertad para hacer elecciones y la lleva a niveles que otras distribuciones no pueden alcanzar.**
Es una de las pocas distribuciones que todavía permite tener un escritorio totalmente funcional en Linux sin systemd, PulseAudio o NetworkManager, por ejemplo.

La principal forma de conseguir este nivel de personalización es compilando básicamente todo. Mientras otras distribuciones ofrecen todo el software que soportan como paquetes precompilados, Gentoo solo ofrece paquetes precompilados opcionales para software que es muy grande y tarda mucho en compilar, como LibreOffice, Firefox u OpenJDK. Todo lo demás se compila en la máquina del usuario usando el código fuente original. Incluso esos otros paquetes grandes se pueden compilar desde la fuente si el usuario así lo elige.

Pero no lo entendamos mal: el usuario _no_ tiene que descargar y compilar manualmente el código fuente de cada software que usa. Esto lo hace transparentemente el gestor de paquetes y **los pasos necesarios para instalar cualquier software no difieren tanto de los de otras distribuciones.** Así, mientras en distribuciones basadas en RedHat ejecutas `yum install audacity` y en las basadas en Debian `apt-get install audacity` para instalar Audacity, en Gentoo también ejecutas simplemente `emerge audacity` y ese comando se ocupará de descargar el código fuente de Audacity y compilarlo para ti.

El gestor de paquetes de Gentoo y sus utilidades básicas relacionadas me parecen muy maduras y elegantes. El proceso de compilación se ejecuta en un <i lang="en">sandbox</i> asegurándose de que no se realizan acciones peligrosas como parte de la compilación y, como cualquier otro gestor de paquetes, también mantiene un registro de los ficheros instalados y su integridad.  
Incluso su mecanismo para seleccionar alternativas (como la versión de Python por defecto cuando tienes varias instaladas) llamado [eselect](https://wiki.gentoo.org/wiki/Eselect) es más potente y elegante que otros como update-alternatives.

Así que, de nuevo, **¿cuál es la ventaja en compilar el código fuente y cómo hace eso que tu sistema esté más personalizado?**

¡Ese es uno de los principales puntos fuertes de Gentoo! Y también una de sus principales debilidades, pero de esto último hablaré más adelante.

**Al compilar todo desde el código fuente, se puede personalizar cómo se compila. Pero _no_ necesitas conocer las particularidades del sistema de compilación de cada software** y cómo configurarlo. El gestor de paquetes de Gentoo se encarga de todo eso, mayormente usando configuraciones como `CHOST`, `CFLAGS` y `USE` <i lang="en">flags</i> (aunque hay muchas más configuraciones disponibles).

[CHOST](https://wiki.gentoo.org/wiki/CHOST) permite configurar el conjunto de instrucciones de la CPU para el que se optimizará el software compilado. **¿Por qué vas a usar software optimizado para un Pentium cuando tú tienes un Core i7?**

[CFLAGS y otras configuraciones relacionadas](https://wiki.gentoo.org/wiki/CFLAGS) permiten configurar opciones de compilación a bajo nivel que también pueden proporcionar mejoras de rendimiento y seguridad o producir ejecutables más pequeños si esa es tu prioridad.

Pero la parte más interesante son los [USE flags](https://wiki.gentoo.org/wiki/USE_flag). Es lo que permite elegir las características que serán activadas en los paquetes que compiles. La página web de paquetes de Gentoo actualmente [lista](https://packages.gentoo.org/useflags) más de 300 USE flags globales que activan o desactivan determinadas características globalmente y más de 4000 USE flags específicos para determinados paquetes. Eso significa que hay **miles de características que puedes activar o desactivar en un sistema Gentoo.**

La lista incluey cosas como Bluetooth, geolocalización, joystick, NFS, etc.

Por ejemplo, si el dispositivo en el que estás instalando Gentoo no tiene Bluetooth, puedes desactivarlo para todos los paquetes que tienen soporte opcional para Bluetooth. O si no quieres que el software que instalas pueda obtener tu localización, puedes desactivar el USE flag `geolocation` para asegurarte de que esté desactivado en los paquetes que lo soportan.

Los USE flags pueden desactivarse globalmente a nivel de todo el sistema o por paquetes. Así, por ejemplo, puedes activar globalmente el USE flag `joystick` porque juegas a videojuegos y quieres asegurarte de que el soporte para joysticks esté activado, pero puedes desactivar ese USE flag para MPlayer porque quién demonios usa un joystick para controlar MPlayer.

¿Pero **por qué querría alguien desactivar características en el software que instala?** ¿No es mejor cuantas más?

Hay diferentes argumentos para desactivar características que no necesitas::

* **Usabilidad —** a veces, cambiar un USE flag cambia cómo se comporta algún software.
* **Seguridad —** cuantas más características tengas activadas y más dependencias necesites instalar como para soportar esas características, más vectores de ataque estás creando.  
Mientras administraba servidores Linux que usan otras distribuciones, he visto como Qt y ALSA eran instalados como dependencias para instalar Apache ZooKeeper porque alguna dependencia intermedia fue compilada con soporte para Qt y ALSA. ¿Pero para qué querría Qt y ALSA en un servidor?
* **Rendimiento —** cuantas más características actives, más grandes seran los ejecutables y más bibliotecas tendrán que cargar en memoria. Desactivar características que no necesitas ayuda a ahorrar recursos.
* **Espacio —** de nuevo, más características significa ejecutables más grandes y más dependencias consumiendo espacio en disco. ¿Has visto esa instalación de Spidermonkey en tu Linux consumiendeo al menos 1 GB de espacio en disco? Está ahí porque es una dependencia incondicional de PolicyKit, un componente necesario en la mayoría de los escritorios Linux modernos. Pero mis servidores Gentoo no necesitan PolicyKit, así que les desactivo en USE flag `policykit` y ahorro ese GB de espacio consumido por Spidermonkey.

Pero no solo se trata de desactivar, a veces lo que quieres es activar algo que por defecto está desactivado.  
A veces alguna característica está desactivada por defecto por las razones anteriormente mencionadas y porque se usa muy raramente. Pero tal vez tú eres uno de esos raros casos en los que esa característica realmente es usada (como, por ejemplo, digamos que realmente quieres poder controlar MPlayer con un joystick), y por lo tanto quieres activarla.

A veces, activar algunas características significa desactivar otras, así que los mantenedores de la distribución no pueden simplemente activar todo cuando construyen un paquete y alguna decisión tiene que ser tomada. **En otras distribuciones, son los responsables de la distribución los que toman esa decisión en lugar del usuario.** Gentoo permite al usuario hacer esa elección.

Además de esto, Gento ofrece perfiles, que son valores predeterminados para estas configuraciones (que por supuesto el usuario puede posteriormente sobreescribir) dependiendo del tipo de sistema que se está instalando. Hay un perfil para "escritorio GNOME con systemd" que activa todos los USE flags y otras configuraciones relevantes para la mejor experiencia con GNOME y systemd. Y un "perfil de seguridad con SELinux" si eres un paranoico de la seguridad. Incluso se pueden combinar perfiles y hacer uno que sea "seguridad con SELinux y GNOME con systemd", aunque yo diría que combinaciones así son algo más experimentales.

Durante algún tiempo, incluso fue posible usar Gentoo con distintos núcleos, mayormente [FreeBSD](https://wiki.gentoo.org/wiki/Gentoo_FreeBSD) hasta que el proyecto fue abandonado, y todavía hay un proyecto para usar un [sistema Gentoo limitado dentro de otros sistemas operativos](https://wiki.gentoo.org/wiki/Project:Prefix) como Windows, MacOS, Solaris, AIX o Android.

**Así que Gentoo va sobre personalización llevada al extremo.**

Pero, como se avanzó al principio, esto no se consigue sin un par de inconvenientes y puede que ya te hayas dado cuenta de cuáles son.

* El primero es que **la compilación puede fallar.** Aún cuando los desarrolladores de Gentoo prueban que los paquetes compilan correctamente, no pueden probar todos los escenarios posibles. Todas las versiones de todas las dependencias y todas las combinaciones de USE flags y CFLAGS posibles. Por eso **Gentoo no es óptimo para el usuario medio** y requiere un tipo de usuario más avanzado. Porque necesitarás saber cómo diagnosticarlo cuando la compilación falle.

  Por este motivo, Gentoo lleva desde hace algún tiempo con el proyecto [Tinderbox](https://blogs.gentoo.org/ago/2020/07/04/gentoo-tinderbox/) que constantemente compila los paquetes de Gentoo con distintas configuraciones y automaticamente informa cuando alguna compilación falla.
  
  También existen iniciativas como [Redcore](https://distrowatch.com/table.php?distribution=redcore) y [Calculate](https://en.wikipedia.org/wiki/Calculate_Linux) para **hacer Gentoo más asequible para el usuario medio de Linux.**

* El segundo inconveniente es que **compilar lleva tiempo.** Y compilar paquetes grandes como GCC o QtWebEngine lleva _mucho_ tiempo.

  Mientras en Arch Linux puedes instalar cualquier software en question de segundos, en Gentoo normalmente tarda minutos o incluso horas, dependiendo del software. Es un serio inconveniente cuando necesitas ese software _ahora_.

  También ha habido esfuerzos para aliviar la carga de tener que compilar todo, como algunas distribuciones basadas en Gentoo que ofrecen paquetes precompilados, como las difuntas [Ututo](https://en.wikipedia.org/wiki/Ututo) y [Sabayon](https://en.wikipedia.org/wiki/Sabayon_Linux) y las todavía activas [Redcore](https://distrowatch.com/table.php?distribution=redcore) y [Calculate](https://en.wikipedia.org/wiki/Calculate_Linux).

  Desde hace algún tiempo, **Gentoo ya soporta [paquetes precompilados](https://wiki.gentoo.org/wiki/Binary_package_guide)** proporcionando medios para empaquetar los resultados de la compilación y compartirlos entre distintas máquinas para instalarlos como paquetes precompilados. Durante años, fue tarea del usuario construir sus propios repositorios de paquetes precompilados, pero recientemente Gentoo ha empezado a [experimentar](https://dilfridge.blogspot.com/2021/09/experimental-binary-gentoo-package.html) con la idea de un repositorio oficial de paquetes precompilados.

Este reciente proyecto de Gentoo para ofrecer repositorios de paquetes precompilados inicialmente solo proporcionara paquetes para la arquitectura AMD64 con los USE flags predeterminados. Para los demás casos (como, por ejemplo, so quieres cambiar algún USE flag) todavía será necesario compilar los paquetes. Lo cual todavía es un gran avance.

En una entrada posterior veremos cómo mejorar los tiempos de compilación en Gentoo.
