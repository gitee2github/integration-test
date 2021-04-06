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
# @Date      :   2020/5/16
# @License   :   Mulan PSL v2
# @Desc      :   Parametric test
# #############################################

source "../common/lib.sh"
function pre_test() {
    LOG_INFO "Start environment preparation."
    pre_junit5
    LOG_INFO "End of environmental preparation!"
}

function run_test() {
    LOG_INFO "Start testing..."
    javac -cp junit-platform-console-standalone-1.6.2.jar -d . TestJunit5.java
    CHECK_RESULT $?
    java -jar junit-platform-console-standalone-1.6.2.jar -cp ./ --class-path . --scan-class-path >result
    CHECK_RESULT $?
    grep '14 tests successful' result
    CHECK_RESULT $?
    grep '0 tests failed' result
    CHECK_RESULT $?
    LOG_INFO "Finish test!"
}

function post_test() {
    LOG_INFO "start environment cleanup."
    clean_junit5
    rm -rf com result
    LOG_INFO "Finish environment cleanup!"
}
main "$@"
