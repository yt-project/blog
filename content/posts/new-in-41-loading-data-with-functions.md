---
title: "New in 4.1: Loading data with functions"
date: 2022-09-01T09:00:00-06:00
author: Matthew Turk
authorlink: https://matthewturk.github.io
cover: /img/cover.jpg
categories:
- Development
- Releases
tags:
- yt 4.1
- Loading Data
- Release
- New Feature
---

There's a new feature in yt 4.1 that lets you load data using just functions, without it needing to be in memory or to have its own frontend defined.

Back in the long, long distant past, the `Stream` frontend was created to make it easy to bring data into yt without writing a full-on "frontend." Originally this was to make it easy to share data between [VTK](https://vtk.org/) and yt -- and it worked! We were even able to write this up in a [blog post over at Kitware's blog](https://www.kitware.com/a-yt-plugin-for-paraview/).

The original idea was that if we could separate out the responsibilities for indexing, IO, etc etc, into a set of easily user-definable components, we could make it a lot easier to define individual frontends, including for the ParaView (and VTK) components we used in that post.

That didn't ... exactly happen. Instead, what we ended up doing was writing wrapper functions for some of the most common use cases -- `load_uniform_grid`, `load_amr_grids`, `load_particles`, `load_hexahedral_mesh`, `load_unstructured_mesh` and `load_octree` -- and then those became the primary drivers of all of the `Stream` frontend development. They hid almost all of the underlying machinery, and they became where time was invested.

But, that brings me back to a feature I'm really excited about in yt 4.1 -- you can now use the `Stream` frontend to load data that is only accessible via functions. Whereas in the past everything had to be supplied using numpy arrays, now you can just supply function handles. In many ways this is similar to derived fields -- those, too, are just functions that are supplied. But the distinction here is that you're also (by default) supplied spatial information in the function handler, specifically the `GridPatch` object.

So ... what does that mean? Well, it means that if your data is hidden behind some complicated set of HTTP requests, or an API that you haven't plugged into yt, you can expose it using functions!

This might not sound like a big deal, but I'm pretty excited about what this will open up. One place we've seen some real potential for it has been in situations where data is easily accessible from an API, but where the act of writing a frontend poses some overhead.

But this also opens up some pretty neat opportunities to do memory-conservative access of data that is stored in familiar file formats, too!
