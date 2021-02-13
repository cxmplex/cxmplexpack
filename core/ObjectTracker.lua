local last_time = 0
local tracked_objects = {}

if not cxmplex_savedvars.objects_to_track then
  cxmplex_savedvars.objects_to_track = {
    [169480] = true,
    [171166] = true,
    [157561] = true,
    [338483] = true,
    [169785] = true,
    [167986] = true,
    [330193] = true,
    [156480] = true,
    [169662] = true,
    [167839] = true,
    [324030] = true,
    [167985] = true,
    [171159] = true,
    [164674] = true,
    [169782] = true,
    [169628] = true,
    [324031] = true,
    [167255] = true,
    [168173] = true,
    [170557] = true
  }
end

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
      if cxmplex_savedvars.objects_to_track[id] ~= nil then
        tracked_objects[cxmplex:ObjectGUID(obj)] = obj
      elseif cxmplex:ObjectIsUnit(obj) and cxmplex:UnitIsRare(obj) then
        tracked_objects[cxmplex:ObjectGUID(obj)] = obj
      elseif cxmplex:ObjectIsType() then
        tracked_objects[cxmplex:ObjectGUID(obj)] = obj
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
      if distance and distance <= 400 then
        local color = {r = 50, g = 205, b = 50, a = 100}
        if cxmplex:UnitIsRare(obj) then
          color = {r = 220, g = 20, b = 60, a = 100}
        end
        if x and y and z and id and name and distance and not dead then
          table.insert(processed_objects, {name = name, x = x, y = y, z = z, distance = distance, object = obj, id = id, color = color})
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

function cxmplex:GetTrackedObjects()
  return processed_objects
end

function cxmplex:AddObjectToTrackerById(id)
  cxmplex_savedvars.objects_to_track[id] = true
end

function cxmplex:RemoveObjectFromTrackerById(id)
  cxmplex_savedvars.objects_to_track[id] = nil
end

local omFrame = CreateFrame("FRAME")
omFrame:SetScript("OnUpdate", ObjectManagerOnUpdate)
omFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
omFrame:SetScript("OnEvent", function(...) tracked_objects = {} end)

local poFrame = CreateFrame("FRAME")
poFrame:SetScript("OnUpdate", ProcessObjectsOnUpdate)
