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

local variables_loaded = false
function cxmplex:CoreOnEvent(event, ...)
    if event == "VARIABLES_LOADED" then
        cxmplex:Init()
        cxmplex.multijump_toggle = cxmplex:GetSystemVar("cxmplex.multijump_toggle") == "true"
        cxmplex.anti_afk = cxmplex:GetSystemVar("cxmplex.anti_afk") == "true"
        cxmplex.fly_toggle = cxmplex:GetSystemVar("cxmplex.fly_toggle") == "true"
        cxmplex.tracker_toggle = cxmplex:GetSystemVar("cxmplex.tracker_toggle") == "true"
        if not cxmplex:GetObjManagerFrame() then
            cxmplex:InitObjectManager()
        end
        if cxmplex.tracker_toggle then
            cxmplex:AddDrawingCallback("objectTracker", cxmplex.DrawTrackedObjects)
            cxmplex:InitTrackerModule()
        end
        cxmplex:EnableFlyingMode(cxmplex.fly_toggle)
        variables_loaded = true
    end
    if not variables_loaded then return end
    if event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(3,
            function()
                if select(1, IsInInstance()) and select(4, GetInstanceInfo()) == "Torghast" then
                    cxmplex:EnableTorghastModule()
                else
                    cxmplex:DisableTorghastModule()
                end
            end
        )
        if cxmplex_savedvars.track_quest_objects then
            cxmplex:EnableQuestTracker()
            cxmplex:AddTrackedAchievementItems()
        end
    elseif event == "PLAYER_TARGET_CHANGED" then
        cxmplex.force_update = true
    elseif event == "CRITERIA_UPDATE" and cxmplex_savedvars.track_quest_objects then
        C_Timer.After(1, function() cxmplex:AddTrackedAchievementItems() end)
    elseif event == "TRACKED_ACHIEVEMENT_UPDATE" and cxmplex_savedvars.track_quest_objects then
        C_Timer.After(1, function() cxmplex:AddTrackedAchievementItems() end)
    elseif event == "QUEST_WATCH_UPDATE" then
        cxmplex.quests.wipe_quest_object_cache = true
    end
end

function cxmplex:Init()
    cxmplex:CreateJumpHook()
    cxmplex:CreateChatHook()
    cxmplex:CreateTrackAchievementHook()
    cxmplex:InitDrawing()
    cxmplex:AddDrawingCallback("arena", cxmplex.ArenaTeamAwareness)
end
