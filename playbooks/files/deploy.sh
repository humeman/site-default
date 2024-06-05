#!/bin/bash

set -e

readonly NAME={{ site_name }}

readonly DOCROOT="/var/www/$NAME"
readonly TIME=$(date +%s)

readonly GIT_USER={{ git_user }}
readonly GIT_PAT={{ git_pat }}

mkdir -p "$DOCROOT/repo"
chown -R www:www "$DOCROOT/repo"
git clone https://{{ git_user }}:{{ git_pat }}@{{ git_repo }} "$DOCROOT/repo/$TIME"
chown -R www:www "$DOCROOT/repo/$TIME"
chmod -R 550 $DOCROOT/repo/$TIME

# Switch to current version
old_ver=-1
if [ -f $DOCROOT/repo/version ]; then
    old_ver=$(cat "$DOCROOT/repo/version")
fi

echo $TIME > "$DOCROOT/repo/version"
if [ -L "$DOCROOT/active" ]; then
    rm "$DOCROOT/active"
fi
ln -s "$DOCROOT/repo/$TIME/src" "$DOCROOT/active"
chown -h www-data:www-data "$DOCROOT/active"
chmod 550 $DOCROOT/repo/$TIME

if [ $old_ver -ne -1 ]; then
    rm -rf "$DOCROOT/repo/$old_ver"
fi
