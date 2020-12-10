# ParaView and yt

author: Matthew Turk

date: 2011-06-13T20:09:34-00:00

Thanks to some awesome work by developers at Kitware, yt can now be
called from within ParaView!

This relies on a couple things, all of which are pretty exciting moving
forward. The idea behind this is to leverage where the two codes have
their own strengths and weaknesses, and identify places where they can
work productively together. For instance, yt has been designed to
provide astrophysical analysis; in this way, it can generate adaptive
projections, spectral energy distributions and so on. By feeding data to
yt (and not asking yt to read any on its own) these functions can be
called from within ParaView, and images and results returned back to
ParaView.

The strategy taken has, so far, been a light one. Almost all of the yt
machinery has been left in place; what happens is a relatively simple
process:

> -   Load data into ParaView
> -   Feed data into yt
> -   Construct IO handlers that pass the contents of internal VTK
>     structures to yt through a custom `IOHandlerBase` implementation.
> -   Construct a hierarchy from the existing contents of the
>     `vtkHierarchicalBoxDataSet` object, and its attendant child
>     objects.
> -   Execute analysis
> -   Return processed data to paraview

We're currently investigating how to streamline this process; currently,
it utilizes a new frontend I wrote that was designed to stream data into
yt from arbitrary locations. This can act as a proxy for datasets that
are already loaded into yt, for datasets that are constructed *ab
initio* in yt and for accepting data through in-memory transfer from
ParaView! One of the fun applications of this will be using ParaView as
a means for conducting
[Co-processing](http://www.kitware.com/blog/home/post/28) of data.

Thanks very much to Jorge, Berk, Charles and George at Kitware for all
your hard work to make this happen. This is going to be a really fun way
to explore new methods for analysis moving forward.

Not only is this exciting because it enables better cross-talk between
yt and ParaView, but also because of the technology that is being
developed on both sides. The stream handler in yt, in particular, is a
great output from this: it can be used in the future to construct
arbitrary datasets in memory, as well as to prototype new frontends for
codebases. When yt gains the ability to write out datasets for various
code types, this will be a valuable tool for constructing datasets from
scratch.

For more information, see [this
pose](http://public.kitware.com/pipermail/amr/2011-June/000027.html) on
the AMR mailing list at Kitware, which contains an example script. While
this functionality will be in the 2.2 release, it will be highlighted in
the 2.3 release as we streamline and work out bugs in a proper ParaView
frontend.
