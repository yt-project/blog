---
title: yt development: Documentation
author: Matthew Turk
date: 2011-02-07T05:29:00-00:00
lastmod: 2011-02-07T05:29:00-00:00
cover: /img/random/shoes.jpeg
categories:
  - archive
tags:
  - archive
---
As a result of progress in my scientific goals, and the application of
recent yt developments to them, I did not make many changes or
developments in yt this week. When I did work on yt, I primarily spent
time re-organizing the [documentation](http://yt.enzotools.org/doc/) and
fixing several errors. I have added an "installation" section,
consolidated a few sections, and wrote two new sections on how to make
plots and on how to generate derived data products. I think that the
documentation is now much easier to navigate and follow.

This week I also fine-tuned the API for the bridge that connects Enzo
and Python, relying on feedback from other Enzo developments. This work
is the first step in creating a generalized library for constructing
initial conditions; it is not meant to be Enzo-specific. I will report
more on this, but the ultimate goal is to be able to construct initial
conditions using scripts, rather than constructing multiple C routines.
This should make scientific experimentation much more accessible.

One final note is that this last week saw the first successful execution
of a large-scale Enzo simulation with inline analysis provided by yt,
using the <span class="title-ref">EnzoStaticOutputInMemory</span>
object. BrittonS is driving that simulation forward, and he's also
conducting benchmarks to see how expensive inline analysis is.
