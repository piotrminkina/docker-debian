#!/bin/sh
set -e


declare do_prepare
declare do_drop
declare do_exec
declare do_clean


docker_prepare() {
    docker build --pull -t docker-debian .
}

docker_drop() {
    set +e
    docker rm -f docker-debian
    set -e
}

docker_exec() {
    docker run \
        --name docker-debian \
        --privileged \
        --rm \
        -t \
        --entrypoint=/usr/bin/make \
        -v $(readlink -f $0|xargs dirname):/usr/src/docker-debian \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -w /usr/src/docker-debian \
        docker-debian \
        "$@"
}

docker_clean() {
    docker rmi -f docker-debian
}

usage() {
    echo "Usage: $0 [-p] [-d] [-e] [-c] [argument] [...]" 1>&2
    exit 1
}


while getopts "pdec" FLAG; do
    case ${FLAG} in
        p) do_prepare=1 ;;
        d) do_drop=1 ;;
        e) do_exec=1 ;;
        c) do_clean=1 ;;
    esac
done
shift $((OPTIND-1))


if [ -z "${do_prepare}${do_drop}${do_exec}${do_clean}" ]; then
    echo "Nothing to do..." 1>&2
    usage
else
    [ -n "${do_prepare}" ] && docker_prepare
    [ -n "${do_drop}" ] && docker_drop
    [ -n "${do_exec}" ] && docker_exec "$@"
    [ -n "${do_clean}" ] && docker_clean
fi
