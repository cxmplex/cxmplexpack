local frame = CreateFrame("FRAME")

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("VARIABLES_LOADED")

frame:SetScript("OnEvent", cxmplex.CoreOnEvent)
frame:SetScript("OnUpdate", cxmplex.CoreOnUpdate)
