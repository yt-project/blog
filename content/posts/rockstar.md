---
title: The Rockstar Halo Finder in yt
date: 2012-11-26T20:22:16-06:00
lastmod: 2012-11-26T20:22:16-06:00
author: Stephen Skory
cover: /img/ROCK_halo0006_0.png
categories:
  - tutorial
tags:
  - New Features
---

Over the last few weeks, Matt Turk, Christopher Moody, and Stephen Skory
have been working to improve the integration of the Rockstar halo finder
in yt. Rockstar was written primarily by Peter Behroozi and has a main
website [here](http://code.google.com/p/rockstar/). Linked there is the
source and the most current edition of the method paper which includes a
timing and scaling study.

Rockstar is a six dimensional halo finder, meaning that it considers
both particle position and momentum when locating dark matter halos. It
is also capable of locating bound substructure in halos and producing a
detailed merger tree. As of this writing its main deficit is that it
cannot handle simulations with varying particle mass. This means that in
simulations that include star particles, the star particles must be
excluded for the purposes of halo finding. Also, Rockstar cannot analyze
\"zoom-in\" or \"nested\" simulations with various values of dark matter
particle mass.

Here is a brief list of the main improvements:

 -   Improved the Cython Rockstar wrapper to allow multiple reader
     tasks. For large datasets on parallel disk systems using multiple
     reader tasks can significantly speed up the overall analysis.
 -   It is now possible to load Rockstar halos off disk (for post
     analysis) that behave like all the other halo objects available in
     yt (HOP, FOF). It is possible to access the halo particle data,
     and the particle data is only loaded on demand.
 -   Additionally, Rockstar halos have attached to them supplementary
     information pulled directly from the Rockstar output. In
     particular, if there is merger tree information, it is stored
     there.
 -   Rockstar should now build automatically with the rest of yt when
     the `install_script.sh` is used.
 -   Rockstar can work \"inline\" with Enzo, meaning that it can locate
     halos from a running Enzo cosmology simulation without first
     staging the data to disk.

The full documentation on how to run Rockstar is available [in the yt
documentation](http://yt-project.org/doc/analysis_modules/running_halofinder.html#rockstar-halo-finding).

## Examples of Substructure Location

One of the compelling features of Rockstar is the ability to identify
bound substructure of halos. Below are two images showing the halos
identified by HOP and Rockstar over-plotted on a projection of gas
density. Note that the circles mean different things in the two cases.
In the case of HOP, the circles show the radius from the center of mass
to the *most distant particle*, while for Rockstar it is from the center
of mass to the *calculated virial radius*.

Paying attention to the central region of the halo, notice how Rockstar
identifies the small in-falling subhalos that HOP doesn\'t. This is not
surprising because HOP is not designed to detect substructure.

HOP:

![HOP Output](/img/HOP_halo0002_0.png)

Rockstar:

![Rockstar Output](/img/ROCK_halo0006_0.png)

Note that In the Rockstar image, the halos on the periphery are not
encircled due to the way the image was prepared.
