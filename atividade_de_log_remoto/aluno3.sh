#!/bin/bash


iptables -F
# Define o limite de taxa para novas conexões
rate_limit="1/s"
 
# Configura as regras do iptables
iptables -A INPUT -p tcp --dport pop3 -m state --state NEW -m recent --set
iptables -A INPUT -p tcp --dport pop3 -m state --state NEW -m recent --update --seconds 1 --hitcount 2 -j NFLOG --nflog-group 6 --nflog-prefix "TR-REJEITADA:"
iptables -A INPUT -p tcp --dport pop3 -m state --state NEW -m recent --update --seconds 1 --hitcount 2 -j REJECT --reject-with tcp-reset
iptables -A INPUT -p tcp --dport pop3 -m state --state NEW -j NFLOG --nflog-group 7 --nflog-prefix "TR-ACEITA:" 


#    Para configurar o rsyslogd deve adicionar as seguintes linhas ao arquivo de configuração do rsyslogd, geralmente localizado em /etc/rsyslog.conf ou /etc/rsyslog.d/50-default.conf:

cat >> /etc/rsyslog.conf <<EOL

#    Armazena mensagens com facilidade "LOCAL6" e criticidade "INFORMATIONAL" no arquivo "/var/log/firewall.log"
local6.=info /var/log/firewall.log

#    Armazena mensagens com facilidade "LOCAL6" e criticidade "NOTICE" no arquivo "/var/log/firewall.log"
local6.=notice /var/log/firewall.log

#    Envia mensagens com facilidade "LOCAL6" e criticidade "NOTICE" para o servidor de log remoto
#local6.=notice @$ip_address     # UDP
local6.=notice @@192.168.102.171:514     # TCP
EOL
<<com
cat >> /etc/ulogd.conf <<EOL
stack=log6:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,tr1:SYSLOG
stack=log7:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,tr2:SYSLOG

[log6]
group=6

[log7]
group=7 

[tr1]

file="/var/log/firewall.log"
sync=1
facility=LOG_LOCAL6
level=LOG_NOTICE

[tr2]

file="/var/log/firewall.log"
sync=1
facility=LOG_LOCAL6
level=LOG_INFO

EOL

com






#    Criar um novo arquivo de configuração para o logrotate em /etc/logrotate.d/rsyslog.
#nano /etc/logrotate.d/rsyslog

#     Adicionar o seguinte bloco de configuração ao arquivo /etc/logrotate.d/rsyslog
cat << EOF > /etc/logrotate.d/rsyslog 
/var/log/firewall.log {
    missingok
    daily
    rotate 5
    notifempty
    create    
    postrotate
        /usr/bin/killall -HUP rsyslogd 2> /dev/null || true
    endscript
}
EOF


#     Adicionar a seguinte linha ao arquivo /etc/crontab para agendar a execução diária do logrotate às 0h30min:
echo "30 0 * * * root /usr/sbin/logrotate /etc/logrotate.d/rsyslog" >> /etc/crontab


#     Reiniciar os serviços de log
killall ulogd
service rsyslog restart
/sbin/ulogd -d