# OPAM for opensuse-42.2 with local switch of OCaml 4.04.0+flambda
# Autogenerated by OCaml-Dockerfile scripts
FROM ocaml/ocaml:opensuse-42.2
LABEL distro_style="zypper" distro="opensuse" distro_long="opensuse-42.2" arch="x86_64" ocaml_version="4.04.0+flambda" opam_version="master" operatingsystem="linux"
RUN git clone -b master git://github.com/ocaml/opam /tmp/opam && \
  sh -c "cd /tmp/opam && make cold && make prefix=\"/usr\" install && echo Not installing OPAM2 wrappers && rm -rf /tmp/opam" && \
  curl -o /usr/bin/aspcud 'https://raw.githubusercontent.com/avsm/opam-solver-proxy/38133c7f82bae3f1aa9f7505901f26d9fb0ed1ee/aspcud.docker' && \
  chmod 755 /usr/bin/aspcud && \
  useradd  -d /home/opam -m opam && \
  echo 'opam ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/opam && \
  chmod 440 /etc/sudoers.d/opam && \
  chown root:root /etc/sudoers.d/opam
USER opam
WORKDIR /home/opam
RUN mkdir .ssh && \
  chmod 700 .ssh && \
  git config --global user.email "docker@example.com" && \
  git config --global user.name "Docker CI" && \
  sudo -u opam sh -c "git clone -b master git://github.com/ocaml/opam-repository" && \
  sudo -u opam sh -c "cd /home/opam/opam-repository && opam admin upgrade && git checkout -b v2 && git add . && git commit -a -m 'opam admin upgrade'" && \
  sudo -u opam sh -c "opam init -a -y --comp ocaml-variants.4.04.0+flambda /home/opam/opam-repository" && \
  sudo -u opam sh -c "opam install -y depext travis-opam"
ENTRYPOINT [ "opam", "config", "exec", "--" ]
CMD [ "sh" ]