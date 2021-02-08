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
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-4-9
# @License   :   Mulan PSL v2
# @Desc      :   MARIADB software compatibility
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function config_params() {
    LOG_INFO "Start to config params of the case."
    sql_password="${NODE1_PASSWORD}"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL "net-tools mariadb-server"
    rm -rf /var/lib/mysql/*
    systemctl start mariadb.service
    mysqladmin -uroot password ${sql_password}
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    SLEEP_WAIT 5
    systemctl restart mariadb
    CHECK_RESULT $?
    netstat -anp | grep 3306
    CHECK_RESULT $?
    expect -c "
        set timeout 10
        spawn mysql -u root -p
        expect {
            \"Enter*\" { send \"${sql_password}\r\";
            expect \"Maria*\" { send \"grant all privileges on *.* to 'root'@'$NODE2_IPV4' IDENTIFIED BY '$NODE2_PASSWORD' WITH GRANT OPTION;\r\"}
            expect \"Maria*\" { send \"flush privileges;\r\"}
            expect \"Maria*\" { send \"exit\r\"}
    }
    }
    expect eof
    "
    SLEEP_WAIT 5
    systemctl restart mariadb
    CHECK_RESULT $?
    systemctl stop firewalld
    SSH_CMD "dnf -y install mariadb-server expect" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    SSH_CMD "systemctl start mariadb;systemctl stop firewalld" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    cp ../common/mariadb_remote .
    sed -i s/local_ip/${NODE1_IPV4}/g mariadb_remote
    sed -i s/local_password/${NODE1_PASSWORD}/g mariadb_remote
    SSH_SCP ./mariadb_remote ${NODE2_USER}@${NODE2_IPV4}:/opt/ ${NODE2_PASSWORD}
    SSH_CMD "expect /opt/mariadb_remote" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    CHECK_RESULT $?
    SSH_SCP ${NODE2_USER}@${NODE2_IPV4}:/root/testlog . ${NODE2_PASSWORD}
    grep -i "ERROR 1245" testlog
    CHECK_RESULT $? 1
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    rm -rf /var/lib/mysql
    rm -rf mariadb.sh testlog
    SSH_CMD "yum remove mariadb-server expect -y" ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    SSH_CMD "rm -rf /opt/mariadb.sh;rm -rf /root/testlog " ${NODE2_IPV4} ${NODE2_PASSWORD} ${NODE2_USER}
    DNF_REMOVE
    LOG_INFO "End to restore the test environment."
}

main $@
