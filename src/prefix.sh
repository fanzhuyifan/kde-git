DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH=$DIR:$PATH
export CHROOT="$DIR/../chroot"
