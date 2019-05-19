# Jekyll - Simply summary

## Install
```sh
# Install ruby
sudo apt install ruby ruby-dev build-essential

# Set up environments
echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME=$HOME/gems' >> ~/.bashrc
echo 'export PATH=$HOME/gems/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Install jekyll
gem install jekyll bundler

# Check version
ruby -v
gem -v
```

## Create new site with basic theme(minia)
```sh
# 현재 위체에서 content로 ./_site에 사이트 생성.
jekyll build
```
* with options
```sh
# specific source/destination.
jekyll build --destination <destination>
jekyll build --source <source> --destination <destination>

# run `jekyll build` with auto re-building 
# when detect to modify any contents.
jekyll build --watch
```
