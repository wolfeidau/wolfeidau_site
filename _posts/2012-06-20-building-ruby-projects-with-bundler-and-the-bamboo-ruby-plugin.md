---
layout: post
title: Building Ruby Projects with Bundler and the Bamboo Ruby Plugin
category: Bamboo, Ruby, Bundler
---

The latest release of the Ruby [plugin](https://marketplace.atlassian.com/plugins/au.id.wolfe.bamboo.rake-bamboo-plugin) I develop for [Atlassian Bamboo](http://atlassian.com/bamboo) now
includes some new configuration options for [Bundler](http://gembundler.com/) along with a number
of other additions and improvements. In this post I want to focus on the
new options available in the Bundler task, and illustrate how they are
used to make [Ruby](http://www.ruby-lang.org/en/) builds simpler.

In the past with my plugin the administrator of the CI server had two
options when managing the gems associated with a build:

1. Install all the gems required by the project prior to performing a build 
2. Permit bundler to write to the local ruby installations gem directory

In my view neither of these options is ideal, so I decided I would do some
research into staging gems within the working copy of a build. The aim
here was to build a ruby project without tainting the local ruby
installation, which is one of  the key objectives of CI. After some reading 
I discovered that Bundler could help stage my gems, therefore saving me
from doing so.

To take advantage of this feature in Bundler the user was
required to pass a couple of switches to install command and
then run Bundler's exec command for all subsequent ruby executions.

To illustrate this using the Bamboo Ruby plugin I will run through
configuring a build with a simple rails project.

Firstly we need a ruby,
which I install using [RVM](rvm.beginrescueend.com/), you could just use the system provided one if
your on OSX.

{% highlight bash %}
$ rvm install 1.9.3
{% endhighlight %}

Then use this install.

{% highlight bash %}
$ rvm use 1.9.3
{% endhighlight %}

Now the only gem you need to install is bundler.

{% highlight bash %}
$ gem install bundler
{% endhighlight %}

Now within Bamboo install the Bamboo Ruby Plugin via the Universal
Plugin Manager.

![Ruby Plugin Installed](/images/RubyPluginInstalled.jpg)

Now go to Server Capabilities in Administration section, and click the
Detect Server Capabilities button, this should find your ruby
installation as seen below.

![Ruby Server Capabilities](/images/RubyServerCapabilities.jpg)

Next setup a project and a release plan.

![Create Plan](/images/CreatePlan.jpg)

Then within your build Job add the Bundler Task, configuring the path
option to vendor/bundle and ticking the binstubs option.

![Bundle Task](/images/CreatePlanBundler.jpg)

Next add a Rake task to run your database migrations.

![Rake DB Migrate Task](/images/CreatePlanRakeDBMigrate.jpg)

Next we want to run the tests in our project, in my case I am using
RSpec2 so I use the spec rake task.

![Rake Run RSpec Task](/images/CreatePlanRakespecs.jpg)

As I like to see my test outputs in the CI server I have enabled xml
output with my RSpec configuration file and added the [rspec_junit_formatter](https://github.com/sj26/rspec_junit_formatter)
gem to my Gemfile. This produces a JUnit XML report file named
rspec.xml which Bamboo parses into test results report.

![JUnit Task](/images/CreatePlanTestResults.jpg)

Now you should enable your build and run it, all going well you should
have green, otherwise have a look at the build log and see what the
issue was.

So that wraps up my demonstration of Bamboo Ruby Plugin using the
awesome bundler gem to enable simple ruby build environments.
