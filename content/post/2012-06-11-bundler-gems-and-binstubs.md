+++
date = "2012-06-11T00:00:00+11:00"
draft = false
title = "Bundler gems and binstubs"
categories = [ "Ruby", "Bundler" ]

+++

I have been working on an update of my [Bamboo](http://www.atlassian.com/bamboo/) ruby plugin which uses
[bundler](http://gembundler.com/) to install all the gems for a given project within the working
copy of the project and then run rake using these gems.

The aim of this post is to illustrate how this is done and how to craft 
an environment to run ruby once gems are "staged" within a working copy.


The aim of this post is to illustrate how a rails project is staged
using bundler without installing any gems in the base ruby installation.

Firstly I will create a new rails project in an environment similar to that 
used when developing rails applications. I will be using an installation of 
ruby with bundler, rake and rails already installed, note I am passing the 
-T switch as I want to setup an alternate test framework.

{{< highlight bash >}}
rails new somenewrailsproj -T
{{< /highlight >}}

Once created I navigate into the project and setup the test framework I am
intending to use which is [Rspec-2 for rails](http://github.com/rspec/rspec-rails).

Add the following code to the end of the Gemfile.

{{< highlight ruby >}}
group :test, :development do
    gem "rspec-rails", "~> 2.0"
end
{{< /highlight >}}

Run bundle install.

{{< highlight bash >}}
bundle install
{{< /highlight >}}

Run the Rspec-2 generator to plugin into the rails project.

{{< highlight bash >}}
rails generate rspec:install
{{< /highlight >}}

Scaffold a sample model.

{{< highlight bash >}}
rails generate scaffold post title body:text published:boolean
{{< /highlight >}}

Migrate this to the database.

{{< highlight bash >}}
rake db:migrate
{{< /highlight >}}

Remove the pending specs as their not important 

{{< highlight bash >}}
rm ./spec/helpers/posts_helper_spec.rb ./spec/models/post_spec.rb
{{< /highlight >}}

Run Rspec and we should be all green.

{{< highlight bash >}}
bundle exec rake spec
{{< /highlight >}}

Now to complete isolate our test environment we need a clean bash shell,
to do this we run the following.

{{< highlight bash >}}
env -i bash
{{< /highlight >}}

Next we export the PATH variable, in my case I only want my specific
ruby version, and indeed the only thing I want is this versions bins.

{{< highlight bash >}}
export PATH=/Users/markw/.rbenv/versions/1.9.2-p320/bin
{{< /highlight >}}

This version ruby has just been installed and therefore only has the base set of
gems

{{< highlight bash >}}
$ gem list
minitest (1.6.0)
rake (0.8.7)
rdoc (2.5.8)
{{< /highlight >}}

To simulate a build server the only gem we will add to this installation is bundler.

{{< highlight bash >}}
gem install bundler
{{< /highlight >}}

Now we run gem adding the vendor/bundle/ruby/1.9.1 directory to the
GEM_PATH this shows the gems we had previously bundled.

{{< highlight bash >}}
GEM_PATH=vendor/bundle/ruby/1.9.1 gem list
{{< /highlight >}}

Now to illustrate how this will work inside a build environment we need augment our path a little, this will ensure gem install can find tools like compilers and such if required.

{{< highlight bash >}}
export PATH=/Users/markw/.rbenv/versions/1.9.2-p320/bin:/bin:/sbin:/usr/bin:/usr/sbin
{{< /highlight >}}

Now run bundle install to recreate vendor/bundle and bin

{{< highlight bash >}}
bundle install --path vendor/bundle --binstubs
{{< /highlight >}}

Now run our specs with the augmented GEM_PATH.

{{< highlight bash >}}
$ GEM_PATH=vendor/bundle/ruby/1.9.1 bundle exec rake spec                             
...
Finished in 0.32614 seconds
28 examples, 0 failures
{{< /highlight >}}

So I have illustrated how I can stage gems for a rails application
and run it's tests without installing anything in the base ruby. This
should work for any gem or project which uses bundler.

Some points to consider about this approach are:

* One should note that ruby has a notion of STD Library API compatibility which is reflected in the ruby/1.9.1 section of the path, this may vary for each release.
* For commercial projects I would recommend using a frozen set of packaged and quality assured gems and running tests with just this set.

That said for things like [Octopress](http://octopress.org/) projects and gems / projects used
internally this is quite a flexible way to run a CI build.
