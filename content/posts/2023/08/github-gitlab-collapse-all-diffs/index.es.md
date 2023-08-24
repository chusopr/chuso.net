---
title: "Plegar todos los bloques de código en Github o GitLab"
slug: github-gitlab-colapsar-diffs
date: 2023-08-24T15:57:05+02:00
categories: [web-development]
tags: [github,gitlab,javascript,git]
images: [/github-gitlab-colapsar-diffs/browser-bookmark-edit.png]
summary: Cómo plegar todos los bloques de código en Github o GitLab al ver el listado de cambios entre versiones
---
Reviso muy a menudo las diferencias entre versiones de un proyecto en Github o GitLab para revisar los cambios introducidos en una nueva versión, pero muchas veces solo estoy interesado en los cambios en un determinado tipo de ficheros. Por ejemplo, en los cambios introducidos en las dependencias de la nueva versión para saber cómo empaquetar el proyecto para Gentoo.

Esto hace que sea bastante incómodo ver diferencias muy largos que tienen cambios en muchos ficheros cuando yo solo estoy interesado en los cambios en un par de tipos de ficheros y el resto no me interesan.

Me resultaría muy práctico que se pudieran mostrar todos los cambios inicialmente plegados para yo ir revisando rápidamente los ficheros que se han cambiado y desplegar solo aquellos que me interesan.

Hay múltiples peticiones a GitLab para que esto mismo sea implementeado, pero aparentemente, es muy difícil o casi imposible.

Así que me he buscado mi propia forma de hacerlo con un <i lang="en">bookmarklet</i> en el navegador.

Un <i lang="en">bookmarklet</i> es un marcador en el navegador que tiene un código JavaScript que lleva a cabo alguna acción:

{{< figure src="github-gitlab-colapsar-diffs/browser-bookmark-edit.png" caption="Ejemplo de un bookmarklet que ejecuta un código JavaScript" alt="Una captura de la pantalla de edición de un marcador del navegador. En el nombre del marcador pone \"GitLab collapse all diffs\" y en el enlace del marcador pone la palabra \"javascript\" en minúsculas seguida de dos puntos y un código JavaScript" >}}

Usando los siguientes códigos JavaScript en un marcador del navegador, se puede conseguir una forma sencilla de plegar todos los bloques de código al mostrar diferencias en Github o GitLab de forma que después podamos desplegar manualmente solo las que nos interesan:

<ul>
<li><p>Github</p>
{{< highlight javascript >}}
buttons=document.getElementsByClassName("btn-octicon"); for (var i=0; i<buttons.length; i++) if (buttons[i].getAttribute("aria-expanded") == "true") buttons[i].click(); void(0);
{{< / highlight >}}
</li>
<li><p>GitLab</p>
{{< highlight javascript >}}
void($('.chevron-down').filter(":visible").click());
{{< / highlight >}}
</li>
</ul>

Si vas a usar estos <i lang="en">bookmarklets</i>, no the olvides de añadir <code>javascript:</code> delante del código al añadirlo al marcador del navegador como se muestra más arriba.
