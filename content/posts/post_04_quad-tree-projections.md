# Quad Tree Projections

author: Matthew Turk

date: 2010-09-10T21:41:23-00:00

The current method for projections in yt is based on a home-grown
algorithm for calculating grid overlap and joining points. I've always
been pretty proud of it -- it gave good results, and it succeeded at the
project-once-make-many-images philosophy that went into its design.
Rather than storing a 2D array of pixels, projections and slices in yt
store flat arrays of image plane coordinates and cell widths. This means
that there's an additional step of pixelization to create an image, but
it also means that arbitrary images can be made from a single projection
or slice operation.

Over the years, I've spent a lot of time shaving time off of the
projection mechanism. But, it was still slow on some types of data --
and the parallelism was never all that great, either. Because of the
algorithm, the parallelism was exclusively based on image-plane
decomposition, which means that it was difficult to get good load
balancing on nested grid simulations and that it was simply impossible
to run inline unless massive amounts of data were to be passed over the
wire between processes. This ultimately meant that embedded analysis
could not generate adaptive projections, only fixed resolution
projections.

A couple months ago, I tried my hand at implementing a new mechanism for
projecting based on [quad trees](http://en.wikipedia.org/wiki/Quadtree).
The advantage with Quad Trees would be that they could be decomposed
independent of the image plane; this would enable the projections to be
made inline, without shipping data around between nodes. The initial
results were extremly promising -- it was able to project the density
field for a 1024^3, 7-level dataset (1.6 billion cells) in just around
2300 seconds in serial, with peak memory usage of 2.7 gigabytes, easily
fitting within a single node. I don't know how long it would take to
project this in serial with the old method, because I killed the task
after a few hours.

For various reasons, I did not have time to implement this in the main
yt code until very recently. It now lives in the main 'yt' branch as the
AMRQuadProj class, hanging off the hierarchy as .quad\_proj. Once it has
been parallelized, it will replace the old .proj method, and will be
used natively. One of the unfortunate side effects of inserting it into
the full yt machinery is that projections have to satisfy a number of
API requirements -- they have to handle field cuts, arbitrary data
objects, and several other reductions that slow things down. However,
even with this added baggage, in most cases the new quad tree projection
will be about twice as fast as the old method for projections. If you
want to give it a go before it becomes the default, you can access it
directly by calling .quad\_proj on the hierarchy.

Hopefully I'll be able to parallelize it soon, so that this can become
the default method -- and so that variable resolution projections can
make their way into embedded analysis!
