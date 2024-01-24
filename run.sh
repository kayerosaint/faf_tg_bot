#!/bin/bash

# get from .env file (not secure in container)
#chat_id=$(awk -F '=' 'function t(s){gsub(/[[:space:]]/,"",s);return s};/^CHAT_ID/{v=t($2)};END{printf "%s\n",v}' ./config/.env)
#api_id=$(awk -F '=' 'function t(s){gsub(/[[:space:]]/,"",s);return s};/^API/{v=t($2)};END{printf "%s\n",v}' ./config/.env)

# get from secrets in docker-compose
chat_id=$(cat /run/secrets/chat_id)
api_id=$(cat /run/secrets/api_id)

extract=$(cat ./config/get.md)
extr_tbl=$(awk -F' ' '{print $1}' ./config/get.md)

if ! apt list --installed | grep postgresql &>/dev/null ; then sudo apt-get install postgresql-client -y ; fi

cur_date=$(date +%Y-%m-%d)
# create db
export PGPASSWORD=postgres
if ! psql -h db -U postgres -tc "SELECT 1 FROM pg_database WHERE datname = 'fafusers'" | grep -q 1 ; then
    psql -h db -U postgres -c "CREATE DATABASE fafusers"
fi
# create table
if ! psql -h db -U postgres -d fafusers -tc "SELECT 1 FROM pg_tables WHERE tablename = 'megausers'" | grep -q 1 ; then 
psql -h db -U postgres -d fafusers -c "CREATE TABLE megausers (comrades CHAR(20), date DATE);"
fi
# add data
psql -h db -U postgres -d fafusers -c "INSERT INTO megausers(comrades, date) SELECT '$extr_tbl', '$cur_date' WHERE NOT EXISTS (SELECT 1 FROM megausers WHERE comrades = '$extr_tbl' AND date = '$cur_date');"

api_id_encoded=$(echo -n "$api_id" | jq -sRr @uri)

curl --data "chat_id=$chat_id&text=$extract" https://api.telegram.org/bot$api_id_encoded/sendMessage?
