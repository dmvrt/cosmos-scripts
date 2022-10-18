#создаем файл скрипта : 

nano spam.sh

#вставляем скрипт ( меняем пароли\адреса  ) :


#!/bin/bash

#  --- НАСТРОЙКИ КОНФИГУРАЦИИ СКРИПТА ---
# ИМЯ ЛОГ ФАЙЛА
LOG=haqqtx.log
# ПАРОЛЬ КОШЕЛЬКА
PWD=Bz2QXxfCXPKqXLdYAyRCyMHgu
# ОБЩЕЕ КОЛИЧЕСТВО ТРАНЗАКЦИЙ
TX_COUNT=100
# АДРЕС С КОТОРОГО ОТПРАВЛЯЕМ
FROM_WALLET_ADDRESS=<ADDRESS>
# АДРЕС КУДА ОТПРАВЛЯЕМ
TO_WALLET_ADDRESS=<Va>
# СУММА ОТПРАВЛЯЕМОГО (Пример: "1adenom")
TX_AMOUNT=1adenom
# ВРЕМЕННОЙ ИНТЕРВАЛ МЕЖДУ ТРАНЗАКЦИЯМИ (Пример: 1 секунда )
DELAY=0.000000001
# CHAIN ID
NODE_CHAIN=<CHAIN_ID>
# КОМИССИЯ ТРАНЗАКЦИИ (Пример: "500adenom")
TX_FEES=500adenom
# NODE TCP ( ФЛАГ ДЛЯ ТЕХ У КОГО НЕСКОЛЬКО НОД НА ОДНОМ СЕРВЕРЕ ) или заменить при установке ноды**
IC_TCP=tcp://127.0.0.1:26652
# NOTE (текст сообщения бывший флаг --memo)
NOTE=<ТЕКСТ>
# КОНЕЦ
light_green='\033[92m'
blank='\033[0m'
c=1
printf "$light_green Sending $TX_COUNT TX:$blank\n"
(
  while [ $c -le $TX_COUNT ]
  do
      TX_STATUS=$(echo $PWD | systemd tx bank send $FROM_WALLET_ADDRESS $TO_WALLET_ADDRESS $TX_AMOUNT --chain-id=$NODE_CHAIN --gas=250000 --fees=$TX_FEES --node $IC_TCP --note $NOTE -y)
      TX_HASH=$(echo $TX_STATUS | jq -r .txhash)
      echo -e "$light_green TX $c $blank- $TX_HASH"
      echo $TX_HASH >> $LOG
        sleep $DELAY
      ((c=c+1))
  done
)


#делаем файл исполняемым

chmod u+x spam.sh

#запускаем 

./spam.sh
