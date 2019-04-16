#!/bin/bash
source /etc/profile
CUR_DIR=/root/miner/base

. ${CUR_DIR}/utils.sh

SERVER_URL=$(cat /root/miner/data/url)
CUR_VERSION=$(cat /root/miner/data/version)


# 设备CPU序列码
DEVICE_CPU_ID=$(dmidecode -t 4 | grep ID |sort -u |awk -F': ' '{print $2}' | sed 's/ //g')

MACS=($(lshw -c network | grep -E "logical name" | awk '{print $3}'))

# 设备网卡MAC地址
DEVICE_MAC_ADDRESS=$(cat /sys/class/net/${MACS[0]}/address)

# MAC2
DEVICE_MAC_ADDRESS_2=$(cat /sys/class/net/${MACS[1]}/address)

# 设备网关IP
# DEVICE_GATEWAY_IP=$(ip route show | grep default | awk '{print $3}')

# 设备网关MAC
# DEVICE_GATEWAY_MAC_ADDRESS=$(arp -a | grep -w ${DEVICE_GATEWAY_IP} | awk {'print $4'})

# 向服务器提交Ping请求
PostPingData4Curl() {

    curl --request POST \
         --url "${SERVER_URL}/api/v2/miner/heartbeat?device_version=${CUR_VERSION}&mac1=${DEVICE_MAC_ADDRESS}&mac2=${DEVICE_MAC_ADDRESS_2}&device_cpu_id=${DEVICE_CPU_ID}" \
         --header 'cache-control: no-cache' \
         --header 'content-type: application/json' \
         --data '{
                "minerNumber":"'${DEVICE_CPU_ID}'"
            }'

}

PostPingData4Curl