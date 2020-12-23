---
title: The first yt development workshop! 
date: 2013-03-18T17:04:06-06:00
lastmod: 2020-12-03T17:04:06-06:00
author: Matthew Turk
authorlink: https://matthewturk.github.io/
cover: /img/devworkshop2013/devworkshop.jpg
categories:
  - archive
  - development
tags:
  - archive
  - community
---

On March 6-8, 2013 we held a yt development workshop at UCSC. Let's talk about
it!

<!--more-->

The First Development Workshop
==============================

March 6-8, we held a yt-dev workshop at UCSC.  Thanks to everyone who attended,
as well as Joel Primack and [HIPACC](http://hipacc.ucsc.edu/) for sponsoring
us.  This was the *first* development-oriented workshop we've ever held, and it
was a gigantic success!  To see a full photo album, visit our 
[Google Plus Page](https://plus.google.com/107728486871834552760/posts/BGi1ah4cNMh).

{{< figure src="/img/devworkshop2013/devworkshop.jpg" 
           title="Exciting development crowd!" 
           height=300
           width=400 >}}

With local organization by Nathan Goldbaum, Chris Moody and Ji-hoon Kim at
UCSC, over twenty people were able to participate, working on a diverse set of
projects.  The workshop was structured around introducing topics through
lightning talks and then sprinting on those topics during breakout sessions.

The lightning talks were set up to be one slide (or ten notebook cells, if you
used the IPython notebook!) presenting a concept with ideas for going into the
breakout sessions.  These were isolated ideas -- shovel-ready, with working
guidelines.  We had talks from John ZuHone, Casey Stark, Kacper Kowalik,
Cameron Hummels, Doug Rudd, Britton Smith, Jeff Oishi, Nathan Goldbaum and
Chris Moody.  Following this, we split into a series of breakout groups.

We also had talks from Joel Primack presenting the AGORA project and from Hari
Krishnan about his work to integrate yt and VisIt.  On the final day, we also
had a show-and-tell, where a member of each working group presented what they
worked on and what they accomplished.

Grid Data Format
----------------

This breakout group focused on building a portable library in C for reading and
writing data that takes the form of structured, rectilinear grids.  The idea
here is to adhere to the 
[GDF format](https://bitbucket.org/yt_analysis/grid_data_format), which specifies a
self-describing HDF5 layout for files.  By developing this portable library,
the group hopes to be able to use yt to 
[make initial conditions](http://blog.yt-project.org/post/Simple_Grid_Refinement.html), 
write them out
in the already-existing GDF writer in yt, and then link simulation codes
against this library to read them back in and run simulations.  It would also
enable directly converting between simulation code outputs.

Units and Arrays
----------------

This group ambitiously set out the task of incorporating Casey's library
[dimensionful](http://caseywstark.com/blog/2012/code-release-dimensionful/)
into yt.  This library utilizes SymPy for developing a units system that can
convert between known units as well as affiliate those units with array
objects.  The hope here is to eliminate much of the existing unit handling and
field duplication (i.e., CellMass and CellMassMsun) and provide easier methods
for deploying unit conversions.  This work may take some time to integrate into
yt 3.0, but it will be a feature of that codebase eventually.  By the end of
the workshop, this group had a working implementation.

Halo Catalogs
-------------

The current system for handling halos and halo catalogs in yt is a bit *ad
hoc*, where objects are passed around and data held onto for some time.  This
is inefficient and doesn't lend itself well to agile and flexible halo finding.
This working group developed a rough outline of a YTEP that described halo
finding and halo catalogs as a state of *flow* -- rather than performing
analysis after the fact, analysis will now be performed during the course of
halo finding.  This will be done by supplying a set of callbacks that will be
executed on each halo in turn.  An ontology for describing halo catalogs was
also developed, which is being fleshed out in a YTEP.

Octree Improvements
-------------------

Some representatives of the NMSU-ART code were present at the workshop.  This
working group focused on cleaning up the rough edes of the Octree support in
yt-3.0, as well as applying it to some actual data.  Chris spent quite a bit of
time polishing up star particle IO, fixing rough corners in the octree code,
and testing things.  Kenza gave a show-and-tell talk on the final day showing
how she was able to load up a galaxy formation simulation and plot streamlines,
all in a few lines of code.

ARTIO
-----

For extremely large Octree datasets, it's simply infeasible to load the entire
mesh into memory.  The ARTIO working group worked to develop opaque data chunks
in yt-3.0, so that yt can iterate over chunks, build data objects, perform
processing, and conduct visualization all without needing to know how the data
is laid out on disk or knowing anything about the mesh at all!  This is an
extremely powerful concept, and will hopefully present a number of
opportunities for applying this elsewhere in the future.

Volume Rendering
----------------

The method by which volume renderings are created in yt is a bit clunky right
now.  Many arguments are pushed into the constructor for the Camera object, and
then there's a limited flexibility after that.  This working group built off of
the still-pending YTEP-0010 to build a new system for creating volume
renderings with a stateful Scene, cameras that move, volumes that don't, and so
on.  Cameron, Mark and Will demoed a working implementation of a Scene object
on the final day.  Jill also was able to demo on the final day some initial
integration of yt with Blender -- showing how to script the camera path via
Python, display surfaces extracted with yt, and make movies from them.

Thank you!
----------

Thanks to everyone who attended!  It was a great time, and I think we're all
excited to have another one sometime in the future.
