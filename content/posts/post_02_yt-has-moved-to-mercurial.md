# yt has moved to mercurial!

author: Matthew Turk

date: 2010-09-09T06:58:23-00:00

For about a year and a half now, most of the unstable development of yt
has occurred inside a [mercurial](http://mercurial.selenic.com/) repo.
Mercurial is a distributed version control system, not unlike git or
bzr, where each checkout brings with it the entire history of the
repository and enables full development. Each individual can commit
changes to their own repository, while still accepting changes from
others. It also makes it much easier to submit patches upstream.

All in all, mercurial is a much better development environment than
subversion, and I think that's been born out by the changes in the
development style of both yt and Enzo, which has also recently moved to
mercurial.

For a while we'd been keeping a mixed model: subversion was regarded as
more stable, slower moving, and the mercurial development was less
stable and faster; things were worked on in hg and then backported to
svn. However, because of the recent reorganization efforts to clean up
the code in preparation for yt-2.0, it became clear that backporting
these changes to svn would be a nightmare. So we decided we would move
exclusively to hg for development.

However, this brought with it some unfortunate problems: when I
initially created the hg repository in February of 2009, I only imported
from SVN revisions 1100 onwards. And because of the way hg works, I was
unable to get any newly reimported history to connect with the old
history. But, if we were going to move to hg exclusively, I wanted all
that old history.

But, thanks to the [convert
extension](http://mercurial.selenic.com/wiki/ConvertExtension) to
mercurial, I was able to import all the old history and splice the two
together. But, unfortunately, this meant that all the changeset hashes
were different! So with the conversion to mercurial we had to force
everyone who already had an hg repo to re-clone and re-initialize their
own repository. This turned out not to be so bad, but because of some
decisions I made during the splicing the graph now looks a bit crazy in
the middle! I'm still thinking about ways to change that without
changing any changeset hashes, but we'll just have to see; maybe it's
not so bad that we have so many crazy paths and branches.

We're gently migrating to the hg repositories exclusively; the
installation scripts have mostly been updated, but not completely rolled
out. Hopefully the end result will be worth it --I've written up some
developer documentation on how to use hg and how to use it [to develop
yt](http://yt.enzotools.org/browser/doc/how_to_develop_yt.txt), and I
hope this will be the start of a more open development process!
