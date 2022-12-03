#!/bin/sh

while [ "${#}" -gt 0 ]
do
    case "${1}" in
        --resource-directory)
            RESOURCE_DIRECTORY="${2}" ;
            shift 2 &&
                break
            ;;
        --hook)
            HOOK="${2}" &&
                shift 2 &&
                break
            ;;
        --inputs)
            INPUTS="${2}" &&
                shift 2 &&
                break
            ;;
        *)
            ${ pkgs.coreutils }/bin/echo UNEXPECTED &&
                exit 64 &&
                break
            ;;
    esac
done &&
    SCRIPT_DIRECTORY=$( ${MKTEMP}/bin/mktemp --directory ) &&
    cd ${SCRIPT_DIRECTORY} &&
    ${NIX}/bin/nix flake init &&
    ${COREUTILS}/bin/cp ${SHELL_HOME}/flake.nix flake.nix &&
    ${COREUTILS}/bin/echo "${ _utils.bash-variable "hook" }" > hook.nix &&
    ${COREUTILS}/bin/echo "${ _utils.bash-variable "inputs" }" > inputs.nix &&
    ${COREUTILS}/bin/echo "${ _utils.bash-variable "inputs" }" > scripts.nix &&
    ${COREUTILS}/bin/chmod 0400 flake.nix hook.nix inputs.txt scripts.tex
