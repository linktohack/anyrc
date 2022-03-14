#!/bin/bash -eu

: ${REPO:='https://github.com/amaya382/anyrc'}
: ${VERSION:='0.1.0'}
: ${DIR:='/usr/local/bin'}
[ "$(ls -ld ${DIR} | cut -d' ' -f3)" != "${USER}" ] && SUDO='sudo' || SUDO=''
echo "Installing anyrc commands into ${DIR} ..."
for cmd in dockrc kuberc dockerrunrc dockerexecrc kubectlexecrc; do
  ${SUDO} rm "${DIR}/${cmd}" &> /dev/null # Remove old commands
done
for cmd in anyrc sshrc dockerrc kubectlrc surc; do
  ${SUDO} curl -sSL "${REPO}/raw/${VERSION}/${cmd}" -o "${DIR}/${cmd}"
  ${SUDO} chmod +x "${DIR}/${cmd}"
done

if [ -e "${HOME}/.anyrc" ]; then
  if [ ! -z "${FORCE:+_}" ]; then
    echo "Overriding ${HOME}/.anyrc"
  else
    SKIP_ANYRC=1
    echo "Skipping installing .anyrc (If you want to install default .anyrc, install again w/ FORCE=1)"
  fi
fi

if [ -z "${SKIP_ANYRC:+_}" ]; then
  echo "Installing ${HOME}/.anyrc ..."
  curl -sSL "${REPO}/raw/${VERSION}/example/.anyrc" \
    -o ~/.anyrc
fi
echo "Creating ${HOME}/.anyrc.d ..."
mkdir -p "${HOME}/.anyrc.d"

cat << EOS
anyrc was successfully installed!
Put your dotfiles into ${HOME}/.anyrc.d . Symlinks are allowed.
EOS

