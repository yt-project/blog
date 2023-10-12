---
title: Updates from yt-napari
date: 2023-10-06T11:27:24-05:00
lastmod: 2023-10-06T11:27:24-05:00
author: Chris Havlin
cover: /img/yt_napari_updates/path_3D_measurements.png
categories:
  - tutorial
  - development
  - releases
tags:
  - fun
  - volume-rendering
  - time-series
  - documentation
draft: false
---

yt-napari has seen a number of new features, performance improvements and new documentation 
in the past year or so. Read on to find out more! 

<!--more-->

## Long form video walkthroughs

One of the main efforts of the past year has been improving documentation. This included not just new
static documentation (e.g., new [example notebooks](https://yt-napari.readthedocs.io/en/latest/notebooks.html)),
but also the yt-napari Tutorial Series. The series starts with an introduction to napari for yt users, 
moves on to how to use the yt-napari plugin to load data into napari from yt and ends with some videos showing 
examples of using **other** napari plugins for analysis and visualization of yt data in napari. The final 
videos are particularly fun as they apply image analysis methods used by the bio-imaging community to segment 
yt-data. For example, here's a screenshot of using a watershed transformation via the `napari-simpleitk-image-processing`
plugin to identify 3D density voids in `enzo_tiny_cosmology` and then the `napari-clusters-plotter` to interactively
visualize mean field values within the domains:

![](/img/yt_napari_updates/density_watershed.png)

Or, check out [this short clip](https://www.youtube.com/watch?v=lBo8jI52BnM) from a longer video in which the
`napari-clusters-plotter` plugin is used to interactively visualize how field intensities relate spatially after having 
used `napari-clusters-plotter` to run a kmeans classification. 

Additionally, you can also use standard napari shapes layers to interactively sample at points or along paths and 
then use plugins like `napari-line-plot` or `napari-properties-plotter` to visualize how data data varies
along the path (screen shot from the [Introduction to other plugins video](https://www.youtube.com/watch?v=k1LdEQ_5Gfw)):

![](/img/yt_napari_updates/path_3D_measurements.png)

Check out either of the following to access all the videos:

* [List of video titles and links](https://yt-napari.readthedocs.io/en/latest/tutorials.html)
* [Full YouTube Playlist](https://www.youtube.com/playlist?list=PLqbhAmYZU5KxuAcnNBIxyBkivUEiKswq1)


## New Feature: Sampling Timeseries 

One of the more exciting new features of recent releases is the ability to sample and load
timeseries for both slices and 3D regions from the napari GUI, a jupyter notebook or via JSON file. 
This allows you to interactively visualize time-dependent behavior. For example, the following 
shows a small 3D region centered on the final max density of the `enzo_tiny_cosmology` dataset:

![](/img/yt_napari_updates/yt_napari_timeseries_small.gif)

For higher resolution sampling, you can work from a notebook and leverage dask to lazily-sample 3D 
regions across a timeseries so that you can load the current timestep on demand:

![](/img/yt_napari_updates/yt_napari_timeseries_regdask_vid.gif)

Check out the sample notebooks and videos for loading timeseries ([notebook](https://yt-napari.readthedocs.io/en/latest/examples/ytnapari_scene_04_timeseries.html), 
[video](https://youtu.be/uNK33C6nOZU)) and using dask with timeseries
([notebook](https://yt-napari.readthedocs.io/en/latest/examples/ytnapari_scene_05_timeseries_dask.html), 
[video](https://www.youtube.com/watch?v=5eeOrcuqvH8))

## The future of yt-napari

One of the exciting features in development upstream in napari is improved on-demand loading of 
multi-resolution data. Once that work is completed, it will open up the possibility of progressive 
sampling in yt-napari! Check out this video for a preview of what this might enable in yt-napari: 
[progressive of the DeeplyNestedZoom dataset](https://www.youtube.com/watch?v=ofoURuz-Cbw). There's 
also plenty to do with yt-napari as it is now, check out the [Issues page](https://github.com/data-exp-lab/yt-napari/issues)
to get involved! 