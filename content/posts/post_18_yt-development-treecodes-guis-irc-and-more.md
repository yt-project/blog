---
title: yt Development: Treecodes, GUIs, IRC and more!
author: Matthew Turk
date: 2011-04-04T06:40:54-00:00
lastmod: 2011-04-04T06:40:54-00:00
cover: /img/random/shoes.jpeg
categories:
  - archive
tags:
  - archive
---
It's been nearly a month since the last yt development post; in that
time, there's been quite a bit of development in a couple different
areas. This is culminating in a 2.1 release, for which Sam Skillman is
release manager, sometime in the next few days.

## Streamlines and Treecode

SamS has spent some time over the last month developing two types of
streamline code. The first integrates a series of streamlines over a
selection of the domain, which can then be visualizing using the mplot3d
package. The other aspect of this involves selecting one of these
integrated streamlines, which is then transformed into an AMR1DData
object, which can be queried for values and plotted in other ways. Sam
has documented both of these modes of streamline integration and they'll
be included in a new build of the documentation presently.

StephenS has been hard at work on developing a treecode for speeding up
the binding energy calculation of clumps or other regions. To that end,
he's implemented not only the treecode itself (using some of the octree
functionality which had as-yet been unused in yt) but also a series of
tests. He sees substantial speedups, and it has been documented to
become part of the next release.

## Development Bootstrap and Pasteboards

The process of getting up and running with Mercurial and with
development of yt can be a bit tricky. To try to alleviate that, I've
added a new command, "yt bootstrap\_dev" that will handle this. It will
set up a bitbucket user, set up a couple handly hg extensions, and also
create a 'pasteboard.' The pasteboard itself is still a bit in flux, so
it's not being touted just yet as a major feature, but I think it has
some promise. The idea behind it is to create a semi-permanent mechanism
for sharing scripts and so forth; it's a versions hg repository which
lives on BitBucket's servers, from which scripts can be programmatically
downloaded, embedded, or viewed.

You can see mine at
[http://matthewturk.bitbucket.org](http://matthewturk.bitbucket.org/).
If you've used the bootstrap\_dev command, you can play with the
pasteboards with "yt pasteboard" and "yt pastegrab", but be forewarned
they might not be completely working yet!

## Web GUI and PlotWindow

JeffO has been hard at work rethinking and rebuilding the plotting
system in yt. He's started with the concept of the PlotCollection and
thrown it out! The PlotCollection dates from a time when our mechanism
for interacting with plots was actually fundamentally different; in the
first few months of yt's existence, it was operated through a GUI called
'HippoDraw' which operated with worksheets. The mapping was from a
single worksheet to a single plot collection.

Nowadays, however, it seems that the most common use of making a plot
collection is to make a bunch of plots that aren't quite synced up in
the same way that they were with HippoDraw. So Jeff has been rethinking
the plotting system, sticking close to the idea of 'conduits' of data
that are present in other systems like the AMRData system. You should be
able to take a porthole into the data, toss it down, and then simply
receive back an image that is visible through that porthole.

Over the last couple weeks he's made quite a bit of progress in that,
which enabled us to add it as a widget in a forthcoming GUI for yt.
&hellip;and, speaking of the GUI, we now have a quite functional
protoype of a GUI working. This is the fifth (!) GUI that has been
designed for yt. BrittonS, CameronH and JeffO and I took a few days and
worked very hard on creating a useful, extensible, and maintainable GUI.
(Britton, in fact, had one of the best quotes of the sprint. I said
something like, "I'm looking forward to this GUI." Britton replied, "I'm
looking forward to this being the *last* GUI." I couldn't agree with
this sentiment more.)

All of the previous versions and implementations of GUIs for yt --
HippoDraw, then the original GUI called Reason and written in wxPython,
then the subsequent TraitsUI wxPython Reason version 2.0, and finally
the Tkinter-based Fisheye -- were dependent on a whole stack of
dependencies. These included things like wx, GTK, Qt, and on and on and
on. These were difficult to install in an automated fashion, but more
than that, they added an incredible level of complexity to the
installation and to using these GUIs on supercomputer centers.

So we decided to get rid of all of that, and return to the basics. We
built a Web GUI, where the widgets, the toolkits, events, and everything
are all handled by a web browser, using JavaScript. The decision to do
this ultimately came down to a maintainability issue -- there's no
compilation necessary, everybody has a web browser, and it can be done
trivially over SSH (with far less bandwidth than is required for a
comparative X11 session being forwarded.)

The underlying system is just a Python interpreter; when buttons are
pressed, they simply call functions that are available in the
interpreter. It's fundamentally a mechanism for issuing commands,
displaying results of those commands (including images), and then on top
of this we have begun adding widgets.

Cameron summarized some of this in an [email to the developer list
&lt;http://lists.spacepope.org/pipermail
/yt-dev-spacepope.org/2011-March/001210.html&gt;](). It's still in
testing, but *is* available for testing, despite not being documented.
This will be a big part of a 2.2 release of yt.

## IRC

There's now an IRC channel for yt, on [FreeNode](http://freenode.net/).
There aren't usually that many people in there (sometimes it's just me!)
but the bot from [CIA.vc](http://CIA.vc) will echo all pushed commits to
the channel. You can use a client like [Adium](http://adium.im),
[Irssi](http://irssi.org), or one of the other Linux or OSX clients, to
connect to irc.freenode.net and then to join the channel \#yt ("/join
\#yt").

We'll occasionally have development talk here, but it could also be
viewed as a faster turnover mechanism for getting help, chatting about
oddities, and suggesting feedback. If you're interested in getting
started developing on yt or fixing bugs, this would be the perfect way
to get your feet wet. We'll also likely have some coordinated
development sessions here in the future.

See you next week!
