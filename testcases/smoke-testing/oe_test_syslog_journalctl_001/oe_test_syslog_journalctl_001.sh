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
# @Author    :   Classicriver_jia
# @Contact   :   classicriver_jia@foxmail.com
# @Date      :   2020-6-18
# @License   :   Mulan PSL v2
# @Desc      :   Supports logging of Basic System Operation Information
# #############################################

source ${OET_PATH}/libs/locallibs/common_lib.sh
function config_params() {
	LOG_INFO "No params need to config."
}

function pre_test() {
	LOG_INFO "No pkgs need to install."
}

function run_test() {
	LOG_INFO "Start to run test."
	rm -rf systemlog2
	journalctl --system >systemlog2
	logsize=$(grep -v ' No entries ' systemlog2 | wc -l)
	test $((logsize)) -gt 1
	CHECK_RESULT $?
	LOG_INFO "End to run test."
}

function post_test() {
	LOG_INFO "Start to restore the test environment."
	rm -rf systemlog2
	LOG_INFO "End to restore the test environment."
}

main $@
