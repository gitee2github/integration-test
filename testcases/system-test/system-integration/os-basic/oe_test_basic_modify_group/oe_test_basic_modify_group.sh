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
# @CaseName  :   oe_test_basic_UserMgmt_003
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2020-04-09
# @License   :   Mulan PSL v2
# @Desc      :   Modity User Group test
# ############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start environment preparation."
    grep -w testuser1 /etc/passwd && userdel testuser1
    grep -w testgroup1 /etc/group && groupdel testgroup1
    useradd testuser1
    groupadd testgroup1
    groupmod -g 6666 testgroup1
    LOG_INFO "Environmental preparation is over."
}

function run_test() {
    LOG_INFO "Start executing testcase!"
    grep -w testgroup1 /etc/group | grep 6666
    CHECK_RESULT $?
    groupmod -g 8888 testgroup1
    CHECK_RESULT $?
    grep -w testgroup1 /etc/group | grep 8888
    CHECK_RESULT $?

    groupmod -n testgroup2 testgroup1
    CHECK_RESULT $?
    grep -w testgroup2 /etc/group | grep 8888
    CHECK_RESULT $?

    grep -w testgroup1 /etc/group
    CHECK_RESULT $? 1

    usermod -a -G testgroup2 testuser1
    CHECK_RESULT $?
    grep -w testgroup2 /etc/group | grep testuser1
    CHECK_RESULT $?

    groupmod --help | grep Usage
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    groupdel testgroup2
    userdel -r testuser1
    LOG_INFO "Finish environment cleanup."
}

main $@
