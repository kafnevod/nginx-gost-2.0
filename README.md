# Установка nginx-ссервера от cryptopro под ALTLinux

Общая процедура установки описана в документе:
[Настройка nginx для работы с сертификатами ГОСТ 2012 года](https://www.cryptopro.ru/forum2/default.aspx?g=posts&t=12505)

Для диистрибутивов семейства ALTLinux требуются определенные изменения, описанные в данном документе.

## Установка nginx-сервера

Указанная в документе процедура `install-nginx.sh` не работает для дистрибутивов ALTLinux по следующим причинам:
- ALTLinux как и дистрибутивы centos, red hatиспользует пакеты RPM, но командой установки пакетов является команда `apt-get`, а не `yum`;
- для установки компиляторов `gcc`, `gcc-c++` требуется указать конкретную версию (в нашем случае 4.7) компиляторов из доступного набора.

Данный скрипт был доработан и размещен в git репозитории под аналогичным именем [install-nginx.sh](https://github.com/kafnevod/nginx-gost-2.0/blob/master/install-nginx.sh).
Кроме этого указанный скрипт устанавливает ALTLinux-пакет `cryptopro-preinstall`, содержащий необходимые зависимые RPM-пакеты (`opensc`, `pcsc-lite`,  `pcsc-lite-rutokens`, `pcsc-lite-ccid`) и  sheel-скрипт `/etc/bashrc.d/cryptopro-paths.sh` устанавливающий переменную PATH для вызова команд `cprocsp` из каталогов `/opt/cprocsp/bin/', `/opt/cprocsp/sbin/'.

Перед установкой nginx необходимо в каталог, где  размещен скрипт `install-nginx.sh` (здесь и далее каталог `/root/`) поместить требуемую X64/RPM версию `КриптоПро CSP/UNIX` со страницы [КриптоПро CSP - Загрузка файлов](https://www.cryptopro.ru/products/csp/downloads).

В нашем слечае это сертифицироанная версия 
```
КриптоПро CSP 4.0 для Linux (x64, rpm)
Контрольная сумма
ГОСТ: 5069CD5888780A5C97744D31D786073E46462DD23B92A3FF8E81509CD6D96F4F
MD5: eba649ae2c974a8c9d0cd69d2b508ae7
```
Скаченный файл имеет имя `linux-amd64.tgz`.




## Установка библиотек libskk-.1.1

### Библиотека от CryptoPro

[Установка КриптоПро CSP](https://www.altlinux.org/%D0%9A%D1%80%D0%B8%D0%BF%D1%82%D0%BE%D0%9F%D1%80%D0%BE#%D0%A3%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BA%D0%B0_%D0%9A%D1%80%D0%B8%D0%BF%D1%82%D0%BE%D0%9F%D1%80%D0%BE_CSP)
```
# apt-get install cryptopro-preinstall
```


https://www.cryptopro.ru/products/csp/downloads#latest_csp50_linux
КриптоПро CSP 5.0 для Linux (x64, rpm) - linux-amd64.tgz
```
# tar xvzf linux-amd64.tgz
# cd linux-amd64
# apt-get install cprocsp-curl* lsb-cprocsp-base* lsb-cprocsp-capilite* lsb-cprocsp-kc1* lsb-cprocsp-rdr-64*
# apt-get install lsb-cprocsp-ca-certs*
```
В каталог `/opt/cprocsp/` установится неободимый софт в подкаталоги 
`bin`,  `lib`,  `sbin`,  `share`.

Добавление в тропу `PATH` каталогов `/opt/cprocsp/bin/`, `/opt/cprocsp/sbin/`
```
# .  /etc/bashrc.d/cryptopro-paths.sh
```

Генерация ключей:
```
# wget https://raw.githubusercontent.com/fullincome/scripts/master/nginx-gost/install-certs.sh && chmod +x install-certs.sh
# ./install-certs.sh
```
Необходимо ввести на клавиатуре длинную последовательность символов, а затем дважды ввести выбранный пароль для ключа.

Экспорт сертификата:
```
/opt/cprocsp/bin/amd64/certmgr -export -cert -dn "CN=srvtest" -dest '/etc/nginx/srvtest.cer'
```

