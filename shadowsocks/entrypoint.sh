#!/bin/bash

SS_CONFIG=${SS_CONFIG:-""}
SS_MODULE=${SS_MODULE:-"ss-server"}
KCP_CONFIG=${KCP_CONFIG:-""}
KCP_MODULE=${KCP_MODULE:-"kcpserver"}
KCP_FLAG=${KCP_FLAG:-"false"}
U2R_CONFIG=${U2R_CONFIG:-""}
U2R_MODULE=${U2R_MODULE:-"udp2raw"}
U2R_FLAG=${U2R_FLAG:-"false"}


while getopts "s:m:k:e:x:u:v:w" OPT; do
    case $OPT in
        s)
            SS_CONFIG=$OPTARG;;
        m)
            SS_MODULE=$OPTARG;;
        k)
            KCP_CONFIG=$OPTARG;;
        e)
            KCP_MODULE=$OPTARG;;
        x)
            KCP_FLAG="true";;
        u)
            U2R_CONFIG=$OPTARG;;
        v)
            U2R_MODULE=$OPTARG;;
        w)
            U2R_FLAG="true";;
    esac
done

if [ "$U2R_FLAG" == "true" ] && [ "$U2R_CONFIG" != "" ]; then
    echo -e "\033[32mStarting udp2raw......\033[0m"
    $U2R_MODULE $U2R_CONFIG --gen-add 2>&1
    $U2R_MODULE $U2R_CONFIG 2>&1 &
else
    echo -e "\033[33mudp2raw not started......\033[0m"
fi

if [ "$KCP_FLAG" == "true" ] && [ "$KCP_CONFIG" != "" ]; then
    echo -e "\033[32mStarting kcptun......\033[0m"
    $KCP_MODULE $KCP_CONFIG 2>&1 &
else
    echo -e "\033[33mKcptun not started......\033[0m"
fi

if [ "$SS_CONFIG" != "" ]; then
    echo -e "\033[32mStarting shadowsocks......\033[0m"
    $SS_MODULE $SS_CONFIG
else
    echo -e "\033[31mError: SS_CONFIG is blank!\033[0m"
    exit 1
fi
