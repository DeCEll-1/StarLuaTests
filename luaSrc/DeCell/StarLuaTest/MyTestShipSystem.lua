-- TYPE SHIP_SYSTEM
-- PACKAGE data.scripts.DeCell.StarLua
-- NAME MyTestShipSystem
MAX_TIME_MULT = 3.0
MIN_TIME_MULT = 0.1

JITTER_COLOR = Color.new(128, 0, 128, 50)
JITTER_UNDER_COLOR = Color.new(128, 0, 128, 155)

return {

    --- Called every frame the ship system is active.
    ---@param stats MutableShipStatsAPI  The stats object representing the ship's mutable stats.
    ---@param id string                  A unique ID for modifying stats, often based on the ship.
    ---@param state string               The current state of the system: "IN", "ACTIVE", or "OUT".
    ---@param effectLevel number         A float from 0 to 1 representing how active the system is.
    apply = function(stats, id, state, effectLevel)
        ---@type ShipAPI
        local ship = nil
        local player = false


        local entity = stats:getEntity()

        if instanceof(entity, ShipAPI) then
            ---@type ShipAPI
            ship = cast(entity, ShipAPI)
            if (Global:getCombatEngine():getPlayerShip() == ship) then
                player = true
            end
            id = id .. "_" .. ship:getId()
        else
            return
        end

        local jitterLevel = effectLevel
        local jitterRangeBonus = 0.0
        local maxRangeBonus = 10.0

        if state == "IN" then
            jitterLevel = effectLevel / (1.0 / ship:getSystem():getChargeUpDur())
            if jitterLevel > 1.0 then
                jitterLevel = 1.0
            end
            jitterRangeBonus = jitterLevel * maxRangeBonus
        elseif state == "ACTIVE" then
            jitterLevel = 1
            jitterRangeBonus = maxRangeBonus
        elseif state == "OUT" then
            jitterRangeBonus = jitterLevel * maxRangeBonus
        end

        jitterLevel = math.sqrt(jitterLevel)
        effectLevel = effectLevel * effectLevel

        ship:setJitter(this, JITTER_COLOR, jitterLevel, 3, 0, 0 + jitterRangeBonus)
        ship:setJitterUnder(this, JITTER_UNDER_COLOR, jitterLevel, 25, 0, 7 + jitterRangeBonus)

        local shipTimeMult = 1 + (MAX_TIME_MULT - 1) * effectLevel
        stats:getTimeMult():modifyMult(id, shipTimeMult)

        if player then
            Global:getCombatEngine():getTimeMult():modifyMult(id, 1 / shipTimeMult)
        else
            Global:getCombatEngine():getTimeMult():unmodifyMult(id)
        end



        ship:getEngineController():fadeToOtherColor(this, JITTER_COLOR, Color.new(0, 0, 0, 0), effectLevel, 0.5)
        ship:getEngineController():extendFlame(this, -0.25, -0.25, -0.25)
    end,

    --- Called when the system is deactivated to clean up stat modifications.
    ---@param stats MutableShipStatsAPI  The stats object for the ship.
    ---@param id string                  The ID used to identify modifications to be removed.
    unapply = function(stats, id)
        ---@type ShipAPI
        local ship = nil
        local player = false

        local entity = stats:getEntity()
        if instanceof(entity, ShipAPI) then
            ---@type ShipAPI
            ship = cast(entity, ShipAPI)
            if Global:getCombatEngine():getPlayerShip() == ship then
                player = true
            end
            id = id .. "_" .. ship:getId()
        else
            return
        end

        Global:getCombatEngine():getTimeMult():unmodify(id)
        stats:getTimeMult():unmodify(id)
    end,

    --- Returns status information shown next to the system icon.
    ---@param index integer             The status line index (0 = first line).
    ---@param state string              The current system state.
    ---@param effectLevel number        A float from 0 to 1 representing the current effect intensity.
    ---@return table|nil                A table with `text` and `active` fields or nil to hide the line.
    getStatusData = function(index, state, effectLevel)
        local shipTimeMult = 1.0 + (MAX_TIME_MULT - 1.0) * effectLevel

        if index == 0 then
            return StatusData.new("Ship Time Mult: " .. string.format("%.2f", shipTimeMult), false)
        end

        return nil
    end,
}
