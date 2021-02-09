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
# @CaseName  :   oe_test_httpd_verify_status
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-4-9
# @License   :   Mulan PSL v2
# @Desc      :   Verify the httpd service status
# #############################################
source ${OET_PATH}/libs/locallibs/common_lib.sh
function pre_test() {
	LOG_INFO "Start environment preparation."
	DNF_INSTALL httpd
	LOG_INFO "Environmental preparation is over."
}

function run_test() {
	LOG_INFO "Start executing testcase."
	systemctl enable httpd
	systemctl start httpd

	systemctl is-active httpd.service | grep active
	CHECK_RESULT $?
	LOG_INFO "End of  executing testcase."
}

function post_test() {
	LOG_INFO "start environment cleanup."
	DNF_REMOVE
	LOG_INFO "Finish environment cleanup."
}

main $@
