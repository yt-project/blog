---
title: How the Merger Tree Sped Up SQLite Database UPDATEs
author: Stephen Skory
date: 2010-09-09T13:26:00-00:00
lastmod: 2010-09-09T13:26:00-00:00
cover: /img/random/shoes.jpeg
categories:
  - archive
tags:
  - archive
---
The [Parallel Merger
Tree](http://yt.enzotools.org/doc/extensions/merger_tree.html) in yt,
like most of the code in yt, has a rich history of changes and upgrades.
One of the most significant upgrades was a change in the way the [SQLite
database file](http://sqlite.org/) is updated during the course of
building the merger tree. Briefly, the database contains all the
information about the merger tree of the halos, as well as the specifics
of each halo, such as the mass, position or bulk velocity. Originally,
the database was built by first filling in all the initially available
information about each halo: the data that comes from the [halo
finder](http://yt.enzotools.org/doc/extensions/running_halofinder.html).
Then, as the merger tree ran and identified relationships between halos,
the entries for each halo would be modified to reflect the new
information using the [SQL "UPDATE"](http://sqlite.org/lang_update.html)
command. Below is a simplified example of how this worked, using random
numbers instead of halo data:

``` python
import sqlite3 as sql
import numpy as np
import time, random
# How many random numbers we'll be working with.
number = int(5e5)

# Create and connect to the database.
conn = sql.connect("test.db")
cursor = conn.cursor()
# Make the table we'll be using. The first column will automatically
# generate the integer index for each row starting at 0.
line = "CREATE TABLE randoms
(count INTEGER PRIMARY KEY, value FLOAT);"
cursor.execute(line)

# Make the random numbers.
rnum = np.random.random(number)

t1 = time.time()
# Insert the values the first time.
for r in rnum:
    line = "INSERT INTO randoms VALUES (null, %1.10e);" % r
    cursor.execute(line)
t2 = time.time()

print "First insertion took %1.2e seconds" % (t2-t1)
print "Now let's update the information."
# Make some more random numbers.
rnum2 = np.random.random(number)
# This make an array of integers [0:number-1], with the positions randomly
# placed.
order = np.array(random.sample(xrange(number), number))

t3 = time.time()
# Update the entries.
for pair in zip(order, rnum2):

    line = "UPDATE randoms SET value = %1.10e WHERE count = %d;" % \
            (pair[1], pair[0])
    cursor.execute(line)
t4 = time.time()

print "Update took %1.2e seconds" % (t4-t3)

# Close up properly.
cursor.close()
conn.close()
```

Running this on my two year old Macbook Pro gives me:

``` none
First insertion took
1.79e+01 seconds
Now let's update the information.
Update took 4.58e+01 seconds
```

Remember that the second operation is putting no more information in the
database, it is just changing the data. However, it's much slower
because it must search the database for each entry with the current
"count" value. In effect, with each "UPDATE", the whole database is
being read and every entry is being compared to "count" to see if it
needs to be changed. There is a "LIMIT" keyword that can be part of an
"UPDATE" statement that tells SQLite to only affect a certain number of
rows. However, this is not a good solution for two reasons. First, this
capability needs to be enabled when the SQLite library is compiled, and
it often isn't. Second, this only reduces the average number of rows
searched from N to N/2, which is not a very good improvement.

In the Merger Tree, this "UPDATE" step became the largest single factor
in the runtime. This is very bad because in the Parallel Merger Tree,
all SQLite writes are done with the root processor, which means all the
other tasks sat idle waiting on the root task. A better way was needed!

As it turns out, there is a much faster way. Instead of using "UPDATE",
a second, temporary database is created. As we can even see from the
example above, "INSERT" statements are relatively fast, so we would like
to use that! As the first database is read in, its values are modified,
and then the data is added to the second. After all is said and done,
the second database will then replace the first, and the overall effect
will be the same.

``` python
import sqlite3 as sql

import numpy as np
import time, random
# How many random numbers we'll be working with.
number = int(5e5)

# Create and connect to the database.
conn = sql.connect("test.db")
cursor =
conn.cursor()

# Make the table we'll be using.
line = "CREATE TABLE randoms (count INTEGER PRIMARY KEY, value FLOAT);"
cursor.execute(line)

# Make the random numbers.
rnum = np.random.random(number)

t1 = time.time()
# Insert the values the first time.
for r in rnum:
    line = "INSERT INTO randoms VALUES (null, %1.10e);" % r
    cursor.execute(line)
t2 = time.time()

print "First insertion took %1.2e seconds" % (t2-t1)
print "Now let's update the information in a faster way."
# Make some more random numbers.
rnum2 = np.random.random(number)

t3 = time.time()
# Make a second database.
conn2 = sql.connect("test2.db")
cursor2 = conn2.cursor()
# We need to make the table, again.
line = "CREATE TABLE randoms (count INTEGER PRIMARY KEY, value FLOAT);"
cursor2.execute(line)
# Update the entries by reading in from the first, writing to the second.
line = "SELECT * FROM randoms ORDER BY count;"
cursor.execute(line)
results = cursor.fetchone()
mark = 0
while results:
    line = "INSERT INTO randoms VALUES (%d, %1.10e);" % \
         (results[0], rnum[mark])
    cursor2.execute(line)
    mark += 1
    results = cursor.fetchone()
t4 = time.time()

print "Update took %1.2e seconds" % (t4-t3)

# Close up properly.
cursor.close()
conn.close()
cursor2.close()
conn2.close()
```

And the timings:

``` none
First insertion took
1.55e+01 seconds
Now let's update the information in a faster way.
Update took
1.82e+01 seconds
```

Of course there will always be some variability in the timings, but the
relative differences between the two methods is very clear. In this
second method, the update time is just a bit longer than the initial
timing. However, the first method was several times longer, for the same
overall result. Note that in the second example, the "count" data column
is being specified, and even if a new entry is made with a "null" value,
SQLite will correctly fill in with the next larger integer with no
problem.

The only caveat is that this method will temporarily require roughly
double the amount of disk space. This is a minor concern because modern
computers have far more disk space than a SQLite database (or two) could
ever fill up in a reasonable application.
