--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Book Base"
ITEM.model = "models/props_lab/clipboard.mdl"
ITEM.description = "This books description has not been setup. This is likely an error, please report this as a bug."
ITEM.category = "Literature"
ITEM.flag = "g"
ITEM.functions.Read = {
	icon = "icon16/book_open.png",
	OnRun = function(item)
		netstream.Start(item.player, "ViewBook", item.id);
		return false
	end;
}
ITEM:Call("Setup")

-- Called when the item should be setup.
function ITEM:Setup()
	if (self.bookInformation) then
		self.bookInformation = string.gsub( string.gsub(self.bookInformation, "\n", "<br>"), "\t", string.rep("&nbsp;", 4) );
		self.bookInformation = "<html>"..self.bookInformation.."</font></html>";
	end;
end;