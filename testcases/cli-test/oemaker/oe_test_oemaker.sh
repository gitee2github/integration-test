#!/usr/bin/bash

# Copyright (c) 2020. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author        :   zhujinlong
#@Contact       :   zhujinlong@163.com
#@Date          :   2020-11-17
#@License       :   Mulan PSL v2
#@Desc          :   Oemaker is a tool for building DVD ISO, including standard ISO, debug ISO and source ISO.
#####################################

source ${OET_PATH}/libs/locallibs/common_lib.sh

function config_params() {
    LOG_INFO "Start to config params of the case."
    EXECUTE_T="120m"
    LOG_INFO "End to config params of the case."
}

function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    DNF_INSTALL oemaker
    LOG_INFO "End to prepare the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    oemaker -h | grep 'Usage'
    CHECK_RESULT $?
    if [ "${NODE1_FRAME}" = "aarch64" ]; then
        oemaker -t standard -p OpenEuler -v 20.09 -r aarch64
        CHECK_RESULT $?
        test -f /result/OpenEuler-20.09-aarch64-aarch64-dvd.iso
        CHECK_RESULT $?
    else
        oemaker -t standard -p OpenEuler -v 20.09 -r x86_64
        CHECK_RESULT $?
        test -f /result/OpenEuler-20.09-x86_64-x86_64-dvd.iso
        CHECK_RESULT $?
    fi
    LOG_INFO "End to run test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf /result
    LOG_INFO "End to restore the test environment."
}

main "$@"
