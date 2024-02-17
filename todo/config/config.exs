import Config

config :todo,
  http_port: 5454,
  database_folder: "./persist"

import_config "#{config_env()}.exs"
