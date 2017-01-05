# OPAM for alpine-armhf-3.4 with local switch of OCaml 4.03.0
# Autogenerated by OCaml-Dockerfile scripts
FROM ocaml/ocaml:alpine-armhf-3.4
LABEL distro_style="apk" distro="alpine-armhf" distro_long="alpine-armhf-3.4" arch="armv7" ocaml_version="4.03.0" opam_version="master" operatingsystem="linux"
RUN apk update && apk upgrade && \
  apk add rsync xz && \
  git clone -b master git://github.com/ocaml/opam /tmp/opam && \
  sh -c "cd /tmp/opam && make cold && make prefix=\"/usr\" install && rm -rf /tmp/opam" && \
  curl -o /usr/bin/aspcud 'https://raw.githubusercontent.com/avsm/opam-solver-proxy/8f162de1fe89b2e243d89961f376c80fde6de76d/aspcud.docker' && \
  chmod 755 /usr/bin/aspcud && \
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
  sudo -u opam sh -c "cd /home/opam/opam-repository && opam admin upgrade-format && git checkout -b v2 && git add . && git commit -a -m 'opam admin upgrade-format'" && \
  sudo -u opam sh -c "opam init -a -y --comp ocaml-base-compiler.4.03.0 /home/opam/opam-repository" && \
  sudo -u opam sh -c "opam install -y depext travis-opam"
ENTRYPOINT [ "opam", "config", "exec", "--" ]
CMD [ "sh" ]