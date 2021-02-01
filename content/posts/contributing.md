---
title: Contributing to the yt Blog!
date: 2021-01-28T15:57:31-06:00
lastmod: 2021-01-28T15:57:31-06:00
cover: /img/yt_logo.svg
categories:
  - meta
  - contributing
tags:
  - blog
---

Do you have:
* A new feature that you think is interesting?
* A way that you use yt that you think others would like?
* A tutorial on how to replicate your analysis?
* A neat application for yt?

Consider contributing to the blog! Here's how to do it! 

<!--more-->

The yt blog is build with the [hugo]() framework. We are hoping that this will
make the blog more accessible to contributions from all kinds of users --
including YOU! If you need any help or clarification on the directions here,
please feel free to ask questions in the yt project slack, or you can open an
issue on the yt blog [repository](https://github.com/yt-project/yt-blog). All
questions about the blog are welcome; we want to know about your work!

We have two ways you can contribute a new post to the blog: either (1)
creating an
issue with your blog post content inside the issue itself, or (2) cloning the
blog repository locally, committing your changes and submitting a pull request.
Both have pros and cons and will be described below. 

**note:** We also welcome contributions to the blog to edit spelling or
grammatical errors, fixing outdated links, submitting issues if you notice 
errors in the blog content, or any other types of blog enhancements. Your
contributions are what make our community strong and vibrant.  

## Option 1: Create an Issue with Your Blog Post Content

Option 1 for building the blog is easier and doesn't require you to install
anything new on your local machine, and it doesn't require you to use command
line git. 

If the above sounds attractive to you and you don't feel like 
building the blog locally, we have a script that will
convert an issue on the yt blog to a blog post PR automatically. To do this
follow these steps: 
1. Go to the [issues](https://github.com/yt-project/yt-blog/issues) page of the yt blog 
   repository. 
1. Click on `new issue` to open your blog post issue. The blog issue template
   is automatically formatted to with some header information for you to
   include so we attribute authorship.
1. Fill in the header information at the top of the page with your information
   and the date that you're writing the post. You can also add tags and
   categories for your post. We have the tags and categories that we're using 
   on the blog currently listed as content in the issue body, so scroll 
   down to check which ones apply to your post. 
1. Start filling in content for the blog post in the issue body. Our issue
   template has a lot of helpful information to get you started, you can delete
   it when you're finished but we hope it helps! 
1. Once your post is finished, click "Submit new issue". One of the blog
   maintainers will come to double check it, and we will trigger the bot to
   start the post PR. Once the PR is created, it will tag your issue, so you
   should see a link pop up. 
   The maintainer may ask you a few questions if there are
   formatting issues in the conversion, so be on the lookout! 

A few helpful tips:
* The blog posts are written in markdown, so you can use formatting in markdown
  to guide your post.
* Make sure to delete the html comment lines (they look like this `<!--` ) on
  your issue
* When you drag and drop images on an issue, github will automatically upload
  them and create the correct markdown URL. For images you'd like to include 
  in your post, drag and drop them in the location of the "issue" that you 
  want them to be placed. Our script will handle the
  conversion to local URLs for the blog. 
* hugo has something called shortcodes to help make embedding videos, twitter
  posts, gists, and other things a bit easier. Check out this page if you'd like to
  use them in your post:
  https://gohugo.io/content-management/shortcodes/#use-hugos-built-in-shortcodes

## Option 2: Issue a Pull Request with your Blog Post Content

If you're interested in playing around more with formatting, and some of the
cool hugo features like
[shortcodes](https://gohugo.io/content-management/shortcodes/), then this might
be the option for you. This is the more "traditional" way of contributing to
open source projects, so it might be the one you're more familiar with. Option
2 does require a local setup, but it also allows you to preview your post in
advance to catch any formatting errors.

Here are the steps to creating a blog post PR:
* Install hugo 
* Fork and Clone the repository
* Build the project locally
* Create a new post
* Commit and push your changes
* Create a Pull Request

### Install Hugo

You'll need a working copy of hugo on your machine to preview your post
locally. To do that, follow the instructions on the [hugo install
page](https://gohugo.io/getting-started/installing/). 

### Fork and Clone the Repository

Go to the yt blog [repository](https://github.com/yt-project/yt-blog) and click
the fork button on the top right of the page. This will create a copy of the
repository under your username, e.g. https://github.com/crashoverride/yt-blog . 

Next, clone the blog from your profile

``` bash
$ git clone git@github.com:crashoverride/yt-blog.git
```

```
Cloning into 'yt-blog'...
remote: Enumerating objects: 608, done.
remote: Counting objects: 100% (608/608), done.
remote: Compressing objects: 100% (163/163), done.
remote: Total 1535 (delta 270), reused 541 (delta 263), pack-reused 927
Receiving objects: 100% (1535/1535), 45.42 MiB | 4.10 MiB/s, done.
Resolving deltas: 100% (676/676), done.
```

This project uses a hugo theme called `dream`. For information about this theme
specifically, check out the [quickstart
page](https://g1eny0ung.site/hugo-theme-dream/#/quick-start?id=add-quotabout-mequot). 
Because we aren't doing any customization of the theme, we are using a
reference to it as a submodule. This isn't cloned with a simple `git clone`, so
we need to get that too. The following command will initialize the submodule
and clone it in the correct location of this repository. 

```bash
$ git submodule update --init
```

```
Submodule 'themes/dream' (https://github.com/g1eny0ung/hugo-theme-dream.git)
registered for path 'themes/dream'
Cloning into '/Users/crashoverride/repos/yt-blog/themes/dream'...
Submodule path 'themes/dream': checked out
'eacbcc3f3625ce3bd770d55f130da915fa1f7ff0'
```

Now we're ready to preview it locally!

### Build the Project Locally

Now that you have the project and submodule cloned, and hugo installed, you can
preview the website locally. Execute:

``` bash
$ hugo server -D
```

To create a local server of the page, served (by default) to localhost:1313

The `-D` flag will show draft posts (the `-D` flag is short for `--buildDrafts`, 
so as you start writing your post it will
show up on this locally served version of the webpage. We will talk a bit more
about drafts in the next step. 

You should get the following output:
```

                   | EN
-------------------+------
  Pages            | 124
  Paginator pages  |   7
  Non-page files   |   0
  Static files     |  91
  Processed images |   0
  Aliases          |  27
  Sitemaps         |   1
  Cleaned          |   0

Built in 281 ms
Watching for changes in /Users/crashoverride/repos/yt-blog/{content,static,themes}
Watching for config changes in /Users/crashoverride/yt-blog/config.toml
Environment: "development"
Serving pages from memory
Running in Fast Render Mode. For full rebuilds on change: hugo server --disableFastRender
Web Server is available at http://localhost:1313/yt-blog/ (bind address 127.0.0.1)
Press Ctrl+C to stop
```

As you modify your post and save it, the site will be rebuilt automatically.
Output in this process looks like the following:

```
Change detected, rebuilding site.
2021-01-28 16:08:05.778 -0600
Source changed "/Users/crashoverride/repos/yt-blog/content/posts/mycoolpost.md": WRITE
Total in 32 ms
```

### Create a New Post

To create a new post with the header information that will be used to attribute
your authorship and tag the post, execute:
``` bash
$ hugo new posts/mycoolpost.md
```
from the base repository directory. 

A new markdown file will be generated by hugo called `mycoolpost.md` in 
`content/posts/`. Open this file with your preferred editor and fill in the
relevant header information, like your name, your website (only if you are
comfortable), and appropriate tags for the post. You can see the tags that we
use on the blog page at https://yt-project.github.io/yt-blog/ in the left
panel. 

If you look through the header of `mycoolpost.md`, you also see a `draft: true`
line. This means your post is currently in draft mode. Because we called `hugo
server -D` in the previous step, your post will show up in the live rendering
of the blog. However, it will not show up on the final webpage or if you call
`hugo server` without the drafts enabled. Before submitting your pull request,
remove the `draft: true` line. `

Continue to fill in your content. We can't wait to see your contribution!!!

**Note:**
Images are stored in a separate location than the posts. Post files are in the
`content/posts/` folder. However, images are stored in `static/img`. For any
images that you'd like to include in your post, create a folder in `static/img`
that matches your post name, e.g. `static/img/mycoolpost` and add your images
there. To reference your images in your post, you can use a reference to your
folder like so:

``` markdown
![](/img/mycoolpost/phaseplota.png)
```

### Commit and Push Your Changes

As you are creating your post, you can commit several times or add everything
at the end. 

```bash
$ git add content/posts/mycoolpost.md
$ git commit -m "add post about how useful PhasePlots are"
```

Once you feel your post is ready, commit your changes and push them up to your
user repository. 

``` bash
$ git push origin main
```

We encourage you to commit and push frequently!

### Create a Pull Request

Now that your changes are on your profile on github, you can [create a pull
request](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request) 
to have them on the yt blog! We can't wait to see your contributions!
