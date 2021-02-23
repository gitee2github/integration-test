#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.

# #############################################
# @CaseName  :   oe_test_basic_view_user_group_ids
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2021.04-09
# @License   :   Mulan PSL v2
# @Desc      :   View user and group id
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function run_test() {
    LOG_INFO "Start executing testcase!"
    id | grep "uid"
    CHECK_RESULT $?
    id_num=$(id | grep -iE 'uid|gid' | awk -F "=" '{print$2}' | awk -F '(' '{print$1}')
    id -g | grep ${id_num}
    CHECK_RESULT $?
    id -G | grep ${id_num}
    CHECK_RESULT $?
    id --help | grep "Usage:"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

main $@
