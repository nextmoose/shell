#!/bin/sh

HDIR=$(pwd) &&
    TDIR=$(mktemp -d) &&
    cd ${TDIR} &&
    cleanup ( ) {
	cd ${HDIR}
    } &&
    trap cleanup EXIT &&
    if [ ${#} -gt 0 ]
    then
	SHOW_TRACE=--show-trace
    else
	SHOW_TRACE=
    fi &&
    sed -e "s#/home/runner/work/shell/shell#${HDIR}#" -e "s#/home/runner/resources#${TDIR}/xxx#" -e wflake.nix ${HDIR}/test/flake.nix &&
    nix --extra-experimental-features nix-command --extra-experimental-features flakes develop ${SHOW_TRACE}
