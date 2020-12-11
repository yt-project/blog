---
title: Dataset Tracking with yt
author: Stephen Skory
date: 2011-09-12T10:53:00-00:00
lastmod: 2011-09-12T10:53:00-00:00
cover: /img/random/shoes.jpeg
categories:
  - archive
tags:
  - archive
---
In this post I'd like to discuss a bit of work in progress to highlight
some exciting new features that we hope to have working in yt sometime
soon.

On any machine that runs yt, there is a file created in the users home
directory named `~/.yt/parameter_files.csv` that yt uses internally to
keep track of datasets it has seen. This is just a simple text file
containing comma-separated entries with a few pieces of information
about datasets, like their location on disk and the last date and time
they were 'seen' by yt. To keep this file from exploding, it's kept at
some maximum number of entries. But, clearly, text is not the ideal way
to store this kind of information for anything over a few hundred
entries. Recently Matt has been working on updating this system to use a
SQLite database, which should have several advantages over the text file
in terms of speed and disk usage.

This got me thinking about what could be done to extend this local
listing of datasets into something more useful, *globally*. What if
there was a way to view any and all datasets ever seen by yt in one
convenient place? It could be searchable over a number of attributes,
including creation date and when it was last seen by yt, and it would
list which machine the dataset is stored on. Finally, this functionality
should be transparent to the user once it is set up (with minimal
effort) - the global listing of datasets should just be updated
automatically in the background as part of the normal workflow.

Over a couple days last week I did a quick and dirty implementation of
this using [Amazon AWS SimpleDB](http://aws.amazon.com/simpledb/) and a
simple web-cgi script I wrote in Python. The advantages of SimpleDB are
that it is "in the cloud" (sheesh) and very inexpensive. In fact, for
small databases with low usage levels, it is free. (As an aside, Amazon
is very generous with academic grants, which could be used for this or
other yt-related services.) The Python script is very simple and can be
[cloned off of BitBucket](https://bitbucket.org/sskory/mydb/overview).
The script can be run on any computer with a webserver and Python (which
includes Macs and Linux machines), and I envision a website (perhaps
mydb.yt-project.org, for example) being created where a user can login
from anywhere to view their datasets easily.

The entire thing is not finished yet: the updates to SimpleDB are not
automatic, nor have we settled on a final list of which attributes to
store in the listing. However, in two days I was able to get enough
working to show what I think are the key killer features of the system
in a screencast which I've linked below. I should note that in the time
since I made the screencast, I have made a few improvements. In
particular, the numerical columns can now be sorted correctly.

I'm excited about the prospects for a simple system like this!

<div class="vimeo">

28797703

</div>
