# initialize submodule or update submodule
git submodule update --init --recursive 2>/dev/null
git submodule foreach git pull origin master

rsync -rPq src/sourcegraph.com/sourcegraph/sourcegraph/vendor/ vendor/src
mkdir -p $GOPATH/src/sourcegraph.com/sourcegraph/sourcegraph/misc
rsync -rPq src/sourcegraph.com/sourcegraph/sourcegraph/misc/sampledata $GOPATH/src/sourcegraph.com/sourcegraph/sourcegraph/misc
rsync -rPq src/sourcegraph.com/sourcegraph/sourcegraph/app $GOPATH/src/sourcegraph.com/sourcegraph/sourcegraph

# get build tools for golang
# go get -u github.com/tools/godep
go get -u github.com/constabulary/gb/...

# download dependencies
# STATUS=
# cd src/src.sourcegraph.com/sourcegraph
# GOPATH=$(pwd)/../../../vendor godep restore -v || STATUS=failed
# cd ../../../

# fix dependency problem
# if [ ! -z "$STATUS" ]
# then
#   rm vendor/manifest
#   gb vendor fetch -no-recurse github.com/spf13/cobra
# fi

# build artifact
gb build
