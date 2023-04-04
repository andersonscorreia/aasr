#!/bin/bash
#criando arvore de diretorios
mkdir -p /q6/d1/{d11,d12,d13},d2/{d21,d22,d23}} echo arquivo1 >> /q6/d2/d23/arquivo1
tree q6
#criando grupos
groupadd operadores
groupadd supervisores groupadd gerentes
#criando usuarios
adduser operador1
adduser operador2
adduser supervisor1
adduser supervisor2
adduser gerente1
adduser gerente2
gpasswd
-a operador1 operadores
gpasswd -a operador2 operadores
gpasswd -a supervisor1 supervisores gpasswd -a supervisor2 supervisores
gpasswd -a gerentel gerentes
gpasswd -a gerente2 gerentes

#permissoes
setfacl -m g:supervisores: rw,g: gerentes:rw,g:operadores:rw /q6/d1
setfacl -m g:supervisores: rw,g: gerentes:rw,g:operadores:rw /q6/d2
setfacl -m g:supervisores:rwx,g: gerentes:rwx, g:operadores:rwx /q6/d1/d11
setfacl -m g:supervisores:rwx,g: gerentes:rwx,g:operadores:rx /q6/d1/d12
setfacl -mg:supervisores:rx,ggerentes:rwx,g:operadores:rx /q6/d1/d13
setfacl -m g:supervisores:rx,g: gerentes:rwx,g:operadores:rx /q6/d2/d21 /q6/d2/d22 /q6/d2/d23
#getfacl -br /q6

