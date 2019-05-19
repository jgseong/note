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

## Create new site with basic theme(minima)
```sh
# 현재 위치의 contents로 ./_site에 사이트 생성.
jekyll build
```
* with options
```sh
# source/destination 지정
jekyll build --destination <destination>
jekyll build --source <source> --destination <destination>

# run `jekyll build` with auto re-generation 
# when detect to modify any contents.
jekyll build --watch
```

## To change the default configurations for developing environments.
* Default service URL : `http://localhost:4000`
* To change the URL, edit `url:` in '_config.yml', then `JEKYLL_ENV=production bundle exec jekyll build`
* When re-build with auto-regeneration(with --watch), not update the `_config.yml`.
> 주 환경설정 파일인 _config.yml 에는 전역 환경설정과 변수들이 정의되어 있으며, 실행 시점에 한 번만 읽어들입니다. 자동 재생성을 사용하는 중이라도, 완전히 새로 실행하기 전까지는  _config.yml 의 변경사항을 읽어들이지 않습니다. 자동 재생성 과정에서 데이터 파일은 다시 읽어들입니다.

> Site Destination 폴더는 사이트 빌드 시 초기화됩니다. 사이트 빌드 시에 자동으로 <destination> 안의 파일들을 지우는 것이 디폴트로 설정되어 있습니다. 사이트에서 생성하지 않는 파일들은 모두 사라질 것입니다. 환경설정 옵션 <keep_files> 를 사용해 <destination> 에 그대로 옮길 파일이나 폴더를 지정할 수 있습니다. 중요한 디렉토리는 절대 <destination> 으로 지정하면 안됩니다; 웹 서버로 옮기기 전에 임시로 파일들을 보관할 경로를 입력하세요.
  
## Service the jekyll on localhost
```sh
# 개발 서버 실행, http://localhost:4000
jekyll serve 
  # default is with --watch
  # default로 자동 재생성(`with --watch`) 활성화
  
jekyll serve --no-watch 
  # 변경사항을 감시하지 않음

# 변경사항 발생 시, LiveReload 기능으로 브라우저를 새로고침
jekyll serve --livereload

# 재생성 소요 시간을 줄이기 위해 증분 재생성 기능으로 부분 빌드를 수행
jekyll serve --incremental 

# run under background
jekyll serve --detach
```
* other options
```
-H <address> : specify listen address
```
* `_config.yml`에서 설정 가능. 환경설정[https://jekyllrb-ko.github.io/docs/configuration/]

## Directory structure
* [Official docs for structure](https://jekyllrb-ko.github.io/docs/structure/)
* Concept
```
# markdown, textile, html 등, markup 언어로 작성된 문서들을 하나 또는 여러 겹의 layout으로 포장.
# URL 구성 방식, 레이아웃에 표시할 데이터, 변환 과정에 포함된 다양한 동작들을 조정.
# 정적 웹사이트 생성이 텍스트 수정으로 가능.
```

## Configurations
* [Official docs for configuration](https://jekyllrb-ko.github.io/docs/configuration/)

## Help
```
jekyll help
             new
             build
             serve
             ...
jekyll docs  # required to install jekyll-docs
```
