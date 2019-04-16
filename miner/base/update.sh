#!/bin/bash

CUR_DIR=/root/miner/base

. ${CUR_DIR}/utils.sh

SERVER_URL=$(cat /root/miner/data/url)
CUR_VERSION=$(cat /root/miner/data/version)

# 获取最新版本信息
GetUpdate4Curl() {

    local JSON_STR=$(curl --request POST --url "${SERVER_URL}api/v2/miner/update" --header 'cache-control: no-cache' --header 'content-type: application/json' \
         --data '{"version":1}')

    local VERSION=$(GetJsonValuesByAwk ${JSON_STR} version | sed 's/\"//g')
    local HASH=$(GetJsonValuesByAwk ${JSON_STR} hash | sed 's/\"//g')
    local UPDATE_URL=$(GetJsonValuesByAwk ${JSON_STR} update_url | sed 's/\"//g')

    if [[ ${VERSION} -gt ${CUR_VERSION} ]]; then
        # 执行更新脚本
        sh -c "$(curl -fsSL ${UPDATE_URL})"
    fi

#    echo ${VERSION}
}

GetUpdate4Curl