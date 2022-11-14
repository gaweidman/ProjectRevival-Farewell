local PLUGIN = PLUGIN
PLUGIN.name = "Combine HUD"
PLUGIN.author = "Elec / ZeMysticalTaco"
PLUGIN.description = "Facial Recognition for Clockwork, adapted for use on HELIX and CMRP, thanks for the code, Elec!"

ix.config.Add("code_mpf", "ASSIST, DEFEND", "The font used to display titles.", nil, {
    category = "Miscellaneous"
})

ix.config.Add("code_overwatch", "ASSIST, SACRIFICE", "The font used to display titles.", nil, {
    category = "Miscellaneous"
})

--[[ix.command.Add("CharSetDivision", {
    syntax = "<string Player>",
    adminOnly = true,
    description = "Set a players' CP Division.",
    arguments = {ix.type.character, ix.type.string},
    OnRun = function(self, client, target, arguments)
        if target then
            target:SetData("mpfdivision", arguments)
            target.player:SetNetVar("mpfdivision", arguments)
            ix.util.Notify(client:Name() .. " has set " .. target.player:Name() .. "'s division to " .. arguments)
        end
    end
})]]

--[[hook.Add("PlayerSpawn", "ixSetDivision", function(ply)
    if ply:GetChar() then
        ply:SetNetVar("mpfdivision", ply:GetChar():GetData("mpfdivision", ""))
    end
end)]]

