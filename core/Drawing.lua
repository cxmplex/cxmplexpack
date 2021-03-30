local sin, cos, atan, atan2, sqrt, rad = math.sin, math.cos, math.atan, math.atan2, math.sqrt, math.rad
local onDrawTicker

local WorldToScreen_Original = cxmplex.WorldToScreen

-- we create this table here because we use it to store these functions
cxmplex.drawing = {}
function cxmplex.drawing:WorldToScreen(wX, wY, wZ)
    local isOnScreen, sX, sY = WorldToScreen_Original(wX, wY, wZ)
    local a = 1365;
    local b = 768;
    local retX, retY
    if sX and sY then
        retX = sX * a
        retY = -(WorldFrame:GetTop() - sY * b)
    elseif sX then
        retX = sX * a
        retY = sY
    elseif sY then
        retX = sX
        retY = sY * b
    else
        retX = sX
        retY = sY
    end
    return retX, retY, isOnScreen
end

function cxmplex.drawing:SetColor(r, g, b, a)
    private.line.r = r * 0.00390625
    private.line.g = g * 0.00390625
    private.line.b = b * 0.00390625
    if a then
        private.line.a = a * 0.01
    else
        private.line.a = 1
    end
end

function cxmplex.drawing:SetColorRaw(r, g, b, a)
    private.line.r = r
    private.line.g = g
    private.line.b = b
    private.line.a = a
end

function cxmplex.drawing:SetWidth(w)
    private.line.w = w
end

function cxmplex.drawing:Line(sx, sy, sz, ex, ey, ez)
    if not sx or not ex then return end
    local sx, sy, isOnScreen = cxmplex.drawing:WorldToScreen(sx, sy, sz)
    local ex, ey, isOnScreen2 = cxmplex.drawing:WorldToScreen(ex, ey, ez)
    if not sx or not sy or not ex or not ey then return end
    cxmplex.drawing:Draw2DLine(sx, sy, ex, ey)
end

local function rotateX(cx, cy, cz, px, py, pz, r)
    if r == nil then return px, py, pz end
    local s = sin(r)
    local c = cos(r)
    -- center of rotation
    px, py, pz = px - cx, py - cy, pz - cz
    local x = px + cx
    local y = ((py * c - pz * s) + cy)
    local z = ((py * s + pz * c) + cz)
    return x, y, z
end

local function rotateY(cx, cy, cz, px, py, pz, r)
    if r == nil then return px, py, pz end
    local s = sin(r)
    local c = cos(r)
    -- center of rotation
    px, py, pz = px - cx, py - cy, pz - cz
    local x = ((pz * s + px * c) + cx)
    local y = py + cy
    local z = ((pz * c - px * s) + cz)
    return x, y, z
end

local function rotateZ(cx, cy, cz, px, py, pz, r)
    if r == nil then return px, py, pz end
    local s = sin(r)
    local c = cos(r)
    -- center of rotation
    px, py, pz = px - cx, py - cy, pz - cz
    local x = ((px * c - py * s) + cx)
    local y = ((px * s + py * c) + cy)
    local z = pz + cz
    return x, y, z
end

function cxmplex.drawing:Array(vectors, x, y, z, rotationX, rotationY, rotationZ)
    for _, vector in ipairs(vectors) do
        local sx, sy, sz = x + vector[1], y + vector[2], z + vector[3]
        local ex, ey, ez = x + vector[4], y + vector[5], z + vector[6]

        if rotationX then
            sx, sy, sz = rotateX(x, y, z, sx, sy, sz, rotationX)
            ex, ey, ez = rotateX(x, y, z, ex, ey, ez, rotationX)
        end
        if rotationY then
            sx, sy, sz = rotateY(x, y, z, sx, sy, sz, rotationY)
            ex, ey, ez = rotateY(x, y, z, ex, ey, ez, rotationY)
        end
        if rotationZ then
            sx, sy, sz = rotateZ(x, y, z, sx, sy, sz, rotationZ)
            ex, ey, ez = rotateZ(x, y, z, ex, ey, ez, rotationZ)
        end

        local sx, sy, isOnScreen = cxmplex.drawing:WorldToScreen(sx, sy, sz)
        local ex, ey, isOnScreen2 = cxmplex.drawing:WorldToScreen(ex, ey, ez)
        if not sx or not sy or not ex or not ey then return end
        cxmplex.drawing:Draw2DLine(sx, sy, ex, ey)
    end
end

