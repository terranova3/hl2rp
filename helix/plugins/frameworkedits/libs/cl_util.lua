--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

function ix.util.AddMenuFromData(menuPanel, data, Callback, iMinimumWidth, bManualOpen)
    local bCreated = false;
    local options = {};
    
    if (!menuPanel) then
        bCreated = true; menuPanel = DermaMenu();
        
        if (iMinimumWidth) then
            menuPanel:SetMinimumWidth(iMinimumWidth);
        end;
    end;
    
    for k, v in pairs(data) do
        options[#options + 1] = {k, v};
    end;
    
    table.sort(options, function(a, b)
        return a[1] < b[1];
    end);
    
    for k, v in pairs(options) do
        if (type(v[2]) == "table" and !v[2].isArgTable) then
            if (tableCount(v[2]) > 0) then
                self:AddMenuFromData(menuPanel:AddSubMenu(v[1]), v[2], Callback);
            end;
        elseif (type(v[2]) == "function") then
            menuPanel:AddOption(v[1], v[2]);
        elseif (Callback) then
            Callback(menuPanel, v[1], v[2]);
        end;
    end;
    
    if (!bCreated) then return; end;
    
    if (!bManualOpen) then
        if (#options > 0) then
            menuPanel:Open();
        else
            menuPanel:Remove();
        end;
    end;
    
    return menuPanel;
end;