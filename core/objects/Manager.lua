local function ObjectProcessor(obj_type)
    local object_list = cxmplex.om.object_list.raw[obj_type]
    if not object_list then return end
    local temp = {}
    local filtered = cxmplex.om.object_list.filtered
    local interactable = cxmplex.om.object_list.interactable
    local target = cxmplex:UnitTarget("player")
    for i = 1, #object_list do
        local struct = object_list[i]
        local obj = struct.Object
        if obj_type == "players" then
            struct.Flags.value = cxmplex:UnitFlags(obj)
            if struct.Flags.value then
                local flags = {}
                for k, v in pairs(cxmplex.enums.UnitFlags) do
                    if bit.band(struct.Flags.value, v) > 0 then
                        flags[k] = true
                    end
                end
                struct.Flags.list = flags
                local dynamic_flags = {}
                for k, v in pairs(cxmplex.enums.UnitDynamicFlags) do
                    if bit.band(struct.DynamicFlags.value, v) > 0 then
                        dynamic_flags[k] = true
                    end
                end
                struct.DynamicFlags.list = dynamic_flags
                struct.Info.Unit.Dead = UnitIsDeadOrGhost(obj)
                table.insert(temp, struct)
            end
        elseif obj_type == "npcs" then
            struct.Flags.value = cxmplex:UnitFlags(obj)
            if struct.Flags.value then
                local flags = {}
                for k, v in pairs(cxmplex.enums.UnitFlags) do
                    if bit.band(struct.Flags.value, v) > 0 then
                        flags[k] = true
                    end
                end
                struct.Flags.list = flags
                local dynamic_flags = {}
                for k, v in pairs(cxmplex.enums.UnitDynamicFlags) do
                    if bit.band(struct.DynamicFlags.value, v) > 0 then
                        dynamic_flags[k] = true
                    end
                end
                struct.DynamicFlags.list = dynamic_flags
                struct.Info.Unit.Dead = UnitIsDeadOrGhost(obj)
                struct.Info.Unit.Rare = cxmplex:UnitIsRare(obj)
                struct.Info.Unit.Hidden = cxmplex:UnitIsHidden(obj, struct.DynamicFlags.value)
                struct.Info.Unit.Lootable = cxmplex:UnitCanBeLooted(object)
                struct.Info.Quest.IsTiedToQuest = cxmplex:ObjectIsQuestObjective(obj, struct.Id, struct.Guid, false)
                table.insert(temp, struct)
            end
        elseif obj_type == "gameobjects" then
            struct.Type.sub_type.id = cxmplex:GameObjectType(obj)
            struct.Type.sub_type.name = cxmplex.enums.GameObjectTypesInverted[struct.Type.sub_type.id]
            struct.Flags.value = cxmplex:GameObjectFlags(obj)
            if struct.Flags.value then
                local flags = {}
                for k, v in pairs(cxmplex.enums.GameObjectFlags) do
                    if bit.band(struct.Flags.value, v) > 0 then
                        flags[k] = true
                    end
                end
                struct.Flags.list = flags
                local dynamic_flags = {}
                for k, v in pairs(cxmplex.enums.GameObjectDynamicLowFlags) do
                    if bit.band(struct.DynamicFlags.value, v) > 0 then
                        dynamic_flags[k] = true
                    end
                end
                struct.DynamicFlags.list = dynamic_flags
                struct.Info.Quest.IsTiedToQuest = cxmplex:ObjectIsQuestObjective(obj, struct.Id, struct.Guid, false)
                struct.Info.GameObject.Interactable = cxmplex:ObjectIsInteractable(obj, struct.DynamicFlags.value)
                table.insert(temp, struct)
            end
        end
        for list, items in pairs(cxmplex_savedvars.objects_to_track) do
            if cxmplex_savedvars.enabled_lists[list] ~= nil then
                if not filtered[list] then
                    filtered[list] = {}
                end
                if (list == "quest" and struct.Info.Quest.IsTiedToQuest) or items[struct.Id] or items[struct.Name] or struct.Info.Unit.Rare then
                    table.insert(filtered[list], struct)
                end
            end
        end
        if struct.Info.Unit.Lootable or (struct.Type.base_type.name == "GameObject" and struct.Info.GameObject.Interactable) then
            table.insert(interactable, struct)
        end
        if struct.Object == target then
            TARGET_UNIT = struct
        end
    end
    cxmplex.om.object_list[obj_type] = temp
end

