#!/usr/bin/bash

# Copyright (c) 2020 Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @Author    :   yuanlulu
# @Contact   :   cynthiayuanll@163.com
# @Date      :   2020-07-27
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-acl
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function config_params() {
    LOG_INFO "This test case has no config params to load!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    ls /tmp/acl01 && rm -rf /tmp/acl01
    id -u testuser || useradd testuser
}

function run_test() {
    LOG_INFO "Start testing..."

    mkdir -p /tmp/acl01
    getfacl -p /tmp/acl01|grep "user"|awk -F : '{print $2}'|grep -w "testuser"
    CHECK_RESULT $? 0 1

    setfacl -m u:testuser:rx /tmp/acl01
    getfacl -p /tmp/acl01|grep "user"|awk -F : '{print $2}'|grep -w "testuser"
    CHECK_RESULT $? 0 0
    mkdir  /tmp/acl01/acl02
    getfacl -p /tmp/acl01/acl02|grep "user"|awk -F : '{print $2}'|grep -w "testuser"
    CHECK_RESULT $? 0 1


    setfacl -m d:u:testuser:rx /tmp/acl01
    getfacl -p /tmp/acl01|grep "user"|awk -F : '{print $2}'|grep -w "testuser"
    CHECK_RESULT $? 0 0
    mkdir  /tmp/acl01/acl03
    getfacl -p /tmp/acl01/acl03|grep "user"|awk -F : '{print $2}'|grep -w "testuser"
    CHECK_RESULT $? 0 0

    setfacl -b /tmp/acl01
    getfacl -p /tmp/acl01|grep "user"|awk -F : '{print $2}'|grep -w "testuser"
    CHECK_RESULT $? 0 1
    getfacl -p /tmp/acl01/acl02|grep "user"|awk -F : '{print $2}'|grep -w "testuser"
    CHECK_RESULT $? 0 1
    getfacl -p /tmp/acl01/acl03|grep "user"|awk -F : '{print $2}'|grep -w "testuser"
    CHECK_RESULT $? 0 0

}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/acl01
    userdel testuser
}

main $@
