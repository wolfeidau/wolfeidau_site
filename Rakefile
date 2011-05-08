desc "Deploy latest code in _site to production"
  task :deploy do
    system(%{
      rsync -axvr --delete _site/ markw@www.wolfe.id.au:/home/markw/public_html
      })
  end
end
