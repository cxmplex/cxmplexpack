cxmplex = {}
cxmplex_savedvars = {}
cxmplex.multijump_toggle = false
cxmplex.anti_afk = false
cxmplex.tracker_toggle = false
cxmplex.arena_los_toggle = true

local classification_types = {
  rareelite = true,
  rare = true
}

function printf(...) print(string.format(...)) end
--   _____
--  /  __ \
--  | /  \/ ___  _ __ ___  _ __ ___   ___  _ __
--  | |    / _ \| '_ ` _ \| '_ ` _ \ / _ \| '_ \
--  | \__/\ (_) | | | | | | | | | | | (_) | | | |
--  \____/\___/|_| |_| |_|_| |_| |_|\___/|_| |_|

-- Gets the base directory path of app storage.
function cxmplex:GetAppStorageDirectory()
  return IsLinuxClient("GetAppStorageDirectory")
end

-- Gets the app base directory path.
function cxmplex:GetAppDirectory()
  return IsLinuxClient("GetAppDirectory")
end

-- Gets the app username.
function cxmplex:GetAppUsername()
  return IsLinuxClient("GetAppUsername")
end

-- Gets the WoW base directory path.
function cxmplex:GetWoWDirectory()
  return IsLinuxClient("GetWoWDirectory")
end

-- Gets the value of the system variable previously set by SetSystemVar.
function cxmplex:GetSystemVar(name)
  return IsLinuxClient("GetSystemVar", name)
end

-- Sets a system variable.
function cxmplex:SetSystemVar(name, value)
  return IsLinuxClient("SetSystemVar", name, value)
end

-- |  ___(_) |
-- | |_   _| | ___
-- |  _| | | |/ _ \
-- | |   | | |  __/
-- \_|   |_|_|\___|

-- Checks if a file exists.
function cxmplex:FileExists(path)
  if not path then return end
  return IsLinuxClient("FileExists", path)
end
-- Reads all text from a file.
function cxmplex:ReadFile(path)
  if not path then return end
  return IsLinuxClient("ReadFile", path)
end
-- Writes all text to a file.
function cxmplex:WriteFile(path, content)
  if not path then return end
  IsLinuxClient("WriteFile", path, content)
end
-- Checks if a directory exists.
function cxmplex:DirectoryExists(path)
  return IsLinuxClient("DirectoryExists", path)
end
-- Creates a directory.
function cxmplex:CreateDirectory(path)
  if not path then return end
  return IsLinuxClient("CreateDirectory", path)
end
-- Gets all file names in a specific directory. Remind the path must end
-- with wildcards. e.g C:\Windows\*.lua
function cxmplex:GetDirectoryFiles(path)
  if not path then return end
  return IsLinuxClient("GetDirectoryFiles", "r9svH6YxEQbNTZGH", path)
end
-- Gets all sub folder names in a specific directory.
function cxmplex:GetDirectoryFolders(path)
  if not path then return end
  return IsLinuxClient("GetDirectoryFolders", path)
end

-- ___  ___      _   _
-- |  \/  |     | | | |
-- | .  . | __ _| |_| |__
-- | |\/| |/ _` | __| '_ \
-- | |  | | (_| | |_| | | |
-- \_|  |_/\__,_|\__|_| |_|

-- Gets all spanning circles of a specific radius over certain weighted points.
function cxmplex:GetAllSpanningCircles(radius, minWeight, points)
  return IsLinuxClient("GetAllSpanningCircles", radius, minWeight, points)
end

-- Gets the distance between two positions in 3D.
function cxmplex:GetDistanceBetweenPositions(x1, y1, z1, x2, y2, z2)
  return IsLinuxClient("GetDistanceBetweenPositions", x1, y1, z1, x2, y2, z2)
end

-- Gets the distance between two objects in 3D.
function cxmplex:GetDistanceBetweenObjects(object1, object2)
  if not object1 or not object2 then return 0 end
  return IsLinuxClient("GetDistanceBetweenObjects", object1, object2)
end

-- Gets the position from object 1 to object 2.
function cxmplex:GetPositionBetweenObjects(object1, object2, dist)
  if not object1 or not object2 then return 0 end
  return IsLinuxClient("GetPositionBetweenObjects", object1, object2, dist)
end

