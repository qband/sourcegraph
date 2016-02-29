git submodule update --init --recursive || git submodule foreach git pull origin master

rsync -rP src/src.sourcegraph.com/sourcegraph/vendor/ vendor/src
rsync -rP src/ $GOPATH/src/

go get -u github.com/constabulary/gb/...
gb build src.sourcegraph.com/sourcegraph/cmd/src
