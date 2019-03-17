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

## Crate new jekyll site
```sh
# mkdir jekyllSite
# cd jekyllSite
jekyll new .    # OR jekyll new <path>
```

## Install plugin
```sh
# install paginate
gem install jekyll-paginate
```

## Service jekyll site
```sh
# service from localhost
# -H [Host] : Host bind to 
# jekyll serve : localhost service
jekyll serve -H 0.0.0.0
```
* Example output
```sh
root@pretest:~/jekyllTutorial# jekyll serve -H 0.0.0.0
Configuration file: /root/jekyllTutorial/_config.yml
            Source: /root/jekyllTutorial
       Destination: /root/jekyllTutorial/_site
 Incremental build: disabled. Enable with --incremental
      Generating...
       Jekyll Feed: Generating feed for posts
                    done in 0.35 seconds.
 Auto-regeneration: enabled for '/root/jekyllTutorial'
    Server address: http://0.0.0.0:4000/
  Server running... press ctrl-c to stop.
```
