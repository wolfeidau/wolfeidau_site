---
layout: post
title: Less is more especially when it comes to CSS
category: JavaScript HTML5
---

I am currently working on new design for my site using HTML5, CSS and a sprinkling of JavaScript. Once I started building my basic design I was re-acquainted with a process that really, really annoys me; the constant tweak refresh loop associated with building a design. So in true yak shaving fashion I decided to find a solution to this problem.

After considering the issue for a bit it dawned on me that this may be a good excuse to try out [LessCSS](http://lesscss.org "LessCSS Website") JavaScript library. When added to a website this enables a designer to use a CSS like markup to significantly reduce the amount of duplication and redundancy in the style sheet.

Initially I planned to call reload of the less library based on a timer, however I found this feature was already present in the library, with the addition of a _#!watch_ to the URL in the browser LessCSS will poll the style sheet for updates.

On a wide screen monitor this means I can tweak the CSS and watch the changes appear, which in turn removes quite a bit of keyboard gymnastics while working on a design.

To take advantage of these features in your site simply add the following fragment to your html page.

{% highlight html %}
<link rel="stylesheet/less" type="text/css" href="css/styles.less">
<script src="js/libs/less.js" type="text/javascript"></script>
{% endhighlight %}

Then move all your styles to _css/styles.less_ within your mockup/site and reload the page. To enable auto reload of the _styles.less_ file append #!watch to the URL and refresh the page.

One thing to note is you will need to serve the site using a web server of some sort otherwise you will get XHR issues, to do this on OSX I use a python one liner.

{% highlight bash %}
$ python -m SimpleHTTPServer
{% endhighlight %}

Next thing I am working on is live reloading of page fragments using [Ember](http://emberjs.com/ "Ember Website") and [Handlebars](http://handlebarsjs.com/ "Handlebars Website").
