# About tmux?
tmux(terminal multiplexer)는 많은 pseudoterminal을 window와 session 단위로 관리하는 도구
하나의 tmux 서버가 세션을 관리하고, tmux 클라이언트는 tmux 서버와 소켓으로 통신하며
그 세션의 pseudoterminal들을 사용자가 원하는 방식대로 보여준다고 한다. 

# Install tmux (by APT)
```sh
sudo add-apt-repository -y ppa:hnakamur/tmux 
sudo apt update
sudo apt install tmux
```

# Install tmux (from source)
```sh
#!/bin/bash
sudo apt update
# install packages need to build
sudo pat install -y git automake build-essential pkg-config libevent-dev libncurses5-dev

[ -d /tmp/tmux ] && rm -rf /tmp/tmux
git clone https://github.com/tmux/tmux.git /tmp/tmux 

cd /tmp/tmux && \
git checkout master && \
./autogen.sh && \
./configure && \ 
make && \
sudo make install && \
cd - && \
rm -rf /tmp/tmux
```

# Components

* session : tmux 실행단위, windows로 구성
* window : terminal 내 화면 단위(tab)
* pane : window 내 분할된 화면 단위
* status bar : 상태 bar

# Commands Shortcuts
```bash
Ctrl+b, <key>   # ^b

# Help
Ctrl+b, ?       # ^b ?

# Command mode
Ctrl+b, :
```

# Session

* New session
  * `tmux new -s 'session name' in shell
  * `^b n`

* Edit session name
  * `^b $`

* Detach session
  * `^b d` in tmux

* Attach session
  * `tmux attach -t 'session-number' # or 'session name'`

* List sessions
  * `tmux ls`

# Window

* New window
  * `^b c`

* New Sesseion with window
```
tmux new -s 'session name' -n 'window name'
```

* Edit Window name
  * `^b ,`

* Terminate Window
  * `^b &`
  * `^d` in pane

* Move to window space
  * `^b <number>` 
  * `^b n` : next window
  * `^b p` : previous window
  * `^b l` : last window
  * `^b w` : window selector
  * `^b f` : find by name 

# Pane

* Divide pane
  * `^b %` : vertical
  * `^b "` : horizontal

* Move to pane space
  * `^b q<number>
  * `^b o` : 순서대로
  * `^b <arrow> : 방향키로 선택

* Delete pane
  * `^b x`
  * `^d` in pane

* Adjust size fo pane
  * `^b :` resize-pane
  * `-[L|R|D|U] 'size'`

* Modify Layout
  * `^b <space>`


_Reference_

1. [tmux 입문자 시리즈 요약](https://edykim.com/ko/post/tmux-introductory-series-summary/)
2. [개발새발로그](https://dgkim5360.tistory.com/entry/the-first-steps-for-tmux-terminal-multiplexer)
