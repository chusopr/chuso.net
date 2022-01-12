---
title: "Aceptar certificados SSL inválidos es incorrecto"
date: 2020-11-18T20:31:24+01:00
categories: [internet,security,software,sysadmin]
slug: aceptar-certificados-ssl-invalidos-incorrecto
tags: [ssl,certificate,brian-krebs,tls]
thumbnail: "/aceptar-certificados-ssl-invalidos-incorrecto/firefox-badssl.png"
---
Dejadme que lo deje claro desde la primera línea: aceptar certificados inválidos es incorrecto.

Y ahora explicaré por qué es incorrecto y por qué hay pocas excusas para ello.

Nos referimos, claro, a los certificados usados para cifrado SSL, el cual sirve dos propósitos:

* *Privacidad* — asegurar que los datos se transfieren cifrados y solo pueden ser descifrados por el destinatario deseado y no por una tercera parte que pueda estar interceptando el tráfico.
* *Autenticación* — asegurar que la parte receptora de los datos que será capaz de descifrarlos es quien dice ser y los datos no son desviados a un destinatario distinto por alguien que sea capaz de manipular nuestro tráfico.

Los certificados inválidos obviamente incumplen el primer proposito de verificar la identidad de la otra parte:

* Si aceptas un certificado autofiramdo o con una firma desconocida, estás aceptando un certificado que podría haber sido generado literalmente por cualquiera. No tienes ninguna seguridad de que los datos los estés enviando a quien dicen ser.
* Si aceptas certificados expirados, estás aceptando certificados que pueden haber sido comprometidos (robados o usando claves obsoletas y débiles que pueden ser rotas).
* Si aceptas certificados que no fueron generados para la organización con la que estás conectando, realmente estás aceptando una suplantación.

Pero la privacidad también se ve afectada ya que no puedes cumplir uno eficazmente si no tienes el otro:

* Si tu conexión no es privada, tus datos son visibles y pueden ser alterados y por lo tanto cualquier método de autenticación puede ser manipulado.
* Si tu conexión no esta autenticada, no puedes confiar en que la otra parte receptora sea quien dice ser y tus datos pueden acabar en las manos equivocadas.

Encuentro incluso incorrecto que en tu vida personal adquieras el hábito de aceptar certificados inválidos, pero eso es ya un problema tuyo. Pero en mi vida profesional habitualmente me he cruzado con organizaciones en las que esto se ha convertido en un hábito rutinario aún cuando trabajan con datos sensibles. Incluso proveedores que proporcionan <i lang="en">software</i> a empresas de [Fortune Global 500](https://fortune.com/global500) y organismos públicos que trabajan con todo tipo de información sensible recomiendan de manera incondicional saltarse la verificación de certificados en su documentación oficial:

![Uso inseguro de curl saltándose la verificación de certificados]({{< param "slug" >}}/curl-insecure.png)

¿Cómo puede algo así pasar cualquier proceso de revisión y validación y acabar en la documentación de un <i lang="en">software</i> proporcionado a organizaciones tan importantes trabajando con datos altamente sensibles por todo el mundo?

Esto es debido a la creencia altamente extendida en la industria de que está bien saltarse la validación de certificaos SSL. Esa documentación probablemente fue escrita por alguien que adquirió el hábito de saltarse incondicionalmente la validación de los certificados para no molestarse en corregir entornos mal configurados ignorando el problema en vez de arreglarlo.  
Quien haya revisado la documentación (si es que alguien lo hizo) antes de aceptar que esto fuese incluido en la documentación final disponible para clientes probablemente tenía el mismo hábito y no vio nada malo en aceptarlo para la documentación.

<figure class="alignright"><img src="{{< param "slug" >}}/firefox-badssl.png" width="300" alt="Firefox mostrando un certificado SSL con errores" />
<figcaption>Firefox mostrando un certificado SSL con errores</figcaption>
</figure>

Este hábito de aceptar certificados inválidos como una práctica aceptada ha sido transmitida desde el personal de IT a los usuarios en sus organizaciones.  
Se pueden ver a usuarios aceptar certificados inválidos de manera rutinaria sin cuestionarlos porque las fuentes acreditadas de sus organizaciones les dijeron que es aceptable: "ve a esta sitio web interno mal configurado y cuando veas la advertencia en el navegador diciendo que el certificado es inválido, dile que quieres ignorar la advertencia y continuar".

Incluso un experto en seguridad informática mediático y de renombre como Brian Krebs recientemente escribió un tuit que favorece la idea de que las advertencias de los navegadores sobre certificados inválidos simplemente pueden ser ignoradas:

{{< tweet briankrebs 1328863446105010177 >}}

Y la Administración española ha estado extendiendo durante años esta clase de hábitos cuando decidieron empezar a usar su propia autoridad certificadora pero hicieron falta [años de infierno burocrático](https://bugzilla.mozilla.org/show_bug.cgi?id=435736) hasta que fue aceptada por los principales navegadores mientra los organismos gubernamentales ya lo estaban usando haciendo que los usuarios tuvieran que aceptar certificados inválidos durante más de una década.

Estos hábitos tienen que acabar.

Como profesionales de la informática, no podemos encontrar estos hábitas aceptables y hay pocas excusas para justificarlo.

El argumento del coste ya no es valido ahora que [Let's Encrypt](https://letsencrypt.org) proporciona certificados de manera gratuita (los cuales, la mayor parte de las veces, son incluso más seguros que los certificados más caros).  
Incluso si decides seguir con un certificado autofirmado no generado por una autoridad certificadora de confianza, hay maneras de hacerlo de manera más apropiada estableciendo tu porpia autoridad certificadora y configurando correctamente la cadena de confianza. Saltarse la validación de los certificados no debe ser el camino a seguir.

He visto que alguna gente argumenta "es un certificado autofirmado que generé yo, así que sé que es legítimo y puedo saltarme la validación". En realidad, no:

* Aunque sea autofirmado, hay maneras de hacer que pase la validación, aunque obtener un certificado correctamente firmado es habitualmente incluso más fácil.
* A no ser que hayas comprobado que la huella del certificado inválido que estás aceptando es la misma que la del certificado autofirmado que creaste, no puedes realmente confiar en el certificado que estás aceptando.
* Esto refuerza ese hábito de que está bien saltarse la validación de certificados hasta que se convierte en el comportamiento por defecto, como se vio más arriba.
* Hay muchas herramientas y bibliotecas, como `curl`, que no soportan aceptar solo _este_ certificado. Solo puedes decirle que o bien valide los certificados, o bien no. Así que si quieres saltarte la validación, lo harás para cualquier certificado proporcionado.

Así que dame una buena razón por la que debería considerar saltarse la validación de los certificados como una práctica aceptable que no sea la pereza o incompetencia para configurar tu cadena de confianza correctamente.
