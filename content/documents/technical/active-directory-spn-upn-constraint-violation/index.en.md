---
title: "Constraint violation in Active Directory principal that doesn't exist"
slug: documents/technical/active-directory-spn-upn-constraint-violation
date: 2022-01-12T22:17:20+02:00
tags: [Active-Directory,Microsoft,Kerberos,CVE-2021-42282]
images: [/documents/technical/active-directory-spn-upn-constraint-violation/CONSTRAINT_ATT_TYPE.png]
summary: Analysis and workaround of new CONSTRAINT_ATT_TYPE errors in Active Directory after the November 2021 patch
showtoc: True
---

## Background

The `CONSTRAINT_ATT_TYPE` error is LDAP's response when one operation is denied because it didn't meet some requirements.

As [Ldapwiki tells](https://ldapwiki.com/wiki/LDAP_CONSTRAINT_VIOLATION), the reasons for a `CONSTRAINT_ATT_TYPE` error can be as many as the constraints that may have failed and it's not always clear which one was not met.

However, Active Directory usually tell us a bit more information on what restriction was not met in a message that looks similar to the next one when the operation was tried through Active Directory's LDAP interface:

```
ldap_add: Constraint violation (19)
        additional info: 000021C7: AtrErr: DSID-03200DF3, #1:
        0: 000021C7: DSID-03200DF3, problem 1005 (CONSTRAINT_ATT_TYPE),
data 0, Att 90303 (servicePrincipalName)
```

In this case, it tells the constraint on the `servicePrincipalName` attribute was not met.

If the operation is tried using some Active Directory client like ADSIEdit, it will give us one more line of information that is even more clarifying:

{{< figure src="/documents/technical/active-directory-spn-upn-constraint-violation/CONSTRAINT_ATT_TYPE.png" alt="Operation failed. Error code: 0x21c8 The operation failed because UPN value provided for addition/modification is not unique forest-wide. 000021C8: AtrErr: DSID-03200BBA, #1:          0: 000021C8: DSID-03200BBA, problem 1005 (CONSTRAINT_ATT_TYPE), data 0, Att 90290 (userPrincipalName)" caption="Source: [SPN and UPN uniqueness | Microsoft Docs](https://docs.microsoft.com/en-ie/windows-server/identity/ad-ds/manage/component-updates/spn-and-upn-uniqueness)" >}}

One of the first lines says <q lang="en">The operation failed because UPN value provided for addition/modification is not unique forest-wide</q>.

Additionally, error codes `000021C7` and `000021C8` provided in both messages also tell us (as [documented by Microsoft](https://docs.microsoft.com/en-ie/windows-server/identity/ad-ds/manage/component-updates/spn-and-upn-uniqueness)) that the `servicePrincipalName` and `userPrincipalName` values (respectively) are not unique.

I.e., we are trying to create a user with a principal like `johndoe@EXAMPLE.COM` which already exists. Initially, this is something quite normal if that principal indeed already exists, which we can confirm with the tools provided by Microsoft for searching Active Directory for principals or with an LDAP search like `(|(userPrincipalName=johndoe@EXAMPLE.COM)(servicePrincipalName=johndoe@EXAMPLE.COM))`.

The problem happens when we get this error creating a principal that doesn't exist, which is something that shouldn't happen.

This started happening in November 2021 due to [KB5008382](https://support.microsoft.com/en-us/topic/kb5008382-verification-of-uniqueness-for-user-principal-name-service-principal-name-and-the-service-principal-name-alias-cve-2021-42282-4651b175-290c-4e59-8fcb-e4e5cd0cdb29) Active Directory update while creating some SPNEGO principals like `HTTP` (but not limited to this one) for hosts that are joined to Active Directory. 

I.e., `CONSTRAINT_ATT_TYPE` error can happen for principals that don't exist when the following conditions are met:

* KB5008382 update from November 2021 has been applied to Active Directory.
* We are trying to create a SPNEGO principal like `HTTP/node1.example.com@EXAMPLE.COM`, `dns/myserver.com@REALM.LOCAL` or `www/webserver.example.net@EXAMPLE.NET`.
* The host the principal is being created for is part of the Active Directory Domain. In the previous example, that would mean `node1.example.com`, `myserver.com` and `webserver.example.net` had been joined to the domain, in the case of Linux machines, usually using `realm join` or similar.

## Cause

The reason why this happens is because of change [KB5008382](https://support.microsoft.com/es-es/topic/kb5008382-verificación-de-la-singularidad-del-nombre-principal-del-usuario-el-nombre-principal-del-servicio-y-el-alias-del-nombre-principal-del-servicio-cve-2021-42282-4651b175-290c-4e59-8fcb-e4e5cd0cdb29) introduced by Microsoft in November 2021.

This change extends the checks for `userPrincipalName` (UPN) and `servicePrincipalName` (SPN) uniqueness to also include aliases.

These aliases are configured in the `sPNMappings` attribute in the `CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration,DC=...` DN, where a few dozens of aliases are configured for the `host` principal.

A typical `sPNMappings` configuration could look like this:

```
sPNMappings: host=alerter,appmgmt,cisvc,clipsrv,browser,dhcp,dnscache,replicator,eventlog,eventsystem,policyagent,oakley,dmserver,dns,mcsvc,fax,msiserver,ias,messenger,netlogon,netman,netdde,netddedsm,nmagent,plugplay,protectedstorage,rasman,rpclocator,rpc,rpcss,remoteaccess,rsvp,samss,scardsvr,scesrv,seclogon,scm,dcom,cifs,spooler,snmp,schedule,tapisrv,trksvr,trkwks,ups,time,wins,www,http,w3svc,iisadmin,msdtc
```

So far, these aliases were being ignored while checking principals uniqueness, but that's what update KB5008382 changes to fix security issue [CVE-2021-42282](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-42282).


When we join host `node1.example.com` to an Active Directory domain, this will create an AD user with the `HOST/node1.example.com` principal. If we later try to create the `HTTP/node1.example.com` principal after the November patch, even when that principal doesn't exist in AD, it will also check the `sPNMappings` value and will find the `host` principal has an `http` alias and will reject the creation of the `HTTP/node1.example.com` principal saying it's not unique.

## Workarounds

The information provided in the [KB5008382](https://support.microsoft.com/en-ie/topic/kb5008382-verificación-de-la-singularidad-del-nombre-principal-del-usuario-el-nombre-principal-del-servicio-y-el-alias-del-nombre-principal-del-servicio-cve-2021-42282-4651b175-290c-4e59-8fcb-e4e5cd0cdb29) change itself already tells that this behaviour change can be reverted by changing the value of the `dSHeuristics` property in the `CN=Directory Service,CN=Windows NT,CN=Services,CN=Configuration,DC=...` DN to `100`.

However, this would make the domain vulnerable again to [CVE-2021-42282](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-42282). There is no public information on what this vulnerability is, but it's not hard to imagine that allowing users to duplicate some other user's alias may pose a risk.

In case it's not possible to change the value of `dSHeuristics` for disabling the new SPN and UPN checks, another workaround suggested by Microsoft is using a domain administrator account for creating those principals. However, this is a bad practice from a security point of view and it's discouraged, especially in products that will need to administer AD principals regularly and need to have the credentials for an account used to manage those principals saved.

Probably, the safest way for working around this problem is by removing the affected host temporarily from Active Directory for creating the conflicting principal and joining it again to AD afterwards.

That is, following the same example:

* Removing `node1.example.com` from Active Directory.
* Creating the `HTTP/node1.example.com` principal.
* Joining `node1.example.com` back to Active Directory.

This operation must be done with care because, for example, removing a host from Active Directory may make AD users unavailable in that host and may lock us out if we don't have a local user in that host.

An alternative solution could be removing the alias that is causing this problem (e.g., in the previous example, removing `http` from the `host` `sPNMappings`). However, this might have unpredictable side effects.

## Solution

Since this change solves a [security problem in Active Directory](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-42282), it's very unlikely that Microsoft will revert it even when it introduces a change in Active Directory that breaks a long-established practice with very little notice about it (probably for preventing in-the-wild exploitation of the security issue before it was patched).

Nowadays, the only solution is modifying the affected products to adapt them to the new Active Directory behaviour or applying one of the aforementioned workarounds.

## Credit

This document includes research from [Bluemetrix](https://bluemetrix.com) and [Cloudera](https://cloudera).
