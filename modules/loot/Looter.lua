local private = { delay = 0.5 }
cxmplex.looter = {}

if not cxmplex_savedvars.looter then
    cxmplex_savedvars.looter = {
        move_to_loot = false
    }
end
-- local struct = {
--     Object = "nil",
--     Name = "nil",
--     Guid = "nil",
--     Id = 0,
--     Type = {
--         base_type = { -- cxmplex:ObjectTypeFlags() GameObject
--             name = "nil"
--         },
--         sub_type = { -- cxmplex:GameObjectType() Door
--             id = 0,
--             name = "nil"
--         }
--     },
--     Flags = { value = 0, list = {} }, -- Depends on sub_type
--     DynamicFlags = { value = 0, list = {} }, -- Depends on sub_tpe
--     Info = {
--         Quest = {
--             IsTiedToQuest = false
--         },
--         Unit = {
--             Dead = false,
--             Hidden = false,
--             Rare = false,
--             Lootable = false,
--             Skinnable = false
--         },
--         Filter = {
--             List = "nil"
--         },
--         GameObject = {
--             Interactable = true
--         }
--     }
-- }
local function GetLootableUnit()
    local interactable_units = cxmplex:GetInteractableObjects()
    local obj_loot_candidates = {}
    for i = 1, #interactable_units do
        local struct = interactable_units[i]
        local object = struct.Object
        local is_good_go = true
        if struct.Type.base_type.name == "GameObject" and not struct.Info.Quest.IsTiedToQuest then
            is_good_go = false
        else
            is_good_go = true
        end
        local distance = cxmplex:GetDistanceBetweenObjects("player", object)
        if cxmplex:InLineOfSight("player", object) and is_good_go then
            table.insert(obj_loot_candidates, {object = object, distance = distance})
        end
    end
    table.sort(obj_loot_candidates, function(a, b) return a.distance < b.distance end)
    private.lootable_unit = obj_loot_candidates[1]
    local npc_loot_candidates = {}
    if not private.lootable_unit or private.lootable_unit.distance > 10 then
        for i = 1, #cxmplex.om.object_list.npcs do
            local struct = cxmplex.om.object_list.npcs[i]
            local object = struct.Object
            if struct.Info.Unit.Dead and struct.Info.Unit.Lootable then
                local distance = cxmplex:GetDistanceBetweenObjects("player", object)
                if cxmplex:InLineOfSight("player", object) then
                    table.insert(npc_loot_candidates, {object = object, distance = distance})
                end
            end
        end
    end
    table.sort(npc_loot_candidates, function(a, b) return a.distance < b.distance end)
    private.lootable_unit = npc_loot_candidates[1]
end

local function Gather()
    GetLootableUnit()
    if not private.combat and private.lootable_unit ~= nil and not UnitIsDeadOrGhost("player") then
        local distance = private.lootable_unit.distance
        if not distance then
            private.lootable_unit = nil
            cxmplex.HAS_LOOTABLE_UNIT = false
            return
        end
        if distance <= 5 then
            cxmplex.HAS_LOOTABLE_UNIT = true
            cxmplex:StopMoving()
            InteractUnit(private.lootable_unit.object)
            private.lootable_unit = nil
        elseif distance < 10 and cxmplex_savedvars.looter.move_to_loot then
            cxmplex.HAS_LOOTABLE_UNIT = true
            local x, y, z = ObjectPosition(private.lootable_unit.object)
            cxmplex:MoveTo(x, y, z)
        else
            cxmplex.HAS_LOOTABLE_UNIT = false
        end
    end
end

local LooterFrame = CreateFrame("BUTTON", "LooterFrame", UIParent)
local LooterStatus = LooterFrame:CreateFontString("LooterStatusText", "OVERLAY")
LooterFrame:RegisterEvent("PLAYER_LOGIN")
LooterFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
LooterFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
LooterFrame:RegisterEvent("PLAYER_STARTED_MOVING")
LooterFrame:RegisterEvent("PLAYER_STOPPED_MOVING")
LooterFrame:RegisterEvent("LOOT_OPENED")
LooterFrame:RegisterEvent("LOOT_CLOSED")
LooterFrame:RegisterUnitEvent("UNIT_SPELLCAST_START")
LooterFrame:RegisterUnitEvent("UNIT_SPELLCAST_STOP")

