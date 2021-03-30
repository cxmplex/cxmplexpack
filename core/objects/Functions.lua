cxmplex.om = {}
-- object manager updated objects
cxmplex.om.updated = false
-- object manager currently interating objects
cxmplex.om.active = false
-- standard object list, split into object type
cxmplex.om.object_list = {}
cxmplex.om.object_list.raw = {}
cxmplex.om.object_list.players = {}
cxmplex.om.object_list.npcs = {}
cxmplex.om.object_list.gameobjects = {}
cxmplex.om.object_list.dynamicobjects = {}
cxmplex.om.object_list.areatriggers = {}
-- filtered and quest related objects
cxmplex.om.object_list.filtered = {}
cxmplex.om.object_list.interactable = {}
-- fast access indexes
cxmplex.om.object_list.indexes = {}
cxmplex.om.object_list.indexes.guid = {}
cxmplex.om.object_list.indexes.name = {}
cxmplex.om.object_list.indexes.id = {}
-- frame access for object manager control
cxmplex.om.frames = {}
cxmplex.om.frames.object_manager = nil
cxmplex.om.frames.process_objects = nil

function cxmplex:GetObjectList()
    return cxmplex.om.object_list.objects
end

function cxmplex:oGetObjectCount()
    return #cxmplex.om.object_list.objects, cxmplex.om.updated, nil, nil
end

function cxmplex:oGetObjectWithIndex(index)
    return cxmplex.om.object_list.objects[index]
end

cxmplex.GetNpcCountCache = {}
cxmplex.fGetNpcCount = {}
cxmplex.fGetNpcCount.use_cache = false
function cxmplex:GetNpcCount(pointer, range)
    if not range then range = 40 end
    if pointer and range then
        cxmplex.fGetNpcCount.use_cache = true
        local npcs = {}
        for i = 1, #cxmplex.om.object_list.npcs do
            local obj = cxmplex.om.object_list.npcs[i]
            local distance = cxmplex:GetDistanceBetweenObjects(obj.Object, pointer)
            if obj and distance and distance <= range then
                table.insert(npcs, obj)
            end
        end
        cxmplex.GetNpcCountCache = npcs
        return #npcs
    end
    cxmplex.fGetNpcCount.use_cache = false
    return #cxmplex.om.object_list.npcs
end

function cxmplex:GetNpcWithIndex(index)
    if cxmplex.fGetNpcCount.use_cache then
        return cxmplex.GetNpcCountCache[index]
    end
    return cxmplex.om.object_list.npcs[index]
end

cxmplex.GetPlayerCountCache = {}
cxmplex.fGetPlayerCount = {}
cxmplex.fGetPlayerCount.use_cache = false
function cxmplex:GetPlayerCount(pointer, range)
    if not range then range = 40 end
    if pointer and range then
        cxmplex.fGetPlayerCount.use_cache = true
        local players = {}
        for i = 1, #cxmplex.om.object_list.players do
            local obj = cxmplex.om.object_list.players[i]
            local distance = cxmplex:GetDistanceBetweenObjects(obj.Object, pointer)
            if obj and distance and distance <= range then
                table.insert(players, obj)
            end
        end
        cxmplex.GetPlayerCountCache = players
        return #players
    end
    cxmplex.fGetPlayerCount.use_cache = false
    return #cxmplex.om.object_list.players
end

function cxmplex:GetPlayerWithIndex(index)
    if cxmplex.fGetPlayerCount.use_cache then
        return cxmplex.GetPlayerCountCache[index]
    end
    return cxmplex.om.object_list.players[index]
end

cxmplex.GetGameObjectCountCache = {}
cxmplex.fGetGameObjectCount = {}
cxmplex.fGetGameObjectCount.use_cache = false
function cxmplex:GetGameObjectCount(pointer, range)
    if not range then range = 40 end
    if pointer and range then
        cxmplex.fGetGameObjectCount.use_cache = true
        local gameobjects = {}
        for i = 1, #cxmplex.om.object_list.gameobjects do
            local obj = cxmplex.om.object_list.gameobjects[i]
            local distance = cxmplex:GetDistanceBetweenObjects(obj.Object, pointer)
            if obj and distance and distance <= range then
                table.insert(gameobjects, obj)
            end
        end
        cxmplex.GetGameObjectCountCache = gameobjects
        return #gameobjects
    end
    cxmplex.fGetGameObjectCount.use_cache = false
    return #cxmplex.om.object_list.gameobjects
end

function cxmplex:GetGameObjectWithIndex(index)
    if cxmplex.fGetGameObjectCount.use_cache then
        return cxmplex.GetGameObjectCountCache[index]
    end
    return cxmplex.om.object_list.gameobjects[index]
end

