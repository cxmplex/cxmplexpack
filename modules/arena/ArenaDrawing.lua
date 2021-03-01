function cxmplex:ArenaTeamAwareness()
  local isArena, isRegistered = IsActiveBattlefieldArena()
  if not isArena then return end

	local player_name = UnitName("player")
	local pX, pY, pZ = cxmplex:ObjectPosition("player")

  for i = 1, GetNumGroupMembers(), 1 do
    local unit = "party" .. tostring(i)
    if UnitExists(unit) then
      if UnitGroupRolesAssigned(unit) == "HEALER" then
        local tX, tY, tZ = cxmplex:ObjectPosition(unit)
        if not pX or not pY or not pZ or not tX or not tY or not tZ then return end
        if not cxmplex:TraceLine(pX, pY, pZ + 2, tX, tY, tZ + 2, 0x100011) then
          cxmplex.drawing:SetColorRaw(0, 1, 0, 1)
        else
          cxmplex.drawing:SetColorRaw(1, 0, 0, 1)
        end
        cxmplex.drawing:SetWidth(3)
        cxmplex.drawing:Line(pX, pY, pZ, tX, tY, tZ)
      else
        local target = cxmplex:UnitTarget(unit)
        if UnitExists(target) and UnitName(target) ~= player_name then
          cxmplex.drawing:SetColor(244, 208, 63, 100)
          cxmplex.drawing:SetWidth(2)
          local x, y, z = cxmplex:ObjectPosition(target)
          cxmplex.drawing:GroundCircle(x, y, z, 2)
        end
      end
    end
  end
	-- for i = 1, 3, 1 do
	-- 	local unit = "arena" .. tostring(i)
	-- 	if UnitExists(unit) then
	-- 		-- get target of unit
	-- 		local target = cxmplex:UnitTarget(unit)
	-- 		local total_targets = 0
	-- 		if select(1, UnitName(target)) == UnitName("player") then
	-- 			total_targets = total_targets + 1
	-- 		end
	-- 		if total_targets > 0 then
	-- 			if total_targets == 1 then
	-- 				-- green
	-- 				cxmplex.drawing:SetColor(113, 238, 184, 100)
	-- 			elseif total_targets == 2 then
	-- 				-- orange
	-- 				cxmplex.drawing:SetColor(255, 127, 80, 100)
	-- 			else
	-- 				-- red
	-- 				cxmplex.drawing:SetColor(255, 8, 0, 100)
	-- 			end
	-- 			cxmplex.drawing:GroundCircle(pX, pY, pZ, 2)
	-- 		end
	-- 	end
	-- end
end
