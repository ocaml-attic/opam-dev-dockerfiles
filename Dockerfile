# OPAM for raspbian-8 with local switch of OCaml 4.03.0
# Autogenerated by OCaml-Dockerfile scripts
FROM ocaml/ocaml:raspbian-8
LABEL distro_style="apt" distro="raspbian" distro_long="raspbian-8" arch="armv7" ocaml_version="4.03.0" opam_version="master" operatingsystem="linux"
RUN apt-get -y update && \
  DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get -y install aspcud && \
  git clone -b master git://github.com/ocaml/opam /tmp/opam && \
  sh -c "cd /tmp/opam && make cold && make install && rm -rf /tmp/opam" && \
  echo 'opam ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/opam && \
  chmod 440 /etc/sudoers.d/opam && \
  chown root:root /etc/sudoers.d/opam && \
  adduser --disabled-password --gecos '' opam && \
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
  sudo -u opam sh -c "cd /home/opam/opam-repository && opam admin upgrade-format && git checkout -b v2 && git add . && git commit -a -m 'opam admin upgrade-format'" && \
  sudo -u opam sh -c "opam init -a -y --comp ocaml-base-compiler.4.03.0 /home/opam/opam-repository" && \
  sudo -u opam sh -c "opam install -y camlp4" && \
  sudo -u opam sh -c "opam install -y depext travis-opam"
ENTRYPOINT [ "opam", "config", "exec", "--" ]
CMD [ "bash" ]