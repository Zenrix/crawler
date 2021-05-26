-- CONFIG =====================================================================

-- Sets the character name
name = BigBotMan

-- Remove most of the "More" prompts
show_more = false

-- Set the forced "More" prompts to an empty array
force_more_message =

-- Never stop autofighting for now
autofight_stop = 0

-- Rebind autofight key
bindkey = [`] CMD_AUTOFIGHT

-- Keybind for lua console
bindkey = [~] CMD_LUA_CONSOLE

-- Prevent other keys from stopping auto travel
travel_key_stop = false

-- misc
explore_delay = -1
travel_delay = -1
rest_delay = -1
show_travel_trail = true

-- END CONFIG =================================================================

{

-- Variables local to the bot script
local current_turn = 0

-- Function that runs at the beginning of each turn
function ready()
	local next_input = "o"
	
	--[[ 
	if (current_turn == 100) then
		crawl.more()
		current_turn = 0
	end
	current_turn = current_turn + 1
	--]]

	--[[
	
	Problems
		- Confused state
		- Invisible enemies NOTE: "There is a strange disturbance nearby!"4
		- Opening shops with auto explore
		- Runed translucent doors
		- Unreachable enemies
        - Reaching the bottom of any branch (Ecuminical Temple)
	
	--]]
	
	--[[
	if tab_or_explore then
		crawl.sendkeys("o")
		tab_or_explore = false
	else
		crawl.sendkeys("`")
		tab_or_explore = true
	end
	--]]
	
	--[[
	recent_message = crawl.messages(1)

	if recent_message:find("Done exploring.") then
		-- Other messages to consider:
		-- Partly explored, can't reach some places.
		-- Partly explored, unvisited transporter.
		
		crawl.sendkeys("X>.>")
	end
	--]]
	
	-- Handle "Could not explore, unopened runed door."
	-- Handle "You are too confused!"
	-- Handle "You suddenly lose the ability to move!" 'more' prompt
	-- Handle "You resist with significant effort" 'more' prompt
	
	recent_message = crawl.messages(1)
	
	-- EXPLORATION
	
	if recent_message:find("Done exploring.") then
		next_input = "X>.>"
	end
	
	-- Handles multiple "Partly explored" messages
	if recent_message:find("Partly explored") then
		next_input = "X>.>"
	end
	
	if recent_message:find("Could not explore, unopened runed door.") then
		next_input = "X>.>"
	end
	
	-- ITEMIZATION
	
	if recent_message:find("ring mail") then
		next_input = "."
	end
	
	-- COMBAT
	
	-- Handle "An * is nearby!" message
	if recent_message:find("nearby!") then
		next_input = "`"
	end
	
	if recent_message:find("No reachable target in view!") then
		next_input = "."
	end
	
	if recent_message:find("There is a strange disturbance nearby!") then
		next_input = random_move()
	end
	
	if recent_message:find("There is a lethal amount of poison in your body!") then
		next_input = "."
	end
	
	if recent_message:find("You cannot move.") then
		next_input = "."
	end
	
	if recent_message:find("You are too confused!") then
		next_input = random_move()
	end
	
	if recent_message:find("Failed to move towards target.") then
		next_input = random_move()
	end

    if recent_message:find("No reachable target in view!") then
		next_input = random_move()
	end
	
	if (recent_message:find("entrance to") and recent_message:find("Shoppe")) then
        crawl.process_keys(string.char(27))
		next_input = string.char(27)
	end
	
	crawl.message("Input: " .. next_input)
	crawl.sendkeys(next_input)
end

-- A hook function, selects strength on level up prompt
function choose_stat_gain()
	return "S"
end

function random_move()
    local output = ""
    local random_direction = crawl.random2(7)
    if random_direction == 0 then
        output = "h"
    elseif random_direction == 1 then
        output = "j"
    elseif random_direction == 2 then
        output = "k"
    elseif random_direction == 3 then
        output = "l"
    elseif random_direction == 4 then
        output = "y"
    elseif random_direction == 5 then
        output = "u"
    elseif random_direction == 6 then
        output = "b"
    elseif random_direction == 7 then
        output = "n"
    end
    return output
end

--[[
    Seeds
    2 - Shop D:4
    4 - infinite loop unapproachable enemies D:2
--]]

}

