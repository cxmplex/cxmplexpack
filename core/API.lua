local cache = { pop_time = 0.020 }
cache.GetObjectCount = { last_ran = 0 }
cache.GetObjectWithIndex = {}
cache.GetNpcCount = { last_ran = 0 }
cache.GetNpcWithIndex = {}
cache.GetPlayerCount = { last_ran = 0 }
cache.GetPlayerWithIndex = {}
cache.GetGameObjectCount = { last_ran = 0 }
cache.GetGameObjectWithIndex = {}
cache.GetDynamicObjectCount = { last_ran = 0 }
cache.GetDynamicObjectWithIndex = {}
cache.GetAreaTriggerCount = { last_ran = 0 }
cache.GetAreaTriggerWithIndex = {}
cache.GetMissileCount = { last_ran = 0 }
cache.GetMissileWithIndex = {}
cache.ObjectIsQuestObjective = {}
cxmplex.QuestRelationMap = {}
cxmplex.oMoveForwardStart = MoveForwardStart
cxmplex.oMoveBackwardStart = MoveBackwardStart
cxmplex.oStrafeLeftStart = StrafeLeftStart
cxmplex.oStrafeRightStart = StrafeRightStart
cxmplex.oJumpOrAscendStart = JumpOrAscendStart
cxmplex.oCameraOrSelectOrMoveStart = CameraOrSelectOrMoveStart
cxmplex.quests = {}
cxmplex.enums = {}

function printf(...) print(string.format(...)) end
function pack(...)
    return {n = select("#", ...), ...}
