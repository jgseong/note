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

## Install pre-release

```
# Check prerequisite
gem install jekyll --pre

# Install specific version
gem install jekyll -v '2.0.0.alpha.1'

# Install development version
git clone git://github.com/jekyll/jekyll.git
cd jekyll
script/bootstrap
bundle exec rake build
ls pkg/*.gem | head -n 1 | xargs gem install -l
```
