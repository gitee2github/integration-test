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
# @Author    :   lutianxiong
# @Contact   :   lutianxiong@huawei.com
# @Date      :   2020-10-10
# @License   :   Mulan PSL v2
# @Desc      :   httpd test
# ############################################

set -eo pipefail
source "$OET_PATH/libs/locallibs/common_lib.sh"

function pre_test() {
    dnf install -y httpd curl
}

function run_test() {
    systemctl start httpd
    curl -o index.html localhost
    grep -q "openEuler" index.html
}

function post_test() {
    systemctl stop httpd
    dnf remove -y httpd
    rm -rf index.html
}

main $@
