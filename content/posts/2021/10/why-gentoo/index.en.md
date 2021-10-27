---
title: "Why I choose Gentoo"
slug: why-gentoo
date: 2021-10-27T20:17:24+02:00
categories: [gentoo-linux]
tags: [gentoo,linux,floss]
images: [/why-gentoo/gentoo-logo.svg]
summary: I've been using Gentoo Linux for 20 years. Why? Because I cannot live without Linux and I haven't found any Linux distribution that I like so much. Here I tell why.
---
I started using Linux 23 years ago.

For the first years, I had been trying different distros, until three years later I bought a Linux magazine that came bundled with an install CD for a quite new and unknown distro called Gentoo.

{{< figure src="why-gentoo/gentoo-logo.svg" link="https://gentoo.org" class="alignright" width="200" >}}

It didn't take me long to fall in love with it and even start [contributing](https://chu.so/gentoo-contribs) shortly after.  
I tried other distros afterwards, but they didn't take Gentoo's place in my heart yet.  
Other newer distros I tried include Arch Linux, from which I like how fast its package manager is (especially compared to Gentoo's) and its excellent documentation, but I'm still in love with Gentoo, sorry.

I think it's because of its level of customization.  
Many people choose Linux because it gives users the power to make many choices. Like choosing between KDE, Gnome, XFCE, etc. You cannot make such choices with Windows or MacOS.  
**Gentoo takes this freedom to choose and pushes it to extents that can't be achieved by other distros.** It's one of the few distributions that still allow you to run a fully-functional desktop on Linux without systemd, PulseAudio or NetworkManager, for example.

The main way to achieve such a level of personalization is by compiling almost everything. While other distributions offer all the software they support as pre-built packages, Gentoo only offers optional pre-built packages for software that is very big and takes too long to compile, like LibreOffice, Firefox or OpenJDK. Everything else is built on the user machine from the upstream source code. Even those other big packages can also be built from source if that's your choice.

Don't get it wrong, the user doesn't need to manually download the source code for every piece of software and build it manually. That's done transparently by the package manager and **the steps required to install some software don't differ so much from those in other distributions.** While in RedHat-based distributions you do `yum install audacity` and in Debian-based ones you do `apt-get install audacity` to install Audacity, in Gentoo you do `emerge audacity` and that will take care of downloading the source code for Audacity and compiling it.

I find Gentoo's package manager and related system base utils very mature and elegant. The build process is sandboxed to make sure no dangerous actions are performed as part of the build and, like any other package system, Gentoo's one keeps track of the files installed and their integrity.  
Even its mechanism for choosing alternatives (e.g., which is your default Python installation when you have more than one installed) called [eselect](https://wiki.gentoo.org/wiki/Eselect) is more powerful and beautiful than others like update-alternatives.

So, again, **what's the benefit of building all from source and how does that make our system more customized?**

That's one of Gentoo's greatest strengths! And also one of its main pain points, but more on that later.

**Since you build everything from source, you can customize how everything is built. But you don't need to know every software's build system** and how to configure it. Gentoo's package manager takes care of that, mostly by the use of settings like `CHOST`, `CFLAGS` and `USE` flags (although many other settings are available).

[CHOST](https://wiki.gentoo.org/wiki/CHOST) allows you to configure the CPU instruction set the resulting binaries will be optimized for. Like **why would you use binaries optimized for Pentium when you are using a Core i7?**

[CFLAGS and related settings](https://wiki.gentoo.org/wiki/CFLAGS) allow you to configure low-level compilation settings that can also bring some performance and security improvements or even make smaller binaries at the cost of performance if that's your priority.

But the most interesting part is [USE flags](https://wiki.gentoo.org/wiki/USE_flag). That allows you to choose what features are enabled in the packages you build. Gentoo's packages website [currently lists](https://packages.gentoo.org/useflags) over 300 global USE flags that enable or disable features globally and over 4000 USE flags that are specific to some package. That means there are **thousands of features you can disable or enable in a Gentoo system.**

This includes things like Bluetooth, geolocation, joystick, NFS, etc.

So, for example, if your device doesn't support Bluetooth, you can disable it for all the packages that have optional support for Bluetooth. Or if you don't want your software to be able to get your location, you can disable the `geolocation` USE flag to make sure it's disabled in the packages that support it.

USE flags can be enabled system-wide or per-package. So, for example, you can have the `joystick` USE flag enabled globally because you play games and you want to make sure joystick support is enabled, but you want that USE flag disabled for MPlayer because who TF uses a joystick to control MPlayer?

But **why would someone want to disable features?** Isn't it the more, the better?

Well, there are different arguments in favour of disabling features you don't need:

* **Usability —** sometimes, changing USE flags changes how some software behaves.
* **Security —** the more features you have enabled and more dependencies you pull to your system as a result of those features, the more attack vectors you are opening.  
While administering Linux servers that use other distributions, I saw Qt and ALSA being pulled in the dependency tree while installing Apache ZooKeeper because some intermediate dependencies were compiled with support for Qt and ALSA. But why would I want Qt and ALSA on a server?
* **Performance —** the more features you have, the more code has to be executed as part of that binary and more code and libraries have to be loaded in memory. Disabling features you don't need saves resources.
* **Space —** again, more features means bigger binaries and more dependencies consuming more disk space. Have you noticed that Spidermonkey installation in your Linux consuming at least 1 GB of your disk space? It's there because it's an unconditional dependency for PolicyKit, a component required in most modern Linux desktops. But my Gentoo servers don't need PolicyKit, so my `policykit` USE flag is disabled for my Gentoo servers and I save that GB of disk space consumed by Spidermonkey.

But it's not only about disabling, sometimes is about enabling.  
Sometimes some feature is disabled by default for the reasons above and because it's only rarely used. But maybe you are one of those rare cases where that feature is really used (like, let's say, you really want to control MPlayer with a joystick?), so you want to enable it.

In some cases, enabling some features means disabling others, so the distribution packagers can't just enable everything, so some choice needs to be made. **In other distributions, it's the distribution packagers who make that choice on behalf of the user.** Gentoo allows the user to make that choice.

In addition to that, Gentoo offers profiles, which are some default values for these settings (which of course the user can also later override) depending on the type of system you are building. You have a "GNOME desktop profile with systemd" which will enable all relevant USE flags and other settings to get the best experience with GNOME and systemd. And a "hardened SELinux profile" if you are paranoid about security. You can even combine profiles and have a "hardened SELinux GNOME desktop with systemd", although such combinations are a bit more experimental I would say.

For some time, it even allowed running Gentoo userspace with different kernels than Linux, mainly [FreeBSD](https://wiki.gentoo.org/wiki/Gentoo_FreeBSD) until that project was discontinued, and there is still a project for running a limited [Gentoo system inside different OSs](https://wiki.gentoo.org/wiki/Project:Prefix) like Windows, MacOS, Solaris, AIX or Android.

**So it's about customization taken to the extreme.**

But, as advanced before, that doesn't come without a couple of drawbacks and you may have already noticed what those will be.

* The first one is that **compilation may fail.** Even when it's tested by Gentoo packagers that some package builds correctly, they cannot test all possible scenarios. All versions of all dependencies and all possible combinations of USE flags and CFLAGS. That's why Gentoo is not optimal for average users and it requires a more advanced type of users. Because you will need to be able to troubleshoot it when some compilation fails.

  For this, Gentoo guys have been running the [Tinderbox](https://blogs.gentoo.org/ago/2020/07/04/gentoo-tinderbox/) project which is constantly building Gentoo packages with different combinations of settings and automatically reports it when some build fails.
  
  There are also projects like [Redcore](https://distrowatch.com/table.php?distribution=redcore) and [Calculate](https://en.wikipedia.org/wiki/Calculate_Linux) to **make Gentoo more attainable for the average Linux user.**

* The second inconvenience is that **compiling software takes time.** And compiling some software like GCC or QtWebEngine takes _a lot_ of time.

  While in Arch Linux you can get some software installed in seconds, in Gentoo it usually takes minutes or even hours depending on the software. That's a serious nuisance when you need that software _now_.
  
  There were also some efforts to alleviate the pain of having to compile everything, like some Gentoo-based distributions that offer binary packages, like the now-discontinued [Ututo](https://en.wikipedia.org/wiki/Ututo) and [Sabayon](https://en.wikipedia.org/wiki/Sabayon_Linux) and the more recent and still alive [Redcore](https://distrowatch.com/table.php?distribution=redcore).

  For some time, **Gentoo has been already supporting [binary packages](https://wiki.gentoo.org/wiki/Binary_package_guide)** providing means to package the compilation results and share them with other machines to install them as binary packages. For years, it was left up to the users to build their own binary package repositories, but they have recently started [experimenting](https://dilfridge.blogspot.com/2021/09/experimental-binary-gentoo-package.html) with the idea of an official Gentoo binary packages repository.

This recent Gentoo project to provide a binary repository will initially provide packages only for the AMD64 architecture with the default USE flags. In all other cases (like, for example, if you want to change some USE flag) you would still need to build the packages yourself. Which is still a great improvement.

In an upcoming post, we will see some ways to improve build times in Gentoo.
