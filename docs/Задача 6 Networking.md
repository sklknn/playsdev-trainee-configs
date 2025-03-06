Создать 2 сервера: 1-ый паблик ( бастион хост), 2-ой сервер - приватный (нет публичного IP) Написать скрипт, который будет храниться на бастион хосте и сможет логиниться на приватный сервер по ssh и выполнять там команду обновления пакетов (apt update). 

Установить и настроить WireGuard или аналоги(openvpn например и тд) и подключиться через него к приватной машине 
```bash
wg genkey > privatekey

wg pubkey < privatekey > publickey

ip link add wg0 type wireguard

ip addr add 10.0.0.2/24 dev wg0

wg set wg0 private-key ./privatekey
ip link set wg0 up

wg set wg0 peer $peerPUBLICkey allowed-ips 10.0.0.1/32 endpoint $PEERIP:$PEERWGPORT
```

Проверить циркуляцию пакетов ssh через tcpdump (через указание интерфейса и напраления и через интерейс any - объяснить разницу)
```bash
sudo tcpdump -i wg0 dst port 22
```
wg0 можно поменять на any, разница будет в отображении всех пакетов приходящих на порт 22, вместо всех пакетов, проходящих через vpn