LooterFrame:SetScript(
    "OnEvent",
    function(self, event, ...)
        local arg1, arg2, arg3 = ...
        if event == "PLAYER_LOGIN" then
            if cxmplex_savedvars.looter_enabled == nil then
                cxmplex_savedvars.looter_enabled = false
            end
            if cxmplex_savedvars.loot_frame_position == nil then
                cxmplex_savedvars.loot_frame_position = {}
                cxmplex_savedvars.loot_frame_position.point = "CENTER"
                cxmplex_savedvars.loot_frame_position.relativePoint = "TOP"
                cxmplex_savedvars.loot_frame_position.xOfs = 2
                cxmplex_savedvars.loot_frame_position.yOfs = -70
            end
            LooterFrame:SetWidth(80)
            LooterFrame:SetHeight(80)
            LooterFrame:SetPoint(
                cxmplex_savedvars.loot_frame_position.point,
                UIParent,
                cxmplex_savedvars.loot_frame_position.relativePoint,
                cxmplex_savedvars.loot_frame_position.xOfs,
                cxmplex_savedvars.loot_frame_position.yOfs
            )
            LooterFrame:SetMovable(true)
            LooterFrame:EnableMouse(true)
            LooterFrame:RegisterForClicks("RightButtonUp")
            LooterFrame:SetScript(
                "OnClick",
                function(self, button, down)
                    if cxmplex_savedvars.looter_enabled == false then
                        cxmplex_savedvars.looter_enabled = true
                    else
                        cxmplex_savedvars.looter_enabled = false
                    end
                end
            )
            LooterFrame:SetScript(
                "OnMouseDown",
                function(self, button)
                    if button == "LeftButton" and not self.isMoving then
                        self:StartMoving()
                        self.isMoving = true
                    end
                end
            )
            LooterFrame:SetScript(
                "OnMouseUp",
                function(self, button)
                    if button == "LeftButton" and self.isMoving then
                        self:StopMovingOrSizing()
                        self.isMoving = false
                        local point, _, relativePoint, xOfs, yOfs = self:GetPoint(1)
                        cxmplex_savedvars.loot_frame_position.point = point
                        cxmplex_savedvars.loot_frame_position.relativePoint = relativePoint
                        cxmplex_savedvars.loot_frame_position.xOfs = xOfs
                        cxmplex_savedvars.loot_frame_position.yOfs = yOfs
                    end
                end
            )
            LooterStatus:SetFontObject(GameFontNormalSmall)
            LooterStatus:SetJustifyH("CENTER")
            LooterStatus:SetPoint("CENTER", LooterFrame, "CENTER", 0, 0)
            LooterStatus:SetText("Looter |cffff0000Disabled")
        elseif event == "PLAYER_REGEN_ENABLED" then
            private.combat = false
        elseif event == "PLAYER_REGEN_DISABLED" then
            private.combat = true
        elseif event == "PLAYER_STARTED_MOVING" then
            playerMoving = true
        elseif event == "PLAYER_STOPPED_MOVING" then
            playerMoving = false
        elseif event == "LOOT_OPENED" then
            private.player_looting = true
        elseif event == "LOOT_CLOSED" then
            private.player_looting = false
            private.pulse = GetTime() + 1
        elseif event == "UNIT_SPELLCAST_START" then
            if arg1 == "player" then
                private.player_casting = true
            end
        elseif event == "UNIT_SPELLCAST_STOP" then
            if arg1 == "player" then
                private.player_casting = false
                private.pulse = GetTime() + 1
            end
        end
    end
)

LooterFrame:SetScript(
    "OnUpdate",
    function(self, elapsed)
        if cxmplex_savedvars.looter_enabled and not private.player_looting and not private.player_casting then
            if private.pulse == nil then
                private.pulse = GetTime()
            end
            if GetTime() > private.pulse then
                Gather()
                private.pulse = GetTime() + private.delay
            end
        end
        if cxmplex_savedvars.looter_enabled then
            LooterStatus:SetText("Looter |cFF00FF00Enabled")
        end
        if not cxmplex_savedvars.looter_enabled then
            LooterStatus:SetText("Looter |cffff0000Disabled")
            private.lootable_unit = nil
        end
    end
)
