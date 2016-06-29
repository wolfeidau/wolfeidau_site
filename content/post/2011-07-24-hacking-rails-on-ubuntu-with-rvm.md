+++
date = "2011-07-24T00:00:00+11:00"
draft = false
title = "Hacking rails on Ubuntu with rvm"
categories = [ "Ruby", "Ruby on Rails" ]

+++

Over the last few days I have been familiarising myself with some of the rails source code and surveying it for use in my own projects. In doing so I noticed there were quite a few gotchas getting [Ubuntu](http://www.ubuntu.com/) and ruby set up [RVM](http://rvm.beginrescueend.com/) to successfully run the tests suites in rails. This post aims to provide a step by step guide to getting a clean ubuntu installation ready to test and hack on rails, note I am using Ubuntu 11.04 and this process has been tested on server and desktop.


Install the development suite for Ubuntu.

```
sudo apt-get install build-essential
```

Install the Git version control package and curl http client utility

```
sudo apt-get install git curl
```

Install the development packages which ruby and it's utilities depend on.

```
sudo apt-get install zlib1g-dev libssl-dev libreadline-dev
```

Install the packages required to build nokogiri, which is an xml library used by rails.

```
sudo apt-get install libxml2-dev libxslt1-dev
```

Install the command line SQLLite and development package, note the command line tools aren't required but are very handy.

```
sudo apt-get install sqlite3 libsqlite3-dev
```

Install MySQL client, server and development packages.

```
sudo apt-get install mysql-client mysql-server libmysqlclient15-dev
```

Install the PostgeSQL client, server and development packages.

```
sudo apt-get install postgresql postgresql-client postgresql-contrib libpq-dev
```

Run the following command to install RVM

```
bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
```

Source the .bashrc to make put the RVM command(s) in your path

```
source .bashrc
```

Install ruby 1.9.2, this compiles the runtime and then installs it.

```
rvm install 1.9.2
```

Enable the ruby 1.9.2 runtime as the default.

```
rvm use 1.9.2 --default
```

Update your gem command.

```
gem update --system
```

Log into the MySQL command line interface using the password which was set for the root user at installation.

```
mysql -uroot -p
```

Set up a rails user with all permissions on the activerecord test database.

```
GRANT ALL PRIVILEGES ON activerecord_unittest.* to 'rails'@'localhost';
GRANT ALL PRIVILEGES ON activerecord_unittest2.* to 'rails'@'localhost';
```

Create a user with super user privileges in PostgreSQL for the login your currently authenticated under.

```
sudo -u postgres createuser --superuser $USER
```

Navigate to where you store the code your working on and clone the rails repository.

```
cd ~/Code/Ruby
git clone git://github.com/rails/rails.git
cd rails
```

Install the latest version of bundler.

```
gem install bundler
```

Install all dependencies including the MySQL and PostgreSQL drivers.

```
bundle install
```

Run the tests.

```
rake test
```


For more information on this process see [Contributing to Ruby on Rails](http://guides.rubyonrails.org/contributing_to_ruby_on_rails.html).
