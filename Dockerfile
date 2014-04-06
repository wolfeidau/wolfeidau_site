from	ubuntu:13.10

run	apt-get update
run	apt-get upgrade -y
run	apt-get install -y ruby nginx
run	apt-get install -y build-essential ruby-dev python-pygments

run mkdir /srv/www

run mkdir /usr/src/wolfeidau_site
add . /usr/src/wolfeidau_site

run gem install bundler
run cp /usr/src/wolfeidau_site/_conf/nginx.conf /etc/nginx

env LANG C.UTF-8
env LC_ALL C.UTF-8

run cd /usr/src/wolfeidau_site && \
    bundle install --path vendor/bundle --binstubs && \
    bundle exec jekyll build && \
    cp -R /usr/src/wolfeidau_site/_site /srv/www/wolfe.id.au

cmd nginx
