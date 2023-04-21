
Exercício 1 (SNAT):

ALUNO 1: Cliente;
ALUNO 2: Cliente;
ALUNO 3: Roteador/NAT;

#!/bin/bash
#
# Flush
#
# Aluno 1 e 2
#
ip route show
ip route add 8.8.8.8 via <"ip do aluno 3">
# ip route del 8.8.8.8 via <"ip do aluno 3">
# Passo 8
# ALVO=`nslookup  www.teobaldo.pro.br|tail -2|grep "Address"|awk '{print $2}`
# ip route add $ALVO via 192.168.104.100 1>/dev/null 2>/dev/null
# ip route del $ALVO via 192.168.104.100 1>/dev/null 2>/dev/null
ip route show

# Passo 10 Aluno 1 fazer
# telnet www.teobaldo.pro.br 80


#!/bin/bash
#
# Flush
#
# Aluno 3
#
#
#  Ligar o roteamento no seu container
echo 1 > /proc/sys/net/ipv4/ip_forward

#  Adicionar ip no eth1
ip addr add 192.168.104.1NN/24 dev eth1
# ip addr del 192.168.104.1NN/24 dev eth1

#  Roteamento
ip route show
ip route add 8.8.8.8 via 192.168.104.100
# ip route del 8.8.8.8 via 192.168.104.100
ALVO=`nslookup  www.teobaldo.pro.br|tail -2|grep "Address"|awk '{print $2}`
ip route add $ALVO via 192.168.104.100 1>/dev/null 2>/dev/null
# ip route del $ALVO via 192.168.104.100 1>/dev/null 2>/dev/null
ip route show



# Firewall
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t filter -F
iptables -t nat -F
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# iptables -A INPUT -p tcp --dport 22 -j NFLOG --nflog-prefix "ALUNO 1: "
iptables -t nat -A POSTROUTING -s 192.168.102.0/24 -j SNAT --to 192.168.104.1NN
# iptables -t nat -A PREROUTING -d 200.1.2.4 -j DNAT --to 10.1.2.4

# Passo 10 Aluno 3 fazer
# conntrack -L


Exercício 2 (SNAT e DNAT conjugados):

ALUNO 1: Cliente (sem configuração a realizar);
ALUNO 2: Servidor (usaremos o serviço WEB deste container para teste);
ALUNO 3: Firewall/Nat/Roteador (Realiza a maior parte das configurações);

#!/bin/bash
#
# Flush
#
# Aluno 3
#
#
#  Ligar o roteamento no seu container
echo 1 > /proc/sys/net/ipv4/ip_forward

#  Adicionar ip no eth1
ip addr add 192.168.104.1NN/24 dev eth1
# ip addr del 192.168.104.1NN/24 dev eth1


# Firewall
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t filter -F
iptables -t nat -F
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# iptables -A INPUT -p tcp --dport 22 -j NFLOG --nflog-prefix "ALUNO 1: "
iptables -t nat -A PREROUTING -p tcp --dport 8080 -d 192.168.102.1NN -j DNAT --to 192.168.104.1NN # IP DO ALUNO 2
iptables -t nat -A POSTROUTING -s 192.168.102.0/24 -j SNAT --to 192.168.104.1NN # IP DO ALUNO 2


#!/bin/bash
#
# Flush
#
# Aluno 2





Resetar configuração adicionadas

#!/bin/bash
#
# Flush
#
#
# ip route flush table main
# ip addr del 192.168.104.1NN/24 dev eth1

ip route del 8.8.8.8 via <"ip do aluno 3">
ip route del 8.8.8.8 via 192.168.104.100
ALVO=`nslookup  www.teobaldo.pro.br|tail -2|grep "Address"|awk '{print $2}`
ip route del $ALVO via 192.168.104.100 1>/dev/null 2>/dev/null

iptables -t filter -F
iptables -t nat -F