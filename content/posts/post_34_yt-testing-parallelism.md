# yt Testing and Parallelism

author: Sam Skillman

date: 2011-10-24T07:14:22-00:00

A few of us worked this past week on a couple yt projects and made what
we think is significant progress. Two of the items we focused on were
testing and parallelism.

For testing, we've broadened the test suite to include many more
functions and derived quantities. We now have 548 tests that include
(off and on-axis) slices, (off and on- axis) projections, phase
distributions, halo finding, volume rendering, and geometrical region
cuts such as rectangular solids, spheres, and disks. We use both plain
and derived fields for these tests so that it covers as many bases as
possible. With this framework, we are now able to keep a gold standard
of the test results for any dataset, then test later changes against
this standard. These tests can test for bitwise identicality or allow
for some tolerance. For a full list of tests, you can run
`python yt/tests/runall.py -l`, and use `--help` to look at the usage.
We will soon be updating the documentation to provide more information
on how to set up the testing framework, but I think all of us agree that
this will make it much easier to test our changes to make sure bugs have
not crept in.

The second big change I'd like to talk about is the way we now handle
parallelism in yt. Previously, methods that employed parallelism through
MPI calls would first inherit from `ParallelAnalysisInterface`, which
had access to a ton of mpi functions that all work off of
`MPI.COMM_WORLD`. In our revamp we wanted to accomplish two things: 1)
merge duplicate mpi calls that were only different by the type of values
they work on and do overall cleanup. 2) Allow for nested levels of
parallelism where two (or more) separate communicators are able to use
barriers and collective operations such as allreduce. To do this, we
worked in a two-step process. First we took things like:

``` python
def _mpi_allsum(self, data):
def _mpi_Allsum_double(self, data):
def _mpi_Allsum_long(self, data):
def _mpi_allmax(self, data):
def _mpi_allmin(self, data):
```

and packed it into a single function:

``` python
def mpi_allreduce(self, data, dtype=None, op='sum'):
```

When a numpy array is passed to this new `mpi_allreduce`, dtype is
determined from the array properties. If the data is a dictionary, then
it is passed to mpi4py's allreduce function that acts on dictionaries.
This greatly reduced the number of lines in
parallel\_analysis\_interface (1376 to 915), even after adding in
additional functionality.

The second step was bundling all of these functions into a new class
called Communicator. This Communicator object is initialized with an MPI
communicator that no longer is restricted to `COMM_WORLD`. Using this as
the fundamental MPI object, we then built a CommunicationSystem object
that manages these communicators. A global communication\_system
instance is created, that is initialized with `COMM_WORLD` at the top of
the system if the environment is mpi4py-capable. If not, an empty
communicator is created that has passthroughs for all the mpi functions.

Using this new framework we are now able to take advantage of multiple
communicators. There are two use cases that we have implemented so far:

## Parallel Objects

parallel\_objects is a method in parallel\_analysis\_interface.py for
iterating over a set of objects such that a group of processors work on
each object. This could be used, for example, to run N projections each
with M processors, allowing for a parallelism of NxM.

## workgroups

workgoups allows users to set up multiple MPI communicators with a
non-uniform number of processors to each work on a separate task. This
capability lives within the ProcessorPool and Workgroup objects in
`parallel_analysis_interface.py`

These are just the first two that we tried out and we are very excited
about the new possibilities.

With these changes, there was one implementation change that has already
come up once in the mailing list. When you implement a new class that
you'd like to have access to the communication objects, you must first
inherit `ParallelAnalysisInterface`, and then make sure that
\_\_init\_\_ makes a call to: `ParallelAnalysisInterface.__init__()`

At that point, your new class will have access to the mpi calls through
the self.comm object. For example, to perform a reduction one would do:

``` python
self.comm.mpi_allreduce(my_data, op='sum')
```

As I said before, this will be documented soon, but hopefully this will
help for now.

Sam, Britton, Cameron, Jeff, and Matt
