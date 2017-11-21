# OPAM for oraclelinux-7 with local switch of OCaml 4.03.0+flambda
# Autogenerated by OCaml-Dockerfile scripts
FROM ocaml/ocaml:oraclelinux-7
LABEL distro_style="yum" distro="oraclelinux" distro_long="oraclelinux-7" arch="x86_64" ocaml_version="4.03.0+flambda" opam_version="master" operatingsystem="linux"
RUN rpm --rebuilddb && yum install -y sudo passwd bzip2 gcc-c++ patch nano git which tar wget xz openssl && yum clean all && \
  rpm --rebuilddb && yum groupinstall -y "Development Tools" && yum clean all && \
  git clone -b master git://github.com/ocaml/opam /tmp/opam && \
  sh -c "cd /tmp/opam && make cold && make prefix=\"/usr\" cold-install && mkdir -p /usr/share/opam && cp shell/wrap-build.sh /usr/share/opam && echo 'wrap-build-commands: \"/usr/share/opam/wrap-build.sh\"' >> /etc/opamrc.userns && cp shell/wrap-install.sh /usr/share/opam && echo 'wrap-install-commands: \"/usr/share/opam/wrap-install.sh\"' >> /etc/opamrc.userns && cp shell/wrap-remove.sh /usr/share/opam && echo 'wrap-remove-commands: \"/usr/share/opam/wrap-remove.sh\"' >> /etc/opamrc.userns && rm -rf /tmp/opam" && \
  curl -o /usr/bin/aspcud 'https://raw.githubusercontent.com/avsm/opam-solver-proxy/38133c7f82bae3f1aa9f7505901f26d9fb0ed1ee/aspcud.docker' && \
  chmod 755 /usr/bin/aspcud && \
  sed -i.bak '/LC_TIME LC_ALL LANGUAGE/aDefaults    env_keep += "OPAMYES OPAMJOBS OPAMVERBOSE"' /etc/sudoers && \
  echo 'opam ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/opam && \
  chmod 440 /etc/sudoers.d/opam && \
  chown root:root /etc/sudoers.d/opam && \
  sed -i.bak 's/^Defaults.*requiretty//g' /etc/sudoers && \
  useradd -d /home/opam -m -s /bin/bash opam && \
  passwd -l opam && \
  chown -R opam:opam /home/opam
USER opam
ENV HOME /home/opam
WORKDIR /home/opam
RUN mkdir .ssh && \
  chmod 700 .ssh && \
  git config --global user.email "docker@example.com" && \
  git config --global user.name "Docker CI" && \
  sudo -u opam sh -c "git clone -b master git://github.com/ocaml/opam-repository" && \
  sudo -u opam sh -c "cd /home/opam/opam-repository && opam admin upgrade && git checkout -b v2 && git add . && git commit -a -m 'opam admin upgrade'" && \
  sudo -u opam sh -c "opam init -a -y --comp ocaml-variants.4.03.0+flambda /home/opam/opam-repository" && \
  sudo -u opam sh -c "opam install -y depext travis-opam"
ENTRYPOINT [ "opam", "config", "exec", "--" ]
CMD [ "bash" ]