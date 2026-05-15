ARG IMAGE_SUFFIX=arm64
FROM dev-env:00-ubuntu-base-${IMAGE_SUFFIX}

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update

RUN apt-get install -y --no-install-recommends \
      bash-completion \
      bat \
      build-essential \
      fd-find \
      fzf \
      git \
      iproute2 \
      iputils-ping \
      jq \
      less \
      nano \
      net-tools \
      openssh-client \
      pkg-config \
      procps \
      ripgrep \
      software-properties-common \
      tmux \
      unzip \
      vim \
      xz-utils \
      zip \
      zsh

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git /opt/oh-my-zsh
RUN git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git /opt/oh-my-zsh/custom/plugins/zsh-autosuggestions
RUN git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git /opt/oh-my-zsh/custom/plugins/zsh-syntax-highlighting

COPY config/zshrc /root/.zshrc
COPY config/gitconfig /root/.gitconfig

RUN mkdir -p /workspace

SHELL ["/usr/bin/zsh", "-lc"]
WORKDIR /workspace
