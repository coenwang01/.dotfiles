require("saturn.basic"):init()

local log = require("saturn.plugins.log")
log:debug("Starting SaturnVim")

local plugin_loader = require("saturn.plugin_loader")
plugin_loader.init()

local configs = require("saturn.configs")
configs.init()

configs.custom_init()
local plugins = require("saturn.plugins")
plugin_loader.load({ plugins })

configs.config()
require("saturn.plugins.theme").config()
require("saturn.plugins.lsp").setup()