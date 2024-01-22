#!/bin/bash

set -e

readonly NAME={{ name }}

readonly DOCROOT="/var/www/$NAME"
readonly TIME=$(date +%s)

readonly GIT_USER={{ git_user }}
readonly GIT_PAT={{ git_pat }}

mkdir -p /var/www/$NAME/repo
chown -R www:www /var/www/$NAME/repo
git clone https://{{ git_user }}:{{ git_pat }}@github.com/{{ git_user }}/{{ repo }} "/var/www/$NAME/repo/$TIME"
chown -R www:www "/var/www/$NAME/repo/$TIME"
chmod -R 400 /var/www/$NAME/repo/$TIME

# Switch to current version
old_ver=-1
if [ -f /var/www/$NAME/repo/version ]; then
    old_ver=$(cat "/var/www/$NAME/repo/version")
fi

echo $TIME > "/var/www/$NAME/repo/version"
rm "/var/www/$NAME/active"
ln -s "/var/www/$NAME/repo/$TIME" "/var/www/$NAME/active"
chown -h www:www "/var/www/$NAME/active"
chmod 500 /var/www/$NAME/repo/$TIME

if [ $old_ver -ne -1 ]; then
    rm -rf "/var/www/$NAME/repo/$old_ver"
fi