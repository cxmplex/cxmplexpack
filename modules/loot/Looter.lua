local private = { delay = 0.5 }

local function GetLootableUnit()
  for i = 1, cxmplex:GetObjectCount() do
    local object = cxmplex:GetObjectWithIndex(i)
    local distance = cxmplex:GetDistanceBetweenObjects("player", object)
    if cxmplex:UnitCanBeLooted(object) and cxmplex:InLineOfSight("player", object) and UnitIsVisible(object) and UnitIsDeadOrGhost(object) then
      private.lootable_unit = object
			return
    end
  end
end

local function Gather()
	GetLootableUnit()
	if not private.combat and private.lootable_unit then
    local distance = CalculateDistance("player", private.lootable_unit)
    if distance <= 3 then
      cxmplex.HAS_LOOTABLE_UNIT = true
      InteractUnit(private.lootable_unit)
      private.lootable_unit = nil
    elseif distance < 10 then
      cxmplex.HAS_LOOTABLE_UNIT = true
      local x, y, z = ObjectPosition(private.lootable_unit)
      cxmplex:MoveTo(x, y, z)
    end
	else
		cxmplex.HAS_LOOTABLE_UNIT = false
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
      if private.enabled == nil then
        private.enabled = false
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
          if private.enabled == false then
            private.enabled = true
          else
            private.enabled = false
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
      LooterStatus:SetText("Gathering |cffff0000Disabled")
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
    if private.enabled and not private.player_looting and not private.player_casting then
      if private.pulse == nil then
        private.pulse = GetTime()
      end
      if GetTime() > private.pulse then
        Gather()
        private.pulse = GetTime() + private.delay
      end
    end
    if private.enabled then
      LooterStatus:SetText("Gathering |cFF00FF00Enabled")
    end
    if not private.enabled then
      LooterStatus:SetText("Gathering |cffff0000Disabled")
      private.lootable_unit = nil
    end
  end
)
