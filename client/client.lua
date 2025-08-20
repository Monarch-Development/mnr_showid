local config = lib.load("config.config")

local showID = {}
showID.__index = showID

showID.active = false
showID.tags = {}
showID.thread = nil

function showID:toggle()
    self.active = not self.active

    if self.active then
        lib.notify({ description = locale("showid-on"), position = "top", type = "success" })
        self:loop()
    else
        lib.notify({ description = locale("showid-off"), position = "top", type = "error" })
        self:stop()
    end
end

function showID:loop()
    if self.thread then return end

    self.thread = CreateThread(function()
        while self.active do
            self:update()
            Wait(1000)
        end
        self.thread = nil
    end)
end

function showID:update()
    local playerCoords = GetEntityCoords(cache.ped)
    local nearby = lib.getNearbyPlayers(playerCoords, config.distance, true)
    local seen = {}

    for _, player in pairs(nearby) do
        local serverId = GetPlayerServerId(player.id)
        local targetPed = player.ped

        if not self.tags[serverId] then
            self.tags[serverId] = CreateFakeMpGamerTag(targetPed, tostring(serverId), false, false, "", 0)
        end

        local tag = self.tags[serverId]
        local hasLOS = HasEntityClearLosToEntity(cache.ped, targetPed, 17)
        local visible = IsEntityVisible(targetPed)

        SetMpGamerTagAlpha(tag, 0, 255)
        SetMpGamerTagAlpha(tag, 4, 255)

        SetMpGamerTagVisibility(tag, 0, hasLOS and visible)
        SetMpGamerTagVisibility(tag, 4, NetworkIsPlayerTalking(player.id))

        seen[serverId] = true
    end

    for serverId, tag in pairs(self.tags) do
        if not seen[serverId] then
            RemoveMpGamerTag(tag)
            self.tags[serverId] = nil
        end
    end
end

function showID:stop()
    for _, tag in pairs(self.tags) do
        RemoveMpGamerTag(tag)
    end
    self.tags = {}
end

lib.addKeybind({
    name = "mnr:showid",
    description = locale("showid-key-desc"),
    defaultKey = config.key,
    onPressed = function()
        showID:toggle()
    end
})