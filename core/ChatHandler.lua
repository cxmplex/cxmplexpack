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
    elseif cmd == "fly" then
        cxmplex.fly_toggle = not cxmplex.fly_toggle
        cxmplex:SetSystemVar("cxmplex.fly_toggle", tostring(cxmplex.fly_toggle))
        SendSystemMessage("Fly: " .. tostring(cxmplex.fly_toggle))
        if not cxmplex.fly_toggle and not cxmplex:IsFlyingModeEnabled() then
            return
        end
        cxmplex:EnableFlyingMode(cxmplex.fly_toggle)
    elseif cmd == "nc" then
        cxmplex.noclip_toggle = not cxmplex.noclip_toggle
        if cxmplex.noclip_toggle then
            if cxmplex:IsFlyingModeEnabled() then
                cxmplex:SetNoClipModes(15)
            else
                cxmplex:SetNoClipModes(7)
            end
        else
            cxmplex:SetNoClipModes(0)
        end
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
            cxmplex:AddDrawingCallback("objectTracker", cxmplex.DrawTrackedObjects)
            cxmplex:InitTrackerModule()
        else
            cxmplex:RemoveDrawingCallback("objectTracker")
        end
    elseif cmd == "track" and args then
        local _, _, action, id = string.find(args, "%s?(%w+)%s?(%d+)")
        if id then
            id = tonumber(id)
        else
            _, _, action, id = string.find(args, "%s?(%w+)%s?([%w%s]+)")
            print("action is: " .. action .. " id is: " .. id)
        end
        if action == "add" then
            cxmplex:AddObjectToTrackerByIdOrName(id)
            SendSystemMessage("Added ID: " .. id)
        elseif action == "del" then
            cxmplex:RemoveObjectFromTrackerByIdOrName(id)
        elseif args == "all" then
            cxmplex:TrackAllObjects()
        elseif args == "quest" then
            cxmplex_savedvars.track_quest_objects = not cxmplex_savedvars.track_quest_objects
            SendSystemMessage("Track Quest Objects: " .. tostring(cxmplex_savedvars.track_quest_objects))
            if cxmplex_savedvars.track_quest_objects then
                cxmplex:EnableQuestTracker()
            end
        elseif action == "quest" and id == "reset" then
            cxmplex_savedvars.objects_to_track.quest = {}
        end
    elseif cmd == "farm" and args then
        if args == "stop" then
            cxmplex:DestroyAllFarmers()
        else
            cxmplex:CreateFarmer(args)
        end
    elseif cmd == "gps" then
        cxmplex:GPS()
    end
end
