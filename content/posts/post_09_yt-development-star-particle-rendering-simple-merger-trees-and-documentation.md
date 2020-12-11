---
title: yt development\: star particle rendering, simple merger trees and documentation
author: Matthew Turk
date: 2011-01-17T05:27:00-00:00
lastmod: 2011-01-17T05:27:00-00:00
cover: /img/random/shoes.jpeg
categories:
  - archive
tags:
  - archive
---
This is the first of a new series of "what's up with yt" blog posts I'm
going to be writing. By keeping this log, I hope that maybe some things
that would otherwise get lost in the version control changesets will get
brought to greater light. This covers the time period of the first
couple weeks in January.

## Star Particle Rendering

On the mailing list, the question of adding star particles to a volume
rendering was raised. The question was mostly related to the idea of
adding an annotation &mdash; if you have a star particle somewhere in
the simulation, for instance in galactic star formation, you likely want
to annotate that somehow. After a bit of discussion, the question was
raised about using star particles in the volume rendering as sources of
emission; could star particles contribute to the overall image? I
consulted with a couple people and then added a first-pass
implementation to add them in to the brick casting. Each star particle
is defined as a Gaussian, and all star particles within the 99th
percentile of the center of a cell are sampled and added on to the
emission of a cell during ray-casting.

This can be an expensive operation, and it comes with a few important
caveats. The first is that right now, you are not necessarily going to
sample the centroid of the Gaussian, and so this simply may not work
correctly unless you have many, many star particles clustered together.
I hope to eliminate this problem by moving to an integration method that
is aware of the underlying function (erf / gaussian) rather than a pure
sampling method and rectangular integration. The second caveat is that
this cannot, in its current form, be used for radiation transport, as
the method is not conservative of flux from star particles: even
relative luminosities from star particles cannot be trusted. This is
currently a pure-visualization algorithm. The solution to the second
issue is not clear to me yet.

To use this, you will need to re-Cythonize your
`yt/utilities/amr_utils.pyx` file. Then rebuild your extensions. As of
right now, there are no real convenience functions for rendering star
particles, so the following relatively verbose code has to be used to
add them appropriately to the volume renderer. This assumed you have
created a `camera` object.

``` python
import yt.utilities.amr_utils as au

si = (dd["creation_time"] > 0)
x = dd["particle_position_x"][si][::10]
y = dd["particle_position_y"][si][::10]
z = dd["particle_position_z"][si][::10]
age = dd["ParticleAge"][si]
age = (age - age.min())/(age.max() - age.min())
cc = iw.map_to_colors(age, "hot").squeeze()[:,:3].astype(
    "float64") / 255.0

skc = au.star_kdtree_container()
skc.add_points(x, y, z, cc)
skc.coeff = 1e-5
skc.sigma = 0.5 * pf.h.get_smallest_dx()
cam.volume.initialize_source()
for b in cam.volume.bricks: b.set_star_tree(skc)
```

Now when you render, it should add the star particles. In the future,
once this feature leaves beta, this will be much easier to do. For a
complete working example, see <http://paste.enzotools.org/show/1482/> .

Here's an example image of just star particles being rendered. It's
fuzzy and doesn't look like much yet, but it shows the basic concepts.

![image](/img/stars_orig.png)

## Simple Merger Tree

Enzo, as of 2.0, can now output Friends Of Friends catalogs on the fly
during a simulation, along with particle IDs of particles belonging to
those halos. Identifying mergers between the halos found with this
method was not implemented, so last summer I wrote a small script to do
so. I've added it to
`yt/analysis_modules/halo_merger_tree/enzofof_merger_tree.py`. You can
access it by `amods.halo_merger_tree.EnzoFofMergerTree`. This function
accepts two ID numbers and loads the corresponding catalogs. It then
calculates the parentage and childhood percentages of each pair of halos
that it can identify.

This means that you get back a set of tuples, describing the percentage
of particles from one halo that went to make up a child halo, as well as
the percentage of that child halo's particles that came from a
particular parent halo. JohnW then extended this to output a graphviz
plot of how the halos merged and formed over time. He also added the
ability to avoid halos that are too small and a couple other feature
additions.

It's a very simple system, but it works well for the EnzoFOF
calculations. In the future, I see it acting as a supplement to
StephenS's more complicated and capable merger tree identification
system.

## Documentation

This week my yt development was mostly focused on getting the yt
documentation brought up to the current state. To that end, I
re-organized it to fit into a better conceptual flow, added in the
orientation section I wrote last December, and asked for feedback from a
couple people. JeffO in particular gave extremely helpful comments about
the structure and flow. I think that overall it's much better. StephenS
also updated his docs to reflect the new import scheme. The
documentation is now de-coupled from the version control repository.
This should help keep them up to date, as we no longer have to execute a
build and check that build in to update the online documentation. With
this change, I think we're now ready for release, so hopefully sometime
today that will go out.

## Maestro

ChrisM and JeffO committed and pushed changes to add MAESTRO support to
yt. This is very exciting, as it's another BoxLib code that seems to be
supported without a lot of engine rewriting. Hopefully this will be
useful to a number of people.
