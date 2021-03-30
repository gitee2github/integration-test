#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   doraemon2020
#@Contact   	:   xcl_job@163.com
#@Date      	:   2020-12-5
#@License   	:   Mulan PSL v2
#@Desc      	:   Open-iscsi Public function
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function TARGET_CONF() {
    SSH_SCP ./common/disk_info.sh "${NODE2_USER}"@"${NODE2_IPV4}":/home/ "${NODE2_PASSWORD}"
    unused_disk="$(SSH_CMD "sh /home/disk_info.sh" "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}" | tail -n 1 | tr -d "echo|\r| ")"
    test_disk=/dev/"${unused_disk}"1
    SSH_CMD "
    dnf install targetcli net-tools -y;
    systemctl stop firewalld;
    systemctl start target;
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    SSH_SCP ./common/target_config.json "${NODE2_USER}"@"${NODE2_IPV4}":/etc/target/saveconfig.json "${NODE2_PASSWORD}"
    SLEEP_WAIT 2
    SSH_CMD "
    sed -i 's|DISK_NAME|${test_disk}|g' /etc/target/saveconfig.json;
    sed -i 's/IP_ADDRESS/${NODE2_IPV4}/g' /etc/target/saveconfig.json;
    systemctl restart target;
    netstat -tulnp|grep 3260;
    " "${NODE2_IPV4}" "${NODE2_PASSWORD}" "${NODE2_USER}"
    sed -i "s/InitiatorName=.*$/InitiatorName=iqn.2020-08.com.example:client/g" /etc/iscsi/initiatorname.iscsi
    systemctl restart iscsid
    SLEEP_WAIT 2
    systemctl status iscsid | grep -i "running" || exit 1
    cp -r /etc/iscsi/ifaces/iface.example /etc/iscsi/ifaces/iface."${NODE1_NICS}"
    echo "iface.transport_name = tcp
iface.initiatorname = iqn.2020-08.com.example:client
iface.net_ifacename = ${NODE1_NICS}
iface.hwaddress = ${NODE1_MAC}
iface.ipaddress = ${NODE1_IPV4}
iface.bootproto = static" >/etc/iscsi/ifaces/iface."${NODE1_NICS}"
}
