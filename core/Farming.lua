local function FindNpcsAndCastSpells(farm_mobs, farm_spells)
    for i = 1, cxmplex:GetNpcCount("player", 30) do
        local unit = cxmplex:GetNpcWithIndex(i)
        if not cxmplex:UnitTarget(unit) and not UnitIsDeadOrGhost(unit) and farm_mobs[UnitName(unit)]
        -- and (not UnitAffectingCombat(unit) or select(1, UnitChannelInfo(unit)) ~= nil)
        and cxmplex:InLineOfSight("player", unit) then
            found_unit = unit
            for id, _ in pairs(farm_spells) do
                if select(1, GetSpellCooldown(id)) == 0 then
                    print("Calling face on unit")
                    cxmplex:Face(unit, true)
                    StopMoving()
                    CastSpellByID(id, unit)
                    return
                end
            end
        end
    end
end

function cxmplex:MobFarmInit(farm_mobs, farm_spells, farm_spots)
    local function IsMoving(pointer)
        local pointer = pointer or "player"
        if UnitIsVisible(pointer) and GetUnitSpeed(pointer) > 0 then
            return true
        end
    end
    -- create a frame and store it in table
    cxmplex.mob_farm_frame = CreateFrame("FRAME")
    cxmplex.mob_farm_frame:SetScript(
        "OnUpdate",
        function(self, ...)
            if UnitIsDeadOrGhost("player") then return end
            if not self.gps_index then
                self.gps_index = 1
            end
            -- limiter
            if not self.last_update_time then
                self.last_update_time = 0
            end
            if not self.last_jump_time then
                self.last_jump_time = 0
            end
            if not self.last_force_move_time then
                self.last_force_move_time = 0
            end
            if GetTime() - self.last_update_time < 0.100 then
                return
            end
            self.last_update_time = GetTime()

            -- iterate mobs
            local found_unit = FindNpcsAndCastSpells(farm_mobs, farm_spells)


            if EnemiesAroundUnit(5, "player") > 3 and not HFBurstMacro then
                RunMacroText("/hf burst")
            end

            -- move to the next hotspot if we didn't find a mob
            if not self.finished_moving and UnitAffectingCombat("player") and GetTime() - self.last_force_move_time > 3 + math.random() and cxmplex:ObjectExists("target") and not IsMoving() then
                local x, y, z = cxmplex:ObjectPosition("target")
                cxmplex:MoveTo(x, y, z, true)
                self.last_force_move_time = GetTime()
            end
            if not found_unit and not cxmplex.HAS_LOOTABLE_UNIT and not UnitAffectingCombat("player") then
                if cxmplex:UnitTarget("player") and not cxmplex:ObjectIsFacing("player", "target") and not IsMoving("player") then
                    StopMoving()
                    cxmplex:Face("target", true)
                end
                local hotspot = farm_spots[self.gps_index]
                local x, y, z = cxmplex:ObjectPosition("player")
                local distance = cxmplex:GetDistanceBetweenPositions(x, y, z, hotspot.x, hotspot.y, hotspot.z)
                if not self.finished_moving then
                    if distance <= 5 then self.finished_moving = true print("finished moving to hotspot index " .. self.gps_index ) else self.finished_moving = false end
                end
                if not self.finished_moving and not IsMoving() then
                    print("moving to hotspot index " .. self.gps_index)
                    cxmplex:MoveTo(hotspot.x + math.random() + 1, hotspot.y + math.random() + 1, hotspot.z, true)
                    if GetTime() - self.last_jump_time > 5 + math.random() then
                        C_Timer.After(1 + math.random(), function() JumpOrAscendStart() end)
                        self.last_jump_time = GetTime()
                    end
                end
                if self.finished_moving then
                    self.gps_index = self.gps_index + 1
                    if self.gps_index > #farm_spots then
                        self.gps_index = 1
                    end
                    self.finished_moving = false
                end
            end
        end
    )
end


function cxmplex:MobFarmDestroy()
    cxmplex.mob_farm_frame:SetScript("OnUpdate", nil)
    cxmplex.mob_farm_frame = nil
end
