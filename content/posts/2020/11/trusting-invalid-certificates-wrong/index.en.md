---
title: "Trusting invalid SSL certificates is wrong"
date: 2020-11-18T20:31:24+01:00
categories: [security,sysadmin,software,internet]
slug: trusting-invalid-ssl-certificates-wrong
tags: [ssl,certificate,tls,brian-krebs]
thumbnail: "/trusting-invalid-ssl-certificates-wrong/firefox-badssl.png"
---
So let me put it clear from the first line: trusting invalid certificates is wrong.

And now I will explain why it's wrong and why there are few excuses for it.

We are talking here about certificates for SSL encryption, which serves basically two purposes:

* *Privacy* — data is transferred encrypted and can only be decrypted by the intended recipient and not a third party wiretapping the line.
* *Authentication* — making sure the receiving end that will be able to decrypt the data is who they claim to be and data is not diverted to a different receiver by a third party with access to manipulating our transfers.

Invalid certificates obviously defeat the second purpose of verifying the other end's identity:

* If you accept self-signed certificates or with an unknown issuer, you are accepting a certificate that could have been issued by literally anyone. You don't have any confidence the receiving end is who they are claiming to be.
* If you accept expired certificates, you are accepting certificates that could have been compromised (stolen or using obsolete weak keys that can be broken).
* If you accept certificates issued for different entities, you are actually accepting impersonation.

But privacy is also affected because you can't effectively have one without the other:

* If your communication is not private, your traffic is visible and can be tampered so any authentication method can be altered for impersonation.
* If your communication is not authenticated, you cannot have confidence your receiving end is who they are claiming to be and your data may end up in the wrong hands.

I even find it wrong if you got the habit of trusting invalid certificates in your private life, but that's more your issue. But in my professional life I often crossed paths with organizations where this had become a routine habit even if they work with sensitive data. Even vendors of software provided to Fortune Global 500 companies and public organism to work with all kinds of sensitive data recommend unconditionally skipping SSL certificates validation in their official documentation:

![Insecure use of curl skipping certificates validation]({{< param "slug" >}}/curl-insecure.png)

How can this pass any review and validation process and end up in the documentation of software provided to such important organizations working with highly-sensitive data all around the world?

This is due to do the widely-spread belief in this industry that it's just OK to bypass SSL certificates validation. That documentation was probably written by someone who got the habit of unconditionally bypassing certificates validation so they don't have to bother about fixing misconfigured environments ignoring the issue instead of fixing it.  
Whoever reviewed the documentation (if that ever happened) before accepting it to be included in the final documentation available to customers probably had the same bad habit and just saw nothing wrong with it.

<figure class="alignright"><img src="{{< param "slug" >}}/firefox-badssl.png" width="300" alt="Firefox showing an SSL certificate error" />
<figcaption>Firefox showing an SSL certificate error</figcaption>
</figure>

This habit of trusting invalid certificates as an acceptable practice has been passed from IT staff to users in their organizations.  
We are seeing users routinely accepting invalid certificates without questioning them because they were told by the authoritative sources in their organization that's acceptable: "go to this misconfigured internal website and when you see a warning in your browser saying the certificate is invalid, say you want to ignore the warning and continue".  

Even a renowned IT security analyst like Brian Krebs recently made a statement in Twitter that favoured the idea that browser SSL warnings can just be ignored:

{{< x user=briankrebs id=1328863446105010177 >}}

And the Spanish administration for years favoured the spread of this kind of habits when they decided they would go with their own certification authority but it took [years of bureaucratic hell](https://bugzilla.mozilla.org/show_bug.cgi?id=435736) to get it accepted by major browsers while organisms of the Spanish administration were already using it pushing users to accept invalid certificates for more than a decade.

These habits have to finish.

As IT professionals, we must be the first ones not finding that acceptable and there are few excuses for it.

The cost argument is not valid anymore now that [Let's Encrypt](https://letsencrypt.org) issues free certificates (which most of the times are even more secure than the 'premium' expensive ones).
Even if you want to go with a self-signed certificate not issued by a trusted authority, there are ways to do it properly by establishing your own certification authority and properly setting the trust chain. Bypassing certificate validation mustn't be the way.

I saw people arguing "it's a self-signed certificate I issued, hence I know it's legit and I can bypass validation". Well, no:

* Even if it's a self-signed certificate, there are ways to make it pass validation, although getting a properly trusted certificate is usually even easier.
* Unless you have verified the fingerprint in the certificate you are being provided matches that of the one you have created, you can't actually trust that certificate.
* That reinforces the habit that it's OK to bypass certificate validation until it becomes the default behaviour as seen above.
* There are many tools and libraries, like `curl`, that don't support trusting just _this_ certificate. It's either validate or not certificates in this request. So if you want to bypass validation, you will do it regardless of the certificate provided.

So give me a valid good reason why I should take trusting invalid certificate as an acceptable practice other than laziness or incompetence to set your trust chain properly.
