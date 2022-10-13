#!/usr/bin/env bash
set -e

if [ -z $1 ];
then
    echo -e "\t => need parameters <="
    exit -1
fi

export_configure() {
    echo ""
    echo -e "\t => export configure file 'docker-compose.yml' <="
    echo ""

    cat << FEOF > docker-compose.yml
version: '3.9'
services:
  # callcenter api
  cc_api:
    image: puteyun/cloud_contact_center:0.1.1
    container_name: cc_api
    volumes:
      - ./:/data
    ports:
      - "8001:8000"
    healthcheck:
      test: [ "CMD", "curl" ,"--fail","-k", "https://localhost:8000/time"]
      timeout: 20s
      retries: 10
    depends_on:
      cc_mariadb:
        condition: service_healthy
      cc_redis:
        condition: service_healthy
    networks:
      - cc_network
    build:
      context: ./cc_api
      dockerfile: ./Dockerfile
  # webrtc 网关
  cc_gateway:
    image: puteyun/cloud_contact_gateway:0.0.1
    container_name: cc_gateway
    network_mode: host
    volumes:
      - ./:/data
    depends_on:
      cc_mariadb:
        condition: service_healthy
      cc_api:
        condition: service_healthy
      cc_redis:
        condition: service_healthy
    build:
      context: cc_gateway
      dockerfile: ./Dockerfile
  # mysql database
  cc_mariadb:
    image: mariadb:10.6.7
    container_name: cc_mariadb
    volumes:
      - ./mariadb_data/data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: 8ccDNF77xcJKO
    healthcheck:
      test: [ "CMD", "mysqladmin" ,"ping", "-h", "localhost","-p8ccDNF77xcJKO"]
      timeout: 20s
      retries: 10
    # if want expose to external,please uncomment this
    ports:
      - "53306:3306"
    networks:
      - cc_network
  cc_redis:
    image: redis
    container_name: cc_redis
    ports:
      - "6379:6379"
    networks:
      - cc_network
    healthcheck:
      test: ["CMD", "redis-cli","ping"]
      interval: 1s
      timeout: 3s
      retries: 5

networks:
  cc_network:
    name: cc_network
FEOF
    echo ""
    echo -e "\t => configure file done <="
    echo ""
    echo ""
}

create() {
    echo ""
    echo "==> try to create cloudfon-cc service <=="
    echo ""
    #echo " args: $@"
    #echo "The number of arguments passed in are : $#"

    # remove command firstly
    shift

    export_configure
    # run cloudfon-cc service
    docker compose up -d

    echo ""
    echo -e "\t done"
    echo ""
}


status() {
    # remove command firstly
    shift

    service_name=

    # parse parameters
    while getopts s: option
    do
        case "${option}" in
            s)
                service_name=${OPTARG}
                ;;
        esac
    done

    # check parameters is exist
    if [ -z "$service_name" ]; then
        echo ""
        echo "status all services"
        echo ""
        docker compose ls -a
        docker compose ps -a
    else
        echo ""
        echo "status service $service_name"
        echo ""
        docker compose ps $service_name
    fi
}

restart() {
    # remove command firstly
    shift

    service_name=

    # parse parameters
    while getopts s: option
    do
        case "${option}" in
            s)
                service_name=${OPTARG}
                ;;
        esac
    done

	# check parameters is exist
    if [ -z "$service_name" ]; then
        echo ""
        echo "restart all services"
        echo ""
        docker compose restart
        exit 0
    else
        echo ""
        echo "restart service $service_name"
        echo ""
        docker compose restart -t 100 $service_name
    fi
}

start() {
    # remove command firstly
    shift

    service_name=

    # parse parameters
    while getopts s: option
    do
        case "${option}" in
            s)
                service_name=${OPTARG}
                ;;
        esac
    done

    # check parameters is exist
    if [ -z "$service_name" ]; then
        echo ""
        echo "start all services"
        echo ""
        docker compose start
    else
        echo ""
        echo "start service $service_name"
        echo ""
        docker compose start $service_name
    fi
}

stop() {
    # remove command firstly
    shift

    service_name=

    # parse parameters
    while getopts s: option
    do
        case "${option}" in
            s)
                service_name=${OPTARG}
                ;;
        esac
    done

	# check parameters is exist
    if [ -z "$service_name" ]; then
        echo ""
        echo "stop all services"
        echo ""
        docker compose stop
    else
        echo ""
        echo "stop service $service_name"
        echo ""
        docker compose stop  -t 100 $service_name
    fi
}

rm() {
    # remove command firstly
    shift

    # remove_data=false

    # # parse parameters
    # while getopts f option
    # do
    #     case "${option}" in
    #         f)
    #             remove_data=true
    #             ;;
    #     esac
    # done

    docker compose down
}

case $1 in
run)
    create $@
    ;;

restart)
    restart $@
    ;;

status)
    status $@
    ;;

stop)
    stop $@
    ;;

start)
    start $@
    ;;

rm)
    rm $@
    ;;

*)
    echo -e "\t error command"
    ;;
esac
