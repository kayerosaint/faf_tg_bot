import telebot
import subprocess
from dotenv import load_dotenv
import os
import random

load_dotenv()

# добавляем возможность извлекать id стикеров из файла
def load_sticker_ids(file):
    with open(file, "r") as f:
        sticker_ids = [line.strip() for line in f]
    return sticker_ids

# get from .env file (not secure in container)
#API = os.environ.get("API")
#CHAT_ID = os.getenv("CHAT_ID")

# get from secrets in docker-compose
with open('/run/secrets/api_id', 'r') as secret_file:
    API = secret_file.read().strip()

with open('/run/secrets/chat_id', 'r') as secret_file:
    CHAT_ID = secret_file.read().strip()

STICKER_FILE = "./ids"
STICKER_IDS = load_sticker_ids(STICKER_FILE)

bot = telebot.TeleBot(API)

@bot.message_handler(commands=['play'])
def play(message):
    user_id = message.from_user.id
    first_name = message.from_user.first_name
    last_name = message.from_user.last_name
    file = open("./config/get.md", "w")
    file.write(f"{first_name} будет играть.")
    file.close()
    subprocess.run(["./run.sh"])
    sticker_id = random.choice(STICKER_IDS)
    bot.send_sticker(CHAT_ID, sticker_id)

@bot.message_handler(commands=['notplay'])
def notplay(message):
    user_id = message.from_user.id
    first_name = message.from_user.first_name
    last_name = message.from_user.last_name
    file = open("./config/get.md", "w")
    file.write(f"{first_name} не будет играть.")
    file.close()
    subprocess.run(["./not_run.sh"])

@bot.message_handler(commands=['whoplaytoday'])
def whoplaytoday(message):
    user_id = message.from_user.id
    first_name = message.from_user.first_name
    last_name = message.from_user.last_name
    subprocess.run(["./who_play.sh"])

@bot.message_handler(func=lambda m: True)
def unknown(message):
    if message.text.startswith('/'):
        bot.reply_to(message, "Такой комманды не существует. Вот список доступных комманд:\n"
                             "/play - буду играть\n"
                             "/notplay - не буду играть\n"
                             "/whoplaytoday - кто играет сегодня?")

bot.infinity_polling()