end
function subrange(t, first, last)
    local sub = {}
    for i = first, last do
        sub[#sub + 1] = t[i]
    end
    return sub
end
function htostr(str)
    return (string.gsub(str, '..', function (cc)
        return string.char(tonumber(cc, 16))
    end))
end
function tc(t, number)
    if number then
        local c = {}
        local x = 1
        for i = #t, 1, - 1 do
            c[x] = t[i]
            x = x + 1
        end
        t = c
    end
    if number then
        return tonumber(table.concat(t, ""), 16)
    end
    return table.concat(t, "")
end
local function table_invert(t)
    local s = {}
    for k, v in pairs(t) do
        s[v] = k
    end
    return s
end
function split(str, sep)
    local result = {}
    local regex = ("([^%s]+)"):format(sep)
    for each in str:gmatch(regex) do
        table.insert(result, each)
    end
    return result
end
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
    return IsLinuxClient("FileExists", "r9svH6YxEQbNTZGH", path)
end
-- Reads all text from a file.
function cxmplex:ReadFile(path, encoding)
    if not path then return end
    if not encoding then encoding = nil end
    return IsLinuxClient("ReadFile", path, encoding)
end
-- Writes all text to a file.
function cxmplex:WriteFile(path, content)
    if not path then return end
    IsLinuxClient("WriteFile", path, content)
end
-- Checks if a directory exists.
function cxmplex:DirectoryExists(path)
    return IsLinuxClient("DirectoryExists", "r9svH6YxEQbNTZGH", path)
end
-- Creates a directory.
function cxmplex:CreateDirectory(path)
    if not path then return end
    return IsLinuxClient("CreateDirectory", "r9svH6YxEQbNTZGH", path)
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
    return IsLinuxClient("GetDirectoryFolders", "r9svH6YxEQbNTZGH", path)
end

-- function cxmplex:ReadQuestCacheAsBytes()
--     local function chunk(text)
--         local res = {}
--         for i = 1, #text, 2 do
--             table.insert(res, text:sub(i, i + 2 - 1))
--         end
--         return res
--     end
--     local results = cxmplex:ReadFile(cxmplex:GetWoWDirectory() .. "\\Cache\\WDB\\enUS\\questcache.wdb", 2)
--     return chunk(results)
-- end
-- function cxmplex:ReadQuestCache()
--     local cache_bytes = cxmplex:ReadQuestCacheAsBytes()
--     -- skip first 24 bytes
--     local quest_bytes = subrange(cache_bytes, 25, #cache_bytes + 1)
--
--     local index = 1
--     while index <= #quest_bytes do
--         -- get the first 8 bytes of the record
--         local record_info = subrange(quest_bytes, index, index + 8)
--         -- advance index past the record info
--         index = index + 8
--         -- convert record id and length to int
--         local record_id = tc(subrange(record_info, 1, 4), true)
--         local length = tc(subrange(record_info, 5, 8), true)
--
--         if length and length > 0 then
--             local record = subrange(quest_bytes, index, length)
--
--             local quest_record = {
--                 id = nil, -- bytes 0-4
--                 QuestType = nil, --bytes 4-8
--                 Quest_UNK_27075 = nil, --bytes 8-12 -- Unknown, but seems to frequently mirror SuggestedGroupNum. Theory: Maximum party size number for LFG Tool to create a group
--                 QuestPackageID = nil, -- 12-16               -- FK to QuestPackageItem.db2
--                 QuestSortID = nil, -- 16-20                   -- When QuestSortID is greater than 0, FK to AreaTable.db2 = nil,otherwise, FK to QuestSort.db2
--                 QuestInfoID = nil, -- 20-24                  -- FK to QuestInfo.db2
--                 SuggestedGroupNum = nil, --24-28
--                 RewardNextQuest = nil, --28-32               -- Next id in the chain = nil,sometimes blank when it shouldn't be because chains are often not linear and require multiple quests to continue at certain points
--                 RewardXPDifficulty = nil, --32-36             -- The column of QuestXp to use
--                 RewardXPMultiplier = nil, --36-40 float         -- Multiplier applied to the value retrieved from the field above
--                 RewardMoney = nil, --40-44                   -- Precomputed final money value based on player level at the time of caching = nil,not very useful unless you can ensure consistent player levels
--                 RewardMoneyDifficulty = nil, --44-48         -- The column of QuestMoneyReward to use
--                 RewardMoneyMultiplier = nil, --48-52      -- Multiplier applied to the value retrieved from the field above
--                 RewardBonusMoney = nil, --52-56             -- Bonus money rewarded if completed at max level
--                 RewardDisplaySpell = nil, --56-68
--                 RewardSpell = nil, --68-72
--                 RewardHonor = nil, --72-76                  -- Amount of honor rewarded by the quest
--                 RewardHonorKill = nil, --76-80         -- Multiplier applied to honor rewarded by the quest (or to kills during it? unknown exactly)
--                 RewardArtifactXPDifficulty = nil, --80-84    -- The column of ArtifactQuestXp to use
--                 RewardArtifactXPMultiplier = nil, --8488  -- Multiplier applied to the value retrieved from the field above
--                 RewardArtifactCategoryID = nil, --88-92
--                 ProvidedItem = nil, --92-96   -- Item linked to the quest, usually destroying it will force the quest to abandon
--                 Flags = nil, --96-100
--                 Flags2 = nil, -- 100-104
--                 Flags3 = nil, -- 104-108
--                 RewardFixedItems = nil, --108-140
--                 ItemDrop = nil -- 140-172
--                 RewardChoiceItems, -- 172 - 244
--                 POIContinent = nil, -- 244-248
--                 POIx = nil, --248-252
--                 POIy = nil, --252-260
--                 POIPriority = nil, --260-264
--                 RewardTitle = nil, --264-268
--                 RewardArenaPoints = nil, --268-272
--                 RewardSkillLineID = nil, --272-276
--                 RewardNumSkillUps = nil, --276-280
--                 PortraitGiverDisplayID = nil, --280-284
--                 BFA_UnkDisplayID = nil, --284-288
--                 PotraitTurnInDisplayID = nil, -- 288-292
--                 RewardFaction = nil, --292-348
--                 RewardFactionFlags = nil, --348-352
--                 RewardCurrency = nil, --352-386
--                 int AcceptedSoundKitID = nil, --386-390
--                 int AcceptedSoundKitID = nil, --390-394
--                 int CompleteSoundKitID = nil, --394-398
--                 int AreaGroupID = nil, --398-402
--                 int TimeAllowed = nil, --402-406
--                 int NumObjectives = nil, --406-410
--                 uint64 RaceFlags = nil, --406-418
--                 uint QuestRewardID = nil, --418-422
--                 uint ExpansionID = nil, --422-426
--                 uint B30993_Int_1; --418-422                 -- Unknown - only set on Warfront-related quests; has values of 12, 113, 114, and 115
--                 uint B31984_Int_1; --422-426
--                 BitFields = nil, --444-453
--
--             }
--
--             quest_record.id = tc(subrange(record, 1, 4), true)
--             quest_record.QuestType = tc(subrange(record, 5, 8), true)
--             quest_record.QuestSortID = tc(subrange(record, 17, 20), true)
--             quest_record.QuestInfoID = tc(subrange(record, 21, 24), true)
--             quest_record.RewardNextQuest = tc(subrange(record, 29, 32), true)
--             quest_record.ProvidedItem = tc(subrange(record, 85, 88), true)
--
--             return quest_record
--         end
--
--         -- print("Found record: [" .. record_id .. "] Len: [" .. length .. "]")
--         -- set index past the record to the next record_info
--         index = index + length
--     end
-- end

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
--   Url = "https:--www.microsoft.com/",
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
--   Url = "https:--echo.websocket.org",
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
    IsLinuxClient("FaceDirection", angle, update)
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

function cxmplex:IsFlyingModeEnabled()
    return IsLinuxClient('IsFlyingModeEnabled')
end

function cxmplex:EnableFlyingMode(toggle)
    if toggle then
        cxmplex:StopFalling()
    else
        if not cxmplex:IsFlyingModeEnabled() then return end
    end
    return IsLinuxClient('EnableFlyingMode', toggle)
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

function cxmplex:UnlockMovement()
    if cxmplex.movement_locked then
        MoveForwardStart = cxmplex.oMoveForwardStart
        MoveBackwardStart = cxmplex.oMoveBackwardStart
        StrafeLeftStart = cxmplex.oStrafeLeftStart
        StrafeRightStart = cxmplex.oStrafeRightStart
        CameraOrSelectOrMoveStart = cxmplex.oCameraOrSelectOrMoveStop
        JumpOrAscendStart = cxmplex.oJumpOrAscendStart
        cxmplex.movement_locked = false
    end
end

function cxmplex:LockMovement()
    MoveForwardStart = function() end
    MoveBackwardStart = function() end
    StrafeLeftStart = function() end
    StrafeRightStart = function() end
    JumpOrAscendStart = function() end
    CameraOrSelectOrMoveStart = function() end
    cxmplex.movement_locked = true
end


function cxmplex:StopMoving(lock)
    MoveForwardStop()
    MoveBackwardStop()
    StrafeLeftStop()
    StrafeRightStop()
    TurnLeftStop()
    TurnRightStop()
    AscendStop()
    CameraOrSelectOrMoveStop()
    if lock then
        cxmplex:UnlockMovement()
    else
        cxmplex:UnlockMovement()
    end
end

-- ___  ____         _ _
-- |  \/  (_)       (_) |
-- | .  . |_ ___ ___ _| | ___  ___
-- | |\/| | / __/ __| | |/ _ \/ __|
-- | |  | | \__ \__ \ | |  __/\__ \
-- \_|  |_/_|___/___/_|_|\___||___/

-- Gets the count of the flying missiles.
function cxmplex:GetMissileCount()
    if GetTime() - cache.GetMissileCount.last_ran > cache.pop_time then
        cache.GetMissileCount.results = pack(IsLinuxClient("GetMissileCount"))
        cache.GetMissileCount.last_ran = GetTime()
    end
    return unpack(cache.GetMissileCount.results)
end

-- Gets the info of a specific missile.
-- spellId, spellVisualId, x, y, z, sourceObject, sourceX, sourceY, sourceZ,
-- targetObject, targetX, targetY, targetZ
function cxmplex:GetMissileWithIndex(index)
    if not cache.GetMissileWithIndex[index] then
        cache.GetMissileWithIndex[index] = { last_ran = 0 }
    end
    if GetTime() - cache.GetMissileWithIndex[index].last_ran > cache.pop_time then
        cache.GetMissileWithIndex[index].results = pack(IsLinuxClient("GetMissileWithIndex", index))
        cache.GetMissileWithIndex[index].last_ran = GetTime()
    end
    return unpack(cache.GetMissileWithIndex[index].results)
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
-- Notice that the map_id must be loaded beforehand.
function cxmplex:FindPath(id, x1, y1, z1, x2, y2, z2)
    return IsLinuxClient("FindPath", "r9svH6YxEQbNTZGH", id, x1, y1, z1, x2, y2, z2)
end

function cxmplex:GetClosestPositionOnMesh(id, x, y, z, ignoreWater)
    if not ignoreWater then ignoreWater = true end
    return IsLinuxClient("GetClosestPositionOnMesh", id, x, y, z, ignoreWater)
end

function cxmplex:GetClosestMeshPolygon(id, x, y, z, dX, dY, dZ)
    return IsLinuxClient("GetClosestMeshPolygon", id, x, y, z, dX, dY, dZ)
end

function cxmplex:GetMeshPolygons(id, startPoly, x, y, z, radius)
    return IsLinuxClient("GetMeshPolygons", id, startPoly, x, y, z, radius)
end

function cxmplex:GetMeshPolygonFlags(id, polygon)
    return IsLinuxClient("GetMeshPolygonFlags", id, polygon)
end

function cxmplex:SetMeshPolygonFlags(id, polygon, flags)
    return IsLinuxClient("SetMeshPolygonFlags", id, polygon, flags)
end

function cxmplex:GetMeshPolygonVertices(id, polygon)
    return IsLinuxClient("GetMeshPolygonVertices", id, polygon)
end

-- Gets the mesh tile coords of a certain position, same as shown on WoW Tools.
--
-- Hint: The map must be loaded before calling the API.
--
-- Hint: The *.mmtile file name follows the format "MMMMYYXX.mmtile". e.g. The tile at (31,41) of map 1 should correspond to the map file "00014131.mmtile".
function cxmplex:GetMeshTile(id, x, y, z)
    return IsLinuxClient("GetMeshTile", id, x, y, z)
end

--  _____ _     _           _
-- |  _  | |   (_)         | |
-- | | | | |__  _  ___  ___| |_
-- | | | | '_ \| |/ _ \/ __| __|
-- \ \_/ / |_) | |  __/ (__| |_
--  \___/|_.__/| |\___|\___|\__|
--            _/ |
--           |__/


-- enums and an inverted version of each table (value to name, name to value)

cxmplex.enums.UnitFlags = {
    UNIT_FLAG_SERVER_CONTROLLED = 0x00000001, -- set only when unit movement is controlled by server - by SPLINE/MONSTER_MOVE packets, together with UNIT_FLAG_STUNNED; only set to units controlled by client; client function CGUnit_C::IsClientControlled returns false when set for owner
    UNIT_FLAG_NON_ATTACKABLE = 0x00000002, -- not attackable
    UNIT_FLAG_REMOVE_CLIENT_CONTROL = 0x00000004, -- This is a legacy flag used to disable movement player's movement while controlling other units, SMSG_CLIENT_CONTROL replaces this functionality clientside now. CONFUSED and FLEEING flags have the same effect on client movement asDISABLE_MOVE_CONTROL in addition to preventing spell casts/autoattack (they all allow climbing steeper hills and emotes while moving)
    UNIT_FLAG_PVP_ATTACKABLE = 0x00000008, -- allow apply pvp rules to attackable state in addition to faction dependent state
    UNIT_FLAG_RENAME = 0x00000010,
    UNIT_FLAG_PREPARATION = 0x00000020, -- don't take reagents for spells with SPELL_ATTR5_NO_REAGENT_WHILE_PREP
    UNIT_FLAG_UNK_6 = 0x00000040,
    UNIT_FLAG_NOT_ATTACKABLE_1 = 0x00000080, -- ?? (UNIT_FLAG_PVP_ATTACKABLE | UNIT_FLAG_NOT_ATTACKABLE_1) is NON_PVP_ATTACKABLE
    UNIT_FLAG_IMMUNE_TO_PC = 0x00000100, -- disables combat/assistance with PlayerCharacters (PC) - see Unit::_IsValidAttackTarget, Unit::_IsValidAssistTarget
    UNIT_FLAG_IMMUNE_TO_NPC = 0x00000200, -- disables combat/assistance with NonPlayerCharacters (NPC) - see Unit::_IsValidAttackTarget, Unit::_IsValidAssistTarget
    UNIT_FLAG_LOOTING = 0x00000400, -- loot animation
    UNIT_FLAG_PET_IN_COMBAT = 0x00000800, -- on player pets: whether the pet is chasing a target to attack || on other units: whether any of the unit's minions is in combat
    UNIT_FLAG_PVP = 0x00001000, -- changed in 3.0.3
    UNIT_FLAG_SILENCED = 0x00002000, -- silenced, 2.1.1
    UNIT_FLAG_CANNOT_SWIM = 0x00004000, -- 2.0.8
    UNIT_FLAG_UNK_15 = 0x00008000,
    UNIT_FLAG_UNK_16 = 0x00010000,
    UNIT_FLAG_PACIFIED = 0x00020000, -- 3.0.3 ok
    UNIT_FLAG_STUNNED = 0x00040000, -- 3.0.3 ok
    UNIT_FLAG_IN_COMBAT = 0x00080000,
    UNIT_FLAG_TAXI_FLIGHT = 0x00100000, -- disable casting at client side spell not allowed by taxi flight (mounted?), probably used with 0x4 flag
    UNIT_FLAG_DISARMED = 0x00200000, -- 3.0.3, disable melee spells casting..., "Required melee weapon" added to melee spells tooltip.
    UNIT_FLAG_CONFUSED = 0x00400000,
    UNIT_FLAG_FLEEING = 0x00800000,
    UNIT_FLAG_PLAYER_CONTROLLED = 0x01000000, -- used in spell Eyes of the Beast for pet... let attack by controlled creature
    UNIT_FLAG_NOT_SELECTABLE = 0x02000000,
    UNIT_FLAG_SKINNABLE = 0x04000000,
    UNIT_FLAG_MOUNT = 0x08000000,
    UNIT_FLAG_UNK_28 = 0x10000000,
    UNIT_FLAG_UNK_29 = 0x20000000, -- used in Feing Death spell
    UNIT_FLAG_SHEATHE = 0x40000000,
    UNIT_FLAG_UNK_31 = 0x80000000,
}

cxmplex.enums.UnitFlagsInverted = table_invert(cxmplex.enums.UnitFlags)

cxmplex.enums.UnitDynamicFlags = {
    UNIT_DYNFLAG_NONE = 0x0000,
    UNIT_DYNFLAG_HIDE_MODEL = 0x0002, -- Object model is not shown with this flag
    UNIT_DYNFLAG_LOOTABLE = 0x0004,
    UNIT_DYNFLAG_TRACK_UNIT = 0x0008,
    UNIT_DYNFLAG_TAPPED = 0x0010, -- Lua_UnitIsTapped
    UNIT_DYNFLAG_SPECIALINFO = 0x0020,
    UNIT_DYNFLAG_DEAD = 0x0040,
    UNIT_DYNFLAG_REFER_A_FRIEND = 0x0080
}

cxmplex.enums.UnitDynamicFlagsInverted = table_invert(cxmplex.enums.UnitDynamicFlags)


cxmplex.enums.GameObjectFlags = {
    GO_FLAG_IN_USE = 0x00000001, -- disables interaction while animated
    GO_FLAG_LOCKED = 0x00000002, -- require key, spell, event, etc to be opened. Makes "Locked" appear in tooltip
    GO_FLAG_INTERACT_COND = 0x00000004, -- cannot interact (condition to interact - requires GO_DYNFLAG_LO_ACTIVATE to enable interaction clientside)
    GO_FLAG_TRANSPORT = 0x00000008, -- any kind of transport? Object can transport (elevator, boat, car)
    GO_FLAG_NOT_SELECTABLE = 0x00000010, -- not selectable even in GM mode
    GO_FLAG_NODESPAWN = 0x00000020, -- never despawn, typically for doors, they just change state
    GO_FLAG_AI_OBSTACLE = 0x00000040, -- makes the client register the object in something called AIObstacleMgr, unknown what it does
    GO_FLAG_FREEZE_ANIMATION = 0x00000080,
    -- for object types GAMEOBJECT_TYPE_GARRISON_BUILDING, GAMEOBJECT_TYPE_GARRISON_PLOT and GAMEOBJECT_TYPE_PHASEABLE_MO flag bits 8 to 12 are used as WMOAreaTable::NameSetID
    GO_FLAG_DAMAGED = 0x00000200,
    GO_FLAG_DESTROYED = 0x00000400,
    GO_FLAG_INTERACT_DISTANCE_USES_TEMPLATE_MODEL = 0x00080000, -- client checks interaction distance from model sent in SMSG_QUERY_GAMEOBJECT_RESPONSE instead of GAMEOBJECT_DISPLAYID
    GO_FLAG_MAP_OBJECT = 0x00100000 -- pre-7.0 model loading used to be controlled by file extension (wmo vs m2)
}

cxmplex.enums.GameObjectFlagsInverted = table_invert(cxmplex.enums.GameObjectFlags)


cxmplex.enums.GameObjectDynamicLowFlags = {
    GO_DYNFLAG_LO_HIDE_MODEL = 0x02, -- Object model is not shown with this flag
    GO_DYNFLAG_LO_ACTIVATE = 0x04, -- enables interaction with GO
    GO_DYNFLAG_LO_ANIMATE = 0x08, -- possibly more distinct animation of GO
    GO_DYNFLAG_LO_NO_INTERACT = 0x10, -- appears to disable interaction (not fully verified)
    GO_DYNFLAG_LO_SPARKLE = 0x20, -- makes GO sparkle
    GO_DYNFLAG_LO_STOPPED = 0x40 -- Transport is stopped
}

cxmplex.enums.GameObjectDynamicLowFlagsInverted = table_invert(cxmplex.enums.GameObjectDynamicLowFlags)

cxmplex.enums.GameObjectTypes = {
    GAMEOBJECT_TYPE_DOOR = 1,
    GAMEOBJECT_TYPE_BUTTON = 2,
    GAMEOBJECT_TYPE_QUESTGIVER = 3,
    GAMEOBJECT_TYPE_CHEST = 4,
    GAMEOBJECT_TYPE_BINDER = 5,
    GAMEOBJECT_TYPE_GENERIC = 6,
    GAMEOBJECT_TYPE_TRAP = 7,
    GAMEOBJECT_TYPE_CHAIR = 8,
    GAMEOBJECT_TYPE_SPELL_FOCUS = 9,
    GAMEOBJECT_TYPE_TEXT = 10,
    GAMEOBJECT_TYPE_GOOBER = 11,
    GAMEOBJECT_TYPE_TRANSPORT = 12,
    GAMEOBJECT_TYPE_AREADAMAGE = 13,
    GAMEOBJECT_TYPE_CAMERA = 14,
    GAMEOBJECT_TYPE_MAP_OBJECT = 15,
    GAMEOBJECT_TYPE_MAP_OBJ_TRANSPORT = 16,
    GAMEOBJECT_TYPE_DUEL_ARBITER = 17,
    GAMEOBJECT_TYPE_FISHINGNODE = 18,
    GAMEOBJECT_TYPE_RITUAL = 19,
    GAMEOBJECT_TYPE_MAILBOX = 20,
    GAMEOBJECT_TYPE_DO_NOT_USE = 21,
    GAMEOBJECT_TYPE_GUARDPOST = 22,
    GAMEOBJECT_TYPE_SPELLCASTER = 23,
    GAMEOBJECT_TYPE_MEETINGSTONE = 24,
    GAMEOBJECT_TYPE_FLAGSTAND = 25,
    GAMEOBJECT_TYPE_FISHINGHOLE = 26,
    GAMEOBJECT_TYPE_FLAGDROP = 27,
    GAMEOBJECT_TYPE_MINI_GAME = 28,
    GAMEOBJECT_TYPE_DO_NOT_USE_2 = 29,
    GAMEOBJECT_TYPE_CONTROL_ZONE = 30,
    GAMEOBJECT_TYPE_AURA_GENERATOR = 31,
    GAMEOBJECT_TYPE_DUNGEON_DIFFICULTY = 32,
    GAMEOBJECT_TYPE_BARBER_CHAIR = 33,
    GAMEOBJECT_TYPE_DESTRUCTIBLE_BUILDING = 34,
    GAMEOBJECT_TYPE_GUILD_BANK = 35,
    GAMEOBJECT_TYPE_TRAPDOOR = 36,
    GAMEOBJECT_TYPE_NEW_FLAG = 37,
    GAMEOBJECT_TYPE_NEW_FLAG_DROP = 38,
    GAMEOBJECT_TYPE_GARRISON_BUILDING = 39,
    GAMEOBJECT_TYPE_GARRISON_PLOT = 40,
    GAMEOBJECT_TYPE_CLIENT_CREATURE = 41,
    GAMEOBJECT_TYPE_CLIENT_ITEM = 42,
    GAMEOBJECT_TYPE_CAPTURE_POINT = 43,
    GAMEOBJECT_TYPE_PHASEABLE_MO = 44,
    GAMEOBJECT_TYPE_GARRISON_MONUMENT = 45,
    GAMEOBJECT_TYPE_GARRISON_SHIPMENT = 46,
    GAMEOBJECT_TYPE_GARRISON_MONUMENT_PLAQUE = 47,
    GAMEOBJECT_TYPE_ITEM_FORGE = 48,
    GAMEOBJECT_TYPE_UI_LINK = 49,
    GAMEOBJECT_TYPE_KEYSTONE_RECEPTACLE = 50,
    GAMEOBJECT_TYPE_GATHERING_NODE = 51,
    GAMEOBJECT_TYPE_CHALLENGE_MODE_REWARD = 52,
    GAMEOBJECT_TYPE_MULTI = 53,
    GAMEOBJECT_TYPE_SIEGEABLE_MULTI = 54,
    GAMEOBJECT_TYPE_SIEGEABLE_MO = 55,
    GAMEOBJECT_TYPE_PVP_REWARD = 56,
    GAMEOBJECT_TYPE_PLAYER_CHOICE_CHEST = 57,
    GAMEOBJECT_TYPE_LEGENDARY_FORGE = 58,
    GAMEOBJECT_TYPE_GARR_TALENT_TREE = 59,
    GAMEOBJECT_TYPE_WEEKLY_REWARD_CHEST = 60,
    GAMEOBJECT_TYPE_CLIENT_MODEL = 61
}

cxmplex.enums.GameObjectTypesInverted = table_invert(cxmplex.enums.GameObjectTypes)

cxmplex.enums.ObjectTypeFlags = {
    Corpse = 1024,
    Conversation = 8192,
    SceneObject = 4098,
    AzeriteEmpoweredItem = 8,
    GameObject = 256,
    Unit = 32,
    Item = 2,
    Player = 64,
    Object = 1,
    DynamicObject = 512,
    AzeriteItem = 16,
    ActivePlayer = 128,
    AreaTrigger = 2048,
    Container = 4
}

cxmplex.enums.ObjectTypeFlagsInverted = table_invert(cxmplex.enums.ObjectTypeFlags)

function cxmplex:GameObjectIsType(object, type)
    if not object then return end
    if type == 0 then return end
    if not cxmplex:ObjectIsGameObject(object) then return end
    local id, _ = cxmplex:GameObjectType(object)
    return type == id
end

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

function cxmplex:GetObject(object)
    if not object then return end
    return IsLinuxClient("GetObject", object)
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
    if not object then return end
    return cxmplex:ObjectIsType(object, IsLinuxClient("GetObjectTypeFlagsTable").Unit)
end

function cxmplex:ObjectIsGameObject(object)
    if not object then return end
    return cxmplex:ObjectIsType(object, IsLinuxClient("GetObjectTypeFlagsTable").GameObject)
end

function cxmplex:GameObjectFlags(object)
    if not object then return end
    return cxmplex:ObjectDescriptor(object, cxmplex:GetObjectDescriptorsTable().CGGameObjectData__m_createdBy + 32, cxmplex:GetValueTypesTable().UInt)
end

function cxmplex:GameObjectDynamicLowFlags(object)
    if not object then return end
    return bit.rshift(cxmplex:ObjectDynamicFlags(object), 8)
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
    if not unit then return end
    local classification_types = {
        rareelite = true,
        rare = true
    }
    return classification_types[UnitClassification(unit)]
end

function cxmplex:GetUnitDynamicFlags(unit)
    if not unit then return end
    return cxmplex:ObjectDescriptor(unit, cxmplex:GetObjectDescriptorsTable().CGObjectData__m_dynamicFlags, cxmplex:GetValueTypesTable().UInt)
end

function cxmplex:UnitIsHidden(unit, flags)
    if not unit then return end
    if not flags then
        flags = cxmplex:ObjectDynamicFlags(unit)
    end
    if not flags then return end
    return bit.band(flags, cxmplex.enums.UnitDynamicFlags.UNIT_DYNFLAG_HIDE_MODEL) > 0
end

function cxmplex:ObjectIsInteractable(object, flags)
    if not object then return end
    if not flags then
        flags = cxmplex:ObjectDynamicFlags(object)
    end
    if not flags then return end
    return not (bit.band(flags, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_NO_INTERACT) > 0)
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
    if GetTime() - cache.GetObjectCount.last_ran > cache.pop_time then
        cache.GetObjectCount.results = pack(IsLinuxClient("GetObjectCount"))
        cache.GetObjectCount.last_ran = GetTime()
    end
    return unpack(cache.GetObjectCount.results)
end

-- Gets a specific world object by its index.
function cxmplex:GetObjectWithIndex(index)
    if not index then return end
    if not cache.GetObjectWithIndex[index] then
        cache.GetObjectWithIndex[index] = { last_ran = 0 }
    end
    if GetTime() - cache.GetObjectWithIndex[index].last_ran > cache.pop_time then
        cache.GetObjectWithIndex[index].results = pack(IsLinuxClient("GetObjectWithIndex", index))
        cache.GetObjectWithIndex[index].last_ran = GetTime()
    end
    return unpack(cache.GetObjectWithIndex[index].results)
end

-- Gets the count of all npcs, also updates npcs.
-- function cxmplex:GetNpcCount(pointer, range)
--     if not pointer then return end
--     if not cache.GetNpcCount[pointer] then
--         cache.GetNpcCount[pointer] = { last_ran = 0 }
--     end
--     if range and not cache.GetNpcCount[pointer][range] then
--         cache.GetNpcCount[pointer][range] = { last_ran = 0 }
--     end
--     if range and GetTime() - cache.GetNpcCount[pointer][range].last_ran > cache.pop_time then
--         cache.GetNpcCount[pointer][range].results = pack(IsLinuxClient("GetNpcCount", pointer, range))
--         cache.GetNpcCount[pointer][range].last_ran = GetTime()
--     elseif not range and GetTime() - cache.GetNpcCount[pointer].last_ran > cache.pop_time then
--         cache.GetNpcCount[pointer].results = pack(IsLinuxClient("GetNpcCount", pointer))
--         cache.GetNpcCount[pointer].last_ran = GetTime()
--     end
--     if range then
--         return unpack(cache.GetNpcCount[pointer][range].results)
--     end
--     return unpack(cache.GetNpcCount[pointer].results)
-- end

-- Gets a specific npc by its index.
-- function cxmplex:GetNpcWithIndex(index)
--     if not index then return end
--     if not cache.GetNpcWithIndex[index] then
--         cache.GetNpcWithIndex[index] = { last_ran = 0 }
--     end
--     if GetTime() - cache.GetNpcWithIndex[index].last_ran > cache.pop_time then
--         cache.GetNpcWithIndex[index].results = pack(IsLinuxClient("GetNpcWithIndex", index))
--         cache.GetNpcWithIndex[index].last_ran = GetTime()
--     end
--     return unpack(cache.GetNpcWithIndex[index].results)
-- end
--
-- -- Gets the count of specific players.
-- function cxmplex:GetPlayerCount(pointer, range)
--     if not pointer then return end
--     if not cache.GetPlayerCount[pointer] then
--         cache.GetPlayerCount[pointer] = { last_ran = 0 }
--     end
--     if range and not cache.GetPlayerCount[pointer][range] then
--         cache.GetPlayerCount[pointer][range] = { last_ran = 0 }
--     end
--     if range and GetTime() - cache.GetPlayerCount[pointer][range].last_ran > cache.pop_time then
--         cache.GetPlayerCount[pointer][range].results = pack(IsLinuxClient("GetPlayerCount", pointer, range))
--         cache.GetPlayerCount[pointer][range].last_ran = GetTime()
--     elseif not range and GetTime() - cache.GetPlayerCount[pointer].last_ran > cache.pop_time then
--         cache.GetPlayerCount[pointer].results = pack(IsLinuxClient("GetPlayerCount", pointer))
--         cache.GetPlayerCount[pointer].last_ran = GetTime()
--     end
--     if range then
--         return unpack(cache.GetPlayerCount[pointer][range].results)
--     end
--     return unpack(cache.GetPlayerCount[pointer].results)
-- end
--
-- -- Gets the specific player by index.
-- function cxmplex:GetPlayerWithIndex(index)
--     if not index then return end
--     if not cache.GetPlayerWithIndex[index] then
--         cache.GetPlayerWithIndex[index] = { last_ran = 0 }
--     end
--     if GetTime() - cache.GetPlayerWithIndex[index].last_ran > cache.pop_time then
--         cache.GetPlayerWithIndex[index].results = pack(IsLinuxClient("GetPlayerWithIndex", index))
--         cache.GetPlayerWithIndex[index].last_ran = GetTime()
--     end
--     return unpack(cache.GetPlayerWithIndex[index].results)
-- end
--
-- -- Gets the count of specific game objects, also updates game objects.
-- function cxmplex:GetGameObjectCount(pointer, range)
--     if not pointer then return end
--     if not cache.GetGameObjectCount[pointer] then
--         cache.GetGameObjectCount[pointer] = { last_ran = 0 }
--     end
--     if range and not cache.GetGameObjectCount[pointer][range] then
--         cache.GetGameObjectCount[pointer][range] = { last_ran = 0 }
--     end
--     if range and GetTime() - cache.GetGameObjectCount[pointer][range].last_ran > cache.pop_time then
--         cache.GetGameObjectCount[pointer][range].results = pack(IsLinuxClient("GetGameObjectCount", pointer, range))
--         cache.GetGameObjectCount[pointer][range].last_ran = GetTime()
--     elseif not range and GetTime() - cache.GetDynamicObjectCount[pointer].last_ran > cache.pop_time then
--         cache.GetGameObjectCount[pointer].results = pack(IsLinuxClient("GetGameObjectCount", pointer))
--         cache.GetGameObjectCount[pointer].last_ran = GetTime()
--     end
--     if range then
--         return unpack(cache.GetGameObjectCount[pointer][range].results)
--     end
--     return unpack(cache.GetGameObjectCount[pointer].results)
-- end
--
-- -- Gets the specific game object by index.
-- function cxmplex:GetGameObjectWithIndex(index)
--     if not index then return end
--     if not cache.GetGameObjectWithIndex[index] then
--         cache.GetGameObjectWithIndex[index] = { last_ran = 0 }
--     end
--     if GetTime() - cache.GetGameObjectWithIndex[index].last_ran > cache.pop_time then
--         cache.GetGameObjectWithIndex[index].results = pack(IsLinuxClient("GetGameObjectWithIndex", index))
--         cache.GetGameObjectWithIndex[index].last_ran = GetTime()
--     end
--     return unpack(cache.GetGameObjectWithIndex[index].results)
-- end

-- Gets the count of specific dynamic objects, also updates dynamic objects.
-- function cxmplex:GetDynamicObjectCount(pointer, range)
--     if not pointer then return end
--     if not cache.GetDynamicObjectCount[pointer] then
--         cache.GetDynamicObjectCount[pointer] = { last_ran = 0 }
--     end
--     if range and not cache.GetDynamicObjectCount[pointer][range] then
--         cache.GetDynamicObjectCount[pointer][range] = { last_ran = 0 }
--     end
--     if range and GetTime() - cache.GetDynamicObjectCount[pointer][range].last_ran > cache.pop_time then
--         cache.GetDynamicObjectCount[pointer][range].results = pack(IsLinuxClient("GetDynamicObjectCount", pointer, range))
--         cache.GetDynamicObjectCount[pointer][range].last_ran = GetTime()
--     elseif not range and GetTime() - cache.GetDynamicObjectCount[pointer].last_ran > cache.pop_time then
--         cache.GetDynamicObjectCount[pointer].results = pack(IsLinuxClient("GetDynamicObjectCount", pointer))
--         cache.GetDynamicObjectCount[pointer].last_ran = GetTime()
--     end
--     if range then
--         return unpack(cache.GetDynamicObjectCount[pointer][range].results)
--     end
--     return unpack(cache.GetDynamicObjectCount[pointer].results)
-- end
--
-- -- Gets a specific dynamic object by index.
-- function cxmplex:GetDynamicObjectWithIndex(index)
--     if not index then return end
--     if not cache.GetDynamicObjectWithIndex[index] then
--         cache.GetDynamicObjectWithIndex[index] = { last_ran = 0 }
--     end
--     if GetTime() - cache.GetDynamicObjectWithIndex[index].last_ran > cache.pop_time then
--         cache.GetDynamicObjectWithIndex[index].results = pack(IsLinuxClient("GetDynamicObjectWithIndex", index))
--         cache.GetDynamicObjectWithIndex[index].last_ran = GetTime()
--     end
--     return unpack(cache.GetDynamicObjectWithIndex[index].results)
-- end

-- Gets the count of specific area triggers
-- function cxmplex:GetAreaTriggerCount(pointer, range)
--     if not pointer then return end
--     if not cache.GetAreaTriggerCount[pointer] then
--         cache.GetAreaTriggerCount[pointer] = { last_ran = 0 }
--     end
--     if range and not cache.GetAreaTriggerCount[pointer][range] then
--         cache.GetAreaTriggerCount[pointer][range] = { last_ran = 0 }
--     end
--     if range and GetTime() - cache.GetAreaTriggerCount[pointer][range].last_ran > cache.pop_time then
--         cache.GetAreaTriggerCount[pointer][range].results = pack(IsLinuxClient("GetAreaTriggerCount", pointer, range))
--         cache.GetAreaTriggerCount[pointer][range].last_ran = GetTime()
--     elseif not range and GetTime() - cache.GetAreaTriggerCount[pointer].last_ran > cache.pop_time then
--         cache.GetAreaTriggerCount[pointer].results = pack(IsLinuxClient("GetAreaTriggerCount", pointer))
--         cache.GetAreaTriggerCount[pointer].last_ran = GetTime()
--     end
--     if range then
--         return unpack(cache.GetAreaTriggerCount[pointer][range].results)
--     end
--     return unpack(cache.GetAreaTriggerCount[pointer].results)
-- end
--
-- -- Gets a specific AreaTrigger by index
-- function cxmplex:GetAreaTriggerWithIndex(index)
--     if not index then return end
--     if not cache.GetAreaTriggerWithIndex[index] then
--         cache.GetAreaTriggerWithIndex[index] = { last_ran = 0 }
--     end
--     if GetTime() - cache.GetAreaTriggerWithIndex[index].last_ran > cache.pop_time then
--         cache.GetAreaTriggerWithIndex[index].results = pack(IsLinuxClient("GetAreaTriggerWithIndex", index))
--         cache.GetAreaTriggerWithIndex[index].last_ran = GetTime()
--     end
--     return unpack(cache.GetAreaTriggerWithIndex[index].results)
-- end

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
function cxmplex:InLineOfSight(obj1, obj2)
    if not obj1 or not obj2 then return end
    local x1, y1, z1 = cxmplex:ObjectPosition(obj1)
    local x2, y2, z2 = cxmplex:ObjectPosition(obj2)
    if x1 and x2 and y1 and y2 and z1 and z2 then
        return not cxmplex:TraceLine(x1, y1, z1 + 2, x2, y2, z2 + 2, 0x100011)
    end
end
-- Gets the position of the camera.
function cxmplex:GetCameraPosition()
    return IsLinuxClient("GetCameraPosition")
end

-- Projects a world position to the screen NDC position
function cxmplex.WorldToScreen(x, y, z)
    return IsLinuxClient("WorldToScreen", x, y, z)
end

function cxmplex:CallMount()
    for i = 1, GetNumCompanions("MOUNT") do
        if C_MountJournal.GetIsFavorite(i) then
            C_Timer.After(math.random(), function() if not UnitCastingInfo("player") then C_MountJournal.SummonByID(0) end end)
            return true
        end
    end
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

-- movement

function cxmplex:Face(pointer, update)
    local pointer = pointer or "target"
    cxmplex:FaceDirection(cxmplex:GetAnglesBetweenObjects("player", pointer), update)
end


-- security
function cxmplex:SpoofKeyPress()
    cxmplex:CallC("IncrementAppleCount")
end

function cxmplex:ObjectIsQuestObjectType(object)
    if not object then return end
    if not cxmplex:ObjectIsGameObject(object) then return end
    local id, _ = cxmplex:GameObjectType(object)
    if id == cxmplex.enums.GameObjectTypes.GAMEOBJECT_TYPE_GOOBER then
        return cxmplex.enums.GameObjectTypes.GAMEOBJECT_TYPE_GOOBER
    elseif id == cxmplex.enums.GameObjectTypes.GAMEOBJECT_TYPE_CHEST then
        return cxmplex.enums.GameObjectTypes.GAMEOBJECT_TYPE_CHEST
    elseif oid == cxmplex.enums.GameObjectTypes.GAMEOBJECT_TYPE_GENERIC then
        return cxmplex.enums.GameObjectTypes.GAMEOBJECT_TYPE_GENERIC
    end
end
-- quests
function cxmplex:GameObjectIsQuestObjective(object, type)
    if not object then return end
    local flags = cxmplex:ObjectDynamicFlags(object)
    if type == cxmplex.enums.GameObjectTypes.GAMEOBJECT_TYPE_GENERIC then
        print("Found generic object type: " .. UnitName(object))
        return bit.band(flags, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_SPARKLE) > 0
    else
        return bit.band(flags, bit.bor(cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_SPARKLE, cxmplex.enums.GameObjectDynamicLowFlags.GO_DYNFLAG_LO_ACTIVATE)) > 0
    end
end

function cxmplex:GetObjectQuestGiverStatusesTable()
    return IsLinuxClient('GetObjectQuestGiverStatusesTable')
end

function cxmplex:ObjectQuestGiverStatus(object)
    if not object then return end
    return IsLinuxClient('ObjectQuestGiverStatus', object)
end

function cxmplex:GetPacketOpcodes()
    return IsLinuxClient('GetPacketOpcodes')
end

function cxmplex:EnablePacketLogger(isSendEnabled, isReceiveEnabled, filePath, filteredOpcodes)
    return IsLinuxClient('EnablePacketLogger', isSendEnabled, isReceiveEnabled, filePath, filteredOpcodes)
end

function cxmplex:IsPacketLoggerEnabled()
    return IsLinuxClient('IsPacketLoggerEnabled')
end

local tool_tip = CreateFrame("GameTooltip", "QuestPlateTooltipScanQuest", nil, "GameTooltipTemplate")
function cxmplex:ScanToolTipForQuestInfo(guid, id)
    tool_tip:SetOwner(_G.WorldFrame, 'ANCHOR_NONE')
    tool_tip:SetUnit(guid)
    local tooltip_text = {}
    local count = tool_tip:NumLines()
    for i = 1, count do
        tooltip_text[i] = _G["QuestPlateTooltipScanQuestTextLeft" .. i]
    end
    local quest_name = nil
    local objective = nil
    if count >= 4 then
        quest_name = tooltip_text[3]:GetText()
        objective = tooltip_text[4]:GetText()

    elseif count == 3 then
        quest_name = tooltip_text[2]:GetText()
        objective = tooltip_text[3]:GetText()
    end
    if quest_name and objective then
        local p1, p2 = objective:match("(%d+)/(%d+)")
        if not p1 then
            p1 = objective:match("(%d+)%%")
        end
        if (p1 and p2 and p1 ~= p2) or (p1 and not p2 and p1 ~= 100) then
            cxmplex.QuestRelationMap[id] = { p1 = p1, p2 = p2}
        else
            cxmplex.QuestRelationMap[id] = nil
        end
    end
    return cxmplex.QuestRelationMap[id] ~= nil
end

function cxmplex:ObjectIsQuestObjective(object, id, guid, unknown)
    if not object then return end
    if cxmplex.quests.wipe_quest_object_cache then
        cache.ObjectIsQuestObjective = {}
        cxmplex.quests.wipe_quest_object_cache = false
    end
    if not cache.ObjectIsQuestObjective[id] then
        cache.ObjectIsQuestObjective[id] = { last_ran = 0 }
    end
    if GetTime() - cache.ObjectIsQuestObjective[id].last_ran > 2 then
        local res = IsLinuxClient('ObjectIsQuestObjective', object, unknown)
        local type = cxmplex:ObjectIsQuestObjectType(object)
        if not res and type then
            res = cxmplex:GameObjectIsQuestObjective(object, type)
        end
        if not res or cxmplex:ObjectIsUnit(object) then
            local result = cxmplex:ScanToolTipForQuestInfo(guid, id)
            if not res then res = result end
        end
        cache.ObjectIsQuestObjective[id].results = pack(res)
        cache.ObjectIsQuestObjective[id].last_ran = GetTime()
    end
    return unpack(cache.ObjectIsQuestObjective[id].results)
end

function cxmplex:GetQuestObjectiveMap()
    local QuestIdObjectiveMap = {}
    local ObjectiveNameQuestIdMap = {}
    for i = 1, C_QuestLog.GetNumQuestLogEntries() do
        local quest_id = C_QuestLog.GetQuestIDForLogIndex(i)
        local quest_obj_table = {}
        for j = 1, GetNumQuestLeaderBoards(i) do
            local description, type, completed = GetQuestLogLeaderBoard(j, i)
            local current, required, text = description:match("([%d]+)/([%d]+)%s-(.*)")
            local struct = {
                current = current,
                required = required,
                name = nil,
                type = type,
                description = description
            }
            if not completed then
                if type == "item" then
                    local name = text
                    struct.name = name
                elseif type == "monster" then
                    local words = split(text, " ")
                    -- pop last element, slain/kill/etc
                    table.remove(words)
                    struct.name = table.concat(words, " ")
                elseif type == "object" then
                    struct.name = text
                end
            end
            table.insert(quest_obj_table, struct)
            ObjectiveNameQuestIdMap[struct.name] = quest_id
        end
        QuestIdObjectiveMap[quest_id] = quest_obj_table
    end
end
-- function cxmplex:IsQuestObject(object)
--     if not object then return end
--     local id = cxmplex:ObjectId(object)
--     if cxmplex.quests.wipe_quest_object_cache then
--         cache.IsQuestObject = {}
--         cxmplex.quests.wipe_quest_object_cache = false
--     end
--     if not cache.IsQuestObject[id] then
--         cache.IsQuestObject[id] = { last_ran = 0 }
--     end
--
--     if GetTime() - cache.IsQuestObject[id].last_ran > 2 then
--         cxmplex.quests.force_quest_object = false
--         -- if cxmplex:UnitIsTracked(object) then cache.IsQuestObject[object].results = true cache.IsQuestObject[object].last_ran = GetTime() end
--         cxmplex.quests.frames.quest_tooltip:SetOwner(_G.WorldFrame, 'ANCHOR_NONE')
--         cxmplex.quests.frames.quest_tooltip:SetHyperlink('unit:' .. cxmplex:ObjectGUID(object))
--         if UnitName(object) == "Forgotten Memorandum" then
--             MEMOR_TOOLTIP = cxmplex:ObjectGUID(object)
--             MEMOR_ID = id
--             local flags = cxmplex:ObjectDynamicFlags(object)
--             print("0x4: " .. bit.band(flags, 0x4))
--             print("0x20: " .. bit.band(flags, 0x20))
--         end
--         for i = 1, cxmplex.quests.frames.quest_tooltip:NumLines() do
--             cxmplex.quests.ScannedQuestTextCache[i] = _G["QuestPlateTooltipScanQuestTextLeft" .. i]
--         end
--
--         local is_quest_unit = false
--         local one_quest_unfinished = false
--
--         for i = 1, #cxmplex.quests.ScannedQuestTextCache do
--             local text = cxmplex.quests.ScannedQuestTextCache[i]:GetText()
--             if cxmplex.quests.QuestCache[text] then
--                 is_quest_unit = true
--                 local j = i
--                 while(cxmplex.quests.ScannedQuestTextCache[j + 1]) do
--                     local next_line_text = cxmplex.quests.ScannedQuestTextCache[j + 1]:GetText()
--                     if next_line_text then
--                         if not next_line_text:match(THREAT_TOOLTIP) then
--                             local p1, p2 = next_line_text:match("(%d+)/(%d+)")
--                             if not p1 then
--                                 p1 = next_line_text:match ("(%d+%%)")
--                                 if p1 then
--                                     p1 = string.gsub(p1, "%%", '')
--                                 end
--                             end
--                             if (p1 and p2 and p1 ~= p2) or (p1 and not p2 and p1 ~= 100) then
--                                 one_quest_unfinished = true
--                             end
--                         else
--                             j = 99
--                         end
--                     end
--                     j = j + 1
--                 end
--             end
--         end
--         if UnitName(object) == "Forgotten Memorandum" then
--             print("is_quest " .. tostring(is_quest_unit))
--             print("one_quest_unf" .. tostring(one_quest_unfinished))
--         end
--         cache.IsQuestObject[id].results = pack((is_quest_unit and one_quest_unfinished and (not UnitIsDeadOrGhost(object) or UnitIsFriend("player", object))))
--         cache.IsQuestObject[id].last_ran = GetTime()
--     end
--     return unpack(cache.IsQuestObject[id].results)
-- end
--
-- function cxmplex:InitTooltipScanner()
--
--
-- end
--
-- function cxmplex:DestroyQuestScanner()
--
--
-- end
--
-- function cxmplex:InitQuestScanner()
--     local function UpdateQuestCache()
--         wipe(cxmplex.quests.QuestCache)
--
--         if IsInInstance() then return end
--
--         --update the quest cache
--         local n_entries, n_quests = C_QuestLog.GetNumQuestLogEntries()
--         for i = 1, n_entries do
--             -- local title, level, suggestedGroup, isHeader, isCollapsed, isComplete, frequency, id, startEvent, displayid, isOnMap, hasLocalPOI, isTask, isStory = GetQuestLogTitle (id)
--             local title, _, id = C_QuestLog.GetInfo(i)
--             if type (id) == "number" and id > 0 then -- and not isComplete
--                 cxmplex.quests.QuestCache[title] = true
--             end
--         end
--
--         local map_id = C_Map.GetBestMapForUnit ("player")
--         if (map_id) then
--             local map_info = C_Map.GetMapInfo(map_id)
--             if map_info.mapType == Enum.UIMapType.Micro then map_id = map_info.parentmap_id end
--             local world_quests = C_TaskQuest.GetQuestsForPlayerBymap_id (map_id)
--             if (type (world_quests) == "table") then
--                 for _, questTable in ipairs (world_quests) do
--                     local x, y, floor, numObjectives, id, inProgress = questTable.x, questTable.y, questTable.floor, questTable.numObjectives, questTable.id, questTable.inProgress
--                     if (type (id) == "number" and id > 0 and ignoreQuest[id] == nil) then
--                         local name = C_TaskQuest.GetQuestInfoByid (id)
--                         if (name) then
--                             cxmplex.quests.QuestCache[name] = true
--                         end
--                     end
--                 end
--             end
--         end
--     end
--     local function QuestCacheOnUpdate(self, event, ...)
--         if not self.last_time then
--             self.last_time = 0
--         end
--         if GetTime() - self.last_time > 1 then
--             UpdateQuestCache()
--             self.last_time = GetTime()
--         end
--     end
--     cxmplex.quests.wipe_quest_object_cache = false
--     cxmplex.quests.active = true
--     cxmplex.quests.frames = {}
--     cxmplex.quests.QuestCache = {}
--     cxmplex.quests.frames.quest_scanner = CreateFrame("Frame", "QuestFrame", UIParent)
--     cxmplex.quests.frames.quest_scanner:RegisterEvent ("QUEST_ACCEPTED")
--     cxmplex.quests.frames.quest_scanner:RegisterEvent ("QUEST_REMOVED")
--     cxmplex.quests.frames.quest_scanner:RegisterEvent ("QUEST_ACCEPT_CONFIRM")
--     cxmplex.quests.frames.quest_scanner:RegisterEvent ("QUEST_COMPLETE")
--     cxmplex.quests.frames.quest_scanner:RegisterEvent ("QUEST_POI_UPDATE")
--     cxmplex.quests.frames.quest_scanner:RegisterEvent ("QUEST_DETAIL")
--     cxmplex.quests.frames.quest_scanner:RegisterEvent ("QUEST_FINISHED")
--     cxmplex.quests.frames.quest_scanner:RegisterEvent ("QUEST_GREETING")
--     cxmplex.quests.frames.quest_scanner:RegisterEvent ("QUEST_LOG_UPDATE")
--     cxmplex.quests.frames.quest_scanner:RegisterEvent ("UNIT_QUEST_LOG_CHANGED")
--     cxmplex.quests.frames.quest_scanner:SetScript("OnEvent", QuestCacheOnUpdate)
-- end
--
-- function cxmplex:DestroyQuestScanner()
--     cxmplex.quests.frames.quest_scanner:SetScript("OnEvent", nil)
--     cxmplex.quests.frames.quest_scanner = nil
--     cxmplex.quests.QuestCache = {}
--     cxmplex.quests.ScannedQuestTextCache = {}
--     cxmplex.quests.active = false
-- end

function cxmplex:EnableQuestTracker()
    -- if cxmplex.quests.active then
    --     cxmplex:DestroyQuestScanner()
    -- end
    -- cxmplex:InitQuestScanner()
    -- cxmplex:InitTooltipScanner()
    cxmplex_savedvars.objects_to_track.quest = {}
    cxmplex_savedvars.enabled_lists.quest = true
end

function cxmplex:GetTooltipForId(id)
    if not id then return end
    return cxmplex.tooltips[id]
end

function cxmplex:GPS()
    local mapId, zoneId = cxmplex:GetCurrentMapInfo()
    if not cxmplex:IsMapLoaded(mapId) then
        cxmplex:LoadMap(mapId)
    end
    local x, y, z = cxmplex:ObjectPosition("player")
    local tile_x, tile_y = cxmplex:GetMeshTile(mapId, x, y, z)
    print(mapId .. " " .. zoneId .. " " .. tile_x .. " " .. tile_y .. " " .. x .. " " .. y .. " " .. z)
end
