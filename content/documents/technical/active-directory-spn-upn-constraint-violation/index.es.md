---
title: "Violación de restricción en principal de Active Directory que no existe"
slug: documentos/tecnicos/active-directory-spn-upn-constraint-violation
date: 2022-01-12T22:17:20+02:00
tags: [Active-Directory,Microsoft,Kerberos,CVE-2021-42282]
images: [/documentos/tecnicos/active-directory-spn-upn-constraint-violation/CONSTRAINT_ATT_TYPE.png]
summary: Análisis y posibles soluciones de nuevos errores CONSTRAINT_ATT_TYPE en Active Directory después del parche del noviembre de 2021
showtoc: True
---

## Síntomas

El error `CONSTRAINT_ATT_TYPE` es la respuesta LDAP para cuando una operación es denegada porque no cumplió determinadas restricciones.

[Como indica Ldapwiki](https://ldapwiki.com/wiki/LDAP_CONSTRAINT_VIOLATION), los motivos para devolver un error `CONSTRAINT_ATT_TYPE` pueden ser múltiples como pueden serlo las restricciones que pudo haber violado la operación y no siempre está claro qué es lo que fue mal.

Sin embargo, Active Directory sí que suele dar algo más de información sobre qué restricción no fue cumplida en un mensaje que tiene un aspecto similar al siguiente cuando la operación se intentó llevar a cabo usando la interfaz LDAP de Active Directory:

```
ldap_add: Constraint violation (19)
        additional info: 000021C7: AtrErr: DSID-03200DF3, #1:
        0: 000021C7: DSID-03200DF3, problem 1005 (CONSTRAINT_ATT_TYPE),
data 0, Att 90303 (servicePrincipalName)
```

En este caso, indica que no se cumplió la restricción con respecto al atributo `servicePrincipalName`.

Si la operación se intenta realizar con algún cliente de Active Directory como ADSIEdit, proporcionará una línea más de información aún más esclarecedora:

{{< figure src="/documentos/tecnicos/active-directory-spn-upn-constraint-violation/CONSTRAINT_ATT_TYPE.png" alt="Operation failed. Error code: 0x21c8 The operation failed because UPN value provided for addition/modification is not unique forest-wide. 000021C8: AtrErr: DSID-03200BBA, #1:          0: 000021C8: DSID-03200BBA, problem 1005 (CONSTRAINT_ATT_TYPE), data 0, Att 90290 (userPrincipalName)" caption="Fuente: [Unicidad de SPN y UPN | Microsoft Docs](https://docs.microsoft.com/es-es/windows-server/identity/ad-ds/manage/component-updates/spn-and-upn-uniqueness)" >}}

Una de las primeras líneas dice <q lang="en">The operation failed because UPN value provided for addition/modification is not unique forest-wide</q> (la operación falló porque el valor UPN proporcionado para la adición o modificación no es único en el bosque).

Además, los códigos `000021C7` y `000021C8` proporcionados en ambos mensajes también nos indican (según [documenta Microsoft](https://docs.microsoft.com/es-es/windows-server/identity/ad-ds/manage/component-updates/spn-and-upn-uniqueness)) que el valor `servicePrincipalName` o `userPrincipalName` (respectivamente) no es único.

Es decir, estamos intentando crear un usuario que tenga un <i lang="en">principal</i> como `johndoe@EXAMPLE.COM` que ya existe. En un principio, algo bastante normal si ese <i lang="en">principal</i> efectivamente ya existe, lo que podemos comprobar usando las herramientas proporcionadas por Microsoft para buscar usuarios en Active Directory o con una búsqueda LDAP usando un filtro como `(|(userPrincipalName=johndoe@EXAMPLE.COM)(servicePrincipalName=johndoe@EXAMPLE.COM))`.

El problema sucede cuando obtenemos ese error creando un <i lang="en">principal</i> que no existe previamente, algo que no debería ocurrir.

Esto ha empezado a ocurrir a partir de Noviembre de 2021 debido a la actualización [KB5008382](https://support.microsoft.com/es-es/topic/kb5008382-verificación-de-la-singularidad-del-nombre-principal-del-usuario-el-nombre-principal-del-servicio-y-el-alias-del-nombre-principal-del-servicio-cve-2021-42282-4651b175-290c-4e59-8fcb-e4e5cd0cdb29) de Active Directory al crear determinados <i lang="en">principals</i> SPNEGO como `HTTP` (pero no restringido a este) para un equipo que forma parte de Active Directory. 

Es decir, el error `CONSTRAINT_ATT_TYPE` se puede obtener para <i lang="en">principals</i> que no existen cuando se cumplen las siguientes condiciones:

* El parche KB5008382 de Noviembre de 2021 ha sido aplicado a Active Directory.
* Estamos intentando crear un <i lang="en">principal</i> SPNEGO como `HTTP/node1.example.com@EXAMPLE.COM`, `dns/myserver.com@REALM.LOCAL` o `www/webserver.example.net@EXAMPLE.NET`.
* El equipo para el que se está intentando crear el <i lang="en">principal</i> forma parte del dominio. Es decir, en el ejemplo anterior, `node1.example.com`, `myserver.com` y `webserver.example.net` habrían sido unidos al dominio, en el caso de Linux, usando `realm join` o similar.

## Causa

El motivo por el que esto sucede es por el cambio [KB5008382](https://support.microsoft.com/es-es/topic/kb5008382-verificación-de-la-singularidad-del-nombre-principal-del-usuario-el-nombre-principal-del-servicio-y-el-alias-del-nombre-principal-del-servicio-cve-2021-42282-4651b175-290c-4e59-8fcb-e4e5cd0cdb29) introducido por Microsoft en Noviembre de 2021.

Este cambio extiende las comprobaciones para comprobar que el `userPrincipalName` (UPN) y `servicePrincipalName` (SPN) son únicos para incluir también los alias.

Estos alias se configuran en el atributo `sPNMappings` del DN `CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration,DC=...`, en donde se configuran varias docenas de alias para el <i lang="en">principal</i> `host`.

Una configuración típica tendría un aspecto similar a este:

```
sPNMappings: host=alerter,appmgmt,cisvc,clipsrv,browser,dhcp,dnscache,replicator,eventlog,eventsystem,policyagent,oakley,dmserver,dns,mcsvc,fax,msiserver,ias,messenger,netlogon,netman,netdde,netddedsm,nmagent,plugplay,protectedstorage,rasman,rpclocator,rpc,rpcss,remoteaccess,rsvp,samss,scardsvr,scesrv,seclogon,scm,dcom,cifs,spooler,snmp,schedule,tapisrv,trksvr,trkwks,ups,time,wins,www,http,w3svc,iisadmin,msdtc
```

Hasta ahora, estos alias eran ignorados al comprobar que un <i lang="en">principal</i> era único, pero eso es lo que cambió la actualización KB5008382 para corregir el problema de seguridad [CVE-2021-42282](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-42282).

Cuando unimos el equipo `node1.example.com` a un dominio Active Directory, eso creará un usuario en AD con el <i lang="en">principal</i> `HOST/node1.example.com`. Si después intentamos crear el <i lang="es">principal</i> `HTTP/node1.example.com`, aunque ese principal no existe en AD, tras el parche de Noviembre AD también comprobará el valor de `sPNMappings` y encontrará que el principal `host` tiene un alias `http` y denegará la operación para crear `HTTP/node1.example.com` diciendo que no es único.

## Mitigación

La información proporcionada en el propio anuncio del cambio [KB5008382](https://support.microsoft.com/es-es/topic/kb5008382-verificación-de-la-singularidad-del-nombre-principal-del-usuario-el-nombre-principal-del-servicio-y-el-alias-del-nombre-principal-del-servicio-cve-2021-42282-4651b175-290c-4e59-8fcb-e4e5cd0cdb29) indica que este cambio de comportamiento puede ser revertido cambiando la propiedad de `dSHeuristics` en `CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration,DC=...` para que su valor sea `100`.

Sin embargo, esto haría que el dominio se viera afectado de nuevo por la vulnerabilidad [CVE-2021-42282](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-42282). No hay información pública sobre en qué consiste esta vulnerabilidad, pero no es difícil imaginar que permitir que se creen usuarios que duplican un alias de otro usuario pueda suponer un riesgo.

En el caso de que no sea posible cambiar el valor de `dSHeuristics` para desactivar las nuevas comprobaciones de SPN y UPN, otra solución recomendada por Microsoft es usar una cuenta de administrador del dominio para crear los <i lang="en">principals</i>. Sin embargo, esto parece una mala práctica desde el punto de vista de la seguridad y no es aconsejable, especialmente en productos que van a necesitar administrar <i lang="en">principals</i> de AD regularmente y necesitan tener guardados los credenciales de una cuenta con la que puedan administrar sus <i lang="en">principals</i>.

Probablemente, la manera más segura de evitar el problema es eliminar el equipo temporalmente de Active Directory para crear el <i lang="en">principal</i> conflictivo y volver a unirlo a AD después.

Es decir, continuando con el mismo ejemplo:

* Eliminar `node1.example.com` de Active Directory.
* Crear el principal `HTTP/node1.example.com`.
* Volver a unir `node1.example.com` a Active Directory.

Esta operación se debe llevar a cabo con las precauciones necesarias ya que, por ejemplo, eliminar un equipo de Active Directory puede hacer que los usuarios de AD no puedan seguir accediendo a ese equipo y podríamos quedarnos sin accesso si no tenemos un usuario local en el equipo.

Otra solución alternativa podría ser eliminar el alias que nos está produciendo el problema (es decir, en nuestro ejemplo, eliminar `http` del `sPNMappings` de `host`). Sin embargo, los efectos colaterales de un cambio así podrían ser impredecibles.

## Solución

Dado que este cambio soluciona un [problema de seguridad en Active Directory](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-42282), es muy poco probable que Microsoft vaya revertirlo a pesar de que introduce un cambio en Active Directory que rompe una práctica establecida desde hace años con muy poca comunicación al respecto (probablemente para evitar que el problema de seguridad fuese explotado <i lang="en">in the wild</i> antes de que el parche fuese aplicado).

Hoy por hoy, la única solución es que los productos que provocan el conflicto de SPN/UPN se modifiquen para adaptarse al nuevo funcionamiento de Active Directory o que se aplique alguno de los remedios en la sección anterior.

## Créditos

Este documento incluye detalles de la investigación llevada a cabo por [Bluemetrix](https://bluemetrix.com) y [Cloudera](https://cloudera).
