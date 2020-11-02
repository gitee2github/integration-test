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
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-10
# @License   :   Mulan PSL v2
# @Desc      :   File system common command test-chmod
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function config_params() {
    LOG_INFO "This test case has no config params to load!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    ls /tmp/test01 && rm -rf /tmp/test01
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    mkdir -p /tmp/test01/test02/test03
    per01=$(ls -l /tmp | grep "test01" | awk -F ' ' '{print $1}')
    per02=$(ls -l /tmp/test01 | grep "test02" | awk -F ' ' '{print $1}')
    [ "$per01" == "drwxr-xr-x." ]
    CHECK_RESULT $?
    chmod 777 /tmp/test01
    per03=$(ls -l /tmp | grep "test01" | awk -F ' ' '{print $1}')
    per04=$(ls -l /tmp/test01 | grep "test02" | awk -F ' ' '{print $1}')
    [ "$per03" == "drwxrwxrwx." ]
    CHECK_RESULT $?
    [ "$per02" == "$per04" ]
    CHECK_RESULT $?

    chmod -R 777 /tmp/test01
    per05=$(ls -l /tmp/ | grep "test01" | awk -F ' ' '{print $1}')
    per06=$(ls -l /tmp/test01 | grep "test02" | awk -F ' ' '{print $1}')
    [ "$per05" == "drwxrwxrwx." ]
    CHECK_RESULT $?
    [ "$per06" == "drwxrwxrwx." ]
    CHECK_RESULT $?

    chmod --help | grep "Usage"
    CHECK_RESULT $?
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -rf /tmp/test01
    LOG_INFO "Finish environment cleanup!"
}

main $@
