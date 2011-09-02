#
# Rake file for wolfe.id.au website.
#
# author: Mark Wolfe<mark@wolfe.id.au>
#
# Usage:
#
# rake deploy
#
# rake newpost TITLE="Some new post to rant in"
#
require 'date'


def underscore(sentence)
  sentence.to_s.tr(" ", "-").downcase
end

desc "Deploy latest code in _site to production"
task :deploy do
  system(%{
    rsync -axvr --delete _site/ markw@www.wolfe.id.au:/home/markw/public_html
    })
end

desc "Create a new blog post with the given title"
task :newpost do
  d = Date.today
  puts d.to_s

  title = ENV['TITLE']
  us_title = underscore(title)
  puts us_title

  if title
    if File.exist?("_posts/#{d}-#{us_title}.md")
      puts 'Post already exists'
    else
      File.open("_posts/#{d}-#{us_title}.md", 'w') do |post_file|
        # write the header for the file
        post_file.puts "---"
        post_file.puts "layout: post"
        post_file.puts "title: #{title}"
        post_file.puts "category: "
        post_file.puts "---"
      end

    end 
  else
    puts 'Must pass in a TITLE!'
  end
end
