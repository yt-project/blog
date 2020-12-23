---
title: What's up with yt 3.0?
date: 2012-11-15T21:05:33-06:00
lastmod: 2012-11-15T21:05:33-06:00
author: Matthew Turk
authorlink: https://matthewturk.github.io/
cover: /img/cylindrical_pixelizer.png
categories:
  - archive
  - development
tags:
  - archive
  - yt-3.x
---

This is a long blog post! The short of it is:

*   If you're using Enzo or FLASH, you can probably do most of what
    you want to do with 3.0. But there are probably bugs, and you
    can't volume render yet. But every bug or missing feature you find
    is a useful piece of information that can help speed up
    development.
*   If you're using RAMSES, 3.0 will be a vast improvement!
*   Boxlib codes will need a small amount of updating to get working
    in 3.0
*   SPH is coming!

As with all of yt, 3.0 is being developed completely in the open. We're
testing using JIRA at <http://yt-project.atlassian.net/> for tracking
progress. The main development repository is at
<https://bitbucket.org/yt_analysis/yt-3.0> and discussions have been
ongoing on the yt-dev mailing list. Down below you can find some
contributor ideas and information!

## Why 3.0?

The very first pieces of yt to be written are now a bit over six years
old. When it started, it was a very simple Python wrapper around pyHDF,
designed to make slices, then export those slices to ASCII where they
were plotted by a plotting package called HippoDraw. It grew a bit to
include projections and sphere selection over the course of a few
months, and eventually became the community project it is today.

But, despite those initial steps being a relatively long time ago, there
are still many vestiges in yt. For instance, the output of `print_stats`
on an AMR hierarchy object is largely unchanged since that time.

Most importantly, however, is that yt needs to continue to adapt to best
serve analysis and visualization needs in the community. To do that, yt
3.0 has been conceived as a project to rethink some of the basic
assumptions and principles in yt. In doing so, we will be able to
support new codes of different types, larger datasets, and most
importantly enable us to grow the community of users and developers. In
many ways, the developments in yt 3.0 will serve to clarify and simply
the code base, but without sacrificing speed or memory. By changing the
version number from 2.X to 3.0, we also send the signal that things may
not work the same way -- and in fact, there may be API incompatibilities
along the way. But they won't be changed without need, and we're trying
to reduce disruption as much as possible.

yt 3.0 is designed to allow support for non-cartesian coordinates,
non-grid data (SPH, unstructured mesh), and to remove many of the
"Enzo-isms" that populate the code base. This brings with it a lot of
work, but also a lot of opportunity.

If you have ideas, concerns or comments, email yt-dev!

## What's Going In To 3.0?

We've slated a large number of items to be put into 3.0, as well as a
large number of system rewrites. By approaching this piecemeal, we hope
to address one feature or system at a time so that the code can remain
in a usable state.

### Geometry selection

In the 2.X series, all geometric selection (spheres, regions, disks) is
conducted by looking first at grids, then points, and choosing which
items go in. This also involves a large amount of numpy array
concatenation, which isn't terribly good for memory.

The geometry selection routines have all been rewritten in Cython. Each
geometric selection routine implements a selection method for grids and
points. This allows non-grid based codes (such as particle-only codes)
to use the same routines without a speed penalty. These routines all
live inside `yt/geometry/selection_routines.pyx`, and adding a new
routine is relatively straightforward.

The other main change with how geometry is handled is that data objects
no longer know how the data is laid out on disk or in memory. In the
past, data objects all had a `_grids` attribute. But, in 3.0, this can
no longer be relied upon -- because we don't want all the data formats
to *have* grids! Data is now laid out in format-neutral "chunks," which
are designed to support selection based on spatial locality, IO
convenience, or another arbitrary method. This allows the new
`GeometryHandler` class to define how data should be read in off disk,
and it reduces the burden on the data objects to understand how to best
access data.

