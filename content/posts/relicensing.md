---
title: Relicensing yt from GPLv3 to BSD
date: 2013-09-12T16:36:29-06:00
lastmod: 2020-12-03T16:36:29-06:00
author: Matthew Turk
authorlink: https://matthewturk.github.io/
cover: /img/random/shoes.jpeg
categories:
  - archive
  - development
tags:
  - archive
  - community
---

Our reasoning for switching licenses for the yt-project

<!--more-->

# Relicensing yt from GPLv3 to BSD

Today, I hit the merge button on a relicensing of yt from GPLv3 to the 3-clause
BSD license.  Below is a blog post, largely drawn from an email I sent to
yt-dev several months ago, describing why this process began and what it means
for both users and developers.

This was an effort we started several months ago, following discussions at the
SciPy 2013 conference.  Nathan Goldbaum, Sam Skillman and I discussed it
somewhat at length, and eventually decided to begin exploring this with the
other key stakeholders of yt.  It wasn't a decision or process that we took
lightly, nor was it particularly seamless, but it was mostly smooth and I think
overall it is going to be a positive change for the community.

When I originally created yt in the Summer of 2006 (then called Raven) I placed
it under the then-new GPLv3 license.  This license brought with it an ideology
that I support -- free (as in freedom) and open source software, and attempts
to ensure that the spread of software spreads those freedoms as well.  This is
done through terms of licensing; while there are several subtleties to how this
plays out, and the goals of FLOSS and the GPL align very well with my own, at
some point I began to believe that yt would be better suited under a
permissive, non-copyleft license rather than the GPLv3.  As such, through
discussions with the other developers, and through consent from every
contributor to yt over its history, we have relicensed it under the 3-clause
BSD license.

### Why?

In the scientific software community, for the most part codes and platforms are
released under a permissive, BSD-like license.  This is not universally true,
but within the scientific python ecosystem (including projects such as AstroPy,
NumPy, IPython and so on), BSD-like licenses are especially prevalent.  These
licenses place no restrictions on redistribution, passing on freedoms to end
users, or making a piece of software closed-source.  A side effect is that if a
piece of software is BSD licensed, it cannot rely on GPL'd software without
itself being subject to those terms.  Specifically, a BSD licensed package that
requires an import of a GPL'd package may then be subject to the GPL -- this is
why it has been termed "viral" in the past.  As examples, many BSD-licensed
packages exist in the scientific software community: VisIt, ParaView, MayaVi,
NumPy, Matplotlib, IPython, Python itself, mpi4py, h5py, SymPy, SciPy, most of
the scikits, scikits-learn, NetworkX and so on.  Collaboration with these
projects is currently one-way because of our license.

When I initially decided on a license for yt (seven years ago) it seemed
appropriate to use the licensing terms as a mechanism to encourage
contributions upstream.  However, within the current ecosystem, it is clear
that because of the virality of the GPL and the prevailing mindsets of
developers, it is actually an impediment to receiving contributions and
receiving mindshare.  John Hunter described it very clearly in his 
"[BSD Pitch](http://nipy.sourceforge.net/software/license/johns_bsd_pitch.html#johns-bsd-pitch)".

While John focuses on commercial utilization, I believe that within the
scientific python ecosystem the picture can be broadened to include any piece
of software that is under a permissive license.  yt cannot be used or relied
upon as a primary component without that piece of software then becoming
subject to the terms of the GPL.  Additionally, some private and public
institutions are averse to providing code under the GPL, specifically version 3
of the GPL.

By transitioning to a permissive license, we may be able to receive more
contributions and collaborate more widely.  As a few examples, this could
include more direct collaborations with packages such as 
[Glue](http://glueviz.org/), [IPython](http://ipython.org/), 
[VisIt](http://visit.llnl.gov/), [ParaView](http://paraview.org/), and even
utilization and exposing of yt methods and operations in other,
permissively-licensed packages.  For example, deep integration between
permissively-licensed simulation codes will benefit from this.  Furthermore,
individuals who otherwise could not contribute code under the GPL (due to
employer restrictions) will be able to contribute code under a permissive
license.

The GPL is designed to prevent turning FLOSS code proprietary.  Changing to a
BSD license does not allow another entity to prevent us from continuing to
develop or make available any yt code.  It simply means that others can utilize
it however they see fit.  

I believe that we stand to gain considerably more than we stand to lose from
this transition.  (Interestingly enough, Wolfgang Bangerth and Timo Heister
came to similar conclusions in section 3.4 their article 
[What Makes Computational Open Source Software Libraries Successful?](http://www.math.tamu.edu/~bangerth/publications/2013-software.pdf))  
More to
the point, a few years ago on the yt-dev mailing list we came up with a mission
statement for yt, which now adorns our homepage.  I think we can better serve
that mission statement by enabling broader collaborations within the scientific
software ecosystem.

This is not motivated by any desire to create a proprietary distribution of yt
-- in fact, exactly the opposite.  I believe that in the current ecosystem of
scientific software, yt will be more sustainable if it is under a permissive
license.  I hope we continue to [scale](http://arxiv.org/abs/1301.7064).

### The New License

As of changeset 7a7ca4d (in main yt branch) and 7b180c7 (yt-3.0 branch), yt is
now available under the 
[3-clause BSD license](https://bitbucket.org/yt_analysis/yt/src/7a7ca4d5a1b3747a06ea76b8d090e33413717b06/COPYING.txt).
In addition to this, the author lists have been removed from the files; this
was a suggestion from the other developers, to encourage a different
representation of authorship.

In beginning this process, I consulted with several individuals that I consider
role models in the community -- other long-term, core yt developers but also
Fernando Perez, Anthony Scopatz, Matthew Terry and Katy Huff.
To accomplish the relicensing, we had a public discussion (on yt-dev) of the advantages
and disadvantages of the relicensing.  I'm deeply grateful to Fernando for an
extremely thoughtful email exchange where he described his own motivations for
moving IPython from LGPL to BSD, as well as a set of guidelines and suggestions
for relicensing yt.  The process was inspired by the IPython licensing and
credit system, and I hope we continue to learn from their successes over time.

To relicense, I personally emailed each individual contributor to yt explaining
the reason, linking to documents describing each license, and asking them to
publicly state their consent to relicense.  Links to each mailing list entry
were posted in a [Google Spreadsheet](http://goo.gl/3PFnf).  Once these
messages had been collected, we were able to change the license on all of the
header files.

At some point in the future, we will likely put out a 2.6 release.  This
release will be a long-term stable release, and will be available under the BSD
license linked to above.  But, as of today, checkouts of the code will be
available under that license already.

### Future

I have come to believe very strongly that as a project we can do more to
support goals of open science, open source, and build a stronger community by
this relicensing, and by rethinking how we fit into an ecosystem of scientific
software.

Fun stuff is ahead.
