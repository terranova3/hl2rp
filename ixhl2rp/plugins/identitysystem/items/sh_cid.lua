ITEM.name = "ID Card"
ITEM.model = Model("models/dorado/tarjeta2.mdl")
ITEM.description = "Originally instituted when proposed by Luna Solaris in 2015, the now-standard ID Card system replaced the previous system of exclusively ID Numbers.\nPreviously, Citizens were expected to remember their 5 digit identification number, which was wildly unpopular with the elderly."

function ITEM:GetDescription()
	return self.description
end

function ITEM:IsCWU()
	return self:GetData("cwu", false)
end

function ITEM:IsCombine()
	return self:GetData("cca", false)
end

function ITEM:GetModel()
	if self:IsCWU() then
		return "models/dorado/tarjeta1.mdl"
	elseif self:IsCombine() then
		return "models/dorado/tarjetazero.mdl"
	else
		return self.model
	end
end

function ITEM:PopulateTooltip(tooltip)
	local data = tooltip:AddRow("data")
	data:SetBackgroundColor(derma.GetColor("Success", tooltip))
	data:SetText("Name: " .. self:GetData("citizen_name", "Unissued") .. "\nID Number: " .. self:GetData("cid", "00000") .. "\nIssue Date: " .. self:GetData("issue_date", "Unissued"))
	data:SetFont("BudgetLabel")
	data:SetExpensiveShadow(0.5)
	data:SizeToContents()

	local warning = tooltip:AddRow("warning")
	warning:SetBackgroundColor(derma.GetColor("Error", tooltip))
	warning:SetText("Each card has an RFID chip and a photo of whoever was present at the time of it being issued. It would be unwise to get caught with a card that isn't yours.")
	warning:SetFont("DermaDefault")
	warning:SetExpensiveShadow(0.5)
	warning:SizeToContents()
end

ITEM.functions.ViewRecord = {
	name = "View Record",
	icon = "icon16/book_edit.png",
	OnRun = function(item)
		local client = item.player
		local target = nil

		for _, v in pairs(player.GetAll()) do
			if(v:GetCharacter():GetData("cid", "") == item:GetData("cid", 00000)) then
				target = v
				break
			end
		end

		if (target) then
			if(!hook.Run("CanPlayerViewData", client, target)) then
				client:Notify("@cantViewData")
				return false
			end
		else
			client:Notify("This character is not online or this is an invalid id.")		
			return false
		end

		local character = target:GetCharacter()
		netstream.Start(client, "ViewData", target, character:GetData("cid"), character:GetData("combineData", {}), character:GetCPInfo())

		return false
	end,

	OnCanRun = function(item)
		return item.player:IsCombine() or item.invID != item.player:GetCharacter():GetInventory():GetID()
	end
}