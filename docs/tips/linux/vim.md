# 자동개행문자 삽입 disable
* 명령 모드에서 
```vim
:set binary
:set noeol
```

* "는 .vimrc 파일에서 해당 줄(line)이 주석.
* vimrc 설정(`~/.vimrc`)
```vim
" ~/.vimrc
set binary
set noeol
```

# Change colorschems for vimdiff
* refer to [1]
* vimdiff recommended colorscheme:
    * [apprentice](https://github.com/romainl/Apprentice)
* download the colorscheme(.vim) file, and copy file to `~/.vim/colors/`
```bash
# e.g.
curl -O https://github.com/romainl/Apprentice/releases/download/v1.9/Apprentice-1.9.zip
unzip Apprentice-1.9 && cp colors/apprentice.vim ~/.vim/colors
```
* edit `~/.vimrc`
```vim
" ...
" if vimdiff
if &diff
  colorscheme apprentice
endif
" ...
```

* Simple colorscheme 
```bash
vim ~/.vim/colors/diffcolors.vim
```
```vim
" diffcolors.vim
hi DiffAdd         ctermbg=black       ctermfg=green       cterm=reverse
hi DiffChange      ctermbg=black       ctermfg=magenta     cterm=reverse                       
hi DiffDelete      ctermbg=black       ctermfg=darkred     cterm=reverse                       
hi DiffText        ctermbg=black       ctermfg=red         cterm=reverse         
```

_Reference_

[1] [Astro Coke](https://astrocoke.tistory.com/7)
