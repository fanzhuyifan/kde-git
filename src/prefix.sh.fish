set DIR $(cd $(dirname $(status --current-filename)) && pwd)
set PATH "$DIR:$PATH"
set CHROOT "$DIR/../chroot"
