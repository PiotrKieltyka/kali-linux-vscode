FROM kalilinux/kali-linux-docker:latest
MAINTAINER PiotrKieltyka <p.kieltyka@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm-256color
RUN apt update
RUN apt install -y curl git python

# zsh
RUN apt install -y zsh && chsh -s $(which zsh)
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k
RUN sed -i -e 's+"robbyrussell"+"powerlevel10k/powerlevel10k"+g' ~/.zshrc

# metasploit framework
RUN apt install -y metasploit-framework

# upgrade and autoremove
RUN apt upgrade -y && apt autoremove -y

# sqlmap
RUN git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev

# Oh-my-git!
RUN git clone https://github.com/arialdomartini/oh-my-git.git ~/.oh-my-git && \
echo source ~/.oh-my-git/prompt.sh >> /etc/profile

# code-server
RUN mkdir -p /opt/code-server && \
curl -Ls https://api.github.com/repos/codercom/code-server/releases/latest | grep "browser_download_url.*linux-x" | cut -d ":" -f 2,3 | tr -d \" | xargs curl -Ls | tar xz -C /opt/code-server --strip 1 && \
echo 'export PATH=/opt/code-server:$PATH' >> /etc/profile

CMD ["/bin/bash", "--init-file", "/etc/profile"]
CMD ["/opt/code-server/code-server", "--auth=none", "--host=0.0.0.0", "--port=8443"]
