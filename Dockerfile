from	ubuntu:13.10

run	apt-get update
run	apt-get upgrade -y ruby nginx
run	apt-get install -y ruby nginx

run mkdir /srv/www

run mkdir /usr/src/wolfeidau_site
add . /usr/src/wolfeidau_site

run \
  cd /usr/src/wolfeidau_site; \
  cp _conf/nginx.conf /etc/nginx; \
  gem install bundler; \
  bundle install --local; \
  bundle exec jekyll build; \
  cp -R _site /srv/www/wolfe.id.au

cmd nginx

expose 80:80