cxmplex.GetDynamicObjectCountCache = {}
cxmplex.fGetDynamicObjectCount = {}
cxmplex.fGetDynamicObjectCount.use_cache = false
function cxmplex:GetDynamicObjectCount(pointer, range)
    if not range then range = 40 end
    if pointer and range then
        cxmplex.fGetDynamicObjectCount.use_cache = true
        local dynamicobjects = {}
        for i = 1, #cxmplex.om.object_list.dynamicobjects do
            local obj = cxmplex.om.object_list.dynamicobjects[i]
            local distance = cxmplex:GetDistanceBetweenObjects(obj.Object, pointer)
            if obj and distance and distance <= range then
                table.insert(dynamicobjects, obj)
            end
        end
        cxmplex.GetDynamicObjectCountCache = dynamicobjects
        return #dynamicobjects
    end
    cxmplex.fGetDynamicObjectCount.use_cache = false
    return #cxmplex.om.object_list.dynamicobjects
end

function cxmplex:GetDynamicObjectWithIndex(index)
    if cxmplex.fGetDynamicObjectCount.use_cache then
        return cxmplex.GetDynamicObjectCountCache[index]
    end
    return cxmplex.om.object_list.dynamicobjects[index]
end

cxmplex.GetAreaTriggerCountCache = {}
cxmplex.fGetAreaTriggerCount = {}
cxmplex.fGetAreaTriggerCount.use_cache = false
function cxmplex:GetAreaTriggerCount(pointer, range)
    if not range then range = 40 end
    if pointer and range then
        cxmplex.fGetAreaTriggerCount.use_cache = true
        local areatriggers = {}
        for i = 1, #cxmplex.om.object_list.areatriggers do
            local obj = cxmplex.om.object_list.areatriggers[i]
            local distance = cxmplex:GetDistanceBetweenObjects(obj.Object, pointer)
            if obj and distance and distance <= range then
                table.insert(areatriggers, obj)
            end
        end
        cxmplex.GetAreaTriggerCountCache = areatriggers
        return #areatriggers
    end
    cxmplex.fGetAreaTriggerCount.use_cache = false
    return #cxmplex.om.object_list.areatriggers
end

function cxmplex:GetAreaTriggerWithIndex(index)
    if cxmplex.fGetAreaTriggerCount.use_cache then
        return cxmplex.GetAreaTriggerCountCache[index]
    end
    return cxmplex.om.object_list.areatriggers[index]
end

-- overwrite handsfree / ucs API
-- avoids conflicts and adds caching
function cxmplex:OverwriteAPI()
    print("Overwriting HF API!")
    _G.GetObjectCount = function() return cxmplex:oGetObjectCount() end
    _G.GetObjectWithIndex = function(...) return cxmplex:oGetObjectWithIndex(...).Object end
    _G.GetPlayerCount = function(...) return cxmplex:GetPlayerCount(...) end
    _G.GetPlayerWithIndex = function(...) return cxmplex:GetPlayerWithIndex(...).Object end
    _G.GetNpcCount = function(...) return cxmplex:GetNpcCount(...) end
    _G.GetNpcWithIndex = function(...) return cxmplex:GetNpcWithIndex(...).Object end
    _G.GetGameObjectCount = function(...) return cxmplex:GetGameObjectCount(...) end
    _G.GetGameObjectWithIndex = function(...) return cxmplex:GetGameObjectWithIndex(...).Object end
    _G.GetDynamicObjectCount = function(...) return cxmplex:GetDynamicObjectCount(...) end
    _G.GetDynamicObjectWithIndex = function(...) return cxmplex:GetDynamicObjectWithIndex(...).Object end
    _G.GetAreaTriggerCount = function(...) return cxmplex:GetAreaTriggerCount(...) end
    _G.GetAreaTriggerWithIndex = function(...) return cxmplex:GetAreaTriggerWithIndex(...).Object end
end

local api_override = CreateFrame("FRAME")
api_override:SetScript("OnUpdate", function()
    if GetObjectCount then
    cxmplex:OverwriteAPI()
    api_override:SetScript("OnUpdate", nil)
    api_override = nil
    return
end
end)


function cxmplex:GetFilteredObjects()
return cxmplex.om.object_list.filtered
end

function cxmplex:GetInteractableObjects()
return cxmplex.om.object_list.interactable
end

function cxmplex:AddObjectToTrackerByIdOrName(id, list)
if not list then list = "default" end
if cxmplex_savedvars.objects_to_track[list] == nil then return end
cxmplex_savedvars.objects_to_track[list][id] = true
end

function cxmplex:RemoveObjectFromTrackerByIdOrName(id, list)
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

function cxmplex:GetObjManagerFrame()
return cxmplex.om.frames.object_manager
end
