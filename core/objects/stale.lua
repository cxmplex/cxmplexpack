-- if cxmplex:ObjectIsGameObject(obj) then
--     local object = obj
--     local flags = cxmplex:ObjectDescriptor(object, cxmplex:GetObjectDescriptorsTable().CGGameObjectData__m_createdBy + 0x20, cxmplex:GetValueTypesTable().UInt)
--     local m_typeid = cxmplex:ObjectDescriptor(object, cxmplex:GetObjectDescriptorsTable().CGGameObjectData__m_createdBy + 0x46, cxmplex:GetValueTypesTable().UInt)
--
--     -- print("GameObject: " .. unitName)
--     -- print("GameObject GUID: " .. objectGUID)
--     -- print("GameObject Field GUID: " .. cxmplex:ObjectField(object, 0, cxmplex:GetValueTypesTable().GUID))
--     -- local gid, name = cxmplex:GameObjectType(object)
--     -- print("GameObject Type Id: " .. gid)
--     -- print("GameObject dec Type Id: " .. m_typeid)
--     local gid, gtypename = cxmplex:GameObjectType(object)
--     for j = 1, 10000 do
--         local dec = cxmplex:ObjectDescriptor(object, cxmplex:GetObjectDescriptorsTable().CGGameObjectData__m_createdBy + j, cxmplex:GetValueTypesTable().UInt)
--         if dec == 59601 then
--             print("found match at index " .. j)
--         end
--     end
--     for j = 1, 5000 do
--         local dec = cxmplex:ObjectField(object, j, cxmplex:GetValueTypesTable().UInt)
--         if dec == 59601 then
--             print("found match at index " .. j)
--         end
--     end
--     -- print("m_flags: " .. flags)
--     -- print("m_spellvisualid: " .. m_spellvisualid)
--     -- print("m_statespellvisualid: " .. m_statespellvisualid)
--     -- print("m_spawntrackingstateanimid: " .. m_spawntrackingstateanimid)
--     -- print("m_spawntrackingstateanimkitid: " .. m_spawntrackingstateanimkitid)
--     -- print("m_stateworldeffectid: " .. m_stateworldeffectid)
--
--     -- local gcount = cxmplex:GetGameObjectCount("player", 40)
--     -- for j = 1, gcount do
--     --     local gobj = cxmplex:GetGameObjectWithIndex(j)
--     --     print(UnitName(gobj) .. " " .. tostring(cxmplex:ObjectIsQuestObjective(gobj, false)))
--     -- end
--     -- local goflags = cxmplex:GameObjectFlags(obj)
--     -- local golowflags = cxmplex:GameObjectDynamicLowFlags(obj)
--     -- print("Object flags " .. goflags)
--     -- print("low flags " .. golowflags)
--     -- print("GO_DYNFLAG_LO_HIDE_MODEL" .. bit.band(golowflags, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_HIDE_MODEL))
--     -- print("GO_DYNFLAG_LO_ACTIVATE" .. bit.band(golowflags, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_ACTIVATE))
--     -- print("GO_DYNFLAG_LO_ANIMATE" .. bit.band(golowflags, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_ANIMATE))
--     -- print("GO_DYNFLAG_LO_NO_INTERACT" .. bit.band(golowflags, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_NO_INTERACT))
--     -- print("GO_DYNFLAG_LO_SPARKLE" .. bit.band(golowflags, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_SPARKLE))
--     -- print("GO_DYNFLAG_LO_STOPPED" .. bit.band(golowflags, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_STOPPED))
--
-- end
-- local typeId, typeName = cxmplex:GameObjectType(obj)
-- if cxmplex:ObjectIsType(obj, cxmplex:GetObjectTypeFlagsTable().GameObject) and cxmplex:GameObjectIsType(obj, cxmplex.EnumGameObjectType.GAMEOBJECT_TYPE_TRANSPORT) then
--     if not USE_ME then
--         USE_ME = obj
--     end
--     local dec1 = cxmplex:ObjectDescriptor(obj, cxmplex:GetObjectDescriptorsTable().CGGameObjectData__m_createdBy + 32, cxmplex:GetValueTypesTable().UInt)
--     local dec2 = cxmplex:ObjectDescriptor(obj, cxmplex:GetObjectDescriptorsTable().CGGameObjectData__m_createdBy + 44, cxmplex:GetValueTypesTable().UInt)
--
--     if dec1 > 0 then
--         print("Dec1: " .. dec1)
--     end
--     if dec2 > 0 then
--         print("dec2: " .. dec2)
--     end
--
--
--
--     --GO_FLAG_IN_USE = 0x00000001, -- disables interaction while animated
--     -- --                 -- GO_FLAG_LOCKED = 0x00000002, -- require key, spell, event, etc to be opened. Makes "Locked" appear in tooltip
--     -- --                 -- GO_FLAG_INTERACT_COND = 0x00000004, -- cannot interact (condition to interact - requires GO_DYNFLAG_LO_ACTIVATE to enable interaction clientside)
--     -- --                 -- GO_FLAG_TRANSPORT = 0x00000008, -- any kind of transport? Object can transport (elevator, boat, car)
--     -- --                 -- GO_FLAG_NOT_SELECTABLE = 0x00000010, -- not selectable even in GM mode
--     -- --                 -- GO_FLAG_NODESPAWN = 0x00000020, -- never despawn, typically for doors, they just change state
--     -- --                 -- GO_FLAG_AI_OBSTACLE = 0x00000040, -- makes the client register the object in something called AIObstacleMgr, unknown what it does
--     -- --                 -- GO_FLAG_FREEZE_ANIMATION = 0x00000080,
--     -- --                 -- -- for object types GAMEOBJECT_TYPE_GARRISON_BUILDING, GAMEOBJECT_TYPE_GARRISON_PLOT and GAMEOBJECT_TYPE_PHASEABLE_MO flag bits 8 to 12 are used as WMOAreaTable::NameSetID
--     -- --                 -- GO_FLAG_DAMAGED = 0x00000200,
--     -- --                 -- GO_FLAG_DESTROYED = 0x00000400,
--     -- --                 -- GO_FLAG_INTERACT_DISTANCE_USES_TEMPLATE_MODEL = 0x00080000, -- client checks interaction distance from model sent in SMSG_QUERY_GAMEOBJECT_RESPONSE instead of GAMEOBJECT_DISPLAYID
--     -- --                 -- GO_FLAG_MAP_OBJECT = 0x00100000 -- pre-7.0 model loading used to be controlled by file extension (wmo vs m2)
--     print("GO_FLAG_IN_USE " .. bit.band(dec1, cxmplex.enums.GameObjectFlags.GO_FLAG_IN_USE) .. " " .. bit.band(dec2, cxmplex.enums.GameObjectFlags.GO_FLAG_IN_USE)
--
--     )
--     print("GO_FLAG_LOCKED " .. bit.band(dec1, cxmplex.enums.GameObjectFlags.GO_FLAG_LOCKED) .. " " .. bit.band(dec2, cxmplex.enums.GameObjectFlags.GO_FLAG_LOCKED)
--
--     )
--     print("GO_FLAG_INTERACT_COND " .. bit.band(dec1, cxmplex.enums.GameObjectFlags.GO_FLAG_INTERACT_COND) .. " " .. bit.band(dec2, cxmplex.enums.GameObjectFlags.GO_FLAG_INTERACT_COND)
--
--     )
--     print("GO_FLAG_TRANSPORT " .. bit.band(dec1, cxmplex.enums.GameObjectFlags.GO_FLAG_TRANSPORT) .. " " .. bit.band(dec2, cxmplex.enums.GameObjectFlags.GO_FLAG_TRANSPORT)
--
--     )
--     print("GO_FLAG_NOT_SELECTABLE " .. bit.band(dec1, cxmplex.enums.GameObjectFlags.GO_FLAG_NOT_SELECTABLE) .. " " .. bit.band(dec2, cxmplex.enums.GameObjectFlags.GO_FLAG_NOT_SELECTABLE))
--
--     print("GO_FLAG_FREEZE_ANIMATION " .. bit.band(dec1, cxmplex.enums.GameObjectFlags.GO_FLAG_FREEZE_ANIMATION) .. " " .. bit.band(dec2, cxmplex.enums.GameObjectFlags.GO_FLAG_FREEZE_ANIMATION)
--
--     )
--     print("GO_FLAG_NODESPAWN " .. bit.band(dec1, cxmplex.enums.GameObjectFlags.GO_FLAG_NODESPAWN) .. " " .. bit.band(dec2, cxmplex.enums.GameObjectFlags.GO_FLAG_NODESPAWN)
--
--     )
--     print("GO_FLAG_DESTROYED " .. bit.band(dec1, cxmplex.enums.GameObjectFlags.GO_FLAG_DESTROYED) .. " " .. bit.band(dec2, cxmplex.enums.GameObjectFlags.GO_FLAG_DESTROYED)
--
--     )
--     print("GO_FLAG_DESTROYED " .. bit.band(dec1, cxmplex.enums.GameObjectFlags.GO_FLAG_DAMAGED) .. " " .. bit.band(dec2, cxmplex.enums.GameObjectFlags.GO_FLAG_DAMAGED)
--
--     )
--
--
-- end
-- --             local objdyn = cxmplex:ObjectDynamicFlags(obj)
-- local dec = cxmplex:ObjectDescriptor(obj, cxmplex:GetObjectDescriptorsTable().CGGameObjectData__m_createdBy + 32, cxmplex:GetValueTypesTable().Byte)
-- --             if objdyn ~= 0 or objdec ~= 0 then
-- --
-- --
-- --                 -- if cxmplex:ObjectDescriptor(obj, cxmplex:GetObjectDescriptorsTable().CGObjectData__m_dynamicFlags, cxmplex:GetValueTypesTable().UInt) then
-- --                 -- local cxmplex.enums.UnitDynamicFlags = {
-- --                 --     UNIT_DYNFLAG_NONE = 0x0000,
-- --                 --     UNIT_DYNFLAG_HIDE_MODEL = 0x0002, -- Object model is not shown with this flag
-- --                 --     UNIT_DYNFLAG_LOOTABLE = 0x0004,
-- --                 --     UNIT_DYNFLAG_TRACK_UNIT = 0x0008,
-- --                 --     UNIT_DYNFLAG_TAPPED = 0x0010, -- Lua_UnitIsTapped
-- --                 --     UNIT_DYNFLAG_SPECIALINFO = 0x0020,
-- --                 --     UNIT_DYNFLAG_DEAD = 0x0040,
-- --                 --     UNIT_DYNFLAG_REFER_A_FRIEND = 0x0080
-- --                 -- }
-- --                 -- if cxmplex:ObjectIsType(obj, cxmplex:GetObjectTypeFlagsTable().Unit) then
-- --                 --     print("NONE " .. bit.band(objdyn, cxmplex.enums.UnitDynamicFlags.UNIT_DYNFLAG_NONE))
-- --                 --     print("HIDE_MODEL " .. bit.band(objdyn, cxmplex.enums.UnitDynamicFlags.UNIT_DYNFLAG_HIDE_MODEL))
-- --                 --     print("LOOTABLE " .. bit.band(objdyn, cxmplex.enums.UnitDynamicFlags.UNIT_DYNFLAG_LOOTABLE))
-- --                 --     print("TRACK_UNIT " .. bit.band(objdyn, cxmplex.enums.UnitDynamicFlags.UNIT_DYNFLAG_TRACK_UNIT))
-- --                 --     print("TAPPED " .. bit.band(objdyn, cxmplex.enums.UnitDynamicFlags.UNIT_DYNFLAG_TAPPED))
-- --                 --     print("SPECIALINFO " .. bit.band(objdyn, cxmplex.enums.UnitDynamicFlags.UNIT_DYNFLAG_SPECIALINFO))
-- --                 --     print("DEAD " .. bit.band(objdyn, cxmplex.enums.UnitDynamicFlags.UNIT_DYNFLAG_DEAD))
-- --                 --     print("REFER_A_FRIEND " .. bit.band(objdyn, cxmplex.enums.UnitDynamicFlags.UNIT_DYNFLAG_REFER_A_FRIEND))
-- --                 -- end
-- --
-- --                 if cxmplex:ObjectIsType(obj, cxmplex:GetObjectTypeFlagsTable().GameObject) then
-- --                     local dynamicFlags = cxmplex:ObjectDynamicFlags(obj)
-- -- local lowbits = bit.band(dynamicFlags, 0xFf)
-- --                     local cxmplex.enums.GameObjectDynamicLowFlags = {
-- --                         GO_DYNFLAG_LO_HIDE_MODEL = 2, -- Object model is not shown with this flag
-- --                         GO_DYNFLAG_LO_ACTIVATE = 4, -- enables interaction with GO
-- --                         GO_DYNFLAG_LO_ANIMATE = 8, -- possibly more distinct animation of GO
-- --                         GO_DYNFLAG_LO_NO_INTERACT = 16, -- appears to disable interaction (not fully verified)
-- --                         GO_DYNFLAG_LO_SPARKLE = 32, -- makes GO sparkle
-- --                         GO_DYNFLAG_LO_STOPPED = 64 -- Transport is stopped
-- --                     }
-- --                     if lowbits > 0 then
-- --                         print(UnitName(obj))
-- --
-- --                         print("Object Dynamic Low Flags: " .. lowbits)
-- --                         print("GO_DYNFLAG_LO_HIDE_MODEL" .. bit.band(lowbits, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_HIDE_MODEL))
-- --                         print("GO_DYNFLAG_LO_ACTIVATE" .. bit.band(lowbits, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_ACTIVATE))
-- --                         print("GO_DYNFLAG_LO_ANIMATE" .. bit.band(lowbits, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_ANIMATE))
-- --                         print("GO_DYNFLAG_LO_NO_INTERACT" .. bit.band(lowbits, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_NO_INTERACT))
-- --                         print("GO_DYNFLAG_LO_SPARKLE" .. bit.band(lowbits, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_SPARKLE))
-- --                         print("GO_DYNFLAG_LO_STOPPED" .. bit.band(lowbits, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_STOPPED))
-- --                         print("-------------------------------------")
-- --
-- --                     end
-- --                     -- if dynamicFlags > 0 then
-- --                     --     print("GO_DYNFLAG_LO_HIDE_MODEL" .. bit.band(dynamicFlags, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_HIDE_MODEL))
-- --                     --     print("GO_DYNFLAG_LO_ACTIVATE" .. bit.band(dynamicFlags, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_ACTIVATE))
-- --                     --     print("GO_DYNFLAG_LO_ANIMATE" .. bit.band(dynamicFlags, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_ANIMATE))
-- --                     --     print("GO_DYNFLAG_LO_NO_INTERACT" .. bit.band(dynamicFlags, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_NO_INTERACT))
-- --                     --     print("GO_DYNFLAG_LO_SPARKLE" .. bit.band(dynamicFlags, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_SPARKLE))
-- --                     --     print("GO_DYNFLAG_LO_STOPPED" .. bit.band(dynamicFlags, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_STOPPED))
-- --                     -- end
-- if cxmplex:ObjectIsType(obj, cxmplex:GetObjectTypeFlagsTable().GameObject) then
--     if dec > 0 then
--         print("our descriptor for [" .. UnitName(obj) .. "]" .. " " .. dec)
--
--         print("GO UNIT DEC FLAGS " .. dec)
--         print("GO_FLAG_IN_USE " .. bit.band(dec, cxmplex.enums.GameObjectFlags.GO_FLAG_IN_USE))
--         print("GO_FLAG_LOCKED " .. bit.band(dec, cxmplex.enums.GameObjectFlags.GO_FLAG_LOCKED))
--         print("GO_FLAG_INTERACT_COND " .. bit.band(dec, cxmplex.enums.GameObjectFlags.GO_FLAG_INTERACT_COND))
--         print("GO_FLAG_TRANSPORT " .. bit.band(dec, cxmplex.enums.GameObjectFlags.GO_FLAG_TRANSPORT))
--         print("GO_FLAG_NOT_SELECTABLE " .. bit.band(dec, cxmplex.enums.GameObjectFlags.GO_FLAG_NOT_SELECTABLE))
--         print("GO_FLAG_NODESPAWN " .. bit.band(dec, cxmplex.enums.GameObjectFlags.GO_FLAG_NODESPAWN))
--         print("GO_FLAG_AI_OBSTACLE " .. bit.band(dec, cxmplex.enums.GameObjectFlags.GO_FLAG_AI_OBSTACLE))
--         print("GO_FLAG_FREEZE_ANIMATION " .. bit.band(dec, cxmplex.enums.GameObjectFlags.GO_FLAG_FREEZE_ANIMATION))
--         print("GO_FLAG_DAMAGED " .. bit.band(dec, cxmplex.enums.GameObjectFlags.GO_FLAG_DAMAGED))
--         print("GO_FLAG_DESTROYED " .. bit.band(dec, cxmplex.enums.GameObjectFlags.GO_FLAG_DESTROYED))
--         print("GO_FLAG_INTERACT_DISTANCE_USES_TEMPLATE_MODEL " .. bit.band(dec, cxmplex.enums.GameObjectFlags.GO_FLAG_INTERACT_DISTANCE_USES_TEMPLATE_MODEL))
--     end
-- end
--
-- --                 end
-- --
-- --                 --GO_FLAG_IN_USE = 0x00000001, -- disables interaction while animated
-- --                 -- GO_FLAG_LOCKED = 0x00000002, -- require key, spell, event, etc to be opened. Makes "Locked" appear in tooltip
-- --                 -- GO_FLAG_INTERACT_COND = 0x00000004, -- cannot interact (condition to interact - requires GO_DYNFLAG_LO_ACTIVATE to enable interaction clientside)
-- --                 -- GO_FLAG_TRANSPORT = 0x00000008, -- any kind of transport? Object can transport (elevator, boat, car)
-- --                 -- GO_FLAG_NOT_SELECTABLE = 0x00000010, -- not selectable even in GM mode
-- --                 -- GO_FLAG_NODESPAWN = 0x00000020, -- never despawn, typically for doors, they just change state
-- --                 -- GO_FLAG_AI_OBSTACLE = 0x00000040, -- makes the client register the object in something called AIObstacleMgr, unknown what it does
-- --                 -- GO_FLAG_FREEZE_ANIMATION = 0x00000080,
-- --                 -- -- for object types GAMEOBJECT_TYPE_GARRISON_BUILDING, GAMEOBJECT_TYPE_GARRISON_PLOT and GAMEOBJECT_TYPE_PHASEABLE_MO flag bits 8 to 12 are used as WMOAreaTable::NameSetID
-- --                 -- GO_FLAG_DAMAGED = 0x00000200,
-- --                 -- GO_FLAG_DESTROYED = 0x00000400,
-- --                 -- GO_FLAG_INTERACT_DISTANCE_USES_TEMPLATE_MODEL = 0x00080000, -- client checks interaction distance from model sent in SMSG_QUERY_GAMEOBJECT_RESPONSE instead of GAMEOBJECT_DISPLAYID
-- --                 -- GO_FLAG_MAP_OBJECT = 0x00100000 -- pre-7.0 model loading used to be controlled by file extension (wmo vs m2)
-- --                 -- end
-- --             end
