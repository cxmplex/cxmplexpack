local frame = CreateFrame("FRAME")
local private

-------------------------------------------------------------------------------------------

--- WORLD QUESTS

function AspirantAutoAbility() -- 59585
  local spells = {
    ["Slash."] = OverrideActionBarButton1,
    ["Bash."] = OverrideActionBarButton2,
    ["Block."] = OverrideActionBarButton3
  }
  private.InActivityFrame = CreateFrame("FRAME")
  private.InActivityFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
  private.InActivityFrame:SetScript("OnEvent",
    function(self, event, unit, castGuid, spellId)
      if spellId == 341934 then in_activity = true end
    end
  )
  private.ChatFrame = CreateFrame("FRAME")
  private.ChatFrame:RegisterEvent("CHAT_MSG_MONSTER_SAY")
  private.ChatFrame:SetScript("OnEvent",
    function(self, event, text, ...)
      if in_activity then
        if spells[text] then
          C_Timer.After(0.250, function() spells[text]:Click("LeftButton") end)
        end
      end
    end
  )
end

function AspirantAutoAbilityDestroy()
  private.InActivityFrame:SetScript("OnEvent", nil)
  private.ChatFrame:SetScript("OnEvent", nil)
end


-------------------------------------------------------------------------------------------
local quests_by_map = {
  [1533] = {
    [59585] = {
      [1] = AspirantAutoAbility,
      [2] = AspirantAutoAbilityDestroy
    }
  }
}

local function OnEvent(self, event, questId, ...)
  local mapId = C_Map.GetBestMapForUnit("player")
  if quests_by_map[mapId] and quests_by_map[mapId][questId] then
    if event == "QUEST_ACCEPTED" then
      quests_by_map[mapId][questId][1]()
    elseif event == "QUEST_FINISHED" then
      quests_by_map[mapId][questId][2]()
    end
  end
end

frame:RegisterEvent("QUEST_ACCEPTED")
frame:RegisterEvent("QUEST_FINISHED")
frame:SetScript("OnEvent", OnEvent)
