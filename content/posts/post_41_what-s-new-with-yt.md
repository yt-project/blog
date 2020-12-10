# What's new with yt?

author: Matthew Turk

date: 2012-02-13T03:10:21-00:00

Now that the post-workshop preparations and work have settled down, I
thought it might be interesting to share some of the developments going
on with yt. We're still a long way from a new release, so these interim
'development' updates are meant to be a bit of a teaser. As always,
these features are either in the main branch or (if noted) in a public
fork on BitBucket. **If they sound interesting, drop us a line on
\`yt-dev &lt;http://lists.spacepope.org/listinfo.cgi
/yt-dev-spacepope.org&gt;\`\_ to see about getting involved!**

Stephen has been pushing lately for more consistency in the code base
--indentation, naming conventions, spaces, and so on. Specifically, he
has been suggesting we follow
[PEP-8](http://www.python.org/dev/peps/pep-0008/), which is a standard
for Python source code. This has gotten a lot of support, and so we're
encouraging this in new commits and looking into mechanisms for updating
old code. (Although it can cause some tricky merges, so we're trying to
take it easy for a bit!)

JohnZ recently added a particle trajectory mechanism, for correlating
particles between outputs and following them. This lets you see where
they go and the character of the gas they pass through.

Sam has been looking at improving volume rendering, including adding
hard surfaces and a much faster (Cythonized) kD-tree routine. The
initial hard surface stuff looks just great. (This is all taking place
in his fork.) This code is also threaded, so it should run much faster
on multi-core machines.

JohnW identified a bug in the ghost zone generation, which has resulted
in a big speedup for generating ghost zones!

Chris has been trying to get the regridding process for ART to be
substantially faster, which he's been having success with. We're now
trying to together work on changing how 'child masking' is thought of;
with patch-based codes it only masks those cells where data at finer
levels is available. We're trying to make it so that it also marks where
coarser data is the finest available, which should help out with speed
for octree based codes.

Finally, I've been up to working on geometric selection. My hope is that
by rethinking how we think about geometry in yt and removing a number of
intermediate steps, we can avoid creating a whole bunch of temporary
arrays and overall speed up the process (and add better support for
non-patch based codes!). Results so far have been pretty good, but it's
a long ways from being ready. It's in my refactor fork.

There are a lot of exciting things going on, so keep your eyes on this
space! In addition to all of these things, we've got web interactors for
isolated routines, an all-new hub, improvements to reason, and tons of
other stuff. As always, drop by [yt-dev
&lt;http://lists.spacepope.org/listinfo.cgi/yt- dev-spacepope.org&gt;]()
or the IRC channel if you'd like to get involved.
