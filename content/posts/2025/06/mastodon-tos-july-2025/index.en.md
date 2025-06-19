---
title: About the New Terms of Use of mastodon.social  
slug: mastodon-tos-july-2025  
date: 2025-06-19T14:18:31+02:00  
categories: [debate, internet]  
tags: [mastodon, fediverse, social-networks, legal, arbitration, intellectual-property]  
summary: The Mastodon instance mastodon.social plans to implement new terms of use starting July 2025, which have turned out to be somewhat controversial.
---

*Update: Mastodon.social has temporarily put on pause their plan to apply these new terms of service:*

<blockquote class="mastodon-embed" data-embed-url="https://mastodon.social/@Mastodon/114709820512537821/embed" style="background: #FCF8FF; border-radius: 8px; border: 1px solid #C9C4DA; margin: 0; max-width: 540px; min-width: 270px; overflow: hidden; padding: 0;"> <a href="https://mastodon.social/@Mastodon/114709820512537821" target="_blank" style="align-items: center; color: #1C1A25; display: flex; flex-direction: column; font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Oxygen, Ubuntu, Cantarell, 'Fira Sans', 'Droid Sans', 'Helvetica Neue', Roboto, sans-serif; font-size: 14px; justify-content: center; letter-spacing: 0.25px; line-height: 20px; padding: 24px; text-decoration: none;"> <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="32" height="32" viewBox="0 0 79 75"><path d="M63 45.3v-20c0-4.1-1-7.3-3.2-9.7-2.1-2.4-5-3.7-8.5-3.7-4.1 0-7.2 1.6-9.3 4.7l-2 3.3-2-3.3c-2-3.1-5.1-4.7-9.2-4.7-3.5 0-6.4 1.3-8.6 3.7-2.1 2.4-3.1 5.6-3.1 9.7v20h8V25.9c0-4.1 1.7-6.2 5.2-6.2 3.8 0 5.8 2.5 5.8 7.4V37.7H44V27.1c0-4.9 1.9-7.4 5.8-7.4 3.5 0 5.2 2.1 5.2 6.2V45.3h8ZM74.7 16.6c.6 6 .1 15.7.1 17.3 0 .5-.1 4.8-.1 5.3-.7 11.5-8 16-15.6 17.5-.1 0-.2 0-.3 0-4.9 1-10 1.2-14.9 1.4-1.2 0-2.4 0-3.6 0-4.8 0-9.7-.6-14.4-1.7-.1 0-.1 0-.1 0s-.1 0-.1 0 0 .1 0 .1 0 0 0 0c.1 1.6.4 3.1 1 4.5.6 1.7 2.9 5.7 11.4 5.7 5 0 9.9-.6 14.8-1.7 0 0 0 0 0 0 .1 0 .1 0 .1 0 0 .1 0 .1 0 .1.1 0 .1 0 .1.1v5.6s0 .1-.1.1c0 0 0 0 0 .1-1.6 1.1-3.7 1.7-5.6 2.3-.8.3-1.6.5-2.4.7-7.5 1.7-15.4 1.3-22.7-1.2-6.8-2.4-13.8-8.2-15.5-15.2-.9-3.8-1.6-7.6-1.9-11.5-.6-5.8-.6-11.7-.8-17.5C3.9 24.5 4 20 4.9 16 6.7 7.9 14.1 2.2 22.3 1c1.4-.2 4.1-1 16.5-1h.1C51.4 0 56.7.8 58.1 1c8.4 1.2 15.5 7.5 16.6 15.6Z" fill="currentColor"/></svg> <div style="color: #787588; margin-top: 16px;">Post by @Mastodon@mastodon.social</div> <div style="font-weight: 500;">View on Mastodon</div> </a> </blockquote> <script data-allowed-prefixes="https://mastodon.social/" async src="https://mastodon.social/embed.js"></script>

<hr>

Those of us who use the Mastodon instance mastodon.social (and I guess also mastodon.online), managed by the Mastodon developers themselves, received this email two days ago announcing new terms of service:

