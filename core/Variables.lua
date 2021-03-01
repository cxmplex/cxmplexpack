ADDON_NOM, TEST_VAR = ...
if not cxmplex then
  cxmplex = {}
  cxmplex.addon_name = "test"
  cxmplex.multijump_toggle = false
  cxmplex.anti_afk = false
  cxmplex.tracker_toggle = false
  cxmplex.arena_los_toggle = true
end

if not cxmplex_savedvars then
  cxmplex_savedvars = {}
  if not cxmplex_savedvars.objects_to_track then
    cxmplex_savedvars.objects_to_track = {
      default = {}
    }
  end
  if not cxmplex_savedvars.enabled_lists then
    cxmplex_savedvars.enabled_lists = {
      default = true
    }
  end
end
