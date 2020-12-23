---
title: yt development - BitBucket, Task Queues, and Streamlines
author: Matthew Turk
date: 2011-02-28T05:35:00-00:00
lastmod: 2011-02-28T05:35:00-00:00
authorlink: https://matthewturk.github.io/
cover: /img/yt_logo.svg
categories:
  - archive
  - development
tags:
  - archive
  - community
  - streamlines
  - yt core
---
The major changes this week came mostly in the form of administrative
shifts. However, SamS did some great work I'm going to hint at (he'll
post a blog entry later) and I started laying the ground work for
something I've been excited about for a while, an MPI-aware task queue.

## BitBucket

For the last couple months, yt has been struggling under the constraints
of the hg server on its hosting plan. The issue was that particular
files checked into the repository (docs\_html.zip for one, which is now
gone, and amr\_utils.c, also gone, for another) took a while to transfer
over some connections. During this transfer, the (shared) hosting
provider on hg.enzotools.org would kill the server process, resulting in
an "abort" message given to the cloning user.

Basically, this was kind of awful, because it meant people couldn't
clone the yt repo reliably, and it also meant that the install script
would fail in unpredictable ways (usually indicating a Forthon or
setup.py error.) I'm kind of bummed out that I didn't do something about
this sooner; I suspect several people probably have tried to install yt
and failed as a result of this. I added some workarounds that staged the
download of yt over a couple pulls, which usually fixed it, but there
was no reliable solution.

Enter BitBucket. A few of the developers had been using BitBucket for
private projects, small repositories, and even (especially) papers that
we'd been working on. For a while we'd been talking about moving yt
there and trying to leverage the functionality it brings for Distributed
Version Control Systems -- like forking and pull requests, social
coding, and on and on --and last week we hit the breaking point. So we
created a new user (yt\_analysis) and uploaded the yt repo, the
documentation repo, and the cookbook, and we're going to be conducting
our development there. The old addresses should all still work -- we
have forwarded [hg.enzotools.org](http://hg.enzotools.org/) to the new
location.

One of the coolest aspects of this is that anyone can now "fork" the yt
repository. What this means is that you can then get your own private
version, which you can then make changes to very easily, and then submit
them back upstream. I'm really excited about this and I would encourage
people to take advantage of it. I've rewritten the [Developer
Documentation](http://yt.enzotools.org/doc/advanced/developing.html) to
describe how to do this.

All in all, I think this will be a very positive move. BitBucket has a
number of value adds, including the forking model, but we should also
immediately see a dramatic increase in the reliability of the
repository.

## Streamlines

SamS has done some work implementing streamlines. Right now they operate
by integrating using RK4 any set of vector fields, and then plotting
their paths using Matplotlib's mplot3d command. He's working on some
cool ways to colorize their values, and one of the things I am pushing
for is to take any given streamline and convert it to an AMR1DData
object. This would enable you to, for instance, follow a stream line in
magnetic fields and calculate the density at every point along that
streamline.

Once Sam's comfortable with the feature as-is, he's going to blog about
it, so I won't steal the thunder for his hard work here.

## Task Queues

Building on the ideas behind the [time series
analysis](http://blog.enzotools.org/yt-development-time-series-and-%20more)
I started work on the idea of a task queue that's MPI aware. When this
is finished being implemented, it will act as a mechanism for
dispatching work, which will be fully integrated with time series
analysis. Right now it's not even close to being done, but a few pieces
of the architecture have been implemented.

The idea here is that you will be able to launch a parallel yt job, but
have it split itself into sub-parallel tasks. For instance, it you had
100 outputs of a medium-size simulation to analyze, you would write your
time series code as usual -- you would describe the actions you want
taken, how to output them, etc etc. You would then launch yt with a
"sub-parallel" option, saying that you wanted to split the total number
of MPI jobs into jobs of size N -- for instance you could launch a 64
processor yt job, telling it to split into sub-groupings of 4 processors
each. Each output would then be distributed in a first come first serve
fashion to each of the processor groups. When each group finished its
job, it would ask for the next job available, and so on. When completed,
the results would be collated and returned.

I'm excited about this, but right now it's in its infancy. I've
constructed the mechanisms to do this within a single process space,
with no sub-delegation of MPI tasks. The process of implementing this
and properly integrating it with time series analysis is going to be a
long one, but I am setting it as a task for the next major release of
yt. If you're at all interested in this, drop me a line, and I'm happy
to show you how to get started testing it out.
