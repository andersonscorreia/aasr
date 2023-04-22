#!/bin/bash

# Firewall


iptables -t filter -F
iptables -t nat -F
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# iptables -A INPUT -p tcp --dport 22 -j NFLOG --nflog-prefix "ALUNO 1: "


iptables -t nat -A PREROUTING -d 192.168.102.154 -p tcp --dport 8080 -j DNAT --to 192.168.104.171:80
iptables -t nat -A POSTROUTING -s 192.168.102.0/24 -d 192.168.104.171 -p tcp --dport 80 -j SNAT --to 192.168.104.154


#iptables -t nat -A PREROUTING -p tcp --dport 8080 -d 192.168.102.154 -j DNAT --to 192.168.104.171:8080 # IP DO ALUNO 2
#iptables -t nat -A POSTROUTING -s 192.168.102.0/24 -j SNAT --to 192.168.104.171 # IP DO ALUNO 2

