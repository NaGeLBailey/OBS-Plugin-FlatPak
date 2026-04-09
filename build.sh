#!/usr/bin/env bash
set -o errexit 

# Adding Repo if neeeded;
addPluginRepo() {
    local repos=$(flatpak remotes)
    #echo "$repos"
    if [[ $(echo ${repos[@]} | grep -F -w "nagel-local-obs-plugins") ]] then
        echo "repo found, not adding..."
    else 
        echo "adding repo 'nagel-local-obs-plugins'"
        flatpak remote-add --no-gpg-verify nagel-local-obs-plugins ../../localPluginRepo/
    fi
}

#Build, export to local repo, then install
build() {
    cd plugins/$1
    flatpak-builder build com.obsproject.Studio.Plugin.$1.yaml -v --force-clean --repo=../../localPluginRepo
    addPluginRepo
    flatpak install com.obsproject.Studio.Plugin.$1
}

ARG=('all')
PROJECTS=()

if [[ $# -ne 1 ]]; then 
    echo "Build requires one, and only one argument! Argument needs to be the foldername or the word: all"
    exit 1
fi
# Source - https://stackoverflow.com/a/18887210
# Posted by Gordon Davisson, modified by community. See post 'Timeline' for change history
# Retrieved 2026-04-09, License - CC BY-SA 4.0

#get plugin list from the plugin folder
shopt -s nullglob
folders=(plugins/*/)
shopt -u nullglob # Turn off nullglob to make sure it doesn't interfere with anything later

for i in "${folders[@]}"; do
    echo "$i"
    name="${i%/}"
    PROJECTS+=("${name#plugins/}")
done
ARG=("${ARG[@]}" "${PROJECTS[@]}") 

# Check if the only argument is one that we can work with 
if [[ $(echo ${ARG[@]} | grep -F -w $1) ]] then
    echo "building $1..."
else
    echo "Not ValidArgument (all or folderName)"
    exit 1
fi

if [[ "$1" == "all" ]]; then
    for i in "${PROJECTS[@]}"; do
        #echo "$i"
        (build $i)
    done
else
    (build $1)
fi