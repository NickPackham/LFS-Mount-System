if not EPS_PurchasedMounts then
    EPS_PurchasedMounts = {}
end

local function EPS_GetAmountOfBuyableMounts()
    local number = 0

    for k, v in pairs(EPS_Mounts_Config.Mounts) do
        if not EPS_Mounts:IsMountPurchased(k) then
            number = number + 1
        end
    end

    return number
end

local function EPS_IsHangarOccupied_Text(hangar)
    if EPS_Mounts:IsHangarOccupied(hangar) then
        return "Occupied"
    else
        return "Empty"
    end
end

local function EPS_Mounts_MainMenu()
    local EPS_Purchasable_Count = EPS_GetAmountOfBuyableMounts()
    local EPS_Spawnable_Count = #EPS_PurchasedMounts[LocalPlayer():SteamID64()]
    local hangarmenu = nil
    local selectedmount = nil

    local EPS_Mounts_Frame = vgui.Create("XeninUI.Frame")
    EPS_Mounts_Frame:SetTitle("Mounts")
    EPS_Mounts_Frame:SetSize(ScrW() * 0.4, ScrH() * 0.4)
    EPS_Mounts_Frame:Center()
    EPS_Mounts_Frame:MakePopup()

    EPS_Mounts_Frame.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, XeninUI.Theme.Primary)
    end

    local EPS_Mounts_NavBar = vgui.Create("XeninUI.Navbar", EPS_Mounts_Frame)
    EPS_Mounts_NavBar:Dock(TOP)
    EPS_Mounts_NavBar.SwitchedTab = function(name)
        EPS_Mounts_NavBar:GetActive():SetVisible(true)

        if IsValid(hangarmenu) then
            hangarmenu:Remove()
        end
    end

    --[[

        Purchase Tab

    --]]

    local EPS_Mounts_PurchaseTab = nil
    local EPS_Mounts_SpawnTab = nil


    local EPS_Mounts_PurchaseTab = EPS_Mounts_NavBar:AddTab("Purchase", "DLabel")
    EPS_Mounts_PurchaseTab:SetParent(EPS_Mounts_Frame)
    EPS_Mounts_PurchaseTab:Dock(FILL)
    EPS_Mounts_PurchaseTab:SetText(" ")
    EPS_Mounts_PurchaseTab.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, XeninUI.Theme.Primary)

        if EPS_Purchasable_Count < 1 then
            draw.SimpleText("No available mounts for purchase.", "XeninUI.EPSMounts.Confirm", w * 0.5, h * 0.3, Color(255,255,255), TEXT_ALIGN_CENTER)
        end
    end

    local EPS_Mounts_PurchaseTab_Scroll = vgui.Create("XeninUI.Scrollpanel.Wyvern", EPS_Mounts_PurchaseTab)
    EPS_Mounts_PurchaseTab_Scroll:Dock(FILL)
    EPS_Mounts_PurchaseTab_Scroll:DockMargin(ScrW() * 0, ScrH() * 0.01, ScrW() * 0.005, ScrH() * 0)
    EPS_Mounts_PurchaseTab_Scroll.VBar:SetWide(0)


    for k, v in pairs(EPS_Mounts_Config.Mounts) do
        if not EPS_Mounts:IsMountPurchased(k) then
            local EPS_Mounts_PurchaseTab_Label = EPS_Mounts_PurchaseTab_Scroll:Add("DLabel")
            EPS_Mounts_PurchaseTab_Label:SetText(" ")
            EPS_Mounts_PurchaseTab_Label:SetSize(ScrW() * 0, ScrH() * 0.075)
            EPS_Mounts_PurchaseTab_Label:Dock(TOP)
            EPS_Mounts_PurchaseTab_Label:DockMargin(ScrW() * 0.005, ScrH() * 0, ScrW() * 0, ScrH() * 0.005)
            EPS_Mounts_PurchaseTab_Label:SetMouseInputEnabled(true)

            EPS_Mounts_PurchaseTab_Label.Paint = function(self, w, h)
                draw.RoundedBox(0, 0, 0, w, h, XeninUI.Theme.Navbar)
                draw.RoundedBox(0, 0, 0, w * 0.0075, h, XeninUI.Theme.Accent)

                draw.SimpleText(EPS_ShortenString(v.Name or "Not Valid", 40).." ("..DarkRP.formatMoney((v.Price or 0))..")", "XeninUI.EPSMounts.Label", w * 0.05, h * 0.175, Color(255, 255, 255), TEXT_ALIGN_LEFT)
                draw.SimpleText(EPS_ShortenString(v.Description or "Not Valid", 40), "XeninUI.EPSMounts.Confirm", w * 0.05, h * 0.5, XeninUI.Theme.Blue, TEXT_ALIGN_LEFT)
            end

            local EPS_Mounts_PurchaseTab_Purchase = vgui.Create("XeninUI.Button", EPS_Mounts_PurchaseTab_Label)
            EPS_Mounts_PurchaseTab_Purchase:SetText("Buy")
            EPS_Mounts_PurchaseTab_Purchase:SetFont("XeninUI.EPSMounts.Button")
            EPS_Mounts_PurchaseTab_Purchase:SetTextColor(Color(255, 255, 255))
            EPS_Mounts_PurchaseTab_Purchase:Dock(RIGHT)
            EPS_Mounts_PurchaseTab_Purchase.DoClick = function()
                if EPS_Mounts_PurchaseTab_Purchase:GetText() == "Confirm" then
                    EPS_Mounts_Frame:Remove()
                    net.Start("EPS_PurchaseMount") net.WriteString(k) net.SendToServer()
                else
                    EPS_Mounts_PurchaseTab_Purchase:SetText("Confirm")
                end
            end
            EPS_Mounts_PurchaseTab_Purchase.Paint = function(self, w, h)
                if self:IsHovered() then
                    if self:GetColor() ~= XeninUI.Theme.Accent then
                        self:SetColor(XeninUI.Theme.Accent)
                    end
                else
                    if self:GetColor() ~= Color(255,255,255) then
                        self:SetColor(Color(255,255,255))
                    end
                end
            end
        end
    end

    --[[

        Spawn Tab

    --]]

    local EPS_Mounts_SpawnTab = EPS_Mounts_NavBar:AddTab("Spawn", "DLabel")
    EPS_Mounts_SpawnTab:SetParent(EPS_Mounts_Frame)
    EPS_Mounts_SpawnTab:Dock(FILL)
    EPS_Mounts_SpawnTab:SetText(" ")

    EPS_Mounts_SpawnTab.Paint = function(self, w, h)
        draw.RoundedBox(6, 0, 0, w, h, XeninUI.Theme.Primary)

        if EPS_Spawnable_Count < 1 then
            draw.SimpleText("No available mounts for spawning.", "XeninUI.EPSMounts.Confirm", w * 0.5, h * 0.3, Color(255,255,255), TEXT_ALIGN_CENTER)
        end
    end

    local EPS_Mounts_SpawnTab_Return = vgui.Create("XeninUI.Button", EPS_Mounts_SpawnTab)
    EPS_Mounts_SpawnTab_Return:SetText("Return Current Mount")
    EPS_Mounts_SpawnTab_Return:SetFont("XeninUI.EPSMounts.Button")
    EPS_Mounts_SpawnTab_Return:SetTextColor(Color(255, 255, 255))
    EPS_Mounts_SpawnTab_Return:Dock(BOTTOM)
    EPS_Mounts_SpawnTab_Return.DoClick = function()
        net.Start("EPS_ReturnMount")
        net.SendToServer()
    end
            EPS_Mounts_SpawnTab_Return.Paint = function(self, w, h)
                if self:IsHovered() then
                    if self:GetColor() ~= XeninUI.Theme.Accent then
                        self:SetColor(XeninUI.Theme.Accent)
                    end
                else
                    if self:GetColor() ~= Color(255,255,255) then
                        self:SetColor(Color(255,255,255))
                    end
                end
            end

    local EPS_Mounts_SpawnTab_Scroll = vgui.Create("XeninUI.Scrollpanel.Wyvern", EPS_Mounts_SpawnTab)
    EPS_Mounts_SpawnTab_Scroll:Dock(FILL)
    EPS_Mounts_SpawnTab_Scroll:DockMargin(ScrW() * 0, ScrH() * 0.01, ScrW() * 0.005, ScrH() * 0)
    EPS_Mounts_SpawnTab_Scroll.VBar:SetWide(0)


    for k, v in pairs(EPS_PurchasedMounts[LocalPlayer():SteamID64()]) do
        if EPS_Mounts_Config.Mounts[v.Mount] then

        local EPS_Mounts_SpawnTab_Label_Menu = EPS_Mounts_SpawnTab_Scroll:Add("DLabel")
        EPS_Mounts_SpawnTab_Label_Menu:SetText(" ")
        EPS_Mounts_SpawnTab_Label_Menu:SetSize(ScrW() * 0, ScrH() * 0.075)
        EPS_Mounts_SpawnTab_Label_Menu:Dock(TOP)
        EPS_Mounts_SpawnTab_Label_Menu:DockMargin(ScrW() * 0.005, ScrH() * 0, ScrW() * 0, ScrH() * 0.005)
        EPS_Mounts_SpawnTab_Label_Menu:SetMouseInputEnabled(true)

        EPS_Mounts_SpawnTab_Label_Menu.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, XeninUI.Theme.Navbar)
            draw.RoundedBox(0, 0, 0, w * 0.0075, h, XeninUI.Theme.Accent)

            draw.SimpleText(EPS_ShortenString(EPS_Mounts_Config.Mounts[v.Mount].Name, 40), "XeninUI.EPSMounts.Label", w * 0.05, h * 0.175, Color(255, 255, 255), TEXT_ALIGN_LEFT)
            draw.SimpleText("Purchased: "..string.NiceTime((os.time() - (tostring(v.PurchaseTime) or tostring(0)))).." ago.", "XeninUI.EPSMounts.Confirm", w * 0.05, h * 0.5, XeninUI.Theme.Blue, TEXT_ALIGN_LEFT)
        end

        local EPS_Mounts_SpawnTab_Select = vgui.Create("XeninUI.Button", EPS_Mounts_SpawnTab_Label_Menu)
        EPS_Mounts_SpawnTab_Select:SetText("Select")
        EPS_Mounts_SpawnTab_Select:SetFont("XeninUI.EPSMounts.Button")
        EPS_Mounts_SpawnTab_Select:SetTextColor(Color(255, 255, 255))
        EPS_Mounts_SpawnTab_Select:Dock(RIGHT)
        EPS_Mounts_SpawnTab_Select.DoClick = function()
            if EPS_Mounts_SpawnTab_Select:GetText() == "Select" then
                EPS_Mounts_SpawnTab_Select:SetText("Confirm")
            else
                selectedmount = v.Mount
                EPS_Mounts_SpawnTab:SetVisible(false)

                local EPS_Mounts_SpawnTab_Hangars_Menu = vgui.Create("DLabel", EPS_Mounts_Frame)
                EPS_Mounts_SpawnTab_Hangars_Menu:Dock(FILL)
                EPS_Mounts_SpawnTab_Hangars_Menu:SetText(" ")
                EPS_Mounts_SpawnTab_Hangars_Menu:SetMouseInputEnabled(true)

                hangarmenu = EPS_Mounts_SpawnTab_Hangars_Menu


                local EPS_Mounts_SpawnTab_Hangars_Scroll = vgui.Create("XeninUI.Scrollpanel.Wyvern", EPS_Mounts_SpawnTab_Hangars_Menu)
                EPS_Mounts_SpawnTab_Hangars_Scroll:Dock(FILL)
                EPS_Mounts_SpawnTab_Hangars_Scroll:DockMargin(ScrW() * 0, ScrH() * 0.01, ScrW() * 0.005, ScrH() * 0)
                EPS_Mounts_SpawnTab_Hangars_Scroll.VBar:SetWide(0)
                EPS_Mounts_SpawnTab_Hangars_Scroll:SetMouseInputEnabled(true)

                for k, v in pairs(EPS_Mounts_Config.SpawnPositions) do
                    if v.Map ~= game.GetMap() then return false end

                    local EPS_Mounts_SpawnTab_Hangars_Label = EPS_Mounts_SpawnTab_Hangars_Scroll:Add("DLabel")
                    EPS_Mounts_SpawnTab_Hangars_Label:SetText(" ")
                    EPS_Mounts_SpawnTab_Hangars_Label:SetSize(ScrW() * 0, ScrH() * 0.075)
                    EPS_Mounts_SpawnTab_Hangars_Label:Dock(TOP)
                    EPS_Mounts_SpawnTab_Hangars_Label:DockMargin(ScrW() * 0.005, ScrH() * 0, ScrW() * 0, ScrH() * 0.005)
                    EPS_Mounts_SpawnTab_Hangars_Label:SetMouseInputEnabled(true)

                    EPS_Mounts_SpawnTab_Hangars_Label.Paint = function(self, w, h)
                        draw.RoundedBox(0, 0, 0, w, h, XeninUI.Theme.Navbar)
                        draw.RoundedBox(0, 0, 0, w * 0.0075, h, XeninUI.Theme.Accent)

                        draw.SimpleText(k.." ("..EPS_IsHangarOccupied_Text(k)..")", "XeninUI.EPSMounts.Label", w * 0.05, h * 0.175, Color(255, 255, 255), TEXT_ALIGN_LEFT)

                        draw.SimpleText("Distance: "..string.Explode(".", LocalPlayer():GetPos():Distance(v.Position) / 52.49)[1].."m", "XeninUI.EPSMounts.Confirm", w * 0.05, h * 0.5, XeninUI.Theme.Blue, TEXT_ALIGN_LEFT)
                    end

                        local EPS_Mounts_SpawnTab_Hangars_Select = vgui.Create("XeninUI.Button", EPS_Mounts_SpawnTab_Hangars_Label)
                        EPS_Mounts_SpawnTab_Hangars_Select:SetText("Select")
                        EPS_Mounts_SpawnTab_Hangars_Select:SetFont("XeninUI.EPSMounts.Button")
                        EPS_Mounts_SpawnTab_Hangars_Select:SetTextColor(Color(255, 255, 255))
                        EPS_Mounts_SpawnTab_Hangars_Select:Dock(RIGHT)
                        EPS_Mounts_SpawnTab_Hangars_Select.DoClick = function()
                            if EPS_Mounts_SpawnTab_Hangars_Select:GetText() == "Select" then
                                EPS_Mounts_SpawnTab_Hangars_Select:SetText("Confirm")
                            else
                                net.Start("EPS_SpawnMount")
                                    net.WriteString(selectedmount)
                                    net.WriteString(k)
                                net.SendToServer()

                                EPS_Mounts_Frame:Remove()
                            end
                        end

                        EPS_Mounts_SpawnTab_Hangars_Select.Paint = function(self, w, h)
                            if self:IsHovered() then
                                if self:GetColor() ~= XeninUI.Theme.Accent then
                                    self:SetColor(XeninUI.Theme.Accent)
                                end
                            else
                                if self:GetColor() ~= Color(255,255,255) then
                                    self:SetColor(Color(255,255,255))
                                end
                            end
                        end
                    end
                end
            end
            EPS_Mounts_SpawnTab_Select.Paint = function(self, w, h)
                if self:IsHovered() then
                    if self:GetColor() ~= XeninUI.Theme.Accent then
                        self:SetColor(XeninUI.Theme.Accent)
                    end
                else
                    if self:GetColor() ~= Color(255,255,255) then
                        self:SetColor(Color(255,255,255))
                    end
                end
            end
        end
    end

    EPS_Mounts_NavBar:SetActive("Purchase")
end

net.Receive("EPS_OpenMountMenu", function()
    EPS_Mounts_MainMenu()
end)

net.Receive("EPS_Mounts_UpdatePurchasedMounts", function()
    local tab = net.ReadTable()

    EPS_PurchasedMounts[LocalPlayer():SteamID64()] = tab
end)