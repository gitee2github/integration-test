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
# @Author    :   huyahui
# @Contact   :   huyahui8@163.com
# @Date      :   2020/5/28
# @License   :   Mulan PSL v2
# @Desc      :   Add sticky bit attribute for global writable directory
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"

function run_test() {
    LOG_INFO "Start executing testcase."
    testdir=$(mktemp -d)
    CHECK_RESULT $?
    test -d ${testdir}
    CHECK_RESULT $?
    chmod 777 ${testdir}
    ls -al ${testdir} | awk 'NR==2' | grep "drwxrwxrwx"
    CHECK_RESULT $?
    find /tmp -type d -perm -0002 ! -perm -1000 -ls | grep -v proc | grep ${testdir}
    CHECK_RESULT $?
    chmod +t ${testdir}
    CHECK_RESULT $?
    ls -al ${testdir} | awk 'NR==2' | grep "drwxrwxrwt"
    CHECK_RESULT $?
    LOG_INFO "Finish testcase execution."
}

function post_test() {
    LOG_INFO "Start cleanning environment."
    rm -rf ${testdir}
    LOG_INFO "Finish environment cleanup!"
}

main "$@"
