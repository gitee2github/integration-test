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
# @Desc      :   File system common command test-dd
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function config_params() {
    LOG_INFO "This test case has no config params to load!"
}

function pre_test() {
    LOG_INFO "This test case does not require environment preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    dd if=/dev/zero of=test bs=1M count=1000
    CHECK_RESULT $?
    dd --help | grep "Usage"
    CHECK_RESULT $?
    ls file && rm -rf file
    echo "test" >file
    dd if=file of=test1 bs=1M count=1000
    CHECK_RESULT $?
    LOG_INFO "End test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    rm -f test test1 file
    LOG_INFO "Finish environment cleanup!"
}

main $@
