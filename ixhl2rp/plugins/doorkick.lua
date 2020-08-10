
PLUGIN.name = "Doorkick Terranova Edit"
PLUGIN.author = "Ayreborne"

ix.config.Add("combineonly", false, "Whether or not doorkick is restricted to combines the server.", nil, {
	category = "Doorkick"
})


ix.command.Add("Doorkick", {
    description = "Kick the door.",
    adminOnly = true,

	OnRun = function(self, client, arguments)

		-- Get the door the player is looking at.
		local entity = client:GetEyeTrace().Entity
		local current = client:GetLocalVar("stm", 0)
		-- Validate it is a door.
		print(ix.config.Get("combineonly", false) )
		print(client:IsCombine())
	if(ix.config.Get("combineonly", false)) then
		if(client:IsCombine()) then
					if (IsValid(entity) and entity:IsDoor() and !entity:GetNetVar("disabled")) then
						if (client:GetPos():Distance(entity:GetPos())< 100) then	
								if(current > 90) then
									if(IsValid(entity.ixLock)) then
										client:Notify("You cannot kick down a combine lock!")
										return false
									  end		
									print(client:GetCharacter():GetAttribute("str", 0))
									client:ConsumeStamina(80)
									--	 client:ForceSequence("adoorkick") --Entra que nem maluco
									client:ForceSequence("kickdoorbaton")
									timer.Simple( 0.5, function()
											
									entity:Fire("unlock")
									entity:Fire("open")
									end )
								else
									client:Notify("You don't have enough stamina!")
								end

						else
							client:Notify("You are not close enough!")
						end
					else
						client:Notify("You are not looking at a door!")
					end
		else
		client:Notify("You are not a combine")
		end
	else
		if (IsValid(entity) and entity:IsDoor() and !entity:GetNetVar("disabled")) then
			if (client:GetPos():Distance(entity:GetPos())< 100) then	
					if(current > 90) then
						if(IsValid(entity.ixLock)) then
							client:Notify("You cannot kick down a combine lock!")
							return false
						  end			
						print(client:GetCharacter():GetAttribute("str", 0))
						client:ConsumeStamina(80)
						entity:EmitSound("physics/wood/wood_panel_break1.wav", 100, 120)
					--	 client:ForceSequence("adoorkick") --Entra que nem maluco
					--	client:ForceSequence("kickdoor")
						client:ForceSequence("kickdoorbaton")
						timer.Simple( 0.5, function()
											
									entity:Fire("unlock")
									entity:Fire("open")
									end )
					else
						client:Notify("You don't have enough stamina!")
					end

			else
				client:Notify("You are not close enough!")
			end
		else
			client:Notify("You are not looking at a door!")
		end
	end
    end
})