+++
date = "2011-03-06T00:00:00+11:00"
draft = false
title = "Moving to Jekyll and Disqus"
categories = [ "HTML", "Jekyll", "Disqus" ]

+++

First post from my newly migrated blog reviewing migration from wordpress to Jekyll and Disqus.

* [Jekyll](http://github.com/mojombo/jekyll) for site generation.
* [Sass](http://sass-lang.com/) for simplified css goodness.
* [Pygments](http://pygments.org/) code highlighting.
* [Disqus](http://disqus.com/)

Following some of the sites which use Jekyll, I generated the skeleton and began building my site using Jekyll. After trialing some of the code highlighting options I selected pygments, this was to ensure my code samples looked good. 


Once the base was configured and working I moved on to add a plugin to utilise Sass in my website. Below is source to my _\_plugins/sass\_converter.rb_, this converts any scss (CSS like sass syntax) files to css.

{{< highlight ruby >}}
module Jekyll
  # Sass plugin to convert .scss to .css
  # 
  # Note: This is configured to use the new css like syntax available in sass.
  require 'sass'
  class SassConverter < Converter
    safe true
    priority :low

     def matches(ext)
      ext =~ /scss/i
    end

    def output_ext(ext)
      ".css"
    end

    def convert(content)
      begin
        puts "Performing Sass Conversion."
        engine = Sass::Engine.new(content, :syntax => :scss)
        engine.render
      rescue StandardError => e
        puts "!!! SASS Error: " + e.message
      end
    end
  end
end
{{< /highlight >}}

