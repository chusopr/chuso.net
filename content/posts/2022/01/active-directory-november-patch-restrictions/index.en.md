---
title: "A November patch introduces new conflicts in Active Directory"
slug: active-directory-november-patch-restrictions
date: 2022-01-12T22:17:20+02:00
tags: [Active-Directory,Microsoft,Kerberos,CVE-2021-42282]
images: [/documents/technical/active-directory-spn-upn-constraint-violation/CONSTRAINT_ATT_TYPE.png]
summary: Since Novembmer '21 update, Active Directory new conditions may make it raise a CONSTRAINT_ATT_TYPE violation affecting other products.
---

In a project for a client that I was working on last month, we saw that when trying to create new users in Active Directory we got the following error: 

```
ldap_add: Constraint violation (19)
        additional info: 000021C7: AtrErr: DSID-03200DF3, #1:
        0: 000021C7: DSID-03200DF3, problem 1005 (CONSTRAINT_ATT_TYPE),
data 0, Att 90303 (servicePrincipalName)
```

An apparently normal error when a user with that principal already exists. But this was not the case, as confirmed by an LDAP search.

So I tried to do the same operation in my own test environment, totally different from the client's environment and with a different Active Directory server.   
The result is the same: `CONSTRAINT_ATT_TYPE`.

After a day and a half trying everything possible with no progress, we started to see other customers who had the same problem. Too coincidence.

It turned out all this was caused by change [KB5008382](https://support.microsoft.com/en-us/topic/kb5008382-verification-of-uniqueness-for-user-principal-name-service-principal-name-and-the-service-principal-name-alias-cve-2021-42282-4651b175-290c-4e59-8fcb-e4e5cd0cdb29) that Microsoft introduced to Active Directory in November.

This change introduces new restrictions in Active Directory when creating new users that effectively represent a change in behavior in Active Directory affecting many products that use SPNEGO.

For such a relevant change, it is difficult to understand that there has been so little communication. Considering that it is a change to correct a [security flaw ](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-42282), they may not have wanted to give too many details in advance so they couldn't be exploited by attackers, but once the change was posted, they could have given it more publicity. There is not even public information about what the security flaw that this change fixes consists of (although speculation can be made, as will be seen later). [Security through obscurity](https://en.wikipedia.org/wiki/Security_through_obscurity)?

In the following article I explain the background of the problem with the possible solutions, with help from [Cloudera](https://cloudera.com) and [Bluemetrix](https://bluemetrix.com) on the research:

<h2 style="text-align: center"><a href="/documents/technical/active-directory-spn-upn-constraint-violation.html">Constraint violation in Active Directory principal that doesn't exist</a></h2>
