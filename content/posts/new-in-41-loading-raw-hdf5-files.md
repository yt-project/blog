---
title: "New in 4.1: Loading data with functions"
date: 2022-09-01T09:00:00-06:00
author: Matthew Turk
authorlink: https://matthewturk.github.io/
cover: /img/cover.jpg
categories:
- Development
- Releases
tags:
- yt 4.1
- Loading Data
- Release
- New Feature
- HDF5
---

Building on our ability to read data using just functions, we can now load data from raw HDF5 files with a minimum of metadata.

I've heard it said that HDF5 isn't *exactly* a file-format. Sure, it describes how to write bits down (and does this extremely well and thoroughly), but I have always personally found it to be more immediately useful as a filesystem for data. And, it seems that people who write data to disk find it to be similarly useful -- but there's no single way that people organize the data they use HDF5 to write to disk, attempts at metadata notwithstanding.

What this means is that the question "Can yt read HDF5 data?" is both *yes* and *unhelpful* -- much of what makes yt useful for datasets is the way it understands how data is organized spatially, and so simply reading the data devoid of context doesn't provide any advantage. What we usually recommended to people in the past was that they either write a full-on frontend for their data or they load the data from disk into memory and access it that way. Because of how yt is set up, this was (unfortunately) true even for datasets that were simple -- such as big unigrid datasets.

But now, enabled by the modifications to the `Stream` frontend that allow for accessing data via function calls, we have a much simpler way of accessing data from HDF5 files. Right now it works just for big, 3D arrays, but it's pretty easy to see how we could extend it to even the most complex AMR formats as well. Using the new `load_hdf5_file` function, we can tell yt where to find the HDF5 file, how to interpret its contents, and then receive back a dataset. This dataset not only takes advantage of yt's load-on-demand functionality, but can also automatically decompose the grid for easier parallel and memory-conservative operations.

Instead of writing a full frontend or loading all the data into memory, it's now possible to make a single call to `load_hdf5_file`! For instance, one of the example datasets we have in yt is the `UnigridData/turb_vels.h5` file, which consists of a bunch of datasets in the root of the file (like `Bx`, `By`, `Bz`, `Density`, etc). While you can supply more complex arguments to specify where the fields can be found, and even provide domain decomposition information for subdividing the grid, this file only requires one line to construct a fully-fledged yt dataset from the file:

```python
ds = yt.load_hdf5_file("UnigridData/turb_vels.h5")
```

And building on this, for the *next* release I think we will be able to make this applicable to particle datasets as well, potentially even using [Kaitai](https://kaitai.io) as a mechanism for describing the particle data.