function cxmplex.drawing:Draw2DLine(sx, sy, ex, ey)
    if not sx or not sy or not ex or not ey then
        return
    end
    local L = tremove(private.lines)
    if not L then
        L = CreateFrame("Frame", private.canvas)
        L.line = L:CreateLine()
        L.line:SetDrawLayer("BACKGROUND")
    end
    L.line:SetThickness(private.line.w)
    L.line:SetColorTexture(private.line.r, private.line.g, private.line.b, private.line.a)
    tinsert(private.lines_used, L)
    L:ClearAllPoints()
    if (sx > ex and sy > ey) or (sx < ex and sy < ey) then
        L:SetPoint("TOPRIGHT", private.canvas, "TOPLEFT", sx, sy)
        L:SetPoint("BOTTOMLEFT", private.canvas, "TOPLEFT", ex, ey)
        L.line:SetStartPoint('TOPRIGHT')
        L.line:SetEndPoint('BOTTOMLEFT')
    elseif sx < ex and sy > ey then
        L:SetPoint("TOPLEFT", private.canvas, "TOPLEFT", sx, sy)
        L:SetPoint("BOTTOMRIGHT", private.canvas, "TOPLEFT", ex, ey)
        L.line:SetStartPoint('TOPLEFT')
        L.line:SetEndPoint('BOTTOMRIGHT')
    elseif sx > ex and sy < ey then
        L:SetPoint("TOPRIGHT", private.canvas, "TOPLEFT", sx, sy)
        L:SetPoint("BOTTOMLEFT", private.canvas, "TOPLEFT", ex, ey)
        L.line:SetStartPoint('TOPLEFT')
        L.line:SetEndPoint('BOTTOMRIGHT')
    else
        L:SetPoint("TOPLEFT", private.canvas, "TOPLEFT", sx, sy)
        L:SetPoint("BOTTOMLEFT", private.canvas, "TOPLEFT", sx, ey)
        L.line:SetStartPoint('TOPLEFT')
        L.line:SetEndPoint('BOTTOMLEFT')
    end
    L:Show()
end

local flags = bit.bor(0x100)
local full_circle = rad(365)
local small_circle_step = rad(3)

function cxmplex.drawing:Circle(x, y, z, size)
    local lx, ly, nx, ny, fx, fy = false, false, false, false, false, false
    for v = 0, full_circle, small_circle_step do
        nx, ny, isOnScreen = cxmplex.drawing:WorldToScreen( (x + cos(v) * size), (y + sin(v) * size), z )
        if not isOnScreen then return end
        if not nx or not ny then return end
        cxmplex.drawing:Draw2DLine(lx, ly, nx, ny)
        lx, ly = nx, ny
    end
end

function cxmplex.drawing:GroundCircle(x, y, z, size)
    local lx, ly, nx, ny, fx, fy, fz = false, false, false, false, false, false, false
    for v = 0, full_circle, small_circle_step do
        fx, fy, fz = TraceLine( (x + cos(v) * size), (y + sin(v) * size), z + 100, (x + cos(v) * size), (y + sin(v) * size), z - 100, flags )
        if fx == nil then
            fx, fy, fz = (x + cos(v) * size), (y + sin(v) * size), z
        end
        nx, ny, isOnScreen = cxmplex.drawing:WorldToScreen( (fx + cos(v) * size), (fy + sin(v) * size), fz )
        if not isOnScreen then return end
        if not nx or not ny then return end
        cxmplex.drawing:Draw2DLine(lx, ly, nx, ny)
        lx, ly = nx, ny
    end
end

function cxmplex.drawing:Arc(x, y, z, size, arc, rotation)
    local lx, ly, nx, ny, fx, fy = false, false, false, false, false, false
    local half_arc = arc * 0.5
    local ss = (arc / half_arc)
    local as, ae = -half_arc, half_arc
    for v = as, ae, ss do
        nx, ny, isOnScreen = cxmplex.drawing:WorldToScreen( (x + cos(rotation + rad(v)) * size), (y + sin(rotation + rad(v)) * size), z )
        if not isOnScreen then return end
        if not nx or not ny then return end
        if lx and ly then
            cxmplex.drawing:Draw2DLine(lx, ly, nx, ny)
        else
            fx, fy = nx, ny
        end
        lx, ly = nx, ny
    end
    local px, py, isOnScreen = cxmplex.drawing:WorldToScreen(x, y, z)
    if not isOnScreen then return end
    if not px or not py then return end
    cxmplex.drawing:Draw2DLine(px, py, lx, ly)
    cxmplex.drawing:Draw2DLine(px, py, fx, fy)
end

