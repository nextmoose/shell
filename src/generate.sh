#!/bin/sh

while [ ${ _utils.bash-variable "#" } -gt 0 ]
do
    case ${ _utils.bash-variable "1" } in
        --resource-directory)
            RESOURCE_DIRECTORY=${ _utils.bash-variable "2" } ;
            shift 2 &&
                break
            ;;
        --hook)
            HOOK=${ _utils.bash-variable "2" } &&
                shift 2 &&
                break
            ;;
        --inputs)
            INPUTS=${ _utils.bash-variable "2" } &&
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
    SCRIPT_DIRECTORY=$( ${ pkgs.mktemp }/bin/mktemp --directory ) &&
    cd ${ _utils.bash-variable "SCRIPT_DIRECTORY" } &&
    ${ pkgs.nix }/bin/nix flake init &&
    ${ pkgs.coreutils }/bin/cp ./src/flake.nix flake.nix &&
    ${ pkgs.coreutils }/bin/echo "${ _utils.bash-variable "hook" }" > hook.nix &&
    ${ pkgs.coreutils }/bin/echo "${ _utils.bash-variable "inputs" }" > inputs.nix &&
    ${ pkgs.coreutils }/bin/echo "${ _utils.bash-variable "inputs" }" > scripts.nix &&
    ${ pkgs.coreutils }/bin/chmode 0400 flake.nix hook.nix inputs.txt scripts.tex
