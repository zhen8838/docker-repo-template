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

RUN mkdir ~/.ssh 
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDrZ3hVcgA/m7ZtlSQRjkJV8dbI+mvhgs3bYApevmkjkDqNn2/Y0UvZ71byCsLSUlSqUq/2terQm9IG7iXsfR30OQC0N6fyYhcxGW8fmwdkw0ZjEcqUXQL2Vv/oyJzkDyltiP5IrcAEQ0vtzLm4sKSqMo9Bxn+HIZbMVZcCm6AVamICkErOnOdHJKis2REbiO2/Qqe5nhs9mYDMF28STECuLCFYBGujw6EYrwDsLQTQlJzZ43zqJ64z/+jlnWBxU8xBkxM1AdpUr5Og0e6vvAoGSLp4B+rwlzEucg5KHrmJbJ+b3tcxaKCueSoYBWjD1UWoMT5vDp/2vp33B7FxruNj ms-pc\zhengqihang@DESKTOP-FIFNVG6" >> ~/.ssh/authorized_keys
RUN echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6idyUnwOlXFGwAiDnpbHuyWExRkLPbVv+3P+69BB9Rnxi+++yt2WrbKBiO9k7YO1vU5Icmmh8vejI5vhk3waZq/ebGAzHdKU0Z6tIsmsnLh2JGLdVyKmEqXeUWy/096wD4UTvoiQNbnB+VKpXfJJRoaLOxh/zMcy+Nwnfjr9LaHAwh6/ZI5uN9QCKlIOhxZkUNkc3iNZJ3U3vnfu+fywikdjjKuetvr2FHHv6+e4KevmF/IL2+wqOW3fNFtGDkIZiN34U4vRO2pBmuCt9ghBgF13RYGLcqmQPse4lMnylSS4QPR9Ct49o3/KJJrgTcvopEpuQ+HEnnsWJ7Bvx8L0Pj0ASSFjadztcKB8BtCYIXDmCww7dWlPZfFd/83JSvHZGyP3QGMSm0f/kXEgLO6jLVQhR4GmVV9A0qpdQursGE6aDZboP1R5RqnWLMiiozRQeC571bJ7PvFLlS7rcaHSh8nv2P2BCoc0rxnNYJYyE4LWJtAnptu67gMcobfMGDsU= lisa@bogon" >> ~/.ssh/authorized_keys

WORKDIR /root
# change default shell to zsh
SHELL ["/bin/zsh", "-c"]

# install omzsh or others

# RUN git config --global --unset http.proxy
# RUN git config --global --unset https.proxy
# CMD [ "sh" "-c" "$(curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh)"]

ENV REMOTE=https://gitee.com/mirrors/oh-my-zsh.git
RUN wget https://hub.fastgit.org/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

RUN git clone --depth=1 https://hub.fastgit.org/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone --depth=1 https://hub.fastgit.org/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
RUN git clone --depth=1 https://hub.fastgit.org/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone --depth=1 https://hub.fastgit.org/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
RUN sed -ri 's@ZSH_THEME=\"robbyrussell\"@ZSH_THEME=\"powerlevel10k/powerlevel10k\"@' /root/.zshrc
RUN sed -ri 's/plugins=\(git\)/plugins=\(git zsh-syntax-highlighting zsh-autosuggestions zsh-completions\)/' /root/.zshrc

# use conda
RUN wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py37_4.9.2-Linux-x86_64.sh 
RUN zsh Miniconda3-py37_4.9.2-Linux-x86_64.sh -b
ENV PATH /root/miniconda3/bin:$PATH
RUN echo 'PATH="/root/miniconda3/bin:$PATH"' >> /root/.zshrc
RUN conda init zsh
RUN pip config set global.index-url https://mirrors.sjtug.sjtu.edu.cn/pypi/web/simple
RUN conda config --add channels https://mirrors.sjtug.sjtu.edu.cn/anaconda/pkgs/free
RUN conda config --add channels https://mirrors.sjtug.sjtu.edu.cn/anaconda/pkgs/main
RUN conda config --add channels https://mirrors.sjtug.sjtu.edu.cn/anaconda/pkgs/mro
RUN conda config --add channels https://mirrors.sjtug.sjtu.edu.cn/anaconda/pkgs/msys2
RUN conda config --set custom_channels.conda-forge https://mirrors.sjtug.sjtu.edu.cn/anaconda/cloud/
RUN conda config --set custom_channels.pytorch https://mirrors.sjtug.sjtu.edu.cn/anaconda/cloud/
RUN pip install -U pip -i https://mirrors.sjtug.sjtu.edu.cn/pypi/web/simple
RUN pip config set global.index-url https://mirrors.sjtug.sjtu.edu.cn/pypi/web/simple

# # install cmake

# install nncase deps
RUN pip install cmake pytest conan tensorflow==2.4.1 matplotlib pillow onnxruntime trash-cli

# install gcc 10
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN sed -i 's/http:\/\/ppa.launchpad.net/https:\/\/launchpad.proxy.ustclug.org/g' /etc/apt/sources.list /etc/apt/sources.list.d/*.list
RUN apt-get update && apt-get install -y --no-install-recommends gcc-10 g++-10
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 40
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 40 

# set zsh and sshd
RUN chsh -s /bin/zsh
RUN echo "export VISIBLE=now" >> /etc/profile
CMD ["/usr/sbin/sshd", "-D"]