For instance, the `GridGeometryHandler` understands how to batch grid IO
for best performance and how to feed that to the code-specific IO
handler to request fields. This new method allows data objects to
specifically request particular fields, understand which fields are
being generated, and most importantly not need to know anything about
how data is being read off disk.

It also allows dependencies for derived fields to be calculated before
any IO is read off disk. Presently, if the field `VelocityMagnitude` is
requested of a data object, the data object will read the three fields
`x-velocity`, `y-velocity` and `z-velocity` (or their frontend-specific
aliases -- see below for discussion of "Enzo-isms") independently. The
new system allows these to be read in bulk, which cuts by a third the
number of trips to the disk, and potentially reduces the cost of
generating the field considerably.

Finally, it allows data objects to expose different chunking mechanisms,
which simplifies parallelism and allows parallel analysis to respect a
single, unified interface.

Geometry selection is probably the biggest change in 3.0, and the one
that will enable yt to read particle codes in the same way it reads grid
codes.

### Removing Enzo-isms

yt was originally designed to read Enzo data. It wasn't until Jeff Oishi
joined the project that we thought about expanding it beyond Enzo, to
the code Orion, and at the time it was decided that we'd alias fields
and parameters from Orion to the corresponding field names and
parameters in Enzo. The Orion fields and parameters would still be
available, but the *canonical* mechanism for referring to them from the
perspective of derived fields would be the Enzo notation.

When we developed yt 2.0, we worked hard to remove many of the Enzo-isms
from the parameter part of the system: instead of accessing items like
`pf["HubbleConstantNow"]` (a clear Enzo-ism, with the problem that it's
also not tab completable) we changed to accessing explicitly accessing
`pf.hubble_constant`.

But the fields were still Enzo-isms: `Density`, `Temperature`, etc. For
3.0, we decided this will change. The standard for fields used in `yt`
is still under discussion, but we are moving towards following PEP-8
like standards, with lowercase and underscores, and going with explicit
field names over implicit field names. Enzo fields will be translated to
this (but of course still accessible in the old way) and all derived
fields will use this naming scheme.

### Non-Cartesian Coordinates

From its inception, yt has only supported cartesian coordinates
explicitly. There are surprisingly few places that this becomes directly
important: the volume traversal, a few fields that describe field
volumes, and the pixelizer routines.

Thanks to hard work by Anthony Scopatz and John ZuHone, we have now
abstracted out most of these items. This work is still ongoing, but we
have implemented a few of the basic items necessary to provide full
support for cylindrical, polar and spherical coordinates. Below is a
slice through a polar disk simulation, rendered with yt.

![](/img/cylindrical_pixelizer.png)

</div>

### Unit Handling and Parameter Access

