local function RunObjectManager()
    local count, isUpdated, addedObjects, removedObjects = cxmplex:GetObjectCount()
    if cxmplex.force_update or GetTime() - cxmplex.om.last_ran > 0.250 then
        isUpdated = true
        cxmplex.om.last_ran = GetTime()
        cxmplex.force_update = false
    end
    if not isUpdated and next(cxmplex.om.filtered_objects) ~= nil then updated = false return else updated = true end

    -- iterate current objects
    for i = 1, count do
        local obj = cxmplex:GetObjectWithIndex(i)
        if obj then
            local objectGUID = cxmplex:ObjectGUID(obj)
            local unitName = UnitName(obj)
            if objectGUID and unitName ~= UnitName("player") then
                local id = cxmplex:ObjectId(obj)
                for list, items in pairs(cxmplex_savedvars.objects_to_track) do
                    if cxmplex_savedvars.enabled_lists[list] ~= nil then
                        if not cxmplex.om.filtered_objects[list] then
                            cxmplex.om.filtered_objects[list] = {}
                        end
                        if items[id] or items[unitName] or cxmplex:IsQuestObject(obj) then
                            cxmplex.om.filtered_objects[list][objectGUID] = obj
                        elseif cxmplex:ObjectIsUnit(obj) and cxmplex:UnitIsRare(obj) then
                            cxmplex.om.filtered_objects[list][objectGUID] = obj
                        end
                    end
                end
                cxmplex.om.object_list[objectGUID] = obj
            end
        end
    end
    -- iterate removed objects to clear tracked_objects table
    for i, obj in ipairs(removedObjects) do
        local guid = cxmplex:ObjectGUID(obj)
        if guid then
            for list, _ in pairs(cxmplex.om.filtered_objects) do
                cxmplex.om.filtered_objects[list][guid] = nil
            end
            cxmplex.om.object_list[guid] = nil
        end
    end
end

local function ObjectManagerOnUpdate(self, elapsed)
    if not self.last_time then
        self.last_time = 0
    end
    self.last_time = self.last_time + elapsed
    if self.last_time > 1 / 30 then
        RunObjectManager()
    end
end

local function ProcessObjects()
    local function subrange(t, first, last)
        local sub = {}
        for i = first, last do
            sub[#sub + 1] = t[i]
        end
        return sub
    end
    if next(cxmplex.om.processed_objects) ~= nil and not updated then return cxmplex.om.processed_objects end
    if cxmplex.om.process_all then
        cxmplex.om.filtered_objects = {default = cxmplex.om.object_list}
    end
    cxmplex.om.processed_objects = {}
    for list, items in pairs(cxmplex.om.filtered_objects) do
        cxmplex.om.processed_objects[list] = {}
        for guid, obj in pairs(items) do
            local dead = cxmplex:ObjectIsUnit(obj) and UnitIsDeadOrGhost(obj)
            if not dead then
                local x, y, z = cxmplex:ObjectPosition(obj)
                local id = cxmplex:ObjectId(obj)
                local name = UnitName(obj)
                local distance = cxmplex:GetDistanceBetweenObjects("player", obj)
                local rare = false
                if distance and distance <= 400 then
                    local color = {r = 50, g = 205, b = 50, a = 100}
                    if cxmplex:UnitIsRare(obj) then
                        color = {r = 220, g = 20, b = 60, a = 100}
                        rare = true
                    end
                    if x and y and z and id and name and distance and not dead then
                        table.insert(cxmplex.om.processed_objects[list], {name = name, x = x, y = y, z = z, distance = distance, object = obj, id = id, color = color, rare = rare, time = GetTime()})
                    end
                else
                    cxmplex.om.filtered_objects[list][guid] = nil
                end
            end
        end
        if cxmplex.om.processed_objects[list] then
            table.sort(cxmplex.om.processed_objects[list], function(a, b) return a.distance < b.distance end)
            cxmplex.om.processed_objects[list] = subrange(cxmplex.om.processed_objects[list], 1, cxmplex.om.process_objects_size)
        end
    end
end

local function ProcessObjectsOnUpdate(self, elapsed)
    if not self.last_time then
        self.last_time = 0
    end
    self.last_time = self.last_time + elapsed
    if self.last_time > 1 / 120 then
        ProcessObjects()
    end
end

function cxmplex:InitObjectManager()
    cxmplex.om.frames.object_manager = CreateFrame("FRAME")
    cxmplex.om.frames.object_manager:SetScript("OnUpdate", ObjectManagerOnUpdate)
    cxmplex.om.frames.object_manager:RegisterEvent("PLAYER_ENTERING_WORLD")
    cxmplex.om.frames.object_manager:SetScript("OnEvent", function(...) cxmplex:ResetObjects() end)

    cxmplex.om.frames.process_objects = CreateFrame("FRAME")
    cxmplex.om.frames.process_objects:SetScript("OnUpdate", ProcessObjectsOnUpdate)
    cxmplex.om.running = true
end

function cxmplex:DestroyObjectManager()
    cxmplex.om.frames.object_manager:SetScript("OnUpdate", nil)
    cxmplex.om.frames.object_manager = nil

    cxmplex.om.frames.process_objects:SetScript("OnUpdate", nil)
    cxmplex.om.frames.process_objects = nil
    cxmplex.om.running = false
end
