FROM ubuntu:18.04
#
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get update 
RUN apt-get install -y --no-install-recommends build-essential libgtk2.0-dev wget curl openssh-server git zsh gdb software-properties-common

RUN mkdir /var/run/sshd
RUN echo 'root:password' | chpasswd
RUN sed -ri 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^UsePAM yes/UsePAM no/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN /usr/sbin/sshd -D &

RUN mkdir ~/.ssh && echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDrZ3hVcgA/m7ZtlSQRjkJV8dbI+mvhgs3bYApevmkjkDqNn2/Y0UvZ71byCsLSUlSqUq/2terQm9IG7iXsfR30OQC0N6fyYhcxGW8fmwdkw0ZjEcqUXQL2Vv/oyJzkDyltiP5IrcAEQ0vtzLm4sKSqMo9Bxn+HIZbMVZcCm6AVamICkErOnOdHJKis2REbiO2/Qqe5nhs9mYDMF28STECuLCFYBGujw6EYrwDsLQTQlJzZ43zqJ64z/+jlnWBxU8xBkxM1AdpUr5Og0e6vvAoGSLp4B+rwlzEucg5KHrmJbJ+b3tcxaKCueSoYBWjD1UWoMT5vDp/2vp33B7FxruNj ms-pc\zhengqihang@DESKTOP-FIFNVG6" >> ~/.ssh/authorized_keys

WORKDIR /root
# change default shell to zsh
SHELL ["/bin/zsh", "-c"]

# use conda
# RUN wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py37_4.9.2-Linux-x86_64.sh 
# RUN zsh Miniconda3-py37_4.9.2-Linux-x86_64.sh -b
# ENV PATH /root/miniconda3/bin:$PATH
# RUN conda init zsh
# RUN pip config set global.index-url https://mirrors.sjtug.sjtu.edu.cn/pypi/web/simple
# RUN conda config --add channels https://mirrors.sjtug.sjtu.edu.cn/anaconda/pkgs/free
# RUN conda config --add channels https://mirrors.sjtug.sjtu.edu.cn/anaconda/pkgs/main
# RUN conda config --add channels https://mirrors.sjtug.sjtu.edu.cn/anaconda/pkgs/mro
# RUN conda config --add channels https://mirrors.sjtug.sjtu.edu.cn/anaconda/pkgs/msys2
# RUN conda config --set custom_channels.conda-forge https://mirrors.sjtug.sjtu.edu.cn/anaconda/cloud/
# RUN conda config --set custom_channels.pytorch https://mirrors.sjtug.sjtu.edu.cn/anaconda/cloud/

# use global python
RUN apt-get update && apt-get install -y --no-install-recommends python3 python3-pip
RUN pip3 install -U pip -i https://mirrors.sjtug.sjtu.edu.cn/pypi/web/simple
RUN pip3 config set global.index-url https://mirrors.sjtug.sjtu.edu.cn/pypi/web/simple



# install cmake
RUN wget https://gitee.com/brightxiaohan/CMake/attach_files/615214/download/cmake-3.18.4-Linux-x86_64.tar.gz
RUN tar -zxvf cmake-3.18.4-Linux-x86_64.tar.gz
ENV PATH /root/cmake-3.18.4-Linux-x86_64/bin:$PATH

# install clash

# wget -q --no-check-certificate -O /tmp/install.sh https://cdn.jsdelivr.net/gh/juewuy/ShellClash@master/install.sh  && sh /tmp/install.sh && source /etc/profile &> /dev/null
# alias clash = "/root/.local/share/clash/clash.sh"
# export clashdir = "/root/.local/share/clash"
# export host_ip=$(cat /etc/resolv.conf |grep "nameserver" |cut -f 2 -d " ")
# alias proxy="export all_proxy=http://$host_ip:7890 http_proxy=http://$host_ip:7890 https_proxy=https://$host_ip:7890"
# alias proxy="export all_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 https_proxy=http://127.0.0.1:7890"
# git config --global http.proxy 'socks5://127.0.0.1:7890'
# git config --global https.proxy 'socks5://127.0.0.1:7890'
# alias unproxy='unset all_proxy http_proxy https_proxy'
# proxy

# install gcc 10

# add-apt-repository -y ppa:ubuntu-toolchain-r/test
# apt-get install gcc-10 g++-10
# update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 40
# update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 40 



# install omzsh or others

# method 1 : zsh in docker

# sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -- \
#     -t https://github.com/denysdovhan/spaceship-prompt \
#     -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
#     -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
#     -p git \
#     -p ssh-agent \
#     -p https://github.com/zsh-users/zsh-autosuggestions \
#     -p https://github.com/zsh-users/zsh-completions \
#     -p https://github.com/zsh-users/zsh-syntax-highlighting

# method 2 : manual

# sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone --depth=1 https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
# git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
