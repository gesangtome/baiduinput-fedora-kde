#!/bin/bash

#
# Created by 弱弱的胖橘猫 <gesangtome@foxmail.com>
# Last update: 2020-08-25 17:08:16
#

for I in $1 $2; do 
    $3 $4 -i 's#/opt/apps/com.baidu.fcitx-baidupinyin/files#/usr#g' $I;
done
