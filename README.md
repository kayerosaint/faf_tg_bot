## Telegram BOT for FAF (Supreme Commander)

clone last version:
    
git clone --branch main https://github.com/kayerosaint/faf_tg_bot/

Then you need to create in current dir config files with your telegram API and CHAT ID

/config/api_id.cfg

/config/chat_id.cfg

_Pay attention to the directory tree_

![Pay attention to the directory tree.](https://github.com/kayerosaint/faf_tg_bot/blob/main/images/2024-01-24_17-17-26.jpg)

**example for conf files:**

chat_id.cfg

-11111111111111

api_id.cfg

66666666666:AAAAAAAAAAAAAAAAAAAAAAAAA-AAAAA

where

66666666666 - bot id

AAAAAAAAAAAAAAAAAAAAAAAAA-AAAAA - API

## Then just run command:

docker-compose up

## Currently, the tg bot commands are scripted and supported:

/play
/notplay
/whoplaytoday