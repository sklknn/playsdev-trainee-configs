## На основе прошлой задачи создать ещё два сервера в nginx и сделать переход по /redblue так, чтобы при обновлении страницы происходило чередование красной и синей страниц. Для этого необходимо задействовать балансировку и проксирование. 

Что из этого не работает?
- [x] Dynamic upstream? //commercial
- [x] Nginx api? //commercial
- [x] state zone? //commercial
- [x] HA? //commercial
- [x] up/down in upstream? //Нужен reload
- [ ] Что-то в модуле proxy_pass?
`proxy_next_upstream` может быть установлен в `off` 
- [ ] Что-то внутри самих серверов на которые уходит запрос?
АХАХАХ Я СХОЖУ С УМА


## При выводе логов показать, куда проксировался запрос клиента. 

```
log_format redbluelog '$server_name to: $upstream_addr [$request]';
```

```
access_log /etc/nginx/access.log redbluelog;
```

```bash
sudo tail -f /etc/nginx/access.log
```
## Создать переход на /image1 для jpg и /image2 для png. 

## Сделать регулярное выражение для картинок: если формат jpg, то картинка будет перевёрнута с помощью nginx.