-- Gets the position from position 1 to position 2.
function cxmplex:GetPositionBetweenPositions(x1, y1, z1, x2, y2, z2, distance)
  return IsLinuxClient("GetPositionBetweenPositions", x1, y1, z1, x2, y2, z2, distance)
end

-- Gets the position relative to a specific position.
function cxmplex:GetPositionFromPosition(x1, y1, z1, distance, facing, pitch)
  return IsLinuxClient("GetPositionFromPosition", x1, y1, z1, distance, facing, pitch)
end

-- Gets the angles (facing & pitch) between two objects.
function cxmplex:GetAnglesBetweenObjects(object1, object2)
  if not object1 or not object2 then return 0 end
  return IsLinuxClient("GetAnglesBetweenObjects", object1, object2)
end

-- ___  ___
-- |  \/  |
-- | .  . | ___ _ __ ___   ___  _ __ _   _
-- | |\/| |/ _ \ '_ ` _ \ / _ \| '__| | | |
-- | |  | |  __/ | | | | | (_) | |  | |_| |
-- \_|  |_/\___|_| |_| |_|\___/|_|   \__, |
--                                    __/ |
--                                   |___/

-- Reads a value at a specific memory offset/rva in a specific memory module.
-- module (string): The name of the memory module. nil for "Wow.exe" aka the main module.
-- offset (number): The offset/rva in the memory module to read.
-- type (number): The type of the value. Check GetValueTypesTable().
-- value (number): The result value. nil if the memory address is not found.
function cxmplex:ReadMemory(module, offset, type)
  return IsLinuxClient("ReadMemory", module, offset, type)
end

-- Gets the offset of a memory address in a specific module.
-- module (string): The name of the memory module. nil for "Wow.exe" aka the main module.
-- address (number): The absolute memory address.
-- offset (number): The result offset. nil if the memory address is not found.
function cxmplex:GetMemoryOffset(module, address)
  return IsLinuxClient("GetMemoryOffset", module, address)
end

