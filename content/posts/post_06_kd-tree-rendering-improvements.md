---
title: kD-Tree Rendering Improvements
author: Sam Skillman
date: 2010-09-27T11:46:00-00:00
lastmod: 2010-09-27T11:46:00-00:00
cover: /img/3d_kd_breadth_decomp.png
categories:
  - archive
tags:
  - archive
  - yt-core
---
Hi all,

Just sharing a video here that showcases some improvements I've made to
the kD-tree rendering that will be making its way to yt for the 2.0
release. You can download it `render_movie.3gp|here`

Just to be clear this is showing the rendering of a cosmology simulation
with a 64^3 root grid + 6 AMR levels in real time on 8 processors. The
script is run in parallel, with the root processor displaying the
results once each frame is finished. The viewpoint is being randomized,
showing the power of a kD- tree homogenization that allows a fast
back-to-front sorting algorithm for each brick. The big key here is that
each processor keeps the data associated with its volume in memory so
that a new viewpoint doesn't require additional file I/O.

To help get an idea of what the load balancing is doing, I figured out a
way to plot the outline of the bricks with a color corresponding to each
processor. This is using the breadth-first load balancing where the top
N subtrees are distributed across the N processors. Some of the colors
overlap in an odd way because of the order in which they are shown but
you can get the general idea.

![image](/img/3d_kd_breadth_decomp.png)

There are a few more improvements on the way such as parallel kD-tree
construction which should lower the overhead for this method by quite a
lot, so keep an eye out!
