-- Faster Teleporter Conversion v1.0.0
-- SmoothSpatula

log.info("Successfully loaded ".._ENV["!guid"]..".")

-- Helper mod
mods.on_all_mods_loaded(function() for k, v in pairs(mods) do if type(v) == "table" and v.hfuncs then Helper = v end end end)

-- Toml mod
mods.on_all_mods_loaded(function() for k, v in pairs(mods) do if type(v) == "table" and v.tomlfuncs then Toml = v end end end)

-- ========== Parameters ==========

local tp = nil

local default_params = {
    faster_teleporter_conversion_enabled = true
}

local params = Toml.load_cfg(_ENV["!guid"])

if not params then
    Toml.save_cfg(_ENV["!guid"], default_params)
    params = default_params
end

-- ========== ImGui ==========

gui.add_to_menu_bar(function()
    local new_value, clicked = ImGui.Checkbox("Enable Faster Teleporter Conversion", params["faster_teleporter_conversion_enabled"])
    if clicked then
        params["faster_teleporter_conversion_enabled"] = new_value
        Toml.save_cfg(_ENV["!guid"], params)
    end
end)

-- ========== Main ==========

gm.post_script_hook(gm.constants.director_populate_interactable_spawn_array, function(self, other, result, args)
    tp = Helper.get_teleporter()
end)

gm.pre_script_hook(gm.constants.__input_system_tick, function()
    if not params["faster_teleporter_conversion_enabled"] or not tp then return end

    tp.exp_cd = 0
end)