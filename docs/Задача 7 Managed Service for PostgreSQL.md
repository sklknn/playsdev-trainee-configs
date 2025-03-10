## Создать инстанс для базы данных используя Managed Service for PostgreSQL. 

Перейти из консоли управления в Managed Service for PostgreSQL и создать кластер

![docs/Pasted image 20250307142026.png](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250307142026.png)
Кластер не может быть создан без базы данных, по этому заполняем поля `имя базы данных`, `имя пользователя` и `пароль`

![[Pasted image 20250307141613.png]](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250307141613.png)
Указать хосты для базы кластера. Если нужен доступ из вне сети yandex cloud - установить в настройках хоста публичный доступ = да . Каждый хост хранит реплицируемую копию бд. Для обеспечения HA можно указать несколько хостов в разных зонах доступности. Для скоращения потребления ресурсов колличество хостов можно уменьшить.

![[[Pasted image 20250307142147.png]]](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250307142147.png)
## Подключиться к ней через pgAdmin, установленный на ПК и через командную строку терминала linux (через терминальный клиент psql). 

1. Сохранить сертификат на машину, с которой планируете подключаться к базе данных
```bash
mkdir -p ~/.postgresql && \
wget "https://storage.yandexcloud.net/cloud-certs/CA.pem" \
    --output-document ~/.postgresql/root.crt && \
chmod 0600 ~/.postgresql/root.crt
```
2. Подключиться через клиент
	1. При использовании pgAdmin выбрать пункт `Add New Server` , указать произвольное имя сервера, во вкладке Connections указать параметры подключения, во вкладке Parameters указать `sslmode` как `verify-full` , а так-же добавить параметр `Client certificate key`  выбрав для него скаченный ранее файл сертификата

![[[Pasted image 20250307143325.png]]](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250307143325.png)

![[[Pasted image 20250307143827.png]]](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250307143827.png)
	3. Для подключения через psql можно использовать команду ниже, при подключении будет запрошен пароль выбранного пользователя
```bash
psql "host=$(Имя хоста кластера) \
    port=$(Порт кластера) \
    sslmode=verify-full \
    dbname=$(Имя базы данных) \
    user=$(Имя пользователя бд) \
    target_session_attrs=read-write"
```


## Cоздать postgres базу данных jundb. Создать в ней таблицу под названием credit_cards_numbers.
1. Выбрать созданный кластер
2. Перейти во вкладку `Базы данных` 
3. Нажать кнопку `Создать базу данных`

![[[Pasted image 20250307144206.png]]](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250307144206.png)
5. Указать название базы данных и её владельца. Если в кластере есть другая, заранее существующая база данных - можно выбрать её в качестве шаблона
6. Создать таблицу можно просто написав SQL запрос, в pgAdmin для этого есть `Query tool`
```SQL
CREATE TABLE credit_cards_numbers (
	card_number VARCHAR(16)
);
```
## Руками сделать резервную копию. Удалить базу данных. Восстановить её из snapshots. Проверить наличие созданной таблицы через pgAdmin и терминальный клиент psql. 
1. Во вкладке `Резервные копии` выбрать `Создать резевную копию`

![[[Pasted image 20250307150814.png]]](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250307150814.png)

2. Во вкладке `Базы данных` удалить нужную базу данных

![[[Pasted image 20250307150854.png]]](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250307150854.png)

3. Восстановить кластер из резервной копии

![[[Pasted image 20250307151057.png]]](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250307151057.png)

![[[Pasted image 20250307151149.png]]](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250307151149.png)

4. Проверяеи наличие удаленной бд и таблицы
	1. В psql:
![[[Pasted image 20250307153108.png]]](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250307153108.png)

 	2. В pgAdmin просто подключиться к заново созданному кластеру. Удаленная база данных будет в списке доступных. Найти таблицу можно с помощью инструмента `Search Objects`
![[[Pasted image 20250307153342.png]]](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250307153342.png)

## Настроить её бэкапы по расписанию. Когда сделан автоматический backup, удалить текущий инстанс и восстановить его из бэкапа. Проверить наличие созданной таблицы credit_cards_numbers через pgAdmin и терминальный клиент psql.

1. Изменить кластер, выбрав в графе `Дополнительные настройки` нужные опции (Время, срок хранения и период, в который могут выполняться резервные копии)

![[[Pasted image 20250307153720.png]]](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250307153720.png)

2. Удалить интсанс в Managed Service for PostgreSQL / Кластеры. Нас предупредят, что резервные копии, созданные в инстансе, будут храниться 7 дней.
3. Перейти в Managed Service for PostgreSQL / Резервные копии. Тут храняться все сделанные резервные копии всех кластеров.
4. Восстановить из созданного по расписанию backup'a(У него будет тип automated) и удалить бд как пункте выше

![[[Pasted image 20250307155633.png]]](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250307155633.png)
	
 	1. Подключаемся через psql и смотрим наличие нашей таблицы
 
![[[Pasted image 20250307161125.png]]](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250307161125.png)
	
 	2. Ровно так-же проверяем её в pgAdmin
 
![[[Pasted image 20250307161306.png]]](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250307161306.png)

## Mongodb в cloud compute

Установка ключей
```bash
sudo apt-get install gnupg curl

curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
   --dearmor
   
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list
```
Благодаря этому можно установить mongodb из официального репозитория mongodb
```bash
sudo apt-get update

sudo apt-get install -y mongodb-org
```
И запускаем 
```bash
sudo systemctl start mongod
#Либо sudo systemctl enable --now mongod
```
Стандартный инстанс mongodb не содержит настроенной конфигурации для пользователей и открыт только для подключений с localhost , по этому подключиться на него можно будет только с машины, на которой поднят сервис 

Чтобы это исправить мы можем просто изменить параметр bindIp либо через аргумент команды запуска `--bind_ip` либо в файле конфигурации `/etc/mongod.conf` 

![[[Pasted image 20250310154243.png]]](https://github.com/sklknn/playsdev-trainee-configs/blob/e5e6367fd6c16f0d6c62e6adc915e2347390b8fd/docs/Pasted%20image%2020250310154243.png)

Теперь можно подключиться используя любой клиент, например mongosh
```bash
mongosh 'mongodb://158.160.7.171:27017'
```

##  Репликация в mongodb
Укажем в /etc/mongod.conf имя нашего пула для репликации

```conf
replication:
    replSetName: "rs1"
```
Затем подключиться к mongodb и выполнить комнады
```
rs.initiate()
rs.add("Тут ip адрес реплики")
```

После можно посмотреть статус пула репликации через `rs.status()` 
В поле members должно быть несколько значений с разными id - это id наших серверов с mongodb

Подключившись к любому из хостов через клиент можно увидеть его статус - 
`rs1 [direct: secondary] dbname>`