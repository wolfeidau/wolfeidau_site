+++
date = "2012-01-09T00:00:00+11:00"
draft = false
title = "Less is more especially when it comes to CSS"
categories = [ "JavaScript", "HTML" ]

+++

I am currently working on new design for my site using HTML5, CSS and a sprinkling of JavaScript. Once I started building my basic design I was re-acquainted with a process that really, really annoys me; the constant tweak refresh loop associated with developing a new site layout. So in true yak shaving sysadmin fashion I got side tracked looking for a solution to this problem.


After considering the issue for a bit it dawned on me that this may be a good excuse to try out [LessCSS](http://lesscss.org "LessCSS Website") JavaScript library. When incorporated into a website this library enables the developer to use a CSS like markup which significantly reduce the amount of duplication and redundancy in the style sheet. The markup is processed on the client using JavaScript and has an API to mess around with how the styles are loaded.

Initially I planned to invoke the reload function in less library using a timer, however after reading the docs I found this feature was already built into LessCSS. Simply add _#!watch_ to the URL in the browser and LessCSS will poll the style sheet for updates.

On a wide screen monitor this means I can tweak the CSS and watch the changes appear, which in turn removes quite a bit of keyboard gymnastics while working on a design.

To take advantage of these features in your site simply add the following fragment to your html page.

{{< highlight html >}}
<link rel="stylesheet/less" type="text/css" href="css/styles.less">
<script src="js/libs/less.js" type="text/javascript"></script>
{{< /highlight >}}

Then move all your styles to _css/styles.less_ within your mockup/site and reload the page. To enable auto reload of the _styles.less_ file append #!watch to the URL and refresh the page.

One thing to note is you will need to serve the site using a web server of some sort otherwise you will get XHR issues, to do this on OSX I use a python one liner.

{{< highlight bash >}}
$ python -m SimpleHTTPServer
{{< /highlight >}}

To illustrate this feature I have created a sample project up on github [lesscss_watch_example_site](https://github.com/wolfeidau/lesscss_watch_example_site "Sample LessCSS Project").

I am currently working on a site which will also live reload page fragments using [Ember](http://emberjs.com/ "Ember Website") and [Handlebars](http://handlebarsjs.com/ "Handlebars Website").
