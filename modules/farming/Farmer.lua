function cxmplex:CreateFarmer(farm_name)
  local farm = cxmplex.farmer.farms[farm_name]
  if farm then
    if cxmplex.mob_farm_frame then
      cxmplex:MobFarmDestroy()
    end
    cxmplex:MobFarmInit(farm.farm_mobs, farm.farm_spells, farm.farm_spots)
  else
    print("Invalid farm name.")
  end
end

function cxmplex:DestroyAllFarmers()
  cxmplex:MobFarmDestroy()
end
