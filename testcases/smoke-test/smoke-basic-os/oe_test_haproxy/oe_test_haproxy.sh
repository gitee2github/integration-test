#!/usr/bin/bash

# Copyright (c) 2021 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   lutianxiong
# @Contact   :   lutianxiong@huawei.com
# @Date      :   2021-01-10
# @License   :   Mulan PSL v2
# @Desc      :   haproxy test
# ############################################

set -eo pipefail
source "$OET_PATH/libs/locallibs/common_lib.sh"
conf="/etc/httpd/conf/httpd.conf"
se_stat="Enforcing"

function pre_test() {
    dnf install -y httpd curl haproxy
    se_stat=$(getenforce)
    setenforce 0

    systemctl stop haproxy
    cp $conf httpd.conf
    sed -i s/"Listen 80"/"Listen 5001"/ $conf
    systemctl restart httpd
}

function run_test() {
    curl -o index.html localhost && return 1
    systemctl restart haproxy
    curl -o index.html localhost
    grep -q "openEuler" index.html
}

function post_test() {
    systemctl stop haproxy
    systemctl stop httpd
    mv httpd.conf $conf
    setenforce "$se_stat"
    rm -rf index.html
}

main $@
