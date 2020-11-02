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
# @Date      :   2020-04-09
# @License   :   Mulan PSL v2
# @Desc      :   Add User test
# ############################################

source "$OET_PATH/libs/locallibs/common_lib.sh"
function config_params() {
    LOG_INFO "This test case has no config params to load!"
}

function pre_test() {
    LOG_INFO "Start environment preparation."
    cat /etc/passwd | grep "testuser:" && userdel -rf testuser
    cat /etc/passwd | grep "testuser1:" && userdel -rf testuser1
    cat /etc/passwd | grep "testuser2:" && userdel -rf testuser2
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    useradd testuser
    passwd testuser <<EOF
$LOCAL_PASSWD
$LOCAL_PASSWD
EOF

    CHECK_RESULT $?
    grep testuser /etc/passwd
    CHECK_RESULT $?

    useradd -e 2020-10-30 testuser1
    CHECK_RESULT $?
    chage -l testuser1 | grep 2020 | grep Oct | grep 30
    CHECK_RESULT $?

    chage -M 4 testuser1
    CHECK_RESULT $?
    chage -l testuser1 | grep Maximum | grep 4
    CHECK_RESULT $?
    useradd --help
    CHECK_RESULT $?
    echo testuser1:Administrator12#$ | chpasswd
    CHECK_RESULT $?

    ls /home/testuser2 || mkdir /home/testuser2
    useradd testuser2 2>&1 | grep 'home directory already exists'
    CHECK_RESULT $?
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    userdel -rf testuser
    userdel -rf testuser1
    userdel -rf testuser2
    LOG_INFO "Finish environment cleanup!"
}

main $@
