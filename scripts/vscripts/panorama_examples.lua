function PanoramaExample_Init()
	print( "building selection init" )
	
	-- CustomGameEventManager:RegisterListener( "aura_selection_select", function( _, data )
	-- 	print( "Aura Select", data.id, data.name )
	-- end )
	
	-- Convars:RegisterCommand( "aura_selection_send", function( _, count )
	-- 	local sendAbilities = {}

	-- 	for i = 1, tonumber( count ) do
	-- 		local r = RandomInt( 1, #abilities )
	-- 		local ability = {
	-- 			name = abilities[r],
	-- 			ability = abilities[r],
	-- 		}
	
	-- 		if RandomInt( 1, 2 ) == 1 then
	-- 			ability.image = "file://{images}/settings/discord_shadow.png"
	-- 			ability.text = "Aura description " .. RandomInt( 1, 99 )
	-- 		end
	
	-- 		table.insert( sendAbilities, ability )
	-- 	end
	
	-- 	CustomGameEventManager:Send_ServerToAllClients( "aura_selection_new", sendAbilities )
	-- end, "", 0 )
	
	Convars:RegisterCommand( "challege_test", function()
		CustomGameEventManager:Send_ServerToAllClients( "challenges_set_quests", {
			{
				name = "First Quest",
				image = "file://{images}/settings/fortune_icon.png",
				reward = 1337,
				progress = 4,
				goal = 6
			},
			{
				name = "Second Quest",
				image = "file://{images}/settings/fortune_icon.png",
				reward = 1488,
				progress = 3,
				goal = 3
			},
			{
				name = "Third Quest",
				image = "file://{images}/settings/fortune_icon.png",
				locked = true
			}
		} )
	end, "", 0 )
end