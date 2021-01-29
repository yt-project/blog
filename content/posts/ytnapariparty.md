---
title: "A yt-napari party"
date: 2021-01-12T18:22:25-06:00
author: Chris Havlin
cover: /img/ytnapari/ytnapari_enzo3d.png
categories:
  - Tutorial
tags:
  - Experimental
---

Interactive visualization of *yt* data using *napari*? 

<!--more-->

A while back I was playing around with using *napari* to visualize data loaded from *yt* and with the launch of the awesome new *yt* blog, I thought that it's about time to brush off that work and share it! The basic goal was to use *yt* to load a dataset and then generate a series of fixed resolution buffers that get passed off to *napari* for interactive visualization. It's a fun and simple way of adding some more interactive analysis to your *yt* workflow and might serve as a basis for writing a *napari* plugin that uses *yt* as a backend for IO and analysis! 

To whet your appetite, here's a screen capture of interactive visualization of the Enzo64 sample dataset:

{{< youtube id="HhoaXgMNOz0" autoplay="true" title="Interactive visualization using yt and napari">}}

In this post, I'll just hit the highlights of the the full notebook, which you can check out [here](https://nbviewer.jupyter.org/github/chrishavlin/yt_scratch/blob/master/notebooks/yt_napari_part_1.ipynb). 

## Visualizing a *yt* image stack

So in general, using *napari* to visualize a 3D array of data is as simple as:

```python
viewer = napari.view_image(image_stack)
```

where `image_stack` is an array object. If we're OK keeping our `image_stack` in memory, we can just sample our *yt* dataset with a [fixed resolution buffer](https://yt-project.org/doc/examining/low_level_inspection.html#examining-image-data-in-a-fixed-resolution-array) and hand that off to *napari*! 

For example, the following code loads up one of *yt*'s sample datasets and pulls out a fixed resolution array containing the log of the density field:

```python
import yt 
import numpy as np 

ds = yt.load("IsolatedGalaxy/galaxy0030/galaxy0030") 
cg = ds.r[::300j,::300j,::300j]
dens_log = np.log10(cg['density'])
```

So to use *napari* to visualize our `dens_log` array, we just add it to a viewer. The *napari* GUI uses Qt for rendering, so the exact syntax depends a bit on your python session. In a standard python shell, you can use the `napari.gui_qt()` context:

```python
import napari
with napari.gui_qt(): 
    viewer = napari.Viewer()
    viewer.add_image(dens_log)
```

Or if in an IPython session (or Jupyter notebook), use the `%gui qt` magic command:

```
%gui qt
import napari
viewer = napari.Viewer()
viewer.add_image(dens_log)
```

In either case, this will launch *napari* and you'll be able to explore the `dens_log` array:

{{< youtube id="adspOox7wMI" title="Interactive visualization using yt and napari">}}

## Visualize *yt* slices 

The next sections of the notebook ([link to full notebook](https://nbviewer.jupyter.org/github/chrishavlin/yt_scratch/blob/master/notebooks/yt_napari_part_1.ipynb)) are focused on lazy loading of *yt* slices using *napari*'s ability to load a delayed *dask* array stack. By defining a function to return a 2d slice:

```python 
def return_x_slice(xval,res,c,hwid):    
    # return a slice at a single xvalue
    # xval: the xvalue in kpc to slice at 
    # res: the resolution of the image array at xval 
    # c: the center of the image in kpc
    # hwid: the half-width of the image in kpc
    region = ds.r[(xval,'kpc'), (c-hwid,'kpc'):(c+hwid,'kpc'):res*1j,
              (c-hwid,'kpc'):(c+hwid,'kpc'):res*1j]
    return np.log10(region['density'])
```

and wrapping it with `dask.delayed`,

```python
sample = return_x_slice(xvals[0],res,c,hwid)
lazy_x_frame = delayed(return_x_slice) 
```       
we can create a stack of delayed slices

```python 
lazy_arrays = [lazy_x_frame(xval,res,c,hwid) for xval in xvals]
dask_arrays = [
    da.from_delayed(lazy_array, shape=sample.shape, dtype=sample.dtype)
    for lazy_array in lazy_arrays
]
dask_stack = da.stack(dask_arrays, axis=0)
```

that we can hand off to the *napari* `Viewer` object. Now as we slice through our volume, *napari* will retrieve the *yt* slices via the `dask_stack` as needed. For the following video, I bumped up the resolution of the slices to demonstrate a case where loading the entire image stack in memory would be problematic (would need 64 Gb of RAM!):

{{< youtube id="50UC1MDzkgA" title="Interactive visualization using yt and napari">}}

## Adding annotations

Finally, I've also played around with using *napari*'s shape layers to add particle positions and streamlines extracted from a *yt* dataset. You can check out the full notebook [here](https://nbviewer.jupyter.org/github/chrishavlin/yt_scratch/blob/master/notebooks/yt_napari_part_2.ipynb).

Streamlines are particularly fun to visualize, which we can do by first generating some streamlines following the [*yt* documentation](https://yt-project.org/doc/visualizing/streamlines.html):

```python 
# Create streamlines of the 3D vector velocity and integrate them through
# the box defined above
streamlines = yt.visualization.api.Streamlines(ds, pos, 'velocity_x', 'velocity_y', 'velocity_z',
                          length=30.0*Mpc, get_magnitude=True)
streamlines.integrate_through_volume()
```

The streamline coordinates can now be extracted from `streamlines.streamlines`, but to add the streamlines to *napari*, we need to account for the fact that *napari* expects coordinates in the **pixel coordinates** of the image. In the case in the notebook, our image is 300x300x300, so we just need to multiply by 300 before using the `napari.viewer.add_shapes` function:

```python
streamlines.streamlines = streamlines.streamlines * 300 
viewer.add_shapes(streamlines.streamlines, shape_type='path', edge_width=1, edge_color=['white'])
``` 

{{< youtube id="xpwcIjfgHtE" title="Interactive visualization using yt and napari">}}


So that's it! Interactive visualization of *yt* in *napari*! This post just scratches the surface of both packages, but given how **easy** this was, I feel that a *yt*-*napari* [plugin](https://napari.org/docs/0.3.8/plugins/for_plugin_developers.html) would be fairly straightforward and might be a great way to add some more interactive analysis for *yt* users. 
