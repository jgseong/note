# Jekyll

* refer to [Jekyll Official - Installation](https://jekyllrb-ko.github.io/docs/installation/)

## Install on Ubuntu 16
```sh
# Install ruby
sudo apt-get install ruby ruby-dev build-essential

# Set up environments
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME=$HOME/gems' >> ~/.bashrc
echo 'export PATH=$HOME/gems/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Install jekyll
gem install jekyll bundler
```

## Check/Update jekyll vertion
```sh
# Check version
jekyll --version
gem list jekyll

# Update jekyll
bundle update jekyll

# Update without bundle
gem update jekyll

# Update Rubygems
gem update --system
```