if CLIENT then
    -- hud
    local alphas = {}
    local sizes = {}
    local str_lens = {}

    local function MatrixText(text, font, x, y, color, scale, rotation)
        surface.SetFont(font)
        local matrix = Matrix()
        matrix:Translate(Vector(x, y, 1))
        matrix:Scale(scale or Vector(1, 1, 1))
        matrix:Rotate(rotation or Angle(0, 0, 0))
        cam.PushModelMatrix(matrix)
        --surface.SetTextPos(0, 0)
        --surface.SetTextColor(color.r, color.g, color.b, color.a)
        --surface.DrawText(text)
        draw.SimpleTextOutlined(text, font, 0, 0, Color(color.r, color.g, color.b, color.a), nil, nil, 4, Color(0, 0, 0, 255))
        cam.PopModelMatrix()
    end

    surface.CreateFont("FaceRecog", {
        font = "Roboto",
        size = 120,
        antialias = true
    })

    function PLUGIN:HUDPaint()
        if not LocalPlayer():HasBiosignal() then
            return
        end

        for k, v in pairs(player.GetAll()) do
            -- we can't see the faces of MPF/OTA
            -- this aint facial recognition anymore ELEC BOYE
            if v ~= LocalPlayer() and v:GetMoveType() ~= MOVETYPE_NOCLIP and v:HasBiosignal() then
                --if table.HasValue(no_recog_models, v:GetModel()) then return end
                if not alphas[v:EntIndex()] then
                    alphas[v:EntIndex()] = 0
                end

                if not sizes[v:EntIndex()] then
                    sizes[v:EntIndex()] = 100
                end

                if not str_lens[v:EntIndex()] then
                    str_lens[v:EntIndex()] = 0
                end

                local head = v:LookupBone("ValveBiped.Bip01_Head1")
                local headpos
                local headposP

                if head then
                    headposP = v:GetBonePosition(head)
                    headpos = v:GetBonePosition(head):ToScreen()
                else
                    headposP = v:EyePos()
                    headpos = v:EyePos():ToScreen()
                end

                -- scale stuff properly with distance
                local size = sizes[v:EntIndex()]
                local scale = v:GetPos():Distance(LocalPlayer():GetPos()) / 384
                size = size / scale
                local name = v:Name()
                surface.SetFont("FaceRecog")
                local ns_x, ns_y = surface.GetTextSize(name)
                local range = 250

                -- check if the player is in range, that their face is visible and that they're alive. and, of course, if facial recog is turned on.
                local tr = util.TraceLine({
                    start = EyePos(),
                    endpos = headposP,
                    mask = MASK_VISIBLE_AND_NPCS,
                    filter = {LocalPlayer(), v}
                })

                if (v:GetPos():Distance(LocalPlayer():GetPos()) <= range and v:Alive() and not tr.Hit) then
                    -- if yes, make magic with alphas, sizes, etc.
                    alphas[v:EntIndex()] = Lerp(FrameTime() * 8, alphas[v:EntIndex()], 255)
                    sizes[v:EntIndex()] = Lerp(FrameTime() * 5, sizes[v:EntIndex()], 20)
                    local str_len_mul = 6

                    if sizes[v:EntIndex()] < 40 then
                        str_len_mul = 50
                    end

                    str_lens[v:EntIndex()] = Lerp(FrameTime() * str_len_mul, str_lens[v:EntIndex()], ns_x)
                else
                    alphas[v:EntIndex()] = Lerp(FrameTime() * 10, alphas[v:EntIndex()], 0)
                    sizes[v:EntIndex()] = Lerp(FrameTime() * 10, sizes[v:EntIndex()], 80)
                    str_lens[v:EntIndex()] = Lerp(FrameTime() * 10, str_lens[v:EntIndex()], 0)
                end

                --[[and v:GetAimVector():Dot(LocalPlayer():GetAimVector()) < 0--]]
                -- draw the box/line
                surface.SetDrawColor(255, 255, 255, alphas[v:EntIndex()])
                -- surface.DrawOutlinedRect(headpos.x - size / 2, headpos.y - size / 2, size, size)
                -- surface.DrawRect(headpos.x + size / 1.9, headpos.y - size * 0.9, 150, 10)
                -- surface.DrawCircle(headpos.x - size / 5, headpos.y - size * 3, size,Color(255,255,255,255))
                -- draw the name in their team color (citizens brown, admins yellow, etc.)
                local team_color = team.GetColor(v:Team())
                local name_size = 0.075
                --local digits = string.match(v:Name(), "%d%d%d%d?%d?") or "CANNOT PARSE DIGITS"
                --[[-------------------------------------------------------------------------
                Going to pull this one off using a local variable for the pattern because i like being difficult!!!
                ---------------------------------------------------------------------------]]
                local pattern = "%p%a%a%a%a?%a?%a?%a?%a?%a?%a?%a?%a?%p%a?%a?%a?%a?%a?%d?%d?%d?"
                local digits = string.match(v:Name(), pattern) or "Invalid Identifier"

                -- local rank = string.match(v:Name(), "%p%a%a%a%p") or string.match(v:Name(), "%p%d%d%p") or "CANNOT PARSE RANK"
                -- local rank = "none"

                if v:Team() == FACTION_OTA then
                    rank = string.match(v:Name(), "%a%a%a%p")
                elseif v:Team() == FACTION_MPF then
                    rank = string.match(v:Name(), "%p%a%d")
                else
                    rank = ""
                end

                local delta = string.find(v:Name(), "USF:D")
                local airw = string.find(v:Name(), "OTA")
                local mpf = string.find(v:Name(), "JTF")
                assessment1 = ix.config.Get("code_mpf")
                assessment2 = ix.config.Get("code_overwatch")
               -- division = v:GetNetVar("mpfdivision", "UNIT")
              

                -- draw text
                if v:HasBiosignal() then
                    -- C17:00.TAGLINE-#
                    -- ranks: 00, 10, 20, 30, 40, RL
                    -- digits: TAGLINE-#
                    if v:Team() == FACTION_MPF then
                        MatrixText(string.sub(digits, 2), "FaceRecog", headpos.x + size / 1.9, headpos.y - size * 0.9, Color(team_color.r, team_color.g, team_color.b, alphas[v:EntIndex()]), Vector(name_size / scale, name_size / scale, 1))

                        MatrixText("CODE: " .. assessment1, "FaceRecog", headpos.x + size / 1.9, headpos.y - size / 2, Color(255, 255, 255, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
                       -- MatrixText("RANK POINTS: " .. string.sub(rank, 2), "FaceRecog", headpos.x + size / 1.9, headpos.y - size / 4, Color(255, 255, 255, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
                        -- MatrixText("PROTECTION TEAM: " .. squad, "FaceRecog", headpos.x + size / 1.9, headpos.y - size * 1.1, Color(team_color.r - 50, team_color.g - 50, team_color.b - 50, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))

                    end

                    if v:Team() == FACTION_OTA then
                        MatrixText(string.sub(digits, 1), "FaceRecog", headpos.x + size / 1.9, headpos.y - size * 0.9, Color(team_color.r, team_color.g, team_color.b, alphas[v:EntIndex()]), Vector(name_size / scale, name_size / scale, 1))

                        MatrixText("CODE: " .. assessment2, "FaceRecog", headpos.x + size / 1.9, headpos.y - size / 2, Color(255, 255, 255, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
                        MatrixText("DESIGNATION: " .. string.sub(rank, 1), "FaceRecog", headpos.x + size / 1.9, headpos.y - size / 4, Color(255, 255, 255, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
                    end

                  --[[  if string.find(rank, "%pRL") then
                        MatrixText("RANK LEADER", "FaceRecog", headpos.x + size / 1.9, headpos.y - size * 1.35, Color(150, 50, 50, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
                    end]]

                    --[[if v:IsSquadLeader() then
                        MatrixText("PT LEADER", "FaceRecog", headpos.x + size / 1.9, headpos.y - size * 1.6, Color(220, 255, 100, 255), Vector(0.05 / scale, 0.05 / scale, 1))
                    end

                    if v:GetNetVar("squad", "none") == LocalPlayer():GetNetVar("squad", "") then
                        MatrixText("SQUAD ASSET", "FaceRecog", headpos.x + size / 1.9, headpos.y - size / 4, Color(50, 50, 255, alphas[v:EntIndex()]), Vector(0.05 / scale, 0.05 / scale, 1))
                    end]]
                end

                local line_matrix = Matrix()
                line_matrix:Translate(Vector(headpos.x + size / 1.9, headpos.y - size / 2, 0))
                line_matrix:Scale(Vector(name_size / scale, 1, 1))
                cam.PushModelMatrix(line_matrix)
                surface.DrawOutlinedRect(0, 0, str_lens[v:EntIndex()], 1)
                cam.PopModelMatrix()
            end
        end
    end
end

--Denzel Washington was here.
SOCIOSTABILITY_STATUSES = {
    [0] = {"SOCIO STABILITY RESTORED ///", Color(0, 255, 0)},
    [1] = {"SOCIOSTABILITY YELLOW ///", Color(255, 255, 0)},
    [2] = {"SOCIOSTABILITY RED ///", Color(255, 0, 0)},
    [3] = {"JUDGEMENT WAIVER ///", Color(255, 0, 0)},
    [4] = {"AUTONOMOUS JUDGEMENT ///", Color(57, 57, 62)},
    [5] = {"SOCIO INCURSION ///", Color(255, 255, 0)},
    [6] = {"UNREST PROCEDURE ///", Color(255, 255, 0)},
    [7] = {"UNREST STRUCTURE ///", Color(255, 255, 0)}
}

ix.command.Add("ChangeSocioStatus", {
    description = "Change the current sociostatus. (green, yellow, red, jw, aj, si, up, us)",
    syntax = ix.type.string,
    OnRun = function(self, client, status)
        if client:IsAdmin() or Schema:HasBiosignalRank(client:Name(), "RL") or v:Team() == FACTION_OTA then
            local statuses = {
                ["green"] = 0,
                ["yellow"] = 1,
                ["red"] = 2,
                ["jw"] = 3,
                ["aj"] = 4,
                ["si"] = 5,
                ["up"] = 6,
                ["us"] = 7
            }

            local sounds = {
                [0] = {"buttons/combine_button3.wav", 100},
                [1] = {"buttons/combine_button3.wav", 95},
                [2] = {"buttons/combine_button3.wav", 90},
                [3] = {"buttons/combine_button3.wav", 85},
                [4] = {"buttons/combine_button3.wav", 75},
                [5] = {"buttons/combine_button3.wav", 95},
                [6] = {"buttons/combine_button3.wav", 95},
                [7] = {"buttons/combine_button3.wav", 95},
            }

            for k, v in pairs(statuses) do
                if status[1] == k then
                    ix.config.Set("socio_status", v)

                    for k2, v2 in pairs(sounds) do
                        if v == k2 then
                            netstream.Start(team.GetPlayers(client:Team()), "EmitPlaySound", {v2[1], 75, v2[2]})
                        else
                            netstream.Start(team.GetPlayers(client:Team()), "EmitPlaySound", {"evo/virgil_2.wav", 75, 100})
                        end
                    end
                end
            end
        else
            client:Notify("You do not have permission to use this command!")
        end
    end
})

ix.config.Add("socio_status", 0, "The current status of sociostability (can be changed by characters).", function(oldValue, newValue)
    if CLIENT then
        for k, v in pairs(SOCIOSTABILITY_STATUSES) do
            if newValue ~= 0 and newValue == k then
                ix.gui.sociostability:SetText(v[1])
                ix.gui.sociostability:SetColor(v[2])
            end
        end
    end
end, {
    data = {
        min = 0,
        max = 10
    },
    category = "Miscellaneous"
})

if CLIENT then
    netstream.Hook("EmitPlaySound", function(data)
        PrintTable(data)
        print("running")
        LocalPlayer():EmitSound(data[1], data[2] or 75, data[3] or 100, data[4] or 1)
    end)

    local PANEL = {}

    surface.CreateFont("ixSocioFont", {
        font = "Bahnschrift SemiLight Condensed", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
        extended = false,
        size = 65,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false
    })

    function PANEL:Init()
        self:SetSize(ScrW() / 4, ScrH() / 14.5)
        --self:SetSize(ScrW() / 1.1, ScrH() / 1.1)
        self:SetPos(ScrW() / 1.4, 100)

        --self:MakePopup()
        for k, v in pairs(SOCIOSTABILITY_STATUSES) do
            local value = ix.config.Get("socio_status", 0)

            if value == k then
                self:SetText(v[1])
                self:SetColor(v[2])
            end
        end

        ix.gui.sociostability = self
    end

    function PANEL:PaintOver(w, h)
        -- draw.DrawText( self.text, "ixSocioFont", math.fmod(SysTime() * 60, w ), 0, self.color, 0)
        local multiplier = 250 -- greater multiplier = faster scroll
        local ypos = 5 -- the y pos on the screen, assuming the text scrolls horizontally
        local text = self.text -- the text to draw
        local font = "ixSocioFont" -- the font to draw it in
        local textcol = color_white -- the color to draw the font
        local toleft_toright = 1 -- Change this to -1 to go left or 1 to scroll to the right
        local width = w + surface.GetTextSize(self.text) / 15 -- the width of hte space which the text will scroll across
        local x = math.fmod(SysTime() * multiplier, width)
        surface.SetFont(font)
        local w2, h2 = surface.GetTextSize(text)

        if x + w2 > width then
            --draw.DrawText(self.text,font,(x + w2 - width) * toleft_toright, ypos, self.color,2)
            draw.SimpleTextOutlined(self.text, font, (x + w2 - width) * toleft_toright, ypos, self.color, 2, nil, 1, Color(0, 0, 0, 255))
        end

        draw.SimpleTextOutlined(self.text, font, math.fmod(SysTime() * multiplier, width), ypos, self.color, 0, nil, 1, Color(0, 0, 0, 255))
        --draw.DrawText(self.text,font,math.fmod(SysTime() * multiplier,width),ypos,self.color,0)
        local sizew, sizeh = self:GetSize()
        surface.SetDrawColor(self.color)
        surface.DrawRect(0, 0, 30, 5)
        surface.DrawRect(0, 0, 5, 30)
        surface.DrawRect(0, sizeh - 30, 5, 30)
        surface.DrawRect(0, sizeh - 5, 30, 5)
        surface.DrawRect(sizew - 30, 0, 30, 5)
        surface.DrawRect(sizew - 5, 0, 5, 30)
        surface.DrawRect(sizew - 5, sizeh - 30, 5, 30)
        surface.DrawRect(sizew - 30, sizeh - 5, 30, 5)
    end

    function PANEL:Paint(w, h)
        surface.SetDrawColor(0, 0, 0, 150)
        surface.DrawRect(0, 0, w, h)
    end

    --draw.DrawText( "SOCIOSTABILITY RED", "ixSmallFont", ScrW() / 1.1 + math.fmod(SysTime() * 70, w ), h / 2, color_black, 0)
    function PANEL:SetText(text)
        self.text = text
    end

    function PANEL:SetColor(color)
        self.color = color
    end

    vgui.Register("SocioStabilityInterface", PANEL, "DPanel")

    hook.Add("HUDPaint", "DrawScrollText", function()
        if not LocalPlayer():HasBiosignal() then
            if IsValid(ix.gui.sociostability) then
                ix.gui.sociostability:Hide()
            end

            return
        end

        if not IsValid(ix.gui.sociostability) then
            vgui.Create("SocioStabilityInterface")
        else
            if ix.config.Get("socio_status", 0) < 1 then
                ix.gui.sociostability:Hide()
            else
                ix.gui.sociostability:Show()
            end
        end
    end)
end