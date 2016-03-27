export PGHOST=172.17.42.1
export PGUSER=sg
export PGPASSWORD=oe9jaacZLbR9pN
export PGDATABASE=sg
export PGSSLMODE=disable

export SRC_SKIP_REQS="Docker"
export SRC_SKIP_REQS="Rlimit"
#sudo sh -c "ulimit -n 65535 && exec su ubuntu"

export SRC_URL=http://127.0.0.1:8085
bin/src serve --http-addr=:8085 --https-addr=11443 --ssh-addr=:1122 --no-worker
