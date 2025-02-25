## Создать инстанс в yandex cloud наименьшего тира.
ну как бы да
## Создать там пользователей user1 и user2. user1 должен заходить каждый раз только по ssh ключу на инстанс, а user2 должен каждый раз вводить свой пароль при попытке зайти на инстанс.
```bash
sudo adduser user1

sudo adduser user2
```

```sshd config
Match User user1
	PasswordAuthentication no
	PubkeyAuthentication yes

Match User user2
	PasswordAuthentication yes
	PubkeyAuthentication no
```
Не забыть закинуть user1 ключ в .ssh/authorized_keys
## user1 должен иметь доступ к sudo, а user2 - нет.
```bash
sudo usermod -aG sudo user1
```
Либо менять в /etc/sudoers
## Под пользователем user1 создать документ. Используя права доступа сделать так - чтоб пользователь user2 не смог прочитать содержимое документа.
chmod []00
## Создать нового пользователя user3, настроить для него интерпретатор по умолчанию sh
```bash
chsh 
```