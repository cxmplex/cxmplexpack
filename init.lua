local frame = CreateFrame("FRAME")

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("VARIABLES_LOADED")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
-- frame:RegisterEvent("CRITERIA_UPDATE")
frame:RegisterEvent("TRACKED_ACHIEVEMENT_UPDATE")

frame:SetScript("OnEvent", cxmplex.CoreOnEvent)
frame:SetScript("OnUpdate", cxmplex.CoreOnUpdate)

cxmplex.core_frame = frame
