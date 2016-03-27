printf "<<=========original docker images==========\n" \
	  && cat src/src.sourcegraph.com/sourcegraph/worker/plan/srclib.go | grep Image: | sed 's~.*"\(.*\)".*~\1~' \
	    && printf "=========original docker images==========>>\n"

# change hard coded docker image revisions
FILEPATH=src/src.sourcegraph.com/sourcegraph/worker/plan/srclib.go
sed -i '/Image: / s~@.*"~"~' $FILEPATH
sed -i '/Image: / s~"\(.*\)\(:\|@\).*"~"\1"~' $FILEPATH

printf "<<=========modified docker images==========\n" \
	  && cat src/src.sourcegraph.com/sourcegraph/worker/plan/srclib.go | grep Image: | sed 's~.*"\(.*\)".*~\1~' \
	    && printf "=========modified docker images==========>>\n"

sh build-binary.sh

DOCKERFILE_FOLDER=tmp
DOCKERFILE=$DOCKERFILE_FOLDER/Dockerfile
cp src/src.sourcegraph.com/sourcegraph/deploy/sourcegraph/Dockerfile $DOCKERFILE_FOLDER/
sed -i '/apk add/i ENV http_proxy http://x.x.x.x:3128' $DOCKERFILE
sed -i '/apk add/i RUN echo proxy=$http_proxy > ~/.curlrc' $DOCKERFILE
#sed -i '/RUN curl/ s~curl~curl --proxy $http_proxy~' $DOCKERFILE
sed -i '/apk add/i RUN setup-proxy $http_proxy && . /etc/profile.d/proxy.sh' $DOCKERFILE
sed -i '/ADD src/ s~src~bin/src~' $DOCKERFILE
sed -i '/ENV STATIC_SITE_VERSION/d' $DOCKERFILE
sed -i '/ENV STATIC_SITE_URL/d' $DOCKERFILE
sed -i '/RUN curl -Ls $STATIC_SITE_URL/ s~.*~ADD tmp/sourcegraph-site /sourcegraph-site~' $DOCKERFILE


STATIC_SITE_VERSION=55878eccbd2b40bf9f80888bd32426ee645b9591
STATIC_SITE_URL=https://s3-us-west-2.amazonaws.com/sourcegraph-site/sourcegraph-site-$STATIC_SITE_VERSION.tar
curl --proxy $http_proxy -Ls $STATIC_SITE_URL | tar x -C $DOCKERFILE_FOLDER

sudo docker rmi qband/sourcegraph
sudo docker build -f $DOCKERFILE -t qband/sourcegraph:latest .
