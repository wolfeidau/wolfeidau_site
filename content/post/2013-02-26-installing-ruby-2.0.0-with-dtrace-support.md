+++
date = "2013-02-26T00:00:00+11:00"
draft = false
title = "Installing Ruby 2.0.0 with Dtrace Support"
categories = [ "Ruby", "rbenv", "DTrace" ]

+++

The aim of this post is to guide the reader through the process of installing [ruby 2.0.0](http://www.ruby-lang.org/en/)
into [rbenv](https://github.com/sstephenson/rbenv) with dtrace probes enabled. As rbenv uses [ruby-build](https://github.com/sstephenson/ruby-build),
which currently downloads and compiles a copy of [openssl](http://www.openssl.org/) rather than using the one
[homebrew](http://mxcl.github.com/homebrew/) i prefer to use the homebrew one.


Note that you MUST install [xcode](https://developer.apple.com/xcode/) before installing anything, then install homebrew,
rbenv, and lastly openssl.

{{< highlight bash >}}
ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
brew install rbenv
brew install openssl
{{< /highlight >}}

Next to overcome the fact that OSX doesn't have an openssl ca certificate bundle, use the following brew to create and
maintain one using the CA certs stored in your keychain.

{{< highlight bash >}}
brew tap raggi/ale && brew install openssl-osx-ca
{{< /highlight >}}

Make a temporary directory to build the sources in, download the 2.0.0-p0 and extract it into this location, then
navigate into the `ruby-2.0.0-p0` directory containing the sources.

{{< highlight bash >}}
mkdir ~/temp && cd ~/temp
curl -L ftp://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p0.tar.bz2 | tar xjf -
cd ruby-2.0.0-p0
{{< /highlight >}}

Run configure file with the arguments as listed below.

{{< highlight bash >}}
./configure --prefix=$HOME/.rbenv/versions/2.0.0-p0 --enable-dtrace \
--with-opt-dir=`brew --prefix openssl`
{{< /highlight >}}

Within this rather verbose output you should see the following, this indicates that dtrace has been included.

{{< highlight bash >}}
checking whether dtrace USDT is available... yes
{{< /highlight >}}

Build ruby, note I am invoking make with the ‘-j’ or ‘--jobs’ option tells make to execute many recipes simultaneously,
in my case I chose 9 as I have eight cores (n of cores + 1).

{{< highlight bash >}}
make -j9
{{< /highlight >}}

Now install ruby into rbenv with the label 2.0.0-p0.

{{< highlight bash >}}
make install
{{< /highlight >}}

To try it out we will alter our shell to use the 2.0.0-p0 version.

{{< highlight bash >}}
rbenv shell 2.0.0-p0
{{< /highlight >}}

Running `ruby -v` should output the following.

{{< highlight bash >}}
ruby 2.0.0p0 (2013-02-24 revision 39474) [x86_64-darwin12.2.0]
{{< /highlight >}}

You can remove the temporary directory you built ruby in now.

{{< highlight bash >}}
rm -r ~/temp
{{< /highlight >}}

NOTE: Bundler has just been updated to cater for ruby 2.0.0 but you will need to retrieve the gem manually and install it as follows.

{{< highlight bash >}}
wget https://rubygems.org/downloads/bundler-1.3.0.gem
gem install bundler-1.3.0.gem
rm bundler-1.3.0.gem
{{< /highlight >}}