{{< figure src="mastodon-tos-july-2025/mastodon-new-tos-announcement.png" caption="Email sent by the mastodon.social administrators announcing the new terms of use" alt="We’re introducing these new Terms of Service to add extra clarity to your use of our service, and for our legal compliance with various requirements: • We explicitly prohibit the scraping of user data for unauthorized purposes, e.g. archival or large language model (LLM) training. We want to make it clear that training LLMs on the data of Mastodon users on our instances, is not permitted. • We clarify that you maintain rights over the works you upload to our service (i.e. your posts, images, audio, video etc. - your content), but grant us a license necessary for the functioning of the service, e.g. displaying your works to your followers. • We’re setting a new minimum age requirement of 16 years. Previously this was cited as 13, for users in the US specifically. Now, it is 16, everywhere. • We’re adding information about the DMCA and other legal notices, as well as disputes and arbitration; along with the prohibited uses section, which underlies our server rules." >}}

I am going to discuss these new terms of service and the concerns about them that have been mentioned on GitHub and Mastodon, keeping in mind that **I am not a lawyer and some things may not be entirely accurate**.

The notice itself includes a summary of what this means so you don't have to go through all the 2,500 words of the new terms of use, which sounds very boring, right?

And the most notable point is that using the instance's content to train generative AIs is prohibited. The announcement was met with delight by the community, considering the well-known bias of much of the fediverse against generative AIs: "Mastodon once again does things right, and while other social networks sell their users' content to train LLMs, Mastodon prohibits it" was the widespread reaction.

Well, maybe we should have gone beyond the initial summary in the announcement and read the full terms, and it may turn out to be not so nice.

## Binding Arbitration

