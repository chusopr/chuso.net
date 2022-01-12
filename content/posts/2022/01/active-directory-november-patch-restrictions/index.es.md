---
title: "Un parche de noviembre introduce nuevos conflictos en Active Directory"
slug: active-directory-parche-noviembre-restricciones
date: 2022-01-12T22:17:20+02:00
categories: [sysadmin]
tags: [Active-Directory,Microsoft,Kerberos,CVE-2021-42282]
images: [/documentos/tecnicos/active-directory-spn-upn-constraint-violation/CONSTRAINT_ATT_TYPE.png]
summary: Desde la actualización de noviembre de 2021, nuevas condiciones en Active Directory pueden hacer que devuelva un error de tipo CONSTRAINT_ATT_TYPE afectando a otros productos.
---

En un proyecto para un cliente en el que estuve trabajando el mes pasado, vimos que al intentar crear nuevos usuarios en Active Directory obteníamos el siguiente error:

```
ldap_add: Constraint violation (19)
        additional info: 000021C7: AtrErr: DSID-03200DF3, #1:
        0: 000021C7: DSID-03200DF3, problem 1005 (CONSTRAINT_ATT_TYPE),
data 0, Att 90303 (servicePrincipalName)
```

Un error aparentemente normal cuando efectivamente ya existe un usuario con ese principal. Pero este no era el caso, como confirmó una búsqueda LDAP.

Entonces intenté hacer la misma operación en un entorno de pruebas propio, totalmente distinto del entorno del cliente y con un servidor Active Directory distinto.  
El resultado, el mismo: `CONSTRAINT_ATT_TYPE`.

Tras un día y medio probando todo lo posible sin avances, empezamos a ver otros clientes que tenían el mismo problema. Demasiada casualidad.

Resultó que todo esto era debido al cambio [KB5008382](https://support.microsoft.com/es-es/topic/kb5008382-verificación-de-la-singularidad-del-nombre-principal-del-usuario-el-nombre-principal-del-servicio-y-el-alias-del-nombre-principal-del-servicio-cve-2021-42282-4651b175-290c-4e59-8fcb-e4e5cd0cdb29) que Microsoft introdujo en Active Directory en noviembre.

Este cambio introduce nuevas restricciones en Active Directory a la hora de crear nuevos usuarios que efectivamente suponen un cambio de comportamiento en Active Directory afectando a muchos productos que usan SPNEGO.

Para un cambio tan relevante, es difícil entender que haya habido tan poca comunicación. Teniendo en cuenta que es un cambio para corregir un [fallo de seguridad](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-42282), es posible que no hayan querido dar muchos detalles con antelación para que no pudieran ser aprovechados por atacantes, pero una vez que el cambio fue publicado, podrían haberle dado más publicidad. Ni siquiera hay información pública sobre en qué consiste el fallo de seguridad que este cambio soluciona (aunque se pueden hacer especulaciones, como se verá después). ¿[Seguridad por oscuridad](https://es.wikipedia.org/wiki/Seguridad_por_oscuridad)?

En el siguiente articulo explico el contexto del problema con las posibles soluciones, con ayuda por parte de [Cloudera](https://cloudera.com) y [Bluemetrix](https://bluemetrix.com) en la investigación:

<h2 style="text-align: center"><a href="/documentos/tecnicos/active-directory-spn-upn-constraint-violation.html">Violación de restricción en principal de Active Directory que no existe</a></h2>
