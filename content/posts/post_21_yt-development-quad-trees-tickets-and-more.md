---
title: yt Development: Quad trees, Tickets and more
author: Matthew Turk
date: 2011-06-02T20:20:00-00:00
lastmod: 2011-06-02T20:20:00-00:00
cover: /img/random/shoes.jpeg
categories:
  - archive
tags:
  - archive
---
It's been a while since the last Development post &mdash; but in that
time, some pretty fun things have been going on. These are some of the
smaller things, but there are bigger things in store which I'll write
about next time.

## QuadTree Projections

For a while, there has been the option to use a QuadTree data structure
to conduct projections through a simulation volume. This was accessible
through the `quad_proj` attribute, which respected the same interface as
the normal `proj` interface. The old-style projection code required a
spatial decomposition in parallel, and did not use the most efficient
mechanism for identifying where cells go and which grids overlapped
other grids.

The quad tree projection mostly avoided those issues; it could
(theoretically) be parallelized with an arbitrary load- balancing
scheme, and it should avoid having to calculate any overlaps, as they're
inherent to the data structure. However, parallelizing the final combine
was never implemented &mdash; so while it showed good results for
scaling in serial, it didn't work in parallel.

However, as of today, it's now parallel! For big simulations, it should
provide a speedup of between 2 and 10 for projecting. For the 2.2
release, this will be the default mechanism for projecting. If you're
reading this, you're encouraged to check it out by replacing the
old-style projection with the new: pf.h.proj = pf.h.quad\_proj

and then conducted any analysis you normally would. Testing and results
for scaling would be greatly appreciated!

## In-Memory Data Format

If you have some AMR data that you don't want to write a full plugin or
frontend for, you're now in luck. One can use the `Stream` frontend to
describe a hierarchy, create a data-reader or data-generator, and then
feed this to yt. And example of this can be found [here
&lt;http://matthewturk.bitbucket.org/html/ba3fd37b-842c-4641-b21e-2d3f5268eefe-
stream\_proxy-py.html&gt;]().

The first implementation of this will be for loading data in Paraview
and conducting analysis on this data in yt.

## Activation Script

We have a new contributor! [Casey W. Stark](http://thestarkeffect.com/)
added in activation scripts to the `install_script`. Using these means
you no longer have to set your `PYTHONPATH` or `LD_LIBRARY_PATH` or
`PATH` manually, as you can just source the activate scripts. Thanks,
Casey!

## Tickets! And Bug Reports!

All of the tickets from Trace have been
[migrated](http://hg.enzotools.org/yt/issues) to BitBucket. All bug
reports should be left there. Soon the wiki will be moved over, too, and
Trac will be mothballed.

Cameron and I are working on a new bug reporting mechanism that can be
run from the command line -- `yt bugreport` -- that should help ensure
triaging of bugs occurs in a timely and meaningful fashion.

That's it for this time. Happy simulating!
