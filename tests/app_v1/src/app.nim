import jester

import dotenv

import app/routes/api


initDotEnv().load()


routes:
  extend api, "/api"
