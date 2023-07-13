#!/usr/bin/env bash

# Application version.
version=1.0.0

# Termux directory.
termux=/data/data/com.termux/files

# Installation directory.
install=/data/data/com.termux/files/linux

# Termux architecture.
architect=$(dpkg --print-architecture)

# Available distros.
distros=(
    "alpine"
    "arch"
    "debian"
    "fedora"
    "kali"
    "manjaro"
    "parrot"
    "ubuntu"
    "void"
)

# Readline, get input from user.
# readline [prefix] [label] [default]
function readline()
{
    if [[ $1 != "" ]]; then
        if [[ $2 != "" ]]; then
            if [[ $3 != "" ]]; then
                echo -e "stdin<$1<$2[=$3]>>\x20\c"
            else
                echo -e "stdin<$1<$2>>\x20\c"
            fi
            read readlineInput
            if [[ $readlineInput == "" ]]; then
                eval "input${2^}=$3"
            else
                eval "input${2^}=$readlineInput"
            fi
        else
            echo -e "stdin<$1>\x20\c"
            read input
        fi
    else
        echo -e "stdin<·>\x20\c"
        read input
    fi
}

# Handle readlind input Action.
# readInputAction [distro] [action] [version]
function readInputAction()
{
    # Handle readline input selection mode.
    # readInputSelect [distro]
    function readInputSelect()
    {
        # Handle readline input dekstop environment.
        # readInputDekstopEnv [distro]
        function readInputDekstopEnv()
        {
            while [[ $inputDekstop == "" ]]; do
                readline $1 "dekstop" "XFCE"
                inputDekstop=${inputDekstop^^}
                case $inputDekstop in
                    1|XFCE) inputDekstop=XFCE ;;
                    2|LXQT) inputDekstop=LXQT ;;
                    3|LXDE) inputDekstop=LXDE ;;
                    *)
                        inputDekstop=
                    ;;
                esac
            done
        }
        
        # Handle readline input window manager.
        # readInputWindowManager [distro]
        function readInputWindowManager()
        {
            while [[ $inputWindow == "" ]]; do
                readline $1 "window" "Awesome"
                inputWindow=${inputWindow,,}
                case $inputWindow in
                    1|awesome) inputWindow=Awesome ;;
                    2|openbox) inputWindow=Openbox ;;
                    3|i3) inputWindow=i3 ;;
                    *)
                        inputDekstop=
                    ;;
                esac
            done
        }
        
        while [[ $inputSelect == "" ]]; do
            readline $1 "select" "cli"
            inputSelect=${inputSelect,,}
            case $inputSelect in
                1|cli) ;;
                2|window)
                    readInputWindowManager $1 $3
                    window=$inputWindow
                ;;
                3|dekstop)
                    readInputDekstopEnv $1 $3
                    dekstop=$inputDekstop
                ;;
                *) inputSelect= ;;
            esac
            select=$inputSelect
        done
    }
    
    # Handle readline input version.
    # readInputVersion [distro] [default]
    function readInputVersion()
    {
        if [[ ${1,,} == "ubuntu" ]]; then
            while [[ $inputVersion == "" ]]; do
                readline $1 "version" $2
                case $inputVersion in
                    1|22|22.04) inputVersion=22.04 ;;
                    2|20|20.04) inputVersion=20.04 ;;
                    3|18|18.04) inputVersion=18.04 ;;
                    *)
                        inputVersion=
                        continue
                    ;;
                esac
                version=$inputVersion
            done
        fi
    }
    
    while [[ $inputAction == "" ]]; do
        readline $1 "action" $2
        case ${inputAction,,} in
            1|install) action=install ;;
            2|import) action=import ;;
            3|remove) action=remove ;;
            4|cancel) action=cancel ;;
            *)
                inputAction=
                continue
            ;;
        esac
    done
    
    # If action is not cancel.
    if [[ $action != "cancel" ]]; then
        if [[ ${1,,} == "ubuntu" ]]; then
            readInputVersion $1 $3
            version=$inputVersion
        fi
        if [[ $action == "import" ]]; then
            readInputImport
            import=$inputImport
        else
            readInputSelect $1
            select=$inputSelect
        fi
        if [[ $select == "window" ]]; then
            window=$inputWindow
        elif [[ $select == "dekstop" ]]; then
            dekstop=$inputDekstop
        fi
    fi
}

# Handle Ubuntu Installation.
function ubuntu()
{
    # Default Ubuntu Mode for install.
    local select=cli
    
    # Default Import is always empty.
    # Because we don't know where source destination.
    local import=
    
    # Default Ubuntu Environment for install.
    local dekstop=XFCE
    
    # Default Ubuntu Window Manager for install.
    local window=Awesome
    
    # Default Ubuntu Version for install.
    local version=22.04
    
    # Available Ubuntu Versions for install.
    local ubuntuVersions=(
        "22.04"
        "20.04"
        "18.04"
    )
    
    # Get user input action.
    readInputAction "ubuntu" "install" $version
    case $action in
        cancel)
            main
        ;;
        remove)
            ubuntuRemove $version $select
        ;;
        import)
            ubuntuImport $version $import $select
        ;;
        install)
            ubuntuInstall $version $select
        ;;
    esac
}

function main()
{
    for i in {1..8}; do
        if [[ $i == 1 ]]; then
            echo -e "\n\x20\x20$i. ${distros[$i]^}"
        elif [[ $i == 8 ]]; then
            echo -e "\x20\x20$i. ${distros[$i]^}\n"
        else
            echo -e "\x20\x20$i. ${distros[$i]^}"
        fi
    done
    local input=
    while true; do
        if [[ $input != "" ]]; then
            case $input in
                1|2|3|4|5|6|7|8)
                    ${distros[$input]}
                    break
                ;;
            esac
        fi
        readline "distro"
    done
}

clear && main
