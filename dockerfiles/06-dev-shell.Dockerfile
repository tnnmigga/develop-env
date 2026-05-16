ARG IMAGE_SUFFIX=arm64
FROM dev-env:extra-tools-${IMAGE_SUFFIX}

RUN git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git /opt/oh-my-zsh \
    && git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git /opt/oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git /opt/oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    && rm -rf \
      /opt/oh-my-zsh/.git \
      /opt/oh-my-zsh/custom/plugins/zsh-autosuggestions/.git \
      /opt/oh-my-zsh/custom/plugins/zsh-syntax-highlighting/.git \
    && find /tmp /var/tmp -mindepth 1 -maxdepth 1 -exec rm -rf {} +

COPY config/zshrc /root/.zshrc
COPY config/gitconfig /root/.gitconfig

# Ensure LF line endings (in case source files have CRLF from Windows)
RUN sed -i 's/\r$//' /root/.zshrc /root/.gitconfig

RUN echo '[ -f ~/.zshrc ] && source ~/.zshrc' >> /root/.profile \
    && echo 'export SHELL=/usr/bin/zsh' >> /root/.profile

RUN mkdir -p /workspace

RUN rm -rf /root/.cache

SHELL ["/usr/bin/zsh", "-lc"]
WORKDIR /workspace
