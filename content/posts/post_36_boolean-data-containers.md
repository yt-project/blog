# Boolean Data Containers

author: Stephen Skory

date: 2011-11-09T07:03:00-00:00

A useful new addition to yt are *boolean* data containers. These are
hybrid data containers that are built by relating already-defined data
containers with each other using boolean operators. Nested boolean
logic, using parentheses, is also supported. The boolean data container
(or volume) is made by constructing a list of volumes interspersed with
operators given as strings. Below are some examples of what can be done
with boolean data containers.

## The "OR" Operator

The "OR" operator combines volume of the two data containers into one.
The two intial volumes may or may not overlap, meaning that the combined
volume may constitute several disjoint volumes. Here is an example
showing the construction of a boolean volume of two disjoint spheres:

``` python
sp1 = pf.h.sphere([0.3]*3, .15)
sp2 = pf.h.sphere([0.7]*3, .25)
bool = pf.h.boolean([sp1, "OR", sp2])
```

Here is a short video showing the result:

<div class="vimeo">

31859862

</div>

## The "AND" Operator

The "AND" operator mixes two volumes where both volumes cover the same
volume. Put another way, the "AND" operator produces a new volume that
is defined by all cells that lie in both of the initial volumes. Here is
an example of the intersection of a sphere and a cube:

``` python
re1 = pf.h.region([0.5]*3, [0.0]*3, [0.7]*3)
sp1 = pf.h.sphere([0.5]*3, 0.5)
bool = pf.h.boolean([re1, "AND", sp1])
```

Here is a short video showing the result:

<div class="vimeo">

31861314

</div>

## The "NOT" Operator

The "NOT" operator is the only non-transitive operator, and is read from
left to right. For example, if there are multiple "NOT" operators, the
first "NOT" on the left and the two volumes on either side are
considered first. The new volume constructed is the volume *contained in
the first data container* that the *second data container* does **not**
cover. This can be thought of as a subtraction from the first volume by
the second volume. Here is an example of a cubical region having a
corner cut out of it:

``` python
re1 = pf.h.region([0.5]*3, [0.]*3, [1.]*3)
re2 = pf.h.region([0.5]*3, [0.5]*3, [1.]*3)
bool = pf.h.boolean([re1, "NOT", re2])
```

Here is a short video showing the result:

<div class="vimeo">

31859691

</div>

## Nested Logic

It is possible to use nested logic using parentheses. When nested logic
is used, the order of logical operations begins at the inner-most nested
level and proceeds outwards, always respecting the left to right
ordering for "NOT" operations. This may be used to create truly
fantastic volumes. Here is an example of a piece of Swiss cheese created
from two cubical regions and two spheres. The second sphere `sp2` wraps
around the periodic boundaries and impacts the largest cube in more than
one place.

``` python
re1 = pf.h.region([0.5]*3, [0.]*3, [1.]*3)
re2 = pf.h.region([0.5]*3, [0.5]*3, [1.]*3)
sp1 = pf.h.sphere([0.5, 0.7, 0.5], .25)
sp2 = pf.h.sphere([0.1]*3, .25)
bool = pf.h.boolean([re1, "NOT", "(", re2, "AND", sp1, ")", "NOT", sp2])
```

<div class="vimeo">

31863019

</div>

For those wondering how the movies were made, I've posted [the script
here](http://paste.enzotools.org/show/1939/) . Note that blocks of
comments will need to be turned on/off to get the desired boolean data
container.
