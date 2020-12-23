---
title: 3D Surfaces and Sketchfab
date: 2012-12-05T13:37:36-06:00
lastmod: 2020-12-04T13:37:36-06:00
author: Matthew Turk
authorlink: https://matthewturk.github.io/
cover: /img/sketchfab/sketchfab.png
categories:
  - archive
  - tutorial
tags:
  - archive
  - new features
  - surfaces
---

Let's talk about exporting surfaces to sketchfab with yt!

<!--more-->

3D Surfaces and Sketchfab
=========================

Surfaces
--------

For a while now, yt has had the ability to extract isosurfaces from volumetric
data using a [marching cubes](http://en.wikipedia.org/wiki/Marching_cubes)
algorithm.  The surfaces could be exported in 
[OBJ format](http://en.wikipedia.org/wiki/Wavefront_.obj_file), 
values could be samples
at the center of each face of the surface, and flux of a given field could be
calculated over the surface.  This means you could, for instance, extract an
isocontour in density and calculate the mass flux over that isocontour.  It
also means you could export a surface from yt and view it in something like
[Blender](http://www.blender.org/), [MeshLab](http://meshlab.sourceforge.net/), 
or even on your Android or iOS device in
[MeshPad](http://www.meshpad.org/) or 
[MeshLab Android](https://play.google.com/store/apps/details?id=it.isticnr.meshlab&hl=en).
One important caveat with marching cubes is that with adaptive mesh refinement
data, you *will* see cracks across refinement boundaries unless a
"crack-fixing" step is applied to match up these boundaries.  yt does not
perform such an operation, and so there will be seams visible in 3D views of
your isosurfaces.

The methods to do so were methods on data objects -- ``extract_isocontours``,
``calculate_isocontour_flux`` -- which returned just numbers or values.
However, recently, I've created a new object called ``AMRSurface`` that makes
this process much easier.  You can create one of these objects by specifying a
source data object and a field over which to identify a surface at a given
value.  For example:

```Python
   from yt.mods import *
   pf = load("/data/workshop2012/IsolatedGalaxy/galaxy0030/galaxy0030")
   sphere = pf.h.sphere("max", (1.0, "mpc"))
   surface = pf.h.surface(sphere, "Density", 1e-27)
```

This object, ``surface``, can now be queried for values on the surface.  For
instance:

```Python

   print surface["Temperature"].min(), surface["Temperature"].max()

```

will return the values 11850.7476943 and 13641.0663899.  These values are
interpolated to the face centers of every triangle that constitutes a portion
of the surface.  Note that reading a new field requires re-calculating the
entire surface, so it's not the fastest operation.  You can get the vertices of
the triangle by looking at the property ``.vertices``.

Exporting to a File
-------------------

If you want to export this to a i
[PLY file](http://en.wikipedia.org/wiki/PLY_(file_format)) you can call the routine
``export_ply``, which will write to a file and optionally sample a field at
every face or vertex, outputting a color value to the file as well.  This file
can then be viewed in MeshLab, Blender or on the website 
[Sketchfab.com](Sketchfab.com)  But if you want to view it on Sketchfab, there's an even
easier way!

Exporting to Sketchfab
----------------------

[Sketchfab](http://sketchfab.com) is a website that uses WebGL, a relatively
new technology for displaying 3D graphics in any browser.  It's very fast and
typically requires no plugins.  Plus, it means that you can share data with
anyone and they can view it immersively without having to download the data or
any software packages!  Sketchfab provides a free tier for up to 10 models, and
these models can be embedded in websites.

There are lots of reasons to want to export to Sketchfab.  For instance, if
you're looking at a galaxy formation simulation and you publish a paper, you
can include a link to the model in that paper (or in the arXiv listing) so that
people can explore and see what the data looks like.  You can also embed a
model in a website with other supplemental data, or you can use Sketchfab to
discuss morphological properties of a dataset with collaborators.  It's also
just plain cool.

The ``AMRSurface`` object includes a method to upload directly to Sketchfab,
but it requires that you get an API key first.  You can get this API key by
creating an account and then going to your "dashboard," where it will be listed
on the right hand side.  Once you've obtained it, put it into your
``~/.yt/config`` file under the heading ``[yt]`` as the variable
``sketchfab_api_key``.  If you don't want to do this, you can also supply it as
an argument to the function ``export_sketchfab``.

Now you can run a script like this:

```Python
   from yt.mods import *
   pf = load("redshift0058")
   dd = pf.h.sphere("max", (200, "kpc"))
   rho = 5e-27

   bounds = [(dd.center[i] - 100.0/pf['kpc'],
              dd.center[i] + 100.0/pf['kpc']) for i in range(3)]

   surf = pf.h.surface(dd, "Density", rho)

   upload_id = surf.export_sketchfab(
       title = "RD0058 - 5e-27",
       description = "Extraction of Density (colored by Temperature) at 5e-27 " \
                   + "g/cc from a galaxy formation simulation by Ryan Joung."
       color_field = "Temperature",
       color_map = "hot",
       color_log = True,
       bounds = bounds
   )
```

and yt will extract a surface, convert to a format that Sketchfab.com
understands (PLY, in a zip file) and then upload it using your API key.  For
this demo, I've used data kindly provided by Ryan Joung from a simulation of
galaxy formation.  Here's what my newly-uploaded model looks like, using the
embed code from Sketchfab:

<!---
fix this with a custom shortcode
--->

   <iframe frameborder="0" height="480" width="854" allowFullScreen
   webkitallowfullscreen="true" mozallowfullscreen="true"
   src="https://skfb.ly/l4jh2edcba?autostart=0&transparent=0&autospin=0&controls=1&watermark=1"></iframe> 

As a note, Sketchfab has a maximum model size of 50MB for the free account.
50MB is pretty hefty, though, so it shouldn't be a problem for most needs.
We're working on a way to optionally upload links to the Sketchfab models on
the [yt Hub](https://hub.yt-project.org/), but for now, if you want to share
a cool model we'd love to see it!

Thanks to Sketchfab for such a cool service, and for helping us out along the
way with their API.
The remaining content of your post.
