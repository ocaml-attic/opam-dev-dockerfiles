# OPAM for alpine-3.6 with local switch of OCaml 4.04.2
# Autogenerated by OCaml-Dockerfile scripts
FROM ocaml/ocaml:alpine-3.6
LABEL distro_style="apk" distro="alpine" distro_long="alpine-3.6" arch="x86_64" ocaml_version="4.04.2" opam_version="master" operatingsystem="linux"
RUN apk update && apk upgrade && \
  apk add rsync xz && \
  git clone -b master git://github.com/ocaml/opam /tmp/opam && \
  sh -c "cd /tmp/opam && make cold && make prefix=\"/usr\" cold-install && mkdir -p /usr/share/opam && cp shell/wrap-build.sh /usr/share/opam && echo 'wrap-build-commands: \"/usr/share/opam/wrap-build.sh\"' >> /etc/opamrc.userns && cp shell/wrap-install.sh /usr/share/opam && echo 'wrap-install-commands: \"/usr/share/opam/wrap-install.sh\"' >> /etc/opamrc.userns && cp shell/wrap-remove.sh /usr/share/opam && echo 'wrap-remove-commands: \"/usr/share/opam/wrap-remove.sh\"' >> /etc/opamrc.userns && rm -rf /tmp/opam" && \
  apk update && apk upgrade && \
  apk add aspcud && \
  adduser -S opam && \
  echo 'opam ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/opam && \
  chmod 440 /etc/sudoers.d/opam && \
  chown root:root /etc/sudoers.d/opam && \
  sed -i.bak 's/^Defaults.*requiretty//g' /etc/sudoers
USER opam
WORKDIR /home/opam
RUN mkdir .ssh && \
  chmod 700 .ssh && \
  git config --global user.email "docker@example.com" && \
  git config --global user.name "Docker CI" && \
  sudo -u opam sh -c "git clone -b master git://github.com/ocaml/opam-repository" && \
  sudo -u opam sh -c "cd /home/opam/opam-repository && opam admin upgrade && git checkout -b v2 && git add . && git commit -a -m 'opam admin upgrade'" && \
  sudo -u opam sh -c "opam init -a -y --comp ocaml-base-compiler.4.04.2 /home/opam/opam-repository" && \
  sudo -u opam sh -c "opam install -y depext travis-opam"
ENTRYPOINT [ "opam", "config", "exec", "--" ]
CMD [ "sh" ]