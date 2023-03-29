---
title: "Faster packages building in Gentoo with tmpfs and binhosts"
slug: documents/technical/gentoo-tmpfs-binhosts-speed-up-build
date: 2023-03-27T11:17:20+02:00
tags: [gentoo,linux,floss]
images: [/why-gentoo/gentoo-logo.svg]
summary: How to use tmpfs and binhosts for faster packages building in Gentoo
showtoc: True
---
I am not going to talk about methods that are already widely known and documented like [distcc](https://wiki.gentoo.org/wiki/Distcc) and [ccache](https://wiki.gentoo.org/wiki/Ccache). They are already documented in the official Gentoo documentation and there is no reason to repeat the same here.

Also, from my point of view, the process to activate those features is not very simple and the result does not make it worth it.

## tmpfs

But there is another unofficial and not so documented way to speed up builds: using [tmpfs](https://en.wikipedia.org/wiki/Tmpfs) for the build directory ([`PORTAGE_TMPDIR`](https://wiki.gentoo.org/wiki//etc/portage/make.conf#PORTAGE_TMPDIR)). tmpfs uses RAM as a file system, which allows a much faster access. Since disk access is one of the things that has the biggest impact on compile times, changing these RAM accesses achieves a significant improvement in compile times in a quite simple way.

The necessary steps are quite simple:

1. Add a new entry in `/etc/fstab` that mounts a new `tmpfs` filesystem that we will use to compile packages:
   ```
   tmpfs /var/tmp/portage-tmpfs  tmpfs size=4G,mode=775,gid=portage,uid=portage
   ```
   The value we put in `size` is the size of that new filesystem, which will limit the size of packages that can be compiled on that filesystem (more on that later).
2. Mount the new filesystem:
   ```
   mount /var/tmp/portage-tmpfs
   ```
3. Change the value of `PORTAGE_TMPDIR` in `/etc/portage/make.conf` so it uses the new filesystem:
   ```
   PORTAGE_TMPDIR=/var/tmp/portage-tmpfs
   ```

That's all. From now on, packages compiled with Portage will use `tmpfs`, bringing a noticeable speed increase.

### Exceptions

However, as I mentioned in the first step, the size of the packages we can compile in `tmpfs` will be limited by the size we provide in the `size` parameter, which may not be enough for larger packages like `dev-qt/qtwebengine`, `dev-lang/mono` or `dev-lang/spidermonkey`.

To fix this, we can use `package.env` to add an exception for certain packages so they are still compiled in the hard drive instead of `tmpfs`:

1. Create a new `/etc/portage/env/notmpfs` file that resets `PORTAGE_TMPDIR` to its original value in the hard drive instead of the new directory in `tmpfs`:
   ```
   PORTAGE_TMPDIR=/var/tmp/portage
   ```
2. In another `/etc/portage/package.env/notmpfs` file, we list the packages that we want to use the environment variables of the `notmpfs` file from the previous step (i.e., the packages that will compile on disk):
   ```
   app-office/libreoffice notmpfs
   app-emulation/virtualbox notmpfs
   dev-lang/mono notmpfs
   dev-lang/rust notmpfs
   dev-lang/spidermonkey notmpfs
   dev-qt/qtwebengine notmpfs
   www-client/firefox notmpfs
   ```

That's all. Those packages will use a different directory to compile.

## Binary packages

Another thing we can do to speed up the installation of packages is simply not to compile them.

Although one of the main characteristics of Gentoo is that all packages are compiled and no official precompiled packages are offered, it still offers the possibility of generating binary packages from the packages that are compiled in a way that they can be reused.

This is useful for example if you use Gentoo on several machines that are similar or use the same architecture, so packages would be built only on one of the machines and reused on the others. However, packages may not be reusable if the [USE flags](https://wiki.gentoo.org/wiki/USE_flag) or dependencies change between machines.

For more information, see the official documentation on [binary packages in Gentoo](https://wiki.gentoo.org/wiki/Binary_package_guide).

Also, you can totally avoid the compilation of packages if you use a binhost or binary package repository, but we have to be sure we are using a trusted repository where the compiled packages have not been modified with malicious code. Also, some packages might be compiled with options that are incompatible with your system such as a newer version of glibc or a different [CHOST](https://wiki.gentoo.org/wiki/CHOST).

### List of binary repositories

Some repositories available for AMD64 architecture:

* Although it's still being tested, Gentoo does have a [repository of binary packages](https://gentoo.osuosl.org/experimental/amd64/binpkg/default/linux/17.1/x86-64/).
* [Pentoo](https://pentoo.osuosl.org/Packages/)
* [Redcore Linux](http://mirrors.redcorelinux.org/redcorelinux/amd64/packages/)
* [Calculate Linux](https://mirror.calculate-linux.org/)
* I also have [my own binhost](https://binpkgs.chuso.net/amd64/)
* [f1r.eu](https://tbz.f1r.eu/packages/seed-lxc-pdns/). I don't really know who is behind this repository and some of them are compiled with a newer version of `sys-libs/glibc` from `~amd64`, so use them with care

For ARM64, I don't know any other repository than [my own](https://binpkgs.chuso.net/arm64/) which I build when I compile [Pinetoo](http://pinetoo.org) for the PinePhone.
