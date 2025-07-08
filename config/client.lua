---@class TargetData
---@field coords vector3
---@field radius number

---@class FloorData
---@field coords vector4
---@field label? string
---@field groups? string|string[]|table<string, number>

---@class ElevatorData
---@field target TargetData[]
---@field floor FloorData[]

return {
    Mechanic = {
        target = {
            {
                coords = vec(-478.7486, -733.0693, 30.5630),
                radius = 5
            },
            {
                coords = vector3(-472.4002, -722.4576, 35.4892),
                radius = 5
            }
        },
        floor = {
            {
                label = 'G',
                coords = vec(-478.7486, -733.0693, 30.5630, 183.3698),
                groups = 'mechanic'
            },
            {
                coords = vec(-472.5219, -728.1053, 35.3815, 179.6284),
            }
        }
    }
}