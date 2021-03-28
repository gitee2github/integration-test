#!/usr/bin/bash

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   doraemon2020
# @Contact   :   xcl_job@163.com
# @Date      :   2020/10/30
# @License   :   Mulan PSL v2
# @Desc      :   command test - keepalived
# ############################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function RANDOM_IP() {
    while true; do
        random_ip=${NODE1_IPV4[0]%.*}.$(shuf -e $(seq 1 254) | head -n 1)
        ping -c 3 "${random_ip}" &>/dev/nul || {
            printf "%s" "$random_ip"
            break
        }
    done
}
function pre_test() {
    LOG_INFO "Start environmental preparation."
    DNF_INSTALL keepalived
    systemctl stop firewalld
    setenforce 0
    net_card=$(ip a | grep "${NODE1_IPV4}" | awk '{print $NF}')
    remote_net_card=$(SSH_CMD "ip a | grep ${NODE2_IPV4} | awk '{print \$NF}'" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" | tail -n 1 | awk -F '\r' '{print $1}')
    keepalived_ip=$(RANDOM_IP)
    cp -rf keepalived.conf /etc/keepalived/
    sed -i "s/TEST_VIP/${keepalived_ip}/g" /etc/keepalived/keepalived.conf;
    sed -i "s/TEST_NETCARD/${net_card}/g" /etc/keepalived/keepalived.conf;
    systemctl start keepalived
    SSH_CMD "dnf -y install keepalived;
    systemctl stop firewalld;
    setenforce 0;" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_SCP /etc/keepalived/keepalived.conf "${NODE2_USER}"@"${NODE2_IPV4}":/etc/keepalived/keepalived.conf "${NODE2_PASSWORD}"
    SSH_CMD "sed -i 's/MASTER/BACKUP/g' /etc/keepalived/keepalived.conf;
    sed -i 's/TEST_NETCARD/${remote_net_card}/g' /etc/keepalived/keepalived.conf;
    sed -i 's/priority\ 150/priority\ 100/g' /etc/keepalived/keepalived.conf;
    sed -i 's/router_id\ n1/router_id\ n2/g' /etc/keepalived/keepalived.conf;
    systemctl start keepalived;" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start executing testcase."
    time=1
    checkip_flag=1
    while (( time <= 6 )); do
        SLEEP_WAIT 10
        if ip addr show | grep "${keepalived_ip}";then
            checkip_flag=0;break;
        fi
        (( time = time + 1 ))
    done
    CHECK_RESULT ${checkip_flag}
    systemctl stop keepalived
    mkdir -p /tmp/keepalived/
    cp -rf /etc/keepalived/keepalived.conf /tmp/keepalived/
    SSH_CMD "systemctl stop keepalived;sleep 1;
    mkdir -p /tmp/keepalived/;
    cp -rf /etc/keepalived/keepalived.conf /tmp/keepalived/;
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    keepalived -D -f /tmp/keepalived/keepalived.conf
    SSH_CMD "sed -i 's/TEST_VIP/$keepalived_ip_2/g' /tmp/keepalived/keepalived.conf
    keepalived -D -f /tmp/keepalived/keepalived.conf" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SLEEP_WAIT 20
    ip addr show | grep "${keepalived_ip}"
    CHECK_RESULT $?
    kill -9 $(pgrep -f "keepalived -D")
    SSH_CMD "kill -9 \$(pgrep -f 'keepalived -D')" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    keepalived -P
    CHECK_RESULT $?
    grep 'Starting VRRP child process, pid' /var/log/messages
    kill -9 $(pgrep -f "keepalived -P")
    echo "local0.*    /var/log/keepalived.log" >>/etc/rsyslog.conf
    systemctl restart rsyslog
    CHECK_RESULT $?
    keepalived -D -d -S 0
    CHECK_RESULT $?
    SLEEP_WAIT 5
    test -s /var/log/keepalived.log
    CHECK_RESULT $?
    kill -9 $(pgrep -f "keepalived -D -f /tmp/keepalived/keepalived.conf")
    keepalived -D -x
    CHECK_RESULT $?
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "start environment cleanup."
    kill -9 $(pgrep -f "keepalived -D")
    sed -i "/keepalived.log/d" >>/etc/rsyslog.conf
    DNF_REMOVE
    rm -rf /etc/keepalived /var/log/keepalived /tmp/keepalived
    ip addr del "${keepalived_ip}"/24 dev "${net_card}":1
    SSH_CMD "
    kill -9 \$(pgrep -f 'keepalived -D');
    dnf remove -y keepalived;
    rm -rf /etc/keepalived /var/log/keepalived  /tmp/keepalived/;" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
