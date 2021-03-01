function cxmplex:CoreOnUpdate(elapsed)
  if not self.last_time then
    self.last_time = 0
  end
  self.last_time = self.last_time + elapsed
  if cxmplex.anti_afk then
    if (self.last_time > math.random(240, 420)) then
      cxmplex.ResetAfk()
      self.last_time = 0
    end
  end
  if cxmplex:GetKeyState(0x02) and not cxmplex:GetKeyState(0x01) and not UnitAffectingCombat("player") and GetCVar("AutoInteract") == "0" then
    SetCVar("AutoInteract", "1")
  end
end

function cxmplex:CoreOnEvent(event, ...)
  if event == "VARIABLES_LOADED" then
    cxmplex:Init()
    local multijump_toggle = cxmplex:GetSystemVar("cxmplex.multijump_toggle")
    if multijump_toggle == "true" then multijump_toggle = true end
    if multijump_toggle == "false" then multijump_toggle = false end
    if multijump_toggle ~= nil then
      cxmplex.multijump_toggle = multijump_toggle
    end
    local anti_afk = cxmplex:GetSystemVar("cxmplex.anti_afk")
    if anti_afk == "true" then anti_afk = true end
    if anti_afk == "false" then anti_afk = false end
    if anti_afk ~= nil then
      cxmplex.anti_afk = anti_afk
    end
    local tracker_toggle = cxmplex:GetSystemVar("cxmplex.tracker_toggle")
    if tracker_toggle == "true" then tracker_toggle = true end
    if tracker_toggle == "false" then tracker_toggle = false end
    if tracker_toggle ~= nil then
      cxmplex.tracker_toggle = tracker_toggle
      if cxmplex.tracker_toggle then
        cxmplex:AddDrawingCallback("objectTracker", cxmplex.DrawTrackedObjects)
      end
    end
  elseif event == "PLAYER_ENTERING_WORLD" then
    C_Timer.After(3,
      function()
        if select(1, IsInInstance()) and select(4, GetInstanceInfo()) == "Torghast" then
          cxmplex:EnableTorghastModule()
        else
          cxmplex:DisableTorghastModule()
        end
      end
    )
  end
end

function cxmplex:Init()
  cxmplex:CreateJumpHook()
  cxmplex:CreateChatHook()
  cxmplex:InitDrawing()
  cxmplex:AddDrawingCallback("arena", cxmplex.ArenaTeamAwareness)
end
