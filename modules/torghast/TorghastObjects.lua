local object_ids = {
  [169785] = true,
  [164674] = true,
  [330193] = true,
  [169782] = true,
  [169662] = true,
  [169480] = true,
  [171166] = true,
  [157561] = true,
  [156480] = true,
  [167985] = true,
  [171159] = true,
  [167986] = true,
  [338483] = true,
  [167839] = true,
  [169628] = true,
  [324030] = true,
  [324031] = true,
  [167255] = true,
  [168173] = true,
  [170557] = true,
  [169783] = true,
  [164549] = true,
  [164624] = true
}

function cxmplex:EnableTorghastModule()
  if not cxmplex:ObjectListExists("torghast") then
    cxmplex:AddObjectList("torghast", object_ids)
    cxmplex:EnableObjectList("torgast")
  end
  if not cxmplex:ObjectListEnabled("torghast") then
    cxmplex:EnableObjectList("torghast")
  end
  if not cxmplex:GetObjManagerFrame() then
    cxmplex:InitObjectManager()
  end
  cxmplex:AddDrawingCallback("objectTracker", cxmplex.DrawTrackedObjects)
end

function cxmplex:DisableTorghastModule()
  if not cxmplex:ObjectListExists("torghast") then return end
  cxmplex:DisableObjectList("torghast")
end
