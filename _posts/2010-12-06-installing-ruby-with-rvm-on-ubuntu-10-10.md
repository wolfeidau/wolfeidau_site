--- 
layout:   post
title:    Installing Ruby with RVM on Ubuntu 10.10
category: html
---
Been installing [RVM](http://rvm.beginrescueend.com/) on anything that runs \*nix lately, ran into some issues with using this great tool on [Ubuntu 10.10](http://www.ubuntu.com/). After a bit of reading I discovered a couple of solutions, either I could install some of these libraries using RVM, or I could locate and install them in Ubuntu. As I like my libraries updated for security issues and such like I took the later option. 

So after sniffing out all the dependencies I pulled together a brief run down on how to get ruby, ruby gems and some other commonly used gems built and running on this version of Ubuntu.

Install the development suite for Ubuntu.
{% highlight bash %}
sudo apt-get install build-essential
{% endhighlight %}
Install the Git version control package and curl http client utility
{% highlight bash %}
sudo apt-get install git-core
sudo apt-get install curl
{% endhighlight %}
Install the Git version control package and curl http client utility
Install the development packages which ruby and it's utilities depend on.
{% highlight bash %}
sudo apt-get install zlib1g-dev
sudo apt-get install libssl-dev
sudo apt-get install libreadline-dev
{% endhighlight %}
Install the packages required to build nokogiri, which is an xml library used by various gems including RSpec
{% highlight bash %}
sudo apt-get install libxml2-dev
sudo apt-get install libxslt-dev
{% endhighlight %}
Install the command line SQLLite and development package.
{% highlight bash %}
sudo apt-get install sqlite3 libsqlite3-dev
{% endhighlight %}
Install Mysql client and development package.
{% highlight bash %}
sudo apt-get install mysql-client libmysqlclient-dev
{% endhighlight %}
Optionally install MySQL Server.
{% highlight bash %}
sudo apt-get install mysql-server
{% endhighlight %}
Run the following command to install RVM
{% highlight bash %}
bash < <( curl http://rvm.beginrescueend.com/releases/rvm-install-head )
{% endhighlight %}
Append the following two lines to end your .bashrc file.
{% highlight bash %}
# This loads RVM into a shell session.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
{% endhighlight %}
Source the .bashrc to make put the RVM command(s) in your path.
{% highlight bash %}
source .bashrc
{% endhighlight %}
Install ruby 1.9.2, this compiles the runtime and then installs it.
{% highlight bash %}
rvm install 1.9.2
{% endhighlight %}
Enable the ruby 1.9.2 runtime as the default.
{% highlight bash %}
rvm use 1.9.2 --default
{% endhighlight %}
List your default gems
{% highlight bash %}
gem list
{% endhighlight %}
Install a few handy gems
{% highlight bash %}
gem install rails nokogiri sqlite3-ruby mysql rspec
{% endhighlight %}

This should give you the basic environment required to build a very basic rails application and tests of course as we all love tests!