local function RunObjectManager()
    -- local start = debugprofilestop()
    local count, isUpdated, addedObjects, removedObjects = cxmplex:GetObjectCount()
    if cxmplex.force_update then
        isUpdated = true
        cxmplex.force_update = false
    end
    if not isUpdated then cxmplex.om.updated = false return else cxmplex.om.updated = true end
    local players = {}
    local gameobjects = {}
    local npcs = {}
    local dynamicobjects = {}
    local areatriggers = {}
    local objects = {}
    local objects_by_guid = {}
    local objects_by_name = {}
    local objects_by_id = {}
    cxmplex.om.active = true
    -- iterate current objects
    for i = 1, count do
        local obj = cxmplex:GetObjectWithIndex(i)
        if obj then
            local objectGUID = cxmplex:ObjectGUID(obj)
            local unitName = UnitName(obj)
            local id = cxmplex:ObjectId(obj)
            if objectGUID and unitName ~= UnitName("player") and id then
                local struct = {
                    Object = "nil",
                    Name = "nil",
                    Guid = "nil",
                    Id = 0,
                    Type = {
                        base_type = { -- cxmplex:ObjectTypeFlags() GameObject
                            name = "nil"
                        },
                        sub_type = { -- cxmplex:GameObjectType() Door
                            id = 0,
                            name = "nil"
                        }
                    },
                    Flags = { value = 0, list = {} }, -- Depends on sub_type
                    DynamicFlags = { value = 0, list = {} }, -- Depends on sub_tpe
                    Info = {
                        Quest = {
                            IsTiedToQuest = false
                        },
                        Unit = {
                            Dead = false,
                            Hidden = false,
                            Rare = false,
                            Lootable = false,
                            Skinnable = false
                        },
                        Filter = {
                            List = "nil"
                        },
                        GameObject = {
                            Interactable = true
                        }
                    }
                }
                struct.Object = obj
                struct.Name = unitName
                struct.Guid = objectGUID
                struct.Id = id
                struct.DynamicFlags.value = cxmplex:ObjectDynamicFlags(obj)
                if struct.DynamicFlags.value and struct.Name ~= "nil" then
                    local typeFlags = cxmplex:ObjectTypeFlags(obj)
                    if bit.band(typeFlags, cxmplex.enums.ObjectTypeFlags.Player) > 0 then
                        struct.Type.base_type.name = "Player"
                        table.insert(players, struct)
                    elseif bit.band(typeFlags, cxmplex.enums.ObjectTypeFlags.GameObject) > 0 then
                        struct.Type.base_type.name = "GameObject"
                        table.insert(gameobjects, struct)
                    elseif bit.band(typeFlags, cxmplex.enums.ObjectTypeFlags.Unit) > 0 and bit.band(typeFlags, cxmplex.enums.ObjectTypeFlags.Player) == 0 then
                        struct.Type.base_type.name = "Unit"
                        table.insert(npcs, struct)
                    elseif bit.band(typeFlags, cxmplex.enums.ObjectTypeFlags.DynamicObject) > 0 then
                        struct.Type.base_type.name = "DynamicObject"
                        table.insert(dynamicobjects, struct)
                    elseif bit.band(typeFlags, cxmplex.enums.ObjectTypeFlags.AreaTrigger) > 0 then
                        struct.Type.base_type.name = "AreaTrigger"
                        table.insert(areatriggers, struct)
                    end
                    table.insert(objects, struct)
                    objects_by_guid[struct.Guid] = struct
                    if struct.Name then
                        if not objects_by_name[struct.Name] then
                            objects_by_name[struct.Name] = {}
                        end
                        table.insert(objects_by_name[struct.Name], struct)
                    end
                    if not objects_by_id[struct.Id] then
                        objects_by_id[struct.Id] = {}
                    end
                    table.insert(objects_by_id[struct.Id], struct)
                end
            end
        end
    end

    -- set global object lists
    cxmplex.om.object_list.raw.players = players
    cxmplex.om.object_list.raw.npcs = npcs
    cxmplex.om.object_list.raw.gameobjects = gameobjects
    cxmplex.om.object_list.dynamicobjects = dynamicobjects
    cxmplex.om.object_list.areatriggers = areatriggers
    cxmplex.om.object_list.objects = objects
    cxmplex.om.object_list.indexes.guid = objects_by_guid
    cxmplex.om.object_list.indexes.name = objects_by_name
    cxmplex.om.object_list.indexes.id = objects_by_id

    -- object manager is done populating lists, they can now be accessed safely
    cxmplex.om.active = false

    -- do additional processing on objects
    -- since 3 object processors will be populating these lists,
    -- we reset the list here instead of in one of the ObjectProcessors
    cxmplex.om.object_list.filtered = {}
    cxmplex.om.object_list.interactable = {}
    C_Timer.After(0, function() ObjectProcessor("players") end)
    C_Timer.After(0, function() ObjectProcessor("npcs") end)
    C_Timer.After(0, function() ObjectProcessor("gameobjects") end)
    -- print("OM Elapsed: " .. debugprofilestop() - start)
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

function cxmplex:InitObjectManager()
    cxmplex.om.frames.object_manager = CreateFrame("FRAME")
    cxmplex.om.frames.object_manager:SetScript("OnUpdate", ObjectManagerOnUpdate)
    cxmplex.om.frames.object_manager:RegisterEvent("PLAYER_ENTERING_WORLD")
    cxmplex.om.frames.object_manager:SetScript("OnEvent", function(...) cxmplex:ResetObjects() end)
    cxmplex.om.running = true
end

function cxmplex:DestroyObjectManager()
    cxmplex.om.frames.object_manager:SetScript("OnUpdate", nil)
    cxmplex.om.frames.object_manager = nil
    cxmplex.om.running = false
end
