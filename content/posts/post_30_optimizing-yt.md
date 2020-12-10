# Optimizing yt

author: Matthew Turk

date: 2011-09-10T08:39:52-00:00

This last week, following the release of version 2.2 of yt, I spent a
bit of time looking at speed improvements. There were several places
that the code was unacceptably slow:

> -   1D profiles (as noted in our method paper, even)
> -   Ghost-zone generation
> -   RAMSES grid data loading

The first of these was relatively easy to fix. In the past, 1D profiles
(unlike 2D profiles) were calculated using pure-python mechanisms; numpy
was used for digitization, then inverse binning was conducted by the
numpy 'where' command, and these binnings were used to generate the
overall histogram. However, with 2D and 3D profiles, we used specialized
C code written expressly for our purposes. This last week I found myself
waiting for profiles for too long, and I wrote a specialized C function
that conducted binning in one-dimensions. This sped up my profiling code
by a factor of 3-4, depending on the specific field being profiled.

The second, ghost zone generation, was harder. To generated a 'smoothed'
grid, interpolation is performed cascading down from the root grid to
the final grid, allowing for a buffer region. This helps to avoid
dangling nodes. Ideally, filling ghost zones would be easier and require
less interpolation; however, as we do not restrict the characteristics
of the mesh in such a way as to ease this, we have to use the most
general case. I spent some time looking over the code, however, and
realized that the most general method of interpolation was being used --
which allowed for interpolation from a regular grid onto arbitrary
shapes. After writing a specialized regular-grid to regular-grid
interpolator (and ensuring consistency and identicality of results) I
saw a speedup of a factor of about 2.5-3 in generating ghost zones; this
has applications from volume rendering to finite differencing and so on.

Finally, in the past, RAMSES grids following regridding were allowed to
cross domains (i.e., processor files.) By rewriting the regridding
process to only allow regrids to exist within a single domain, I was
able to speed up the process of loading data, allowing it to preload
data for things like projections, as well. Next this will be used as a
load balancer, and it will also ease the process of loading particles
from disk. I am optimistic that this will also enable faster, more
specific read times to bring down peak memory usage.

Hopefully over the next few months more optimization can be conducted.
If you want to test out how long something takes, particularly if it's a
long-running task, I recommend using `pyprof2html`, which you can
install with `pip install pyprof2html`. Then run a profiling code:

``` bash
$ python2.7 -m cProfile -o my_slow_script.cprof my_slow_script.py
$ pyprof2html my_slow_script.cprof 
```

This will create a directory called 'html', which has a nice
presentation of where things are slow. If you send the .cprof file to
the mailing list, we can take a look, too, and see if there are some
obvious places to speed things up.
