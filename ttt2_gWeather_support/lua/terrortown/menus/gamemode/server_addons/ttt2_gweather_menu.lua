CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.title = "ttt2_gweather_title"

-- actual menu stuff
function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "ttt2_gweather_form1")
	form:MakeHelp({
        label = "ttt2_gweather_help1",
    })
	form:MakeCheckBox({
        label = "ttt2_gweather_label_entitydamage",
        serverConvar = "gw_weather_entitydamage",
    })
	form:MakeSlider({
        label = "ttt2_gweather_label_weathertime",
        serverConvar = "gw_weather_lifetime",
        min = 0,
        max = 2000,
        decimal = 0,
    })
	
	form:MakeHelp({
        label = "ttt2_gweather_help2",
    })
	form:MakeCheckBox({
        label = "ttt2_gweather_label_windeffectsplayers",
        serverConvar = "gw_windphysics_player",
    })
	form:MakeCheckBox({
        label = "ttt2_gweather_label_windeffectsprops",
        serverConvar = "gw_windphysics_prop",
    })
	form:MakeSlider({
        label = "ttt2_gweather_label_windeffecttime",
        serverConvar = "gw_nextwind",
        min = 0.1,
        max = 2,
        decimal = 1,
    })
	
	form:MakeHelp({
        label = "ttt2_gweather_help3",
    })
	local temperatureEffectsPlayers = form:MakeCheckBox({
        label = "ttt2_gweather_label_temperatureeffects",
        serverConvar = "gw_tempaffect",
    })
	
	local form2 = vgui.CreateTTT2Form(parent, "ttt2_gweather_form2")
	form2:MakeHelp({
        label = "ttt2_gweather_help4",
    })
	form2:MakeSlider({
        label = "ttt2_gweather_label_weatherchance",
        serverConvar = "ttt2_cv_gweather_chance",
        min = 0,
        max = 1,
        decimal = 2,
    })
	form2:MakeSlider({
        label = "ttt2_gweather_label_weathertiers",
        serverConvar = "ttt2_cv_gweather_max_tier",
        min = 1,
        max = 6,
        decimal = 0,
    })
end

function CLGAMEMODESUBMENU:PopulateButtonPanel(parent)
	-- Delete weather
    local buttonDeleteWeather = vgui.Create("DButtonTTT2", parent)
    buttonDeleteWeather:SetText("ttt2_gweather_button_delete")
    buttonDeleteWeather:SetSize(300, 45)
    buttonDeleteWeather:SetPos(20, 20)
    buttonDeleteWeather.DoClick = function(btn)
        net.Start("ttt2_delete_weather")
		net.SendToServer()
    end
	
	-- Add random weather
    local buttonAddRandomWeather = vgui.Create("DButtonTTT2", parent)
    buttonAddRandomWeather:SetText("ttt2_gweather_button_add")
    buttonAddRandomWeather:SetSize(300, 45)
    buttonAddRandomWeather:SetPos(340, 20)
    buttonAddRandomWeather.DoClick = function(btn)
		net.Start("ttt2_add_random_weather")
		net.SendToServer()
    end
end

function CLGAMEMODESUBMENU:HasButtonPanel()
    return true
end