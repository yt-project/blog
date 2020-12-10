# yt development: HEALpix and Contour Tree

author: Matthew Turk

date: 2011-02-21T04:14:53-00:00

This week there was not very much yt development. However, a few notes
may be of interest. SamS has updated the HEALPix camera to support
ordered projections; what this means is that you can now make volume
renderings using a standard color transfer function, or even the Planck
transfer function, that cover 4pi of the sky. I am still working on
integrating a method for creating images easily, but for now the scripts
from [last
week](http://blog.enzotools.org/yt-development-all-sky-column-density-calcula)
should work.

I worked a bit on improving the speed of the contour tree, but I am
growing to suspect that a full new algorithm will have to be
implemented. I have researching this, and I believe that the best method
will require a 'union merge' data structure. Hopefully I will have
something to report on this shortly. As of now, the contouring algorithm
should be a factor of 10%-50% faster than it was a week ago, depending
on the dataset characteristics. The idea of selection of astrophysical
objects, rather than geometric objects, has been on my mind lately, and
I committed a first pass at an API for this sort of selection. I hope to
have more information about that in the near future, but I anticipate
those development efforts to ramp up around the end of March.
