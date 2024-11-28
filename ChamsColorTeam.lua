local dwEntities = game:GetService("Players")
local dwLocalPlayer = dwEntities.LocalPlayer 
local dwRunService = game:GetService("RunService")

local settings_tbl = {
    ESP_Enabled = true,
    ESP_TeamCheck = false,
    Chams = true,
    Chams_Transparency = 0.5 -- Прозрачность (0 = непрозрачно, 1 = полностью прозрачно)
}

function destroy_chams(char)
    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("Highlight") then
            v:Destroy()
        end
    end
end

dwRunService.Heartbeat:Connect(function()
    if settings_tbl.ESP_Enabled then
        for _, player in ipairs(dwEntities:GetPlayers()) do 
            if player ~= dwLocalPlayer then
                if player.Character and
                   player.Character:FindFirstChild("HumanoidRootPart") and 
                   player.Character:FindFirstChild("Humanoid") and 
                   player.Character:FindFirstChild("Humanoid").Health > 0 then

                    if not settings_tbl.ESP_TeamCheck or player.Team ~= dwLocalPlayer.Team then
                        local char = player.Character
                        
                        if settings_tbl.Chams then
                            if not char:FindFirstChild("ChamsHighlight") then
                                local highlight = Instance.new("Highlight", char)
                                highlight.Name = "ChamsHighlight"
                                highlight.FillColor = player.TeamColor.Color -- Устанавливаем цвет команды
                                highlight.FillTransparency = settings_tbl.Chams_Transparency
                                highlight.OutlineColor = player.TeamColor.Color
                                highlight.OutlineTransparency = 0 -- Контур непрозрачный
                            else
                                -- Обновляем цвет чамса, если он уже создан
                                local highlight = char:FindFirstChild("ChamsHighlight")
                                highlight.FillColor = player.TeamColor.Color
                                highlight.OutlineColor = player.TeamColor.Color
                            end
                        else
                            destroy_chams(char)
                        end
                    else
                        destroy_chams(player.Character)
                    end
                else
                    destroy_chams(player.Character)
                end
            end
        end
    else
        for _, player in ipairs(dwEntities:GetPlayers()) do 
            if player ~= dwLocalPlayer and player.Character then
                destroy_chams(player.Character)
            end
        end
    end
end)
