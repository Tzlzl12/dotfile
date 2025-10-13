local default_model = "gemini-2.5-pro-exp-03-25"
local default_model_inline = "gemini-2.5-flash-preview-04-17"
local current_model = default_model
local current_model_inline = default_model_inline

local parse_model = function(model)
  if model:find "/" and model:sub(-4) == "free" then
    return "openrouter"
  end
  return model:match "^[^%-]+"
end

local adapter = parse_model(current_model)
local adapter_inline = parse_model(current_model_inline)
-- 通过输入来获取adapter
local available_models = {
  "gemini-2.5-flash-preview-04-17",
  "gemini-2.5-pro-exp-03-25",
  "gemini-2.0-flash",
  "gemini-2.0-pro-exp-02-05",
  "deepseek/deepseek-chat-v3-0324:free",
  "google/gemini-2.5-pro-exp-03-25:free",
  "arliai/qwq-32b-arliai-rpr-v1:free",
}

local model_selection = {
  "inline",
  "model",
}

local function select_model()
  vim.ui.select(available_models, {
    prompt = "Select  Model:",
  }, function(choice)
    if choice then
      current_model = choice
      adapter = parse_model(current_model)
      vim.notify("Selected model: " .. current_model)
    end
  end)
end
local function select_model_inline()
  vim.ui.select(available_models, {
    prompt = "Select  Model:",
  }, function(choice)
    if choice then
      current_model_inline = choice
      adapter_inline = parse_model(current_model_inline)
      vim.notify("Selected Inline model: " .. current_model_inline)
    end
  end)
end

local function change_model()
  vim.ui.select(model_selection, {
    prompt = "Change Mode:",
  }, function(choice)
    if choice == "inline" then
      select_model_inline()
    elseif choice == "model" then
      select_model()
    end
  end)
end
