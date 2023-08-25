---
title: "Collapse all diff blocks in Github or GitLab"
slug: github-gitlab-collapse-all-diffs
date: 2023-08-25T15:39:54+02:00
categories: [web-development]
tags: [github,gitlab,javascript,git]
images: [/github-gitlab-collapse-all-diffs/browser-bookmark-edit.png]
summary: How to collapse all diff blocks in Github or GitLab while seeing changes between versions
---
I check the differences between versions of a project on Github or GitLab very often to review the changes introduced in a new version, but many times I am only interested in the changes in certain types of files. For example, in the changes introduced in the dependencies of a new version to know how to package the project for Gentoo.

This makes it a bit annoying to see very large diffs that have changes in too many files when I'm only interested in changes to a couple of file types and not the rest.

It would be very practical for me if all the changes were initially collapsed so I could quickly review what files have been changed and expand only the ones I need to see.

There are multiple requests to GitLab for this to be implemented, but apparently, it is very difficult or almost impossible.

So I've found my own way to do it with a bookmarklet in the browser.

A bookmarklet is a bookmark in the browser that contains some JavaScript code to perform some action:

{{< figure src="github-gitlab-collapse-all-diffs/browser-bookmark-edit.png" caption="Example of a bookmarklet that runs some JavaScript code" alt="A screenshot of the bookmark editing screen in a browser. In the bookmark name it says \"GitLab collapse all diffs\" and the bookmark link shows the \"javascript\" word in lowercase followed by a colon and some Javascript code" >}}

Using the following JavaScript codes in a browser bookmark, you can get an easy way to collapse all diffs on Github or GitLab so later we can manually expand only the ones we are interested in:

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

If you are going to use these bookmarklets, don't forget to add <code>javascript:</code> in front of it when you add it to the bookmark as shown above.
