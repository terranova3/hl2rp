--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {}

-- Called when the panel is first initialized.
function PANEL:Init()
	local parent = self
	
	self.recordReferences = {}

	self:Dock(FILL)
	self:SetDrawBackground(false)

	self.main = self:Add("DPanel")
	self.main:Dock(FILL)
	self.main:SetDrawBackground(false)

	self.backHeader = self.main:Add(ix.gui.record:AddBackHeader())

	self.record = self.main:Add("DListView")
	self.record:Dock(FILL)

	self.record:AddColumn("Record Title")
	self.record:AddColumn("Added by")
	self.record:AddColumn("Points")
	
	self.bottomBox = self.main:Add("DPanel")
	self.bottomBox:Dock(BOTTOM)
	self.bottomBox:DockMargin(0, 8, 0, 0)
	self.bottomBox:SetDrawBackground(false)

	self.addRecord = self.bottomBox:Add(self:AddButton("Add Record", self.BuildRecordAdd))
	self.editRecord = self.bottomBox:Add(self:AddButton("Edit Record", function()
		parent:BuildRecordAdd(true)
	end))
	self.deleteRecord = self.bottomBox:Add(self:AddButton("Delete Record", self.DeleteRecord))

	local index = 1
	-- Loading the combine data records into the UI.
	if(ix.gui.record:GetRecord().rows) then 
		for k, v in pairs(ix.gui.record:GetRecord().rows) do
			self.recordReferences[index] = k
			self:AddRecord(v)

			index=index+1
		end
	end

	ix.gui.loadedRecord = self.record
	ix.gui.record:SetLoyaltyPoints(self.record)
end

function PANEL:Think()
	if(IsValid(self.editRecord)) then
		if(self:GetSelectedRow()) then
			self.editRecord:SetEnabled(true)
			self.deleteRecord:SetEnabled(true)
		else
			self.editRecord:SetEnabled(false)
			self.deleteRecord:SetEnabled(false)
		end
	end
end

-- Called when we need to construct a new record.
function PANEL:BuildRecordAdd(editMode)
	local parent = self
	local data = {}
	local headerTitle = "Record Creation"

	-- This is how we check if we're editing a record or creating a new one.
	if(editMode and self:GetSelectedRow()) then
		local i, row = self:GetSelectedRow()
		headerTitle = "Record Editing"
		data = {
			index = i,
			title = row:GetColumnText(1),
			creator = row:GetColumnText(2),
			points = row:GetColumnText(3)
		}
	end

	self.main:SetVisible(false)

	self.recordAdd = self:Add("DPanel")
	self.recordAdd:Dock(FILL)

	self.recordAdd:Add(ix.gui.record:AddBackHeader(function()
		self.recordAdd:Remove()
		self.main:SetVisible(true)
	end))

	local title = self.recordAdd:Add(ix.gui.record:BuildLabel(headerTitle, true))
	title:DockMargin(0,0,0,4)
	
	local recordName = self.recordAdd:Add(ix.gui.record:BuildLabel("Record name"))
	recordName:DockMargin(0,0,0,4)

	local titleTextEntry = self.recordAdd:Add("DTextEntry")
	titleTextEntry:SetText(data.title or "")
	titleTextEntry:Dock(TOP)
	titleTextEntry:DockMargin(4,0,4,0)

	self.recordAdd:Add(ix.gui.record:BuildLabel("Loyalty Points"))
	recordName:DockMargin(0,0,0,4)

	local points = self.recordAdd:Add("DNumberWang")
	points:SetValue(data.points or 0)
	points:Dock(TOP)
	points:DockMargin(4,0,4,0)

	local finishButton = self.recordAdd:Add("ixNewButton")
	finishButton:Dock(TOP)
	finishButton:SetText("Complete record")
	finishButton:DockMargin(4,4,4,0)

	-- Called when the finish button is clicked.
	function finishButton:DoClick()
		if(!data.index) then 
			parent:AddRecord({
				title = titleTextEntry:GetText(),
				points = points:GetValue() or 0
			}, true)
		else
			parent:EditRecord({
				index = data.index,
				title = titleTextEntry:GetText(),
				creator = data.creator,
				points = points:GetValue() or 0,
			})
		end

		parent.recordAdd:Remove()
		parent.main:SetVisible(true)
	end
end

-- Called when we need to delete a row we have selected.
function PANEL:DeleteRecord(data)
	if(self:GetSelectedRow()) then
		local index = self:GetSelectedRow()

		-- Hack
		if(self.recordReferences[self:GetSelectedRow()]) then
			index = self.recordReferences[self:GetSelectedRow()]
			self.recordReferences[self:GetSelectedRow()] = nil
		end

		ix.gui.record:SendToServer(VIEWDATA_REMOVEROW, {
			index = index
		})

		self.record:RemoveLine(self:GetSelectedRow())
		ix.gui.record:SetLoyaltyPoints(self.record)
	end;
end

-- Called when we need to populate a row into the list view.
function PANEL:AddRecord(data, bNetwork)
	if(!data.title) then	
		return
	end

	-- Initializing the data table we will send to the server.
	local row = {
		title = data.title,
		creator = data.creator or LocalPlayer():GetName(),
		points = data.points or 0
	}

	-- Add a new row to the record list view for the client.
	self.record:AddLine(row.title, row.creator, row.points)

	-- Send a net message to the server telling it to update the row on the server.
	if(bNetwork) then
		ix.gui.record:SendToServer(VIEWDATA_ADDROW, row)		
		ix.gui.record:SetLoyaltyPoints(self.record)
	end
end

-- Called when we need to edit a row that exists.
function PANEL:EditRecord(data)
	if(!data.title or !data.index) then
		return
	end

	-- This is updating the clientside data.
	local row = self.record:GetLine(data.index)
	row:SetColumnText(1, data.title)
	row:SetColumnText(2, data.creator or LocalPlayer():GetName())
	row:SetColumnText(3, data.points or 0)

	-- Hack
	if(self.recordReferences[data.index]) then
		data.index = self.recordReferences[data.index]
		self.recordReferences[data.index] = nil
	end

	-- Send the data to the server so it can update the record there.
	ix.gui.record:SendToServer(VIEWDATA_EDITROW, data)
	ix.gui.record:SetLoyaltyPoints(self.record)
end

-- Returns the currently selected row in the record.
function PANEL:GetSelectedRow()
	if(self.record:GetSelectedLine()) then
		return self.record:GetSelectedLine()
	end

	return false
end

-- A helper function that returns a button with a click callback
function PANEL:AddButton(text, callback)
	local parent = self
	local button = vgui.Create("ixNewButton")
	button:SetText(text)
	button:Dock(LEFT)
	button:SetWide(157)

	function button:DoClick()
		if(isfunction(callback)) then
			callback(parent)
		end
	end

	return button
end

vgui.Register("ixCombineViewDataRecord", PANEL, "DPanel")