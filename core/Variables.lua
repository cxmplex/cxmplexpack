addon_name, _ = ...
if not cxmplex then
    cxmplex = {}
    cxmplex.addon_name = addon_name
    cxmplex.multijump_toggle = false
    cxmplex.anti_afk = false
    cxmplex.fly_toggle = false
    cxmplex.noclip_toggle = false
    cxmplex.tracker_toggle = false
    cxmplex.arena_los_toggle = true
    cxmplex.tooltips = {
        [175422] = "Kill a npc near and then use quest item.",
    }
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
