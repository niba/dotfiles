local Path = require("plenary.path")
---@class core.session
local M = {}
-- local session_dir = utils.join_paths(vim.fn.stdpath("data") --[[@as string]], "nextsessions") --[[@as string]]
-- local session_dir = Path.joinpath(vim.fn.stdpath("data") --[[@as string]], "nextsessions")
local session_dir = Path:new(vim.fn.stdpath("data"), "nextsessions")