As [Cory Doctorow has pointed out](https://mamot.fr/@pluralistic/114706885462760813), the new terms of service establish **mandatory and binding arbitration** to resolve disputes. This basically means the **privatization of justice** by designating a private entity to resolve any dispute that may arise and could have legal consequences, **denying you the right to go to court**.

But why would you need to go to court against mastodon.social? It's a free software project, managed by a non-profit, etc.
Well, free software does not intrinsically mean free from all wrongdoing, just as the administration of mastodon.social is not immune from possibly engaging in bad actions at some point in the future. Nor would it be the first time a Mastodon instance changes owners and ends up in the hands of someone with less benign intentions.

Arbitration clauses can be a mechanism to protect against frivolous lawsuits ("I'm going to sue this instance because they moderated a post of mine"), considering also that Mastodon is a non-profit free software project with limited legal resources. But binding arbitration clauses have serious consequences for violating the rights of users and consumers. The most serious recent example was that of a woman who died at Disney World after receiving incorrect information about allergens in her food, and her widower was denied the right to go to court because he was a Disney+ user and [its terms of service include an arbitration clause](https://www.nbcnews.com/news/us-news/disney-says-man-cant-sue-wifes-death-agreed-disney-terms-service-rcna166594) (Disney later [retracted](https://www.npr.org/2024/08/14/nx-s1-5074830/disney-wrongful-death-lawsuit-disney) after media pressure).

## Perpetual and Irrevocable License

Another key point in the notice about the new terms of service is that mastodon.social users will be granting it a "limited, non-exclusive, irrevocable, transferable, royalty-free, perpetual license to use, copy, store, display, share, distribute, communicate and transfer" the content you upload to the instance.

This, in itself, often alarms people who do not fully understand how intellectual property works, and when they discover a similar clause in any social network—especially content creators like illustrators—they exclaim that "they want to take the property of everything I upload".

**That interpretation of the clause is incorrect.** As the terms of use themselves state and the notice mentions, "you retain all property rights to the content you submit to the instance". You simply grant the instance owners **the permissions necessary to carry out the expected purpose for the content you share** and to store it on the instance, distribute it, and display it to other users. Without such a clause, the content you upload to the instance would be in a gray area where you implicitly grant some permission to the instance administrators to store your content, but without clarifying exactly what is included in that permission.

So far, that's a more or less normal clause, but what has sparked this wave of scrutiny of mastodon.social's new terms of service was a [GitHub issue](https://github.com/mastodon/mastodon/issues/35086) pointing out the irrevocability of that license to use users' content.

This means that it doesn't matter if we delete our account from the instance. If, for example, the instance changes owners to others we don't trust (because remember, the license to use our content is transferable). Or, for any other reason, we no longer want any relationship with the instance. In theory, nothing would prevent them from continuing to use the license granted to use the content we had uploaded. Because it is a **perpetual and irrevocable** license.

As noted in the GitHub issue, other social networks considered more restrictive and hostile to user rights are much more respectful in this regard.

For example, a social network with as poor a reputation for defending user rights as Facebook states in its [terms of use](https://www.facebook.com/terms.php) that the license to use user content **is revoked after the user deletes their account**:

> This licence will end when your content is deleted from our systems.

Facebook's terms of use also contain an entire section explaining how that content is deleted.

## Regulatory Conflicts

The arbitration clause is also likely invalid in many jurisdictions.

The [majority of European countries](https://www.uria.com/en/publicaciones/9258-brief-notes-on-arbitration-clauses-in-consumer-contracts-illustrated-by-the-dis) place strong **restrictions on the use of arbitration clauses**. In the case of Germany, where the mastodon.social servers are hosted and the organization is legally constituted, **arbitration clauses must be explicitly signed by both parties in a separate contract** that does not include any other agreement besides arbitration.

This has clearly **not been complied with by mastodon.social**, since no one has signed anything to accept that arbitration agreement (and even if signed, it could be **illegal in most European jurisdictions**) and instead, an email was sent to all users saying "if you continue using the service, it means you accept the new terms". This, in itself, is problematic. How many times have you seen services that require you to accept the new terms of use after changing them to continue using the service? This is because implicit acceptance of "if you keep using the service, you accept the terms" is often not enough.

So, the new terms of use (or at least some parts of them) seem **hardly applicable, at least in Europe**. That does not mean that once the invalidity of those terms is confirmed (which someone other than me will have to do), I should not be concerned. I am concerned because even if they may not affect me, I am not indifferent to them affecting others, and I do not agree with terms of use that are more restrictive and affect certain rights for citizens of some regions, even if I am not in those regions. And also, the fact that they have tried to apply these terms of use **indicates the direction the instance administration wanted to take**, even if they may have failed to implement those plans.

## Lack of Communication

One of the [defenses Gargron has raised](https://github.com/mastodon/mastodon/issues/35086#issuecomment-2982642642) (as it is Mastodon's author Eugen Rochko better known) regarding these issues is that the draft of the new terms of use has been circulating for about a year and these objections had not been raised until now.

First of all, **the moment when these objections are raised is not related to their validity**. Are there reasons for concern about the arbitration clause, the irrevocability of the user content license and regulatory conflicts? Are those reasons for concern less valid for being mentioned now and not at any other time in the past?

But also, as other users have mentioned, where the "draft has been around for something like a year" is in the Mastodon code repository. That is, **you would only have seen this draft if you are actively involved in Mastodon's development**.

The rest of us users found out two days ago when we received the notice by email that the new terms of use would come into effect in two weeks. This **limits transparency and prior debate**. We could not raise objections to changes we were not informed about.

## New Terms of Use for All Instances?

According to the GitHub issue, these terms of use are included in the template when deploying new instances, which means that **these would be the default terms of use for all instances that do not modify them**, subjecting all users of those other instances to arbitration clauses and permanent and irrevocable intellectual property licenses (and the administrators of those instances to possible regulatory conflicts).

They are problematic terms of use for mastodon.social, but they are even more problematic if made the default terms of use for all instances.

## Was It a Trial Balloon?

Another defense from Gargron has been that they work with pro bono external lawyers who really do not understand how the federated social network service they are trying to regulate works, and the Mastodon organization members (mostly engineers and other similar tech profiles, not lawyers) have to try to explain what the lawyers do not understand about the service's operation.

I understand that the implication is that there may have been communication gaps that led the lawyers not to correctly understanding some concepts of the technology they are trying to regulate, and the Mastodon team accepting some legal conditions that were not the most appropriate.

However, **it is not exactly about technological concepts, which could be justified by the lawyers' lack of understanding, that most objections have been raised**. The perpetual and irrevocable use license, the arbitration clause that is hardly applicable in Germany where the Mastodon instance is hosted and legally constituted, and the other regulatory conflicts are not something explained by a lack of understanding of how federated social networks work. Instead, they seem like generic terms of use aimed at the U.S. area. It is notable that, being for a German entity, it includes clauses potentially invalid in Germany and yet includes references to the U.S. DMCA but not to European regulations like the GDPR or the DSA.

All this gives the impression that it was actually **an experiment**. Something they are testing and were aware might not be the best option yet, but that could be refined over time. But these are the terms of use of a service that you want to be **legally binding**. It does not seem like the best area to experiment with something you do not fully understand.