Units in yt have always been in cgs, but we would like to make it easier
to convert fields and lengths. The first step in this direction is to
use Casey Stark's project dimensionful (
<http://caseywstark.com/blog/2012/code-release-dimensionful/> ). This
project is ambitious and uses the package SymPy ( <http://sympy.org> )
for manipulating symbols and units, and it seems ideal for our use case.
Fields will now carry with them units, and we will ensure that they are
correctly propagated.

Related to this is how to access parameters. In the past, parameter
files (`pf`) have been overloaded to provide dict-like access to
parameters. This was degenerate with accessing units and conversion
factors. In 3.0, you will need to explicitly access `pf.parameters` to
access them.

### Multi-Fluid and Multi-Particle Support

In yt 3.0, we want to be able to support simulations with separate
populations of fluids and particles. As an example, in many cosmology
simulations, both dark matter and stars are simulated. As it stands in
yt 2.X, separating the two for analysis requires selecting the entire
set of all particles and discarding those particles not part of the
population of interest. Some simulation codes allow for subselecting
particles in advance, but the means of addressing different particle
types was never clear. For instance, it's not ideal to create new
derived fields for each type of particle -- we want to re-use derived
field definitions between particle types.

Some codes, such as Piernik (the code Kacper Kowalik, one of the yt
developers, uses) also have support for multiple fluids. There's
currently no clear way to address different types of fluid, and this
suffers from the same issue the particles do.

In 3.0, fields are now specified by two characteristics, both of which
have a default, which means you don't have to change anything if you
don't have a multi-fluid or multi-particle simulation. But if you do,
you can now access particles and fluids like this:

    sp = pf.h.sphere("max", (10.0, 'kpc'))
    total_star_mass = sp["Star", "ParticleMassMsun"].sum()

Furthermore, these field definitions can be accessed anywhere that
allows a field definition:

    sp = pf.h.sphere("max", (10.0, 'kpc'))
    total_star_mass = sp.quantities["TotalQuantity"](("Star", "ParticleMassMsun"))

For codes that do allow easy subselection (like the
sometime-in-the-future Enzo 3.0) this will also insert the selection of
particle types directly in the IO frontend, preventing unnecessary reads
or allocations of memory.

By using multiple fluids directly, we can define fields for angular
momentum, mass and so on only once, but apply them to different fluids
and particle types.

### Supporting SPH and Octree Directly

One of the primary goals that this has all been designed around is
supporting non-grid codes natively. This means reading Octree data
directly, without the costly step of regridding it, as is done in 2.X.
Octree data will be regarded as Octrees, rather than patches with cells
in them. This can be seen in the RAMSES frontend and the
`yt/geometry/oct_container.pyx` file, where the support for querying and
manipulating Octrees can be found.

A similar approach is being taken with SPH data. However, as many of the
core yt developers are not SPH simulators, we have enlisted people from
the SPH community for help in this. We have implemented particle
selection code (using Octrees for lookups) and are already able to
perform limited quantitative analysis on those particles, but the next
phase of using information about the spatial extent of particles is
still to come. This is an exciting area, and one that requires careful
thought and development.

## How Far Along Is It?

Many of the items above are still in their infancy. However, several are
already working. As it stands, RAMSES can be read and analyzed directly,
but not volume rendered. The basics of reading SPH particles and quickly
accessing them are done, but they are not yet able to be regarded as a
fluid with spatial extent or visualized in a spatial manner. Geometry
selection is largely done with the exception of boolean objects and
covering grids. Units are still in their infancy, but the removal of
Enzo-isms has begun. Finally, non-cartesian coordinates are somewhat but
not completely functional; FLASH cylindrical datasets should be
available, but they require some work to properly analyze still.

## Why Would I Want To Use It?

The best part of many of these changes is that they're under the hood.
But they also provide for cleaner scripts and a reduction in the effort
to get started. And many of these improvements carry with them
substantial speedups.

For example, reading a large data region off disk from an Enzo dataset
is now nearly 50% faster than in 2.X, and the memory overhead is
considerably lower (as we get rid of many intermediate allocations.)
Using yt to analyze Octree data such as RAMSES and NMSU-ART is much more
straightforward, and it requires no costly regridding step.

Perhaps the best reason to want to move to 3.0 is that it's going to be
the primary line of development. Eventually 2.X will be retired, and
hopefully the support of Octree and SPH code will help grow the
community and bring new ideas and insight.

## How Can I Help?

The first thing you can do is try it out! If you clone it from
<http://bitbucket.org/yt_analysis/yt-3.0> you can build it and test it.
Many operations on patch based AMR will work (in fact, we run the
testing suite on 3.0, and as of right now only covering grid tests fail)
and you can also load up RAMSES data and project, slice, and analyze it.

If you run into any problems, please report them to either yt-users or
yt-dev! And if you want to contribute, whether that be in the form of
brainstorming, telling us your ideas about how to do things, or even
contributing code and effort, please stop by either the \#yt channel on
chat.freenode.org or yt-dev, where we can start a conversation about how
to proceed.

Thanks for making it all the way down -- 3.0 is the future of yt, and I
hope to continue sharing new developments and status reports.
