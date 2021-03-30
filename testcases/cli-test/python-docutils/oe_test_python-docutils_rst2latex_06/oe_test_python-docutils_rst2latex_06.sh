#!/usr/bin/bash

# Copyright (c) 2021. Huawei Technologies Co.,Ltd.ALL rights reserved.
# This program is licensed under Mulan PSL v2.
# You can use it according to the terms and conditions of the Mulan PSL v2.
#          http://license.coscl.org.cn/MulanPSL2
# THIS PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
# MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
# See the Mulan PSL v2 for more details.
####################################
#@Author    	:   doraemon2020
#@Contact   	:   xcl_job@163.com
#@Date      	:   2020-10-16
#@License   	:   Mulan PSL v2
#@Desc      	:   The command rst2latex parameter coverage test of the python-docutils package
#####################################

source "${OET_PATH}"/libs/locallibs/common_lib.sh
function pre_test() {
    LOG_INFO "Start to prepare the test environment."
    cp -r ../common/testfile_tex.rst ./testfile.rst
    DNF_INSTALL "python-docutils"
    LOG_INFO "Finish preparing the test environment."
}

function run_test() {
    LOG_INFO "Start to run test."
    rst2latex --compound-enumerators testfile.rst test1.tex
    CHECK_RESULT $?
    rst2latex --no-compound-enumerators testfile.rst test2.tex
    CHECK_RESULT $?
    rst2latex --section-prefix-for-enumerators testfile.rst test3.tex
    CHECK_RESULT $?
    rst2latex --no-section-prefix-for-enumerators testfile.rst test4.tex
    CHECK_RESULT $?
    rst2latex --section-enumerator-separator="@" testfile.rst test5.tex
    CHECK_RESULT $?
    rst2latex --literal-block-env=fancyvrb testfile.rst test6.tex
    CHECK_RESULT $?
    rst2latex --use-verbatim-when-possible testfile.rst test7.tex
    CHECK_RESULT $?
    rst2latex --table-style=booktabs testfile.rst test8.tex && grep 'toprule' test8.tex
    CHECK_RESULT $?
    rst2latex --graphicx-option=dvips testfile.rst test9.tex
    CHECK_RESULT $?
    rst2latex --font-encoding=OT1 testfile.rst test10.tex && grep 'usepackage\[OT1\]{fontenc}' test10.tex
    CHECK_RESULT $?
    rst2latex --reference-label=ref* testfile.rst test11.tex && grep 'hyperref\[cit1\]{\\ref\*{cit1}}' test11.tex
    CHECK_RESULT $?
    rst2latex --use-bibtex=mystyle,mydb1,mydb2 testfile.rst test12.tex
    CHECK_RESULT $?
    LOG_INFO "End of the test."
}

function post_test() {
    LOG_INFO "Start to restore the test environment."
    DNF_REMOVE
    rm -rf ./*.tex ./*.rst ./*.log ./*.sty
    LOG_INFO "Finish restoring the test environment."
}

main "$@"
