---
title: "Dask and yt: a pre-YTEP"
date: 2021-01-27T10:15:14-06:00
draft: false
author: Chris Havlin
cover: /img/yt_logo.svg
categories:
  - "Development"
tags:
  - "New Feature"
---

An update and proposal on continuing development of Dask and yt.

<!--more-->

# Dask and yt: a pre-YTEP


## Table of Contents 
* [Overview](#yt-and-Dask-an-overview)
* [Experiments in daskifying *yt*](#experiments-in-daskifying-yt)
* [Development plan](#Development-plan)
* [Some Final Notes](#Some-Final-Notes)

## yt and Dask: an overview

In the past months, I've been investigating and working on integrating Dask into the *yt* codebase. This document provides an overview of my efforts to date but also is meant as a a preliminary YTEP (or pYTEP?) to solicit feedback from the yt community at an early stage before getting to far into the weeds of refactoring. 

So in general, Dask provides a flexible framework for managing computations across chunks objects (stored in serial on a single processor or in parallel across workers). The *yt* operations that could potentially be simplified are any of the operations that rely on the chunking protocol such as data IO, calculating derived quantities, calculating profiles, sampling data (slices, projections) and [more](https://yt-project.org/doc/analyzing/parallel_computation.html#capabilities). Furthermore, allowing *yt* to return a `dask.array` object to the user would allow the user to create their own parallel workflows more easily.

Before diving in, it's worth discussing the interplay between Dask and the existing MPI architecture within *yt*. Dask itself provides mpi management via the [dask-mpi package](http://mpi.dask.org/en/latest/index.html) so from a user perspective, anyone already using *yt* and MPI should see minimal disruption to their workflows. 

## experiments in daskifying yt 

Thus far, my efforts have focused on developing a series of experiments demonstrating *yt* + Dask integration at different levels withint *yt* covering using dask to read data off of disk, constructing a daskified version of a non-trivial and parallel *yt* calculation (profiles) and an initial prototype for adding `dask` functionality to `unyt` arrays. Each of these subjects has a detailed description at the following links:

1. (particle) data IO ([link](https://hackmd.io/@chavlin/SJvD-iXAw))
2. profile calculation ([link](https://hackmd.io/@chavlin/BJDVGiX0P))
3. dask-unyt arrays ([link](https://hackmd.io/@chavlin/HyknMi7RD))

I encourage you to check out the detailed descriptions, but I'll provide a short summary here before describing some general takewaways and then proposing a plan for moving development into the *yt* pipeline. 

**1. (particle) data IO ([link](https://hackmd.io/@chavlin/SJvD-iXAw))**

In this experiment, I re-wrote the `BaseIOHandler._read_particle_selection()` function (in `yt.utilities.io_handler`) to use dask to read in particle data from a Gadget dataset. The implementation iterates over the dataset chunks to build a list of `dask.delayed` objects. 

```python=
delayed_chunks = [               
                  dask.delayed(self._read_single_ptype)(
                    ch, this_ptf, selector, ptype_meta[ptype]
                  ) for ch in chunks
                 ]
```

The main challenges here were related to dask communication. The first is that dask uses pickle to serialize and distribute objects to different workers, so any arguments to delayed functions must be pickleable. So in order to implement this, I had to add some pickling methods for the base `selector` objects and slightly modify the underlying `ParticleContainer` class (that gets stored in each chunk) so that the dataset index is not needlessly rebuilt when unpickling. 

The second communication related issue is that when *yt* pickles a `DataSet` object, the hash values are stored in an in-memory cache by default, which is not accessible to the various Dask workers when working in parallel. In the IO prototype, I simply switched to using the on-disk hash storage, but it may be worth considering more direct [memory management with Dask](https://distributed.dask.org/en/latest/memory.html), perhaps creating a shared dask context to distribute certain objects across workers. 

**2. profile calculation ([link](https://hackmd.io/@chavlin/BJDVGiX0P))**

In this experiment, I focused on refactoring a task that leverages chunked data: calculating profiles. I first attempted to write a pure dask version of calculating a binned statistic equivalent to a *yt* 1D profile but performance wasn't great and it wasn't clear how to generalize the code. So instead I focused on building a delayed workflow that **directly** uses *yt*'s optimized 1d binning function, `yt.utilities.lib.misc_utilities.new_binprofile1d`. This approach can easily be extended across *yt* where we are performing collections and reductions across chunks. The modifications to the code would also be fairly minimal -- mostly replacing MPI gathering operations with iterations over delayed dask objects (reminder: you would still be able to use MPI as normal, it's just that dask would handle the MPI communications behind the scenes).

**3. dask-unyt arrays ([link](https://hackmd.io/@chavlin/HyknMi7RD))**

In order to leverage dask wherever chunks are used, we need to be able to return dask arrays from the IO functions. In *yt*, however, our base arrays are `unyt_array` objects. So in this experiment, I built a rough `dask-unyt` array prototype. The basic approach was to create a new `unyt` class that is subclassed off of the base dask `Array` object (`dask.array.core.Array`) that behaves as a dask `Array` but carries units alongside in hidden `unyt` attributes. Since the initial attempt, I've started an improved implementation that does a better job of minimizing code duplication ([hopefully a PR to unyt soon](https://github.com/chrishavlin/unyt/tree/dask_unyt)). 


**data IO complexity**

Finally, it is worth noting that the work here, particularly in the above section on the daskified particle reader, is closely related to Matt Turk's thoughts on frontend refactoring ([Part 1](https://matthewturk.github.io/post/refactoring-yt-frontends-part1/), [Part 2](https://matthewturk.github.io/post/refactoring-yt-frontends-part2/), [Part 3](https://matthewturk.github.io/post/refactoring-yt-frontends-part3/)). While his posts do not mention dask, there are some synergies with the present work. In refactoring to leverage dask, we should considers ways to simplify frontend development.

([back to TOC](#Table-of-Contents))

## Development plan

Now that I've worked through some isolated experiments in daskifying parts of *yt*, it makes sense to get a wider range of folks involved. Towards that end, I'm proposing the following work plan: 

* **Stage 0**: initial input from the *yt* community **<----- We are Here**
* **Stage 1**: move development to the *yt* pipeline
* **Stage 2**: particle dataset IO
* **Stage 3**: chunk operations on delayed arrays
* **Stage 4**: non-particle datasets (and more)

### Stage 0: initial input from the *yt* community 

This is the current stage. Do you love/hate any/all of this? Send me your ideas, thoughts, fears and hopes for *yt* + Dask! You can email me (chavlin@illinois.edu) or come and discuss on the [yt slack channel](yt-project.slack.com).

### Stage 1: move development to the *yt* pipeline (branch logistics)

So far, my development has mainly proceeded as standalone notebooks and modules in the DXL [yt-dask-experiments repository](https://github.com/data-exp-lab/yt-dask-experiments). But in order to start fully devloping these new features, we need to move development into the *yt* pipeline. Given that these changes will take some time and will likely temporarily break many things, we need to isolate *yt*-Dask development from the main yt development . Towards that end, we can create a new `dask_yt` development branch, after which development would proceed via:

* dask-specific PRs: these are PRs submitted directly to the `dask_yt` branch. They may introduce breaking changes.
* "neutral" PRs: these are PRs that make non-breaking changes that are independent of dask and are submitted to *yt*'s `master` branch as normal PRs. 

Occasionally, we merge yt `master` into `dask_yt` as neutral changes are merged into `master` (and as normal yt development occurs). 

*Stage 1 Tasks & Follow Up:*
* create the new `dask_yt` development branch.

### Stage 2: particle dataset IO 

The simplest place to start in actual refactoring is to implement a modified prototype particle reader within *yt* proper. While it will use dask to read the chunks, it can simply return expected in-memory dict with data and will not break anything. 

*Stage 2 Tasks & Follow Up:*
* implement/copy the prototype `_read_particle_fields()` method
* consider `dask.array` vs `dask.dataframe` usage (at present the protopye uses `dask.dataframe` for the initial read to avoid having to know the number of particles a priori)
* consider the initial chunk creation -- can we use Dask here initialy instead of the `chunk` iterator object?


### Stage 3: chunk operations on delayed arrays

Once we have a daskified particle reader in place, we need to add the option to return the data as delayed dask arrays. Once in place, we can refactor many of the operations that use the `chunk`  iterator object. The main obstacle to this, besides refactoring any of the operations that use the chunks, is the fact that the arrays returned by `_read_particle_fields` are converted to `unyt_arrays`, so the first step in this stage is completing the `dask-unyt_array` implementation:

*Stage 3 Tasks & Follow Up:*
* implement `dask-unyt_array` class (as upstream contribution to `unyt`, in progress [here](https://github.com/chrishavlin/unyt/tree/dask_unyt))
* add a `return_dask` argument to return dask arrays when reading 
* refactor the simpler routines that use the `chunk` iteration (derived quantities and profile calculations) to use the dask arrays (following the [profile calculation experiment](#experiments-in-daskifying-yt)).
* start conducting performance tests for the new daskified routines. Compare computation times and memory usage to both serial and MPI-parallel equivalanets on *yt* `master` branch. 


### Stage 4: non-particle datasets (and more)

Once we have working IO for particle datasets, the ability to return dask arrays, and some parallel operations succesfully using the dask arrays, the development path becomes a bit broader. Work could start on gridded datasets or some of the other *yt* operations that leverage chunks could be daskified. 

([back to TOC](#Table-of-Contents))

### existing PRs 

several small related PRs that would qualify as "neutral changes" in the above context already exist: [2416](https://github.com/yt-project/yt/pull/2416), [2934](https://github.com/yt-project/yt/pull/2934), [2954](https://github.com/yt-project/yt/pull/2954).

### related links and references

* [The dxl repo home to the experiments describe above ](https://github.com/data-exp-lab/yt-dask-experiments)
* [RHytHM2020 talk on Leveraging Dask in *yt*](https://www.youtube.com/watch?v=3GLbEBgpaK4)
* [An earlier overview of my yt + Dask efforts](https://hackmd.io/UakT_HXNTSCXMz221_lFTQ)
* Matt Turk's thoughts of frontend refactoring: [Part 1](https://matthewturk.github.io/post/refactoring-yt-frontends-part1/), [Part 2](https://matthewturk.github.io/post/refactoring-yt-frontends-part2/), [Part 3](https://matthewturk.github.io/post/refactoring-yt-frontends-part3/).

([back to TOC](#Table-of-Contents))
