cxmplex.om = {}
cxmplex.om.frames = {}

cxmplex.om.updated = false
cxmplex.om.last_ran = 0
cxmplex.om.process_all = false
cxmplex.om.process_objects_size = 8
cxmplex.om.object_list = {}
cxmplex.om.filtered_objects = {}
cxmplex.om.processed_objects = {}
cxmplex.om.frames.object_manager = nil
cxmplex.om.frames.process_objects = nil

function cxmplex:GetObjectList()
    return cxmplex.om.object_list
end

function cxmplex:GetFilteredObjectList()
    return cxmplex.om.filtered_objects
end

function cxmplex:GetProcessedObjects(list)
    return cxmplex.om.processed_objects[list]
end

function cxmplex:AddObjectToTrackerById(id, list)
    if not list then list = "default" end
    if cxmplex_savedvars.objects_to_track[list] == nil then return end
    cxmplex_savedvars.objects_to_track[list][id] = true
end

function cxmplex:RemoveObjectFromTrackerById(id, list)
    if not list then list = "default" end
    if cxmplex_savedvars.objects_to_track[list] == nil then return end
    cxmplex_savedvars.objects_to_track[list][id] = nil
end

function cxmplex:EnableObjectList(name)
    cxmplex_savedvars.enabled_lists[name] = true
end

function cxmplex:DisableObjectList(name)
    cxmplex_savedvars.enabled_lists[name] = nil
end

function cxmplex:AddObjectList(name, items)
    cxmplex_savedvars.objects_to_track[name] = items
end

function cxmplex:RemoveObjectList(name)
    cxmplex_savedvars.objects_to_track[name] = nil
    cxmplex_savedvars.enabled_lists[name] = nil
end

function cxmplex:ObjectListEnabled(name)
    return cxmplex_savedvars.enabled_lists[name] ~= nil
end

function cxmplex:ObjectListExists(name)
    return cxmplex_savedvars.objects_to_track[name] ~= nil
end

function cxmplex:AddTrackedAchievementItems()
    if not cxmplex_savedvars.objects_to_track.quest then
        cxmplex_savedvars.objects_to_track.quest = {}
    end
    cxmplex_savedvars.enabled_lists.quest = true
    local achievements = {GetTrackedAchievements()}
    for _, v in ipairs(achievements) do
        if not select(4, GetAchievementInfo(v)) then
            local n = GetAchievementNumCriteria(v)
            if n and n > 0 then
                for i = 1, n, 1 do
                    local str, type, completed, _, _, _, _, assetID, _, criteriaID = GetAchievementCriteriaInfo(v, i)
                    -- print("Str: " .. str .. " type: " .. type)
                    if type == 27 then
                        cxmplex_savedvars.objects_to_track.quest[str] = not completed
                    end
                end
            end
        end
    end
end

function cxmplex:ResetObjects()
    cxmplex.om.object_list = {}
    cxmplex.om.filtered_objects = {}
    cxmplex.om.processed_objects = {}
end

function cxmplex:TrackAllObjects()
    cxmplex.om.process_all = not cxmplex.om.process_all
    if cxmplex.om.process_all then
        cxmplex.om.process_objects_size = 20
    else
        cxmplex:ResetObjects()
        cxmplex.om.process_objects_size = 8
    end
end

function cxmplex:DrawTrackedObjects()
    local function roundDistance(distance)
        if not distance then
            return 0
        end
        return distance + 0.5 - (distance + 0.5) % 1
    end
    for list, _ in pairs(cxmplex_savedvars.enabled_lists) do
        local objects = cxmplex:GetProcessedObjects(list)
        if not objects then return end
        for _, data in pairs(objects) do
            if data.object then
                data.distance = cxmplex:GetDistanceBetweenObjects("player", data.object)
            end
            -- if we're tracking all obj then getting the processed object list takes
            -- a long time, so we can update the object position in this frame
            -- but we only want to do that if its been a long time
            if GetTime() - data.time > 0.100 then
                data.x, data.y, data.z = cxmplex:ObjectPosition(data.object)
            end
            if data.x ~= nil and data.y ~= nil and data.z ~= nil and data.name ~= nil then
                local r = data.color.r
                local g = data.color.g
                local b = data.color.b
                local alpha = data.color.a
                cxmplex.drawing:SetColor(r, g, b, alpha)
                cxmplex.drawing:Text("[" .. data.id .. "]" .. data.name .. " " .. roundDistance(data.distance), data.x, data.y, data.z + 3)
                if data.rare then
                    local config = {
                        texture = "Interface\\Addons\\" .. cxmplex.addon_name .. "\\media\\textures\\skull.blp",
                        width = 64,
                        height = 64,
                        scale = 0.3
                    }
                    cxmplex.drawing:Texture(config, data.x, data.y, data.z, 80)
                end
            end
        end
    end
end

function cxmplex:GetObjManagerFrame()
    return cxmplex.om.frames.object_manager
end
