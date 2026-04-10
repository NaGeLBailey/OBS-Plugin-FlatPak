#!/usr/bin/env bash
set -o errexit 
if ! [[ -e .env ]]; then
	echo "create .env file!"
    exit 1
fi

# shellcheck disable=SC1091
source .env

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
REPOLOCATION="$SCRIPT_DIR/localPluginRepo"
SPECIAL_LOCALVOCAL="LocalVocal"

# Adding Repo if neeeded;
addPluginRepo() {
    local repos
    repos=$(flatpak remotes)
    if echo "${repos[@]}" | grep -F -w -q "nagel-local-obs-plugins"; then
        echo "repo found, not adding..."
    else 
        echo "adding repo 'nagel-local-obs-plugins'"
        flatpak remote-add --no-gpg-verify nagel-local-obs-plugins "$REPOLOCATION"
    fi
}

#Build, export to local repo, then install
build() {
	echo "=================================================="
	echo " Building $1 "
	echo "=================================================="
	case "$1" in
		"$SPECIAL_LOCALVOCAL")
			buildLocalVocal
			;;
		*)
			buildGeneric "$1"
			;;
	esac
	addPluginRepo
    flatpak install com.obsproject.Studio.Plugin."$1"
}
#Generic build
buildGeneric() {
	cd plugins/"$1"
    flatpak-builder build com.obsproject.Studio.Plugin."$1".yaml --force-clean --repo="$REPOLOCATION" --disable-rofiles-fuse
}

#Special Build for LocalVocal
buildLocalVocal() {
	#ACCELERATION=$LOCALVOCAL_ACCELERATION ./plugins/"$SPECIAL_LOCALVOCAL"/flatpak/build.sh  --disable-rofiles-fuse --force-clean --repo="$REPOLOCATION" plugins/"$SPECIAL_LOCALVOCAL"/flatpak/build
    cd plugins/"$SPECIAL_LOCALVOCAL"/flatpak
    flatpak-builder build com.obsproject.Studio.Plugin."$SPECIAL_LOCALVOCAL".yaml --force-clean --repo="$REPOLOCATION" --disable-rofiles-fuse
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
    name="${i%/}"
    PROJECTS+=("${name#plugins/}")
done
ARG=("${ARG[@]}" "${PROJECTS[@]}") 

# Check if the only argument is one that we can work with 
if echo "${ARG[@]}" | grep -F -w -q "$1"; then
    echo "building $1..."
else
    echo "Not ValidArgument (all or folderName)"
    exit 1
fi

if [[ "$1" == "all" ]]; then
    for i in "${PROJECTS[@]}"; do
        (build "$i")
    done
else
    (build "$1")
fi