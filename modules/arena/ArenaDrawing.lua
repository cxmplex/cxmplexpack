local function roundDistance(distance)
  if not distance then return 0 end
  return distance + 0.5 - (distance + 0.5) % 1
end

function cxmplex:DrawTrackedObjects()
  local objects = cxmplex:GetTrackedObjects()
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
    end
  end
end

function cxmplex:ArenaTeamAwareness()
  isArena, isRegistered = IsActiveBattlefieldArena()
  if not isArena then return end
  for i = 1, GetNumGroupMembers(), 1 do
    local unit = "party" .. tostring(i)
    if UnitExists(unit) then
      if UnitGroupRolesAssigned(unit) == "HEALER" then
        local playerX, playerY, playerZ = cxmplex:ObjectPosition("player")
        local targetX, targetY, targetZ = cxmplex:ObjectPosition(unit)
        if not playerX or not playerY or not playerZ or not targetX or not targetY or not targetZ then return end
        if TraceLine(playerX, playerY, playerZ + 5, targetX, targetY, targetZ + 5, 0x100111) == nil then
          cxmplex.drawing:SetColorRaw(0, 1, 0, 1)
        else
          cxmplex.drawing:SetColorRaw(1, 0, 0, 1)
        end
        cxmplex.drawing:SetWidth(3)
        cxmplex.drawing:Line(playerX, playerY, playerZ, targetX, targetY, targetZ)
      else
        local target = cxmplex:UnitTarget(unit)
        if UnitExists(target) then
          cxmplex.drawing:SetColor(244, 208, 63, 100)
          cxmplex.drawing:SetWidth(2)
          local x, y, z = cxmplex:ObjectPosition(target)
          cxmplex.drawing:GroundCircle(x, y, z, 2)
        end
      end
    end
  end
end