function cxmplex.drawing:Texture(config, x, y, z, alphaA)
    local function Distance(ax, ay, az, bx, by, bz)
        return math.sqrt(((bx - ax) * (bx - ax)) + ((by - ay) * (by - ay)) + ((bz - az) * (bz - az)))
    end
    local texture, width, height = config.texture, config.width, config.height
    local left, right, top, bottom, scale = config.left, config.right, config.top, config.bottom, config.scale
    local alpha = config.alpha or alphaA

    if not texture or not width or not height or not x or not y or not z then return end
    if not left or not right or not top or not bottom then
        left = 0
        right = 1
        top = 0
        bottom = 1
    end
    if not scale then
        local cx, cy, cz = cxmplex:GetCameraPosition()
        scale = width / Distance(x, y, z, cx, cy, cz)
    end

    local sx, sy, isOnScreen = cxmplex.drawing:WorldToScreen(x, y, z)
    if not isOnScreen then return end
    if not sx or not sy then return end
    local w = width * scale
    local h = height * scale
    sx = sx - w * 0.5
    sy = sy + h * 0.5
    local ex, ey = sx + w, sy - h

    local T = tremove(private.textures) or false
    if T == false then
        T = private.canvas:CreateTexture(nil, "BACKGROUND")
        T:SetDrawLayer(private.level)
        T:SetTexture(private.texture)
    end
    tinsert(private.textures_used, T)
    T:ClearAllPoints()
    T:SetTexCoord(left, right, top, bottom)
    T:SetTexture(texture)
    T:SetWidth(width)
    T:SetHeight(height)
    T:SetPoint("TOPLEFT", private.canvas, "TOPLEFT", sx, sy)
    T:SetPoint("BOTTOMRIGHT", private.canvas, "TOPLEFT", ex, ey)
    T:SetVertexColor(1, 1, 1, 1)
    if alpha then T:SetAlpha(alpha) else T:SetAlpha(1) end
    T:Show()
end

local i = 0
function cxmplex.drawing:Text(text, x, y, z, refid)
    local sx, sy, isOnScreen = cxmplex.drawing:WorldToScreen(x, y, z)
    if not isOnScreen then return end
    if not sx or not sy then return end
    local B = tremove(private.buttons)
    if not B then
        B = CreateFrame("Button", "CxmplexDrawingButton" .. i, private.canvas, "UIPanelButtonTemplate")
        B:DisableDrawLayer("BACKGROUND")
        B:SetHighlightTexture(nil)
        B:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            local text = cxmplex:GetTooltipForId(refid)
            if not text then return end
            GameTooltip:AddLine(text)
            GameTooltip:Show()
        end)
        B:SetScript("OnLeave", function() GameTooltip:ClearLines() GameTooltip:Hide() end)
    end
    B:SetNormalFontObject("GameFontNormalSmall")
    local font = B:GetNormalFontObject()
    font:SetTextColor(private.line.r, private.line.g, private.line.b, private.line.a)
    font:SetFont("Interface\\Addons\\" .. cxmplex.addon_name .. "\\media\\fonts\\Ruluko.ttf", 10)
    B:SetNormalFontObject(font)
    B:SetText(text)
    B:SetPoint("TOPLEFT", private.canvas, "TOPLEFT", sx - (B:GetWidth() * 0.5), sy + (B:GetHeight() * 0.5))
    B:Show()
    tinsert(private.buttons_used, B)
    i = i + 1
end

function cxmplex.drawing:Camera()
    local fX, fY, fZ = cxmplex:ObjectPosition("player")
    local sX, sY, sZ = cxmplex:GetCameraPosition()
    return sX, sY, sZ, atan2(sY - fY, sX - fX), atan((sZ - fZ) / sqrt(((fX - sX) ^ 2) + ((fY - sY) ^ 2)))
end

local function clearCanvas()
    for i = #private.lines_used, 1, - 1 do
        private.lines_used[i]:Hide()
        tinsert(private.lines, tremove(private.lines_used))
    end
    for i = #private.buttons_used, 1, - 1 do
        private.buttons_used[i]:Hide()
        tinsert(private.buttons, tremove(private.buttons_used))
    end
    for i = #private.textures_used, 1, - 1 do
        private.textures_used[i]:Hide()
        tinsert(private.textures, tremove(private.textures_used))
    end
end

local function OnDrawUpdate()
    if private and IsPlayerInWorld() then
        clearCanvas()
        for _, callback in pairs(private.callbacks) do
            callback()
        end
    end
end

local function Enable(interval)
    return C_Timer.NewTicker(interval, OnDrawUpdate)
end

local function stopDrawing()
    if not onDrawTicker then return end
    onDrawTicker:Cancel()
end

function cxmplex:AddDrawingCallback(key, callback)
    private.callbacks[key] = callback
end

function cxmplex:RemoveDrawingCallback(key)
    private.callbacks[key] = nil
end

function cxmplex:InitDrawing()
    if not private then
        private = {line = {r = 0, g = 1, b = 0, a = 1, w = 1},
            callbacks = {},
            canvas = CreateFrame("Frame", WorldFrame),
            lines = {},
            lines_used = {},
            buttons = {},
            buttons_used = {},
            textures = {},
            level = "BACKGROUND",
        textures_used = {}}
        private.canvas:SetAllPoints(WorldFrame)
        onDrawTicker = Enable(1 / 100)
    end
end

function cxmplex:DestroyDrawing()
    StopDrawing()
    clearCanvas()
    private = nil
end

function cxmplex:GetDrawingObject()
    return private
end
