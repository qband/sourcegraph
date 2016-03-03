# initialize submodule or update submodule
git submodule update --init --recursive 2>/dev/null
git submodule foreach git pull origin master

# rsync -rPq src/src.sourcegraph.com/sourcegraph/vendor/ vendor/src
# rsync -rPq src/ $GOPATH/src/

# get build tools for golang
go get -u github.com/tools/godep
go get -u github.com/constabulary/gb/...

# download dependencies
cd src/src.sourcegraph.com/sourcegraph
GOPATH=$(pwd)/../../../vendor godep restore -v
cd ../../../

# build artifact
gb build src.sourcegraph.com/sourcegraph/cmd/src
