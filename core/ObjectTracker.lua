local last_time = 0
local tracked_objects = {}
local objManagerFrame, processObjectFrame = nil

local updated = false
local processed_objects = {}

local function RunObjectManager()
    local count, isUpdated, addedObjects, removedObjects = cxmplex:GetObjectCount()
    if not isUpdated and next(tracked_objects) ~= nil then updated = false return else updated = true end
    -- iterate removed objects to clear tracked_objects table
    for i, obj in ipairs(removedObjects) do
        local guid = cxmplex:ObjectGUID(obj)
        if guid and tracked_objects[guid] ~= nil then
            tracked_objects[guid] = nil
        end
    end
    -- iterate current objects
    for i = 1, count do
        local obj = cxmplex:GetObjectWithIndex(i)
        if obj then
            local id = cxmplex:ObjectId(obj)
            for list, items in pairs(cxmplex_savedvars.objects_to_track) do
                if cxmplex_savedvars.enabled_lists[list] ~= nil then
                    if items[id] ~= nil then
                        tracked_objects[cxmplex:ObjectGUID(obj)] = obj
                    elseif cxmplex:ObjectIsUnit(obj) and cxmplex:UnitIsRare(obj) then
                        tracked_objects[cxmplex:ObjectGUID(obj)] = obj
                    elseif cxmplex:ObjectIsType() then
                        tracked_objects[cxmplex:ObjectGUID(obj)] = obj
                    end
                end
            end
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

local function subrange(t, first, last)
    local sub = {}
    for i = first, last do
        sub[#sub + 1] = t[i]
    end
    return sub
end


local function ProcessObjects()
    if next(processed_objects) ~= nil and not updated then return processed_objects end
    processed_objects = {}
    for guid, obj in pairs(tracked_objects) do
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
                    table.insert(processed_objects, {name = name, x = x, y = y, z = z, distance = distance, object = obj, id = id, color = color, rare = rare})
                end
            else
                tracked_objects[guid] = nil
            end
        end
    end
    table.sort(processed_objects, function(a, b) return a.distance < b.distance end)
    processed_objects = subrange(processed_objects, 1, 8)
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

local function GetTrackedObjects()
    return processed_objects
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

function cxmplex:InitObjectManager()
    objManagerFrame = CreateFrame("FRAME")
    objManagerFrame:SetScript("OnUpdate", ObjectManagerOnUpdate)
    objManagerFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
    objManagerFrame:SetScript("OnEvent", function(...) tracked_objects = {} end)

    processObjectFrame = CreateFrame("FRAME")
    processObjectFrame:SetScript("OnUpdate", ProcessObjectsOnUpdate)
end

function cxmplex:GetObjManagerFrame()
    return objManagerFrame
end

function cxmplex:DrawTrackedObjects()
    local function roundDistance(distance)
        if not distance then return 0 end
        return distance + 0.5 - (distance + 0.5) % 1
    end
    local objects = GetTrackedObjects()
    for guid, data in pairs(objects) do
        if data.object then
            data.distance = cxmplex:GetDistanceBetweenObjects("player", data.object)
        end
        if data.x ~= nil and data.y ~= nil and data.z ~= nil and data.name ~= nil then
            local r = data.color.r
            local g = data.color.g
            local b = data.color.b
            local alpha = data.color.a
            cxmplex.drawing:SetColor(r, g, b, alpha)
            cxmplex.drawing:Text(data.name .. " " .. roundDistance(data.distance), data.x, data.y, data.z + 3)
            if data.rare then
                local config = {texture = "Interface\\Addons\\" .. "\\media\\textures\\skull.blp", width = 64, height = 64, scale = 0.3}
                cxmplex.drawing:Texture(config, data.x, data.y, data.z, 80)
            end
        end
    end
end
