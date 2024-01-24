#!/bin/bash
# get from .env file (not secure in container)
#chat_id=$(awk -F '=' 'function t(s){gsub(/[[:space:]]/,"",s);return s};/^CHAT_ID/{v=t($2)};END{printf "%s\n",v}' ./config/.env)
#api_id=$(awk -F '=' 'function t(s){gsub(/[[:space:]]/,"",s);return s};/^API/{v=t($2)};END{printf "%s\n",v}' ./config/.env)

# get from secrets in docker-compose
chat_id=$(cat /run/secrets/chat_id)
api_id=$(cat /run/secrets/api_id)

api_id_encoded=$(echo -n "$api_id" | jq -sRr @uri)
curl --data "chat_id=$chat_id&text=Приветствую командоры! Кто сегодня будет играть? Команды можете посмотреть набрав  /  в чате " https://api.telegram.org/bot$api_id_encoded/sendMessage?
