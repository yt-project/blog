# yt development: External Analysis and Simulation Code Support

author: Matthew Turk

date: 2011-03-07T06:17:09-00:00

This last week was the first full week on
[BitBucket](http://hg.enzotools.org/) and so far I think it has been
quite successful. The new development process is for most of the core
developers to maintain personal forks for experimental changes, or
longer term changes, and then to commit directly or merge when bug fixes
or features are ready to be integrated. The list of forks is [easily
visible](http://hg.enzotools.org/yt/descendants) and each individual
fork's divergence from the primary repository can be viewed by clicking
on the green arrows. All of the new mechanisms for developing using
BitBucket are included in the '[How to Develop
yt](http://yt.enzotools.org/doc/advanced/developing.html)' section of
the documentation.

This last week I spent a few days at KITP's Galaxy Clusters workshop,
where I presented on yt. There were a few major points that came out of
my visit, talking to the simulators there, that are germane to the long
term development of yt.

> -   As time goes on, yt should be increasingly viewed as a mechanism
>     not just for analyzing data with its own, internal analysis
>     routines, but as a mechanism for handling data, transforming it
>     into a uniform interface independent of the underlying simulation
>     code. This will allow for linking against and utilizing external
>     analysis codes much more easily. (The three examples that came up
>     while I was at KITP were a new halo finder, a weak lensing code,
>     and a radiation transport code.) To facilitate the process of
>     calling external codes from within yt, I've written a section in
>     the documentation [that covers
>     it](http://yt.enzotools.org/doc/advanced/external_analysis.html).
> -   There is a great deal of interest in ensuring yt works equally
>     well with many different simulation platforms. This is a primary
>     goal of my current fellowship, and I am working toward it. The
>     next two codes that will be targeted for improvement are Gadget
>     and ART, and I made good contacts at the workshop to this end.
> -   The idea of analysis modules, particularly in a block-programming
>     environment, is compelling. There is quite a bit of interest in an
>     interface where inputs and outputs were handled like pipes. I am
>     still formulating my ideas on this. Last Fall I experimented a bit
>     with an introspection system that could handle arguments and could
>     hook up pipes, but it never got very far. ([The
>     code](https://bitbucket.org/MatthewTurk/analysis_plugins/overview).)

I had a number of scientific takeaways from the meeting, too, but that
would all go into a different blog post.

This week I hope to finish up the adaptive ray tracing. This past week
StephenS unveiled a halo serialization mechanism, which I Think many
people are excited about, and SamS continued developing his streamline
code.
