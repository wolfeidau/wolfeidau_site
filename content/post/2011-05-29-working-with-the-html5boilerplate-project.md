+++
date = "2011-05-29T00:00:00+11:00"
draft = false
title = "Working with the html5boilerplate project"
categories = [ "HTML", "CSS", "nginx" ]

+++

Recently I started work on a new site which I plan to use [underscore.js](http://documentcloud.github.com/underscore/) and [backbone.js](http://documentcloud.github.com/backbone/). Starting a site from scratch can be quite a chore, as well as time consuming. To remedy this I decided to take the plunge and give the [html5boilerplate](http://html5boilerplate.com/) project a try, this project is designed to kickstart your [html5](http://developers.whatwg.org/) site development with a shell containing all of the stuff that you need to begin with.


So why start with html5boilerplate at all? Well the following things come with it:
* modenizer included and configured for legacy browser support.
* A cool `favicon.ico` to eliminate those 404 errors I always get in my logs, as well as apple touch icons.
* A base project structure with files originised into a nice layout.
* JQuery bundled in and ready to roll.
* A great starting point annotated css file with a whole raft of tips and tricks.
* Sample site compression build scripts in [Apache Ant](http://ant.apache.org/).
* A nice example of how to load the google analytics script asynchronously.

Even for those maintaining an existing site there are quite a few very handy lessons to learn from this project. Personally I like all the server configuration file examples located at [html5-boilerplate-server-configs](https://github.com/paulirish/html5-boilerplate-server-configs), this is a very important facet of any site and is often overlooked.

So in summary I have learnt a lot of good lessons while working with this project and I will be merging some of these into my own blog site.