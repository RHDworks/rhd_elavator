local elevatorId

local ui = require 'modules.ui'
local config = require 'config.client'

local function filterGroups(groups)
    local qbPlayerData = exports.qbx_core:GetPlayerData()

    local playerJob = qbPlayerData.job

    if not groups then
        return true
    end

    local _lt = type(groups)
    local jobname, jobtype = playerJob.name, playerJob.type

    if _lt == "string" then
        return (jobname == groups) or (jobtype == groups)
    elseif _lt == "table" then
        if table.type(groups) == 'array' then
            return lib.table.contains(groups, jobname)
        else
            local gradeLevel = groups[jobname] or groups[jobtype]
            return gradeLevel and playerJob.grade.level >= gradeLevel
        end
    end

    return false
end

local function prepareElevator(liftData)
    local data = {
        id = elevatorId,
        floor = {}
    }

    local myCoords = GetEntityCoords(cache.ped)

    for i=1, #liftData.floor do
        local floor = liftData.floor[i]
        local currentFloor = false
        local isAuthorize = filterGroups(floor.groups)

        local distance = #(myCoords - floor.coords.xyz)

        if distance < 5 then
            currentFloor = true
        end

        local disable = currentFloor or floor.groups and not isAuthorize

        data.floor[#data.floor+1] = {
            index = i,
            label = floor.label,
            disable = disable
        }
    end

    ui.sendMessage('setVisible', {
        visible = true,
        liftData = data
    }, true)
end

local function executeElevator(index)
    if not elevatorId then
        return
    end

    local floor = config[elevatorId]?.floor

    if not floor then
        return
    end

    if not floor[index] then
        return
    end

    local liftReady = lib.progressBar({
        label = 'Waiting Lift',
        duration = 5000,
        useWhileDead = false,
        canCancel = true,
        disable = {
            combat = true,
            move = true,
            car = true
        },
        anim = {
            dict = 'anim@apt_trans@elevator',
            clip = 'elev_1'
        }
    })

    if not liftReady then
        return
    end

    StopAnimTask(cache.ped, "anim@apt_trans@elevator", "elev_1", 1.0)
    DoScreenFadeOut(500)
    Wait(1000)
    SetEntityCoords(cache.ped, floor[index].coords.x, floor[index].coords.y, floor[index].coords.z, 0, 0, 0, false)
    SetEntityHeading(cache.ped, floor[index].coords.w)
    Wait(1000)
    DoScreenFadeIn(600)
end

RegisterNUICallback('rhd_elevator:client:execute', function (data, cb)
    if not elevatorId then
        cb('ok')
        return
    end

    SetNuiFocus(false, false)
    executeElevator(data.floor)
    ui.onClosed()
    cb('ok')
end)

RegisterNUICallback('exit', function (data, cb)
    ui.onClosed()
    cb('ok')
end)

CreateThread(function ()
    for id, data in pairs (config) do
        if data.target and #data.target > 0 then
            for t=1, #data.target do
                local tdata = data.target[t]

                exports.ox_target:addSphereZone({
                    coords = tdata.coords.xyz,
                    radius = tdata.radius,
                    options = {
                        {
                            label = 'Use Elevator',
                            icon = 'fas fa-circle-info',
                            distance = 2.5,
                            onSelect = function ()
                                elevatorId = id
                                prepareElevator(data)
                            end
                        }
                    }
                })
            end
        end
    end
end)