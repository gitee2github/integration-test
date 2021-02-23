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
# @CaseName  :   oe_test_basic_view_disk_info
# @Author    :   xuchunlin
# @Contact   :   xcl_job@163.com
# @Date      :   2021.04-09 10:52:41
# @License   :   Mulan PSL v2
# @Desc      :   View disk information
# ############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function run_test() {
    LOG_INFO "Start executing testcase!"
    disk_name=$(lsblk | awk  '{print$1}' | sed -n 2p)
    fdisk -l | grep ${disk_name}
    CHECK_RESULT $?

    fdisk -v | grep "fdisk"
    CHECK_RESULT $?
    LOG_INFO "End of testcase execution!"
}

main $@
