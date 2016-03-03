git submodule update --init --recursive
git submodule foreach git pull origin master

# rsync -rPq src/src.sourcegraph.com/sourcegraph/vendor/ vendor/src
# rsync -rPq src/ $GOPATH/src/

go get -u github.com/tools/godep
pushd src/src.sourcegraph.com/sourcegraph
godep restore -v
popd

go get -u github.com/constabulary/gb/...
gb build src.sourcegraph.com/sourcegraph/cmd/src
