#!/bin/bash
ETH=$1

LATENCY=$2

LOSS=$3

JITTER=$4

BW=$5

echo $ETH, $LATENCY, $LOSS, $JITTER, $BW
#Reset
#tc qdisc del dev $ETH root

#tc qdisc add dev $ETH  root netem delay $LATENCY loss $LOSS

sudo /sbin/tc qdisc del dev eth0 root
sudo /sbin/tc qdisc add dev eth0 root handle 1: netem delay $LATENCY $JITTER 
sudo /sbin/tc qdisc add dev eth0 parent 1:1 handle 10: netem loss $LOSS
sudo /sbin/tc qdisc add dev eth0 parent 10:1 handle 20: htb default 1
sudo /sbin/tc class add dev eth0 parent 20: classid 0:1 htb rate $BW ceil $BW

#tc qdisc change dev eth0 root netem loss $LOSS
sudo /sbin/tc qdisc show

#chmod 0644 /tmp/netemstate.txt
