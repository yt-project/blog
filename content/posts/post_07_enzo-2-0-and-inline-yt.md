---
title: Enzo 2.0 and Inline yt
author: Matthew Turk
date: 2010-09-30T20:05:36-00:00
lastmod: 2010-09-30T20:05:36-00:00
authorlink: https://matthewturk.github.io/
cover: /img/yt_logo.svg
categories:
  - archive
tags:
  - archive
  - frontends Enzo
---
Enzo 2.0 has just been released to its new [Google Code
website](http://enzo.googlecode.com/). This release features preliminary
support for inline Python analysis, using yt.

In the Enzo documentation there's a [brief
section](http://docs.enzo.googlecode.com/hg/user_guide/EmbeddedPython.html)
on how to use yt for inline analysis. As it stands, many features are
not fully functional, but things like phase plots, profiles, derived
quantities and slices all work. This functionality is currently untested
at large (&gt; 128) processors, but for small runs -- particularly
debugging runs! -- it works nicely. (Projections do not work yet, [but
they will &lt;http://blog.enzotools.org /quad-tree-projections&gt;]().)

Email the mailing list or leave a comment here if you run into any
trouble, or if you want to share success stories!
