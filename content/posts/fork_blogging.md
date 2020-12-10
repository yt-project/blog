---
title: Our New Blog
date: 2012-11-04T22:09:04-06:00
lastmod: 2012-11-04T22:09:04-06:00
author: Matthew Turk
cover: /img/Simple_Grid_Refinement_files/Simple_Grid_Refinement_fig_00.png
categories:
  - meta
tags:
  - blog
---

# Our New Blog

Hi everyone! Welcome to the new yt Project blog. We\'ve gotten rid of
the old Posterous-based blog in favor of making it easier to include
code, entries from anybody in the community, and to overall make it
easier and clearer how to contribute.

So, to that end, we\'ve moved to using a combination of pretty cool
technologies to make it easy to blog and have your entry added to the
blog.

For the blogging itself, we use [Blohg](http://blohg.org), which is a
mercurial-backed system. So all the blog entries are stored in a
mercurial repository, on BitBucket
([yt_analysis/blog](http://bitbucket.org/yt_analysis/blog)) and instead
of being in HTML or something, they\'re written in ReStructured Text
(ReST) \-- which is the same format that the yt docstrings and
documentation are all written in. We\'re standardizing on ReST, which
means to contribute to any of yt, you only have to learn one way to
format your text. (Plus, ReST is [super
easy](http://docutils.sourceforge.net/docs/user/rst/quickstart.html).)

To add a new entry, you just have to
[fork](http://bitbucket.org/yt_analysis/blog/fork) the blog repository
and then issue a Pull Request. You can add the entry by creating a new
file in the directory [content/post]{.title-ref}, and it\'ll
automatically show up with your name and the time you added it. Once
your pull request is accepted, the blog will be *automatically* rebuilt
and uploaded to the blog site (thanks to [Shining
Panda](http://shiningpanda-ci.com), which we use for our testing suite
\-- more on that later!) which lives inside Amazon\'s cloud.

But the best part is that this is all hidden behind the scenes. For all
intents and purposes, you just need to add your text, issue a pull
request, and it\'ll show up in a few minutes.

But here\'s the best part \-- by converting to this system, we\'ve also
made it easy to include code samples using the [IPython
Notebook](http://ipython.org). A bunch of the yt developers have started
using the IPython notebook for basically everything \-- analysis,
teaching, sharing snippets \-- and we want to keep using it for
everything. (If you take a look over at <https://hub.yt-project.org/>
you can see that we\'ve started uploading Notebooks to the yt Data Hub,
which then get displayed by the amazing NBViewer project by the IPython
developers.) So, we made it easy to include a notebook here in the blog.

To include the notebook, you\'ll first need a copy of the NBConvert
repository, which will also need to be in your `PYTHONPATH`. You may
also need to install the \"pandoc\" project, but that\'s usually
included in most Linux distributions and can be gotten with MacPorts.
Once you\'ve added that, just cd to the blohg directory and run::

    python2.7 blohg_converter.py /path/to/your/notebook.ipynb

This will grab all the images and put them in the right directories
inside the blog repository, add a new `.rst` file, and then you\'re set
to go. Just run `hg ci -A` and you\'re good to go!

Because this blog is a bit new, we\'re still working through some kinks.
Already as I\'ve made a couple changes, the RSS feed has marked itself
as completely updated; this is an error, so I\'m trying to figure out
what\'s going on and fix it up. So I apologize in advance if any other
minor glitches happen along the way!

With this change in the blogging system, I think we\'ve lowered the
barrier to sharing with the community changes in yt, new features, and
even showing old features using the Notebook. I\'m really optimistic

And if you have something you would like to share \-- a new paper
you\'ve written, something cool you\'ve done (even if not in yt!) or
anything else, go ahead and
[fork](http://bitbucket.org/yt_analysis/blog/fork) the repository and
write up a blog post \-- everything you need comes in the box!
