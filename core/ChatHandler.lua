function cxmplex:RunCommand(msg)
  local _, _, cmd, args = string.find(msg, "%s?(%w+)%s?(.*)")
  if cmd == "mj" then
    cxmplex.multijump_toggle = not cxmplex.multijump_toggle
    SendSystemMessage("Multi-Jump: " .. tostring(cxmplex.multijump_toggle));
    cxmplex:SetSystemVar("cxmplex.multijump_toggle", tostring(cxmplex.multijump_toggle))
  elseif cmd == "aa" then
    cxmplex.anti_afk = not cxmplex.anti_afk
    SendSystemMessage("Anti-Afk: " .. tostring(cxmplex.anti_afk));
    cxmplex:SetSystemVar("cxmplex.anti_afk", tostring(cxmplex.anti_afk))
  elseif cmd == "nc" then
    cxmplex.noclip_toggle = not cxmplex.noclip_toggle
    if cxmplex.noclip_toggle and not cxmplex.multijump_toggle then
      cxmplex.multijump_toggle = true
    end
    cxmplex:SetSystemVar("cxmplex.multijump_toggle", tostring(cxmplex.multijump_toggle))
  elseif cmd == "travel" and args then
    cxmplex.Travel(args)
  elseif cmd == "trace" then
    if args == "start" then
      cxmplex.trace_timer = C_Timer.NewTicker(0.5, cxmplex.TraceLogObjects)
    else
      cxmplex.trace_timer:Cancel()
    end
  elseif cmd == "tracker" then
    cxmplex.tracker_toggle = not cxmplex.tracker_toggle
    SendSystemMessage("Object Tracker: " .. tostring(cxmplex.tracker_toggle));
    cxmplex:SetSystemVar("cxmplex.tracker_toggle", tostring(cxmplex.tracker_toggle))
    if cxmplex.tracker_toggle then
      if not cxmplex:GetObjManagerFrame() then
        cxmplex:InitObjectManager()
      end
      cxmplex:AddDrawingCallback("objectTracker", cxmplex.DrawTrackedObjects)
    else
      cxmplex:RemoveDrawingCallback("objectTracker")
    end
  elseif cmd == "track" and args then
    local _, _, action, id = string.find(args, "%s?(%w+)%s?(%d+)")
    if action == "add" then
      cxmplex:AddObjectToTrackerById(tonumber(id))
    elseif action == "del" then
      cxmplex:RemoveObjectFromTrackerById(tonumber(id))
    end
  elseif cmd == "farm" and args then
    if args == "stop" then
      cxmplex:DestroyAllFarmers()
    else
      cxmplex:CreateFarmer(args)
    end
  end
end
