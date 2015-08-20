#!/bin/bash
# script name : rollbackstaging.bash
# script args : $1 -- file to be edited
#
# 
# Say you have this, where C is your HEAD and (F) is the state of your files.
#
#    (F)
# A-B-C
#     ↑
#   master
# You want to nuke commit C and never see it again. You do this:
#
# The result is:
#
#  (F)
# A-B
#   ↑
# master
# Now B is the HEAD. Because you used --hard, your files are reset to their state at commit B.
#
# This script rollsback the last commit, resets your working files to the state of the last commit,
# and then merges the rollback into staging on github before rollingback staging on heroku.


git checkout development
git branch
git reset --hard HEAD~1
git checkout staging
git branch
git merge development
git push origin staging
cat ~/.netrc | grep heroku || heroku login && heroku keys:add ~/.ssh/id_rsa.pub
heroku git:remote -a staging-compucay-ky -r staging-heroku
git push staging-heroku staging:master
git checkout development
