cxmplex.tracker = {}
cxmplex.tracker.frames = {}
cxmplex.tracker.processed_objects = {}
cxmplex.tracker.process_all = false
cxmplex.tracker.process_objects_size = 8

if not cxmplex_savedvars.tracker then
    cxmplex_savedvars.tracker = {
        draw_distance = true,
        draw_quest_info = true,
        draw_hostile_npcs = true,
        draw_id = true
    }
end

local function ProcessObjects()
    local filtered_objects = cxmplex:GetFilteredObjects()
    if next(filtered_objects) == nil then return end
    if filtered_objects.tag then return cxmplex.tracker.processed_objects end
    if cxmplex.tracker.process_all then
        filtered_objects = {default = cxmplex:GetObjectList()}
    end
    for list, items in pairs(filtered_objects) do
        local item_list = {}
        for i = 1, #items do
            local obj = items[i]
            local guid = obj.Guid
            local dead = obj.Info.Unit.Dead
            local hidden = obj.Info.Unit.Hidden
            local interactable = obj.Info.GameObject.Interactable
            local nonhostile_npc = obj.Flags.list.UNIT_FLAG_IMMUNE_TO_PC
            local dynamic_flags = obj.DynamicFlags.value
            local go = obj.Type.base_type.name == "GameObject"
            local unit = obj.Type.base_type.name == "Unit"
            local go_id = obj.Type.sub_type.id
            if not dead and not hidden and interactable and (not unit or (nonhostile_npc or cxmplex_savedvars.tracker.draw_hostile_npcs)) then
                local x, y, z = cxmplex:ObjectPosition(obj.Object)
                local distance = cxmplex:GetDistanceBetweenObjects("player", obj.Object)
                local id = obj.Id
                local name = obj.Name
                local rare = obj.Info.Unit.Rare
                if distance and distance <= 400 then
                    local color = {r = 50, g = 205, b = 50, a = 100}
                    if rare then
                        color = {r = 220, g = 20, b = 60, a = 100}
                        rare = true
                    end
                    if go then
                        color = {r = 223, g = 70, b = 97, a = 100}
                    end
                    if name == "Next Floor" then
                        color = {r = 254, g = 80, b = 0, a = 100}
                    end
                    if x and y and z and id and name and distance and not dead then
                        table.insert(item_list, {dynamic_flags = dynamic_flags, interactable = interactable, guid = guid, go = go, go_id = go_id, name = name, x = x, y = y, z = z, distance = distance, object = obj.Object, id = id, color = color, rare = rare, time = GetTime()})
                    end
                end
            end
        end
        if item_list then
            table.sort(item_list, function(a, b) return a.distance < b.distance end)
            cxmplex.tracker.processed_objects[list] = subrange(item_list, 1, cxmplex.tracker.process_objects_size)
        end
    end
    filtered_objects.tag = true
end


local function ProcessObjectsOnUpdate(self, elapsed)
    if not self.last_time then
        self.last_time = 0
    end
    self.last_time = self.last_time + elapsed
    if self.last_time > 1 / 10 then
        ProcessObjects()
    end
end

function cxmplex:InitTrackerModule()
    cxmplex.tracker.frames.process_objects = CreateFrame("FRAME")
    cxmplex.tracker.frames.process_objects:SetScript("OnUpdate", ProcessObjectsOnUpdate)
end

function cxmplex:DestroyTrackerModule()
    cxmplex.tracker.frames.process_objects:SetScript("OnUpdate", nil)
    cxmplex.tracker.frames.process_objects = nil
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
                    if completed then completed = nil else completed = true end
                    if type == 27 then -- quest type
                        cxmplex_savedvars.objects_to_track.quest[str] = completed
                    elseif type == 68 then -- book type
                        cxmplex_savedvars.objects_to_track.quest[assetID] = completed
                    elseif type == 0 then -- mob kill or interact
                        cxmplex_savedvars.objects_to_track.quest[assetID] = completed
                    elseif type == 28 then
                        cxmplex_savedvars.objects_to_track.quest[str] = completed
                    end
                end
            end
        end
    end
    cxmplex:ResetObjects()
end

function cxmplex:ResetObjects()
    cxmplex.tracker.processed_objects = {}
end

function cxmplex:TrackAllObjects()
    cxmplex.tracker.process_all = not cxmplex.tracker.process_all
    if cxmplex.tracker.process_all then
        cxmplex.tracker.process_objects_size = 20
    else
        cxmplex:ResetObjects()
        cxmplex.tracker.process_objects_size = 8
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
        local objects = cxmplex.tracker.processed_objects[list]
        if not objects then return end
        for _, data in pairs(objects) do
            if data then
                if data.object then
                    data.distance = cxmplex:GetDistanceBetweenObjects("player", data.object)
                end
                -- if we're tracking all obj then getting the processed object list takes
                -- a long time, so we can update the object position in this frame
                -- but we only want to do that if its been a long time
                if GetTime() - data.time > 0.050 then
                    data.x, data.y, data.z = cxmplex:ObjectPosition(data.object)
                    data.interactable = cxmplex:ObjectIsInteractable(data.object, data.dynamic_flags)
                end
                if data.x ~= nil and data.y ~= nil and data.z ~= nil and data.name ~= nil then
                    local r = data.color.r
                    local g = data.color.g
                    local b = data.color.b
                    local alpha = data.color.a
                    cxmplex.drawing:SetColor(r, g, b, alpha)
                    local text = data.name
                    if cxmplex_savedvars.tracker.draw_distance then
                        text = text .. " " .. roundDistance(data.distance)
                    end
                    local quest_info = cxmplex.QuestRelationMap[data.id]
                    if cxmplex_savedvars.tracker.draw_quest_info and quest_info then
                        if not quest_info.p2 then quest_info.p2 = 100 end
                        text = text .. " (" .. quest_info.p1 .. "/" .. quest_info.p2 .. ")"
                    end
                    if cxmplex_savedvars.tracker.draw_id then
                        if data.go then
                            text = "[" .. data.id .. "][" .. data.go_id .. "] " .. text
                        else
                            text = "[" .. data.id .. "] " .. text
                        end
                    end
                    cxmplex.drawing:Text(text, data.x, data.y, data.z + 3, data.id)
                    if data.rare then
                        local config = {
                            texture = "Interface\\Addons\\" .. cxmplex.addon_name .. "\\media\\textures\\skull.blp",
                            width = 64,
                            height = 64,
                            scale = 0.3
                        }
                        cxmplex.drawing:Texture(config, data.x, data.y, data.z - 0.5, 80)
                    end
                end
            end
        end
    end
end
