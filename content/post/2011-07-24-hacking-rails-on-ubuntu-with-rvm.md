+++
date = "2011-07-24T00:00:00+11:00"
draft = false
title = "Hacking rails on Ubuntu with rvm"
categories = [ "Ruby", "Ruby on Rails" ]

+++

Over the last few days I have been familiarising myself with some of the rails source code and surveying it for use in my own projects. In doing so I noticed there were quite a few gotchas getting [Ubuntu](http://www.ubuntu.com/) and ruby set up [RVM](http://rvm.beginrescueend.com/) to successfully run the tests suites in rails. This post aims to provide a step by step guide to getting a clean ubuntu installation ready to test and hack on rails, note I am using Ubuntu 11.04 and this process has been tested on server and desktop.


Install the development suite for Ubuntu.

{{< highlight bash >}}
sudo apt-get install build-essential
{{< /highlight >}}

Install the Git version control package and curl http client utility

{{< highlight bash >}}
sudo apt-get install git curl
{{< /highlight >}}

Install the development packages which ruby and it's utilities depend on.

{{< highlight bash >}}
sudo apt-get install zlib1g-dev libssl-dev libreadline-dev
{{< /highlight >}}

Install the packages required to build nokogiri, which is an xml library used by rails.

{{< highlight bash >}}
sudo apt-get install libxml2-dev libxslt1-dev
{{< /highlight >}}

Install the command line SQLLite and development package, note the command line tools aren't required but are very handy.

{{< highlight bash >}}
sudo apt-get install sqlite3 libsqlite3-dev
{{< /highlight >}}

Install MySQL client, server and development packages.

{{< highlight bash >}}
sudo apt-get install mysql-client mysql-server libmysqlclient15-dev
{{< /highlight >}}

Install the PostgeSQL client, server and development packages.

{{< highlight bash >}}
sudo apt-get install postgresql postgresql-client postgresql-contrib libpq-dev
{{< /highlight >}}

Run the following command to install RVM

{{< highlight bash >}}
bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
{{< /highlight >}}

Source the .bashrc to make put the RVM command(s) in your path

{{< highlight bash >}}
source .bashrc
{{< /highlight >}}

Install ruby 1.9.2, this compiles the runtime and then installs it.

{{< highlight bash >}}
rvm install 1.9.2
{{< /highlight >}}

Enable the ruby 1.9.2 runtime as the default.

{{< highlight bash >}}
rvm use 1.9.2 --default
{{< /highlight >}}

Update your gem command.

{{< highlight bash >}}
gem update --system
{{< /highlight >}}

Log into the MySQL command line interface using the password which was set for the root user at installation.

{{< highlight bash >}}
mysql -uroot -p
{{< /highlight >}}

Set up a rails user with all permissions on the activerecord test database.

{{< highlight bash >}}
GRANT ALL PRIVILEGES ON activerecord_unittest.* to 'rails'@'localhost';
GRANT ALL PRIVILEGES ON activerecord_unittest2.* to 'rails'@'localhost';
{{< /highlight >}}

Create a user with super user privileges in PostgreSQL for the login your currently authenticated under.

{{< highlight bash >}}
sudo -u postgres createuser --superuser $USER
{{< /highlight >}}

Navigate to where you store the code your working on and clone the rails repository.

{{< highlight bash >}}
cd ~/Code/Ruby
git clone git://github.com/rails/rails.git
cd rails
{{< /highlight >}}

Install the latest version of bundler.

{{< highlight bash >}}
gem install bundler
{{< /highlight >}}

Install all dependencies including the MySQL and PostgreSQL drivers.

{{< highlight bash >}}
bundle install
{{< /highlight >}}

Run the tests.

{{< highlight bash >}}
rake test
{{< /highlight >}}


For more information on this process see [Contributing to Ruby on Rails](http://guides.rubyonrails.org/contributing_to_ruby_on_rails.html).