-- ___  ____
-- |  \/  (_)
-- | .  . |_ ___  ___
-- | |\/| | / __|/ __|
-- | |  | | \__ \ (__
-- \_|  |_/_|___/\___|

-- Gets the pressed state of a specific key.
function cxmplex:GetKeyState(key)
  return IsLinuxClient("GetKeyState", key)
end

-- Plays a specific sound WAV/MP3 file once.
function cxmplex:PlaySoundFile(path)
  return IsLinuxClient("PlaySoundFile", path)
end

-- Loads a Lua script with a name by engine into a function.
function cxmplex:LoadScript(name, script)
  return IsLinuxClient("LoadScript", name, script)
end

-- Runs a Lua script with a name by engine.
function cxmplex:RunScript(name, script)
  return IsLinuxClient("RunScript", name, script)
end

-- Adds a custom script (indexed by name) that gets loaded side by side
-- with the engine modules (Primary and Secondary). Loaded in GLUE
function cxmplex:SetCustomScript(name, script)
  return IsLinuxClient("SetCustomScript", name, script)
end


--  _   _      _                      _
-- | \ | |    | |                    | |
-- |  \| | ___| |___      _____  _ __| | __
-- | . ` |/ _ \ __\ \ /\ / / _ \| '__| |/ /
-- | |\  |  __/ |_ \ V  V / (_) | |  |   <
-- \_| \_/\___|\__| \_/\_/ \___/|_|  |_|\_\

-- -- The request info.
-- info = {
--   -- string: The request URL.
--   Url = "https://www.microsoft.com/",
--   -- [OPTIONAL] string: The request method, can be "GET", "POST", "PUT" or "DELETE".
--   Method = "POST",
--   -- [OPTIONAL] string: The additional request headers.
--   Headers = "Content-Type: application/json\r\nX-Custom: test",
--   -- [OPTIONAL] string: The request body, only used Method is "POST" or "PUT".
--   Body = "{\"test\": 123}",
--   -- [OPTIONAL] string: The pinned HTTPs server certificate as a protection for packet sniffing. If provided, the server certificate must match it or the HTTP request would fail with status "INVALID_CERTIFICATE".
--   Certificate = "PINNED CERTIFICATE",
--   -- [OPTIONAL] function: The callback function cxmplex:when the status of the request is updated.
--   Callback = function(request, status) ... end,
-- }
-- -- The HTTP request ID if sent successfully, for querying HTTP response later.
-- request = "abc123"
function cxmplex:SendHttpRequest(info)
  return IsLinuxClient("SendHttpRequest", info)
end

-- -- The HTTP request ID previously sent.
-- request = "abc123"
-- -- The current status of the HTTP request, can be:
-- -- "REQUESTING": The request is still on the way.
-- -- "REQUEST_FAILED": The request is terminated due to failures.
-- -- "INVALID_CERTIFICATE": The request is terminated due to invalid HTTPs certificate.
-- -- "RESPONDING": Downloading response after the request is sent.
-- -- "RESPONSE_HEADERS_FAILED": The response download is terminated while fetching response headers.
-- -- "RESPONSE_BODY_FAILED": The response download is terminated while fetching response body.
-- -- "SUCCESS": The response is received and everything about the HTTP request is done.
-- status = "CONNECTING"
-- -- The response data, available if status is "SUCCESS"
-- response = {
--   -- number: The HTTP response status code.
--   Code = 200,
--   -- string: The HTTP response headers.
--   Headers = "HTTP/1.1 200 OK...",
--   -- string: The HTTP response body.
--   Body = "...",
--   -- string: The actual server certificate if the request is HTTPs, which can be used for pinning.
--   Certificate = "SERVER CERTIFICATE",
-- }
function cxmplex:ReceiveHttpRequest(request)
  return IsLinuxClient("ReceiveHttpRequest", request)
end

-- -- The websocket info.
-- info = {
--   -- string: The websocket URL. (Use http(s) instead of ws(s))
--   Url = "https://echo.websocket.org",
--   -- [OPTIONAL] string: The additional request headers.
--   Headers = "Content-Type: application/json\r\nX-Custom: test",
--   -- [OPTIONAL] string: The pinned HTTPs server certificate as a protection for packet sniffing. If provided, the server certificate must match it or the websocket connection would fail with status "INVALID_CERTIFICATE".
--   Certificate = "PINNED CERTIFICATE",
--   -- [OPTIONAL] function: The callback function cxmplex:when the status of the connection is updated, which can be any one of "CONNECTING", "CONNECTION_FAILED", "INVALID_CERTIFICATE", "CONNECTED", "CLOSING", "CLOSED".
--   ConnectCallback = function(connection, status) ... end,
--   -- [OPTIONAL] function: The callback function cxmplex:when a piece of data is sent over the connection. (Only string data is supported)
--   SendCallback = function(connection, data) ... end,
--   -- [OPTIONAL] function: The callback function cxmplex:when a piece of data is received over the connection. (Only string data is supported)
--   ReceiveCallback = function(connection, data) ... end
-- }
-- -- The websocket connection ID if sent successfully.
-- connection = "abc123"
function cxmplex:ConnectWebsocket(info)
  return IsLinuxClient("ConnectWebsocket", info)
end

-- Closes an existing websocket connection.
function cxmplex:CloseWebSocket(info)
  return IsLinuxClient("CloseWebSocket", info)
end

-- Sends a piece of string data over an existing websocket connection.
function cxmplex:SendWebsocketData(connection, data)
  return IsLinuxClient("SendWebsocketData", connection, data)
end

--   ___       _   _
--  / _ \     | | (_)
-- / /_\ \ ___| |_ _  ___  _ __
-- |  _  |/ __| __| |/ _ \| '_ \
-- | | | | (__| |_| | (_) | | | |
-- \_| |_/\___|\__|_|\___/|_| |_|

-- Clicks a world position.
function cxmplex:ClickPosition(x, y, z)
  IsLinuxClient("ClickPosition", x, y, z)
end

-- Faces a horizontal direction, in radian.
function cxmplex:FaceDirection(angle, update)
  IsLinuxClient("FaceDirection", angle, not update)
end

-- Sets the player vertical pitch, in radian.
function cxmplex:SetPitch(angle)
  if not angle then return end
  return IsLinuxClient("SetPitch", angle)
end

-- Moves the player to a specific position, using CTM.
function cxmplex:MoveTo(x, y, z, instantTurn)
  instantTurn = instantTurn or true
  IsLinuxClient("MoveTo", x, y, z, instantTurn)
end

-- Interacts with an object.0
function cxmplex:ObjectInteract(object)
  if not object then return end
  InteractUnit(object)
end

--   ___
--  / _ \
-- / /_\ \_   _ _ __ __ _
-- |  _  | | | | '__/ _` |
-- | | | | |_| | | | (_| |
-- \_| |_/\__,_|_|  \__,_|

-- Gets the count of auras on a specific unit, optionally filtered by spell ID.
function cxmplex:GetAuraCount(unit, spellId)
  if not unit then return end
  if spellId then
    return IsLinuxClient("GetAuraCount", spellId)
  end
  return IsLinuxClient("GetAuraCount", unit)
end

-- Gets the info of a specific aura, saved by the most recent call to GetAuraCount().
function cxmplex:GetAuraWithIndex(index, detailed)
  if detailed then
    return IsLinuxClient("GetAuraWithIndex", index, detailed)
  end
  return IsLinuxClient("GetAuraWithIndex", index)
end

-- ______ _            _         _____         _
-- | ___ \ |          | |       |_   _|       | |
-- | |_/ / | __ _  ___| | ________| | ___  ___| |__
-- | ___ \ |/ _` |/ __| |/ /______| |/ _ \/ __| '_ \
-- | |_/ / | (_| | (__|   <       | |  __/ (__| | | |
-- \____/|_|\__,_|\___|_|\_\      \_/\___|\___|_| |_|

-- Sets the current camera distance maximum. If nil, restore original setting.
function cxmplex:SetCameraDistanceMax(distance)
  return IsLinuxClient("SetCameraDistanceMax", distance)
end

-- Sets the engine allowed climb angle, in radian. If nil, restore original setting.
function cxmplex:SetClimbAngle(angle)
  if not angle then return end
  return IsLinuxClient("SetClimbAngle", angle)
end

-- Sets a CVar without system limitation.
function cxmplex:SetCVarEx(name, value)
  return IsLinuxClient("SetCVarEx", name, value)
end

-- Sets the current nameplate visible distance maximum. If nil, restore original setting.
function cxmplex:SetNameplateDistanceMax(distance)
  return IsLinuxClient("SetNameplateDistanceMax", distance)
end

-- Stops the current falling of the character right now.
function cxmplex:StopFalling()
  return IsLinuxClient('StopFalling')
end

-- Gets the current no-clip mode flags, which is a sum of:
-- 0: none 1: building 2: static object 4: dynamic object
function cxmplex:GetNoClipModes()
  return IsLinuxClient("GetNoClipModes")
end

-- Sets the current no-clip mode flags. Check the enum above.
function cxmplex:SetNoClipModes(modes)
  return IsLinuxClient("SetNoClipModes", modes)
end

-- ___  ____         _ _
-- |  \/  (_)       (_) |
-- | .  . |_ ___ ___ _| | ___  ___
-- | |\/| | / __/ __| | |/ _ \/ __|
-- | |  | | \__ \__ \ | |  __/\__ \
-- \_|  |_/_|___/___/_|_|\___||___/

-- Gets the count of the flying missiles.
function cxmplex:GetMissileCount()
  return IsLinuxClient("GetMissileCount")
end

-- Gets the info of a specific missile.
-- spellId, spellVisualId, x, y, z, sourceObject, sourceX, sourceY, sourceZ,
-- targetObject, targetX, targetY, targetZ
function cxmplex:GetMissileWithIndex(index)
  return IsLinuxClient("GetMissileWithIndex", index)
end

-- in-world navigation
-- Gets the map information about the current location.
function cxmplex:GetCurrentMapInfo()
  return IsLinuxClient("GetCurrentMapInfo")
end
-- Checks whether the navigation files for a specific map exists.
function cxmplex:MapExists(id)
  if not id then return end
  return IsLinuxClient("MapExists", id)
end
-- Loads a navigation map. Map files must be placed correctly before loading.
function cxmplex:LoadMap(id)
  if not id then return end
  return IsLinuxClient("LoadMap", id)
end
-- Unloads a navigation map.
function cxmplex:UnloadMap(id)
  if not id then return end
  return IsLinuxClient("UnloadMap", id)
end
-- Checks if a navigation map is loaded.
function cxmplex:IsMapLoaded(id)
  if not id then return end
  return IsLinuxClient("IsMapLoaded", id)
end
-- Calculates a path to navigate from one position to another.
-- Notice that the mapId must be loaded beforehand.
function cxmplex:FindPath(id, x1, y1, z1, x2, y2, z2)
  return IsLinuxClient("FindPath", "r9svH6YxEQbNTZGH", id, x1, y1, z1, x2, y2, z2)
end

--  _____ _     _           _
-- |  _  | |   (_)         | |
-- | | | | |__  _  ___  ___| |_
-- | | | | '_ \| |/ _ \/ __| __|
-- \ \_/ / |_) | |  __/ (__| |_
--  \___/|_.__/| |\___|\___|\__|
--            _/ |
--           |__/

-- flags = {
--   Object = 1,
--   Item = 2,
--   Container = 4,
--   AzeriteEmpoweredItem = 8,
--   AzeriteItem = 16,
--   ...
-- }
function cxmplex:GetObjectTypeFlagsTable()
  return IsLinuxClient("GetObjectTypeFlagsTable")
end

-- fields = {
--   ["AnimationState"] = 123,
--   ...
-- }
function cxmplex:GetObjectFieldsTable()
  return IsLinuxClient("GetObjectFieldsTable")
end

-- descriptors = {
--   ["CGObjectData__m_guid"] = 0,
--   ["CGObjectData__m_entryID"] = 8,
--   ...
-- }
function cxmplex:GetObjectDescriptorsTable()
  return IsLinuxClient("GetObjectDescriptorsTable")
end

function cxmplex:GetValueTypesTable()
  return IsLinuxClient("GetValueTypesTable")
end

-- Gets a descriptor value of an object.
function cxmplex:ObjectDescriptor(object, offset, type)
  if not object then return end
  return IsLinuxClient("ObjectDescriptor", object, offset, type)
end

-- Gets player spec by player descriptor.
function cxmplex:GetPlayerSpecByDescriptor(player)
  return cxmplex:ObjectDescriptor(player, cxmplex:GetObjectDescriptorsTable().CGPlayerData__currentSpecID, cxmplex:GetValueTypesTable().UInt)
end

-- Gets the scale of an object.
function cxmplex:ObjectScale(object)
  if not object then return end
  return IsLinuxClient("ObjectScale", object)
end

-- Gets the dynamic flags of an object.
function cxmplex:ObjectDynamicFlags(object)
  if not object then return end
  return IsLinuxClient("ObjectDynamicFlags", object)
end

-- Gets a field value of an object.
function cxmplex:ObjectField(object, offset, type)
  if not object then return end
  return IsLinuxClient("ObjectField", object, offset, type)
end

-- Gets the type info of a game object.
function cxmplex:GameObjectType(object)
  if not object then return end
  return IsLinuxClient("GameObjectType", object)
end

-- Gets the object by its GUID.
function cxmplex:GetObjectWithGUID(GUID)
  return IsLinuxClient("GetObjectWithGUID", GUID)
end

-- Gets the type flags of an object.
function cxmplex:ObjectTypeFlags(object)
  if not object then return end
  return IsLinuxClient("ObjectTypeFlags", object)
end

-- Checks if an object is of specific type.
function cxmplex:ObjectIsType(object, type)
  if not object then return end
  return IsLinuxClient("ObjectIsType", object, type)
end

-- Checks whether an object exists in memory.
function cxmplex:ObjectExists(object)
  if not object then return end
  return IsLinuxClient("ObjectExists", object)
end

-- Gets the ID of an object.
function cxmplex:ObjectId(object)
  if not object then return end
  return IsLinuxClient("ObjectId", object)
end

function cxmplex:ObjectGUID(object)
  if not object then return end
  return cxmplex:ObjectDescriptor(object, cxmplex:GetObjectDescriptorsTable().CGObjectData__m_guid, cxmplex:GetValueTypesTable().GUID)
end

-- Gets the world position of an object.
function cxmplex:ObjectPosition(object)
  if object then
    return IsLinuxClient("ObjectPosition", object)
  else
    return 0, 0, 0
  end
end

-- Gets the horizontal rotation of an object, in radian.
function cxmplex:ObjectFacing(object)
  if not object then return end
  return IsLinuxClient("ObjectFacing", object)
end

-- Checks if an object is facing another object.
function cxmplex:ObjectIsFacing(object1, object2, delta)
  if not object1 or not object2 then return end
  if delta then
    return IsLinuxClient("ObjectIsFacing", object1, object2, delta)
  else
    return IsLinuxClient("ObjectIsFacing", object1, object2)
  end
end

-- Checks if an object is behind another object.
function cxmplex:ObjectIsBehind(object1, object2)
  if not object1 or not object2 then return end
  return IsLinuxClient("ObjectIsBehind", object1, object2)
end

-- Checks if object is type unit.
function cxmplex:ObjectIsUnit(object)
  return cxmplex:ObjectIsType(object, IsLinuxClient("GetObjectTypeFlagsTable").Unit)
end

function cxmplex:ObjectIsAnimating(object)
  return cxmplex:ObjectField(object, 60, 3) > 0
end

--  _   _       _ _
-- | | | |     (_) |
-- | | | |_ __  _| |_
-- | | | | '_ \| | __|
-- | |_| | | | | | |_
--  \___/|_| |_|_|\__|

-- descriptors = {
--   Forward = 1,
--   Backward = 2,
--   StrafeLeft = 4,
--   StrafeRight = 8,
--   TurnLeft = 16,
--   ...
-- }
function cxmplex:GetUnitMovementFlagsTable()
  return IsLinuxClient("GetUnitMovementFlagsTable")
end

-- Gets the creator object of an object.
function cxmplex:UnitCreator(unit)
  if not unit then return end
  return IsLinuxClient("UnitCreator", unit)
end

-- Gets the bounding radius of an unit.
function cxmplex:UnitBoundingRadius(unit)
  if not unit then return end
  return IsLinuxClient("UnitBoundingRadius", unit)
end

-- Gets the combat reach of an unit.
function cxmplex:UnitCombatReach(unit)
  if not unit then return end
  return IsLinuxClient("UnitCombatReach", unit)
end

-- Gets the target object of an unit.
function cxmplex:UnitTarget(unit)
  if not unit then return end
  return IsLinuxClient("UnitTarget", unit)
end

-- Gets the flags of an unit.
function cxmplex:UnitFlags(unit)
  if not unit then return end
  return IsLinuxClient("UnitFlags", unit)
end

-- Gets the casting info of a unit, an enhanced version for the BLZ API UnitCastingInfo.
function cxmplex:UnitCasting(unit)
  if not unit then return end
  return IsLinuxClient("UnitCasting", unit)
end

-- Gets the channel info of a unit, an enhanced version for the BLZ API
function cxmplex:UnitChannel(unit)
  if not unit then return end
  return IsLinuxClient("UnitChannel", unit)
end

-- Gets the casting target object of a unit.
function cxmplex:UnitCastingTarget(unit)
  if not unit then return end
  return IsLinuxClient("UnitCastingTarget", unit)
end

-- Gets the transport object of a unit.
function cxmplex:UnitTransport(unit)
  if not unit then return end
  return IsLinuxClient("UnitTransport", unit)
end

-- Gets the vertical pitch of a unit, in radian.
function cxmplex:UnitPitch(unit)
  if not unit then return end
  return IsLinuxClient("UnitPitch", unit)
end

-- Gets the movement flags of a unit, indicating its moving status.
function cxmplex:UnitMovementFlags(unit)
  if not unit then return end
  return IsLinuxClient("UnitMovementFlags", unit)
end

-- Gets the ID of a unit's creature type.
function cxmplex:UnitCreatureTypeId(unit)
  if not unit then return end
  return IsLinuxClient("UnitCreatureTypeId", unit)
end

-- Gets the ID of a unit's creature family. nil if the unit does not have one.
function cxmplex:UnitCreatureFamilyId(unit)
  if not unit then return end
  return IsLinuxClient("UnitCreatureFamilyId", unit)
end

-- Gets the field value of a unit's creature cache struct.
function cxmplex:UnitCreatureField(unit, offset, type)
  if not unit then return end
  return IsLinuxClient("UnitCreatureField", unit, offset, type)
end

-- Gets whether unit can be looted.
function cxmplex:UnitCanBeLooted(unit)
  if not unit then return end
  return IsLinuxClient("UnitIsLootable", unit)
end

-- Gets whether unit can be skinned.
function cxmplex:UnitIsSkinnable(unit)
  if not unit then return end
  return IsLinuxClient("UnitIsSkinnable", unit)
end

-- Gets whether unit is mounted.
function cxmplex:UnitIsMounted(unit)
  if not unit then return end
  return IsLinuxClient("UnitIsMounted", unit)
end

-- Gets the mount display id of the unit.
function cxmplex:UnitMountID(unit)
  if not unit then return end
  return ObjectDescriptor(unit, IsLinuxClient("GetObjectDescriptorsTable").CGUnitData__mountDisplayID, IsLinuxClient("GetValueTypesTable").UInt)
end

function cxmplex:UnitIsRare(unit)
  local classification = UnitClassification(unit)
  return classification_types[classification] ~= nil
end


--  _____ _     _           _    ___  ___
-- |  _  | |   (_)         | |   |  \/  |
-- | | | | |__  _  ___  ___| |_  | .  . | __ _ _ __
-- | | | | '_ \| |/ _ \/ __| __| | |\/| |/ _` | '_ \
-- \ \_/ / |_) | |  __/ (__| |_  | |  | | (_| | | | |_
--  \___/|_.__/| |\___|\___|\__| \_|  |_/\__,_|_| |_(_)
--            _/ |
--           |__/

-- Gets the count of all world objects, also updates all objects.
function cxmplex:GetObjectCount()
  return IsLinuxClient("GetObjectCount")
end

-- Gets a specific world object by its index.
function cxmplex:GetObjectWithIndex(index)
  return IsLinuxClient("GetObjectWithIndex", index)
end

-- Gets the count of all npcs, also updates npcs.
function cxmplex:GetNpcCount(pointer, range)
  if not pointer then return end
  if range then
    return IsLinuxClient("GetNpcCount", pointer, range)
  else
    return IsLinuxClient("GetNpcCount", pointer)
  end
end

-- Gets a specific npc by its index.
function cxmplex:GetNpcWithIndex(index)
  return IsLinuxClient("GetNpcWithIndex", index)
end

-- Gets the count of specific players.
function cxmplex:GetPlayerCount(pointer, range)
  if not pointer then return end
  if range then
    return IsLinuxClient("GetPlayerCount", pointer, range)
  else
    return IsLinuxClient("GetPlayerCount", pointer)
  end
end

-- Gets the specific player by index.
function cxmplex:GetPlayerWithIndex(index)
  return IsLinuxClient("GetPlayerWithIndex", index)
end

-- Gets the count of specific game objects, also updates game objects.
function cxmplex:GetGameObjectCount(pointer, range)
  if not pointer then return end
  return IsLinuxClient("GetGameObjectCount", pointer, range)
end

-- Gets the specific game object by index.
function cxmplex:GetGameObjectWithIndex(index)
  return IsLinuxClient("GetGameObjectWithIndex", index)
end

-- Gets the count of specific dynamic objects, also updates dynamic objects.
function cxmplex:GetDynamicObjectCount(pointer, range)
  if not pointer then return end
  if range then
    return IsLinuxClient("GetDynamicObjectCount", pointer, range)
  else
    return IsLinuxClient("GetDynamicObjectCount", pointer)
  end
end

-- Gets a specific dynamic object by index.
function cxmplex:GetDynamicObjectWithIndex(index)
  return IsLinuxClient("GetDynamicObjectWithIndex", index)
end

-- Gets the count of specific area triggers
function cxmplex:GetAreaTriggerCount(pointer, range)
  if not pointer then return end
  if range then
    IsLinuxClient("GetAreaTriggerCount", pointer, range)
  end
  return IsLinuxClient("GetAreaTriggerCount", pointer)
end

-- Gets a specific AreaTrigger by index
function cxmplex:GetAreaTriggerWithIndex(index)
  return IsLinuxClient("GetAreaTriggerWithIndex", index)
end

--  _____            _ _
-- /  ___|          | | |
-- \ `--. _ __   ___| | |
--  `--. \ '_ \ / _ \ | |
-- /\__/ / |_) |  __/ | |
-- \____/| .__/ \___|_|_|
--       | |
--       |_|

-- Checks if there is a pending spell on the cursor.
-- false (boolean): There is no cursor spell pending.
-- spellId (number): The ID of the spell pending on cursor.
function cxmplex:IsAoEPending()
  return IsLinuxClient("IsAoEPending")
end

-- Cancels the pending spell on the cursor.
function cxmplex:CancelPendingSpell()
  return IsLinuxClient("CancelPendingSpell")
end

--  _____ _        _
-- /  ___| |      | |
-- \ `--.| |_ __ _| |_ ___
--  `--. \ __/ _` | __/ _ \
-- /\__/ / || (_| | ||  __/
-- \____/ \__\__,_|\__\___|

-- Resets the timer for AFK
function cxmplex:ResetAfk()
  return IsLinuxClient("ResetAfk")
end

-- Gets the name of the current WoW account. (same as the WTF subfolder)
function cxmplex:GetCurrentAccount()
  return IsLinuxClient("GetCurrentAccount")
end

--  _   _ _     _
-- | | | (_)   (_)
-- | | | |_ ___ _  ___  _ __
-- | | | | / __| |/ _ \| '_ \
-- \ \_/ / \__ \ | (_) | | | |
--  \___/|_|___/_|\___/|_| |_|

-- RayTrace
function cxmplex:TraceLine(x1, y1, z1, x2, y2, z2, flags)
  return IsLinuxClient("TraceLine", x1, y1, z1, x2, y2, z2, flags)
end

-- Gets the position of the camera.
function cxmplex:GetCameraPosition()
  return IsLinuxClient("GetCameraPosition")
end

-- Projects a world position to the screen NDC position
function cxmplex.WorldToScreen(x, y, z)
  return IsLinuxClient("WorldToScreen", x, y, z)
end

----------------- MISC
function cxmplex:DrawText(x, y, text)
  print(x .. " " .. y)
  if x == 0 or y == 0 then return end
  local screen_physical_width, screen_physical_height = GetPhysicalScreenSize();
  local scale_x = 768 / GetScreenHeight() * GetScreenWidth() / (screen_physical_width * UIParent:GetEffectiveScale());
  local scale_y = 768 / (screen_physical_height * UIParent:GetEffectiveScale());
  label = CreateFrame("Frame", nil, UIParent);
  label_font_string = label:CreateFontString(nil, "BORDER");
  label_font_string:SetPoint("TOPLEFT");
  label_font_string:SetFont("Fonts\\FRIZQT__.TTF", 11, "OUTLINE, MONOCHROME")
  label_font_string:SetJustifyH("CENTER");
  label_font_string:SetText(text);
  label:SetWidth(label_font_string:GetStringWidth());
  label:SetHeight(label_font_string:GetStringHeight());
  print("converted " .. x * screen_physical_width * scale_x .. " " .. y * screen_physical_height * scale_y)
  label:SetPoint("BOTTOMLEFT", x * screen_physical_width * scale_x, y * screen_physical_height * scale_y);
  label:Show()
end

function cxmplex:TraceLogObjects()
  local dCount = cxmplex:GetDynamicObjectCount("player", 40) or 0
  local mCount = cxmplex:GetMissileCount() or 0
  -- print("Dynamic Object Count: " .. dCount)
  -- print("Missile Count: " .. mCount)
  if dCount > 0 then
    for i = 1, dCount do
      local object = cxmplex:GetDynamicObjectWithIndex(i)
      local typeId, typeName = cxmplex:GameObjectType(object)
      print("Dynamic Object [" .. typeId .. "] " .. typeName)
    end
  end
  if mCount > 0 then
    for i = 1, mCount do
      local spellId, spellVisualId, x, y, z, sourceObject, sourceX, sourceY, sourceZ, targetObject, targetX, targetY, targetZ = cxmplex:GetMissileWithIndex(i)
      local spellName = select(1, GetSpellInfo(spellId))
      if spellName == "Shadow Crash" then
        print("Missile Info: \n" .. spellName .. "\n" .. "Location: " .. x .. " " .. y .. " " .. z .. "\n" .. "Source Location: " .. sourceX .. " " .. sourceY .. " " .. sourceZ .. "\n")
        print("Target Location: " .. targetX .. " " .. targetY .. " " .. targetZ)
        local isOnScreen, sX, sY = cxmplex:WorldToScreen(targetX, targetY, targetZ)
        print("Target screen: " .. tostring(isOnScreen) .. " " .. sX .. " " .. sY)
        cxmplex:DrawText(sX, sY, spellName .. " TARGET")
        isOnScreen, sX, sY = cxmplex:WorldToScreen(sourceX, sourceY, sourceZ)
        print("source screen: " .. tostring(isOnScreen) .. " " .. sX .. " " .. sY)
        cxmplex:DrawText(sX, sY, spellName .. " SOURCE")
        isOnScreen, sX, sY = cxmplex:WorldToScreen(x, y, z)
        print("default screen: " .. tostring(isOnScreen) .. " " .. sX .. " " .. sY)
        cxmplex:DrawText(sX, sY, spellName .. " DEFAULT")
      end
    end
  end
end
