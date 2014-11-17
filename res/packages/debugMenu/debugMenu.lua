--- debug menu unit that holds all labels, menus and open layers.


local function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end


debugMenu = {}
debugMenu.__index = debugMenu

setmetatable(debugMenu, {
             __call = function (cls, ...)
             return cls.new(...)
             end,
             })

--- create a new debugMenu instance (singleton).
-- @return debugMenu object
function debugMenu.new()
    
    
    
    
    local self = setmetatable({}, debugMenu)
    self.config = getPackageConfig("debugMenu")
    self.persistency = persistency:getPackagePersistency("debugMenu")
    self.labels = {}
    self.menus = {}
    self.labels["counter"] = 0
    self.openLayers = {}
    self.visible = true
    self.shouldShowBackButton = false
    self.openMenu = {}
    self.openMenu["current"] = "None"
    self.openMenu["last"] = "None"
    self.buttonPositionX = 30
    self.buttonPositionY = 95
    self.shouldScaleScene = 0
    self.adsBlockingViewShown = vars:getFloatVar("adsBlockingViewShown")
    self.isLandscape = vars:getFloatVar("isLandscape")
    self.keyboard = {}
    self.keyboard.buttonSize = {}
    self.keyboard.buttonSize.height = 62
    self.keyboard.buttonSize.width = 60
    
    --xStartPosition position is in percentage
    if self.isLandscape == 0 then
        self.keyboard.xStartPosition = 5.5
    else
        self.keyboard.xStartPosition = 16.5
    end
    
    print("in debugMenu:self.isLandscape ".. self.isLandscape)
    return self
end
--- get Y coordinate position of a menu.
-- @param name the name of the menu as appears in debugMenuConfig.plist
-- @return Y coordinate of the menu or 55 by default if the menu does not appear in debugMenuConfig
function debugMenu:getMenuYPos(name)
    if self.config[name] == nil or self.config[name].menuPosition == nil or self.config[name].menuPosition.YPos == nil then return 55 end
    --print ("debug menu width is "..self.config[name].menuSize.width)
    return self.config[name].menuPosition.YPos
end

--- get Y coordinate position of the menu back button (<<=).
-- @param name the name of the menu as appears in debugMenuConfig.plist
-- @return Y coordinate of the menu back button
function debugMenu:getMenuBackButtonYPos(name)
    return debugMenu:getMenuYPos(name) + debugMenu:getMenuHeight(name)/2 - 2
end

--- get X coordinate position of the menu back button (<<=).
-- @param name the name of the menu as appears in debugMenuConfig.plist
-- @return X coordinate of the menu back button
function debugMenu:getMenuBackButtonXPos(name)
    return debugMenu:getMenuXPos(name) - debugMenu:getMenuWidth(name)/2 + 5
end

--- get Y coordinate position of the menu exit button (X).
-- @param name the name of the menu as appears in debugMenuConfig.plist
-- @return Y coordinate of the menu exit button
function debugMenu:getMenuExitButtonYPos(name)
    -- TODO: include font size calculations here
    return debugMenu:getMenuYPos(name) + debugMenu:getMenuHeight(name)/2 - 2
end

--- get X coordinate position of the menu exit button (X).
-- @param name the name of the menu as appears in debugMenuConfig.plist
-- @return X coordinate of the menu exit button
function debugMenu:getMenuExitButtonXPos(name)
    return debugMenu:getMenuXPos(name) + debugMenu:getMenuWidth(name)/2 - 2
end

--- get Y coordinate position of the menu title label.
-- @param name the name of the menu as appears in debugMenuConfig.plist
-- @return Y coordinate of the menu title label
function debugMenu:getMenuTitleYPos(name)
    return debugMenu:getMenuYPos(name) + debugMenu:getMenuHeight(name)/2 - 2
end

--- get X coordinate position of the menu title label.
-- @param name the name of the menu as appears in debugMenuConfig.plist
-- @return X coordinate of the menu title label
function debugMenu:getMenuTitleXPos(name)
    return debugMenu:getMenuXPos(name)
end


--- get X coordinate position of the menu.
-- @param name the name of the menu as appears in debugMenuConfig.plist
-- @return X coordinate of the menu or 50 by default if it does not exist in debugMenuConfig
function debugMenu:getMenuXPos(name)
    if self.config[name] == nil or self.config[name].menuPosition == nil or self.config[name].menuPosition.XPos == nil then return 50 end
    return self.config[name].menuPosition.XPos
end

--- get menu width.
-- @param name the name of the menu as appears in debugMenuConfig.plist
-- @return width of the menu or 60 by default if it does not exist in debugMenuConfig
function debugMenu:getMenuWidth(name)
    if self.config[name] == nil or self.config[name].menuSize == nil or self.config[name].menuSize.width == nil then return 60 end
    return self.config[name].menuSize.width
end
--- get menu height.
-- @param name the name of the menu as appears in debugMenuConfig.plist
-- @return height of the menu or 50 by default if it does not exist in debugMenuConfig
function debugMenu:getMenuHeight(name)
    if self.config[name] == nil or self.config[name].menuSize == nil or self.config[name].menuSize.width == nil then return 50 end
    return self.config[name].menuSize.height
end

--- adds a label to the label table and increment the counter for that label.
-- @param name the name of the label to add
-- @param menuName the name of the menu as appears in debugMenuConfig.plist

function debugMenu:addLabel(name, menuName)
    if self.menus[menuName] == nil then
        self.menus[menuName] = 1
    end
    if self.labels[name] == nil then
        local counter = self.menus[menuName]
        self.labels[name] = {counter, menuName}
        self.menus[menuName] = counter + 1
        print("label added: "..name.." "..self.labels[name][1])
    end
    
end

--- calculate the label X position.
-- @param name the name of the label

function debugMenu:calculateLabelX(name)
    if self.labels[name] == nil then return 50
        else
        local menuName = self.labels[name][2]
        local menuWidth = debugMenu:getMenuWidth(menuName)
        local menuHeight = debugMenu:getMenuHeight(menuName)
        local menuXPos = debugMenu:getMenuXPos(menuName)
        return menuXPos
    end
    
end
--- calculate the label Y position.
-- @param name the name of the label
function debugMenu:calculateLabelY(name)
    
    if self.labels[name] == nil then return 50
        else
        local menuName = self.labels[name][2]
        local menuWidth = debugMenu:getMenuWidth(menuName)
        local menuHeight = debugMenu:getMenuHeight(menuName)
        local menuYPos = debugMenu:getMenuYPos(menuName)
        -- include font size of title
        local startPos = menuYPos + menuHeight/2 - 7.5
        local a = startPos - (self.labels[name][1]-1)*5
        --print("menu width is "..tostring(menuWidth).." ".."menu height is "..tostring(menuHeight))
        print("the label is "..tostring(self.labels[name][1]).." "..tostring(name).. " " ..a)
        
        -- include font size calculations later
        
        return a
    end
    
end

--- open a layer by adding it to the table of open layers and marking it as true.
-- @param name the name of the layer
function debugMenu:openLayer(name)
    self.openLayers[name] = true
    --for future development
    --self.openLayers.positions[name] = {x= 50, y= 55}
end
--- close a layer by marking it as false in the table of open layers.
-- @param name the name of the layer
function debugMenu:closeLayer(name)
    self.openLayers[name] = false
end
--- check whether a layer is open. If no layer name is given, check whether there is at least one layer open.
-- @param name the name of the layer.
-- @return true if the layer is open, or if no layer name is given, return true if any layer is open, otherwise return false.
function debugMenu:isLayerOpen(name)
    if name == nil then
        for k,v in pairs(self.openLayers) do
            if v == true then return true end
        end
        return false
    else
        return self.openLayers[name] == true
    end
end

--- sets the visibility of the debugMenu button to false.
function debugMenu:hide()
    self.visible = false
end

--- check whether the debugMenu button is visible.
-- @return true if visible, false otherwise
function debugMenu:isVisible()
    return self.visible
end

--- toggles the visibility of the android back button.
function debugMenu:toggleBackButtonVisibility()
    if self.shouldShowBackButton == true then
        self.shouldShowBackButton = false
    else
        self.shouldShowBackButton = true
    end
end
function debugMenu:isBackButtonVisible()
    return self.shouldShowBackButton
end

function debugMenu:setLastMenu(menuName)
    self.openMenu["last"]=menuName
end

--- sets the current menu
-- @param menuName the current menu to set to
function debugMenu:setCurrentMenu(menuName)
    
    print("debugMenu: current "..tostring(self.openMenu["current"]))
    print("debugMenu: future: "..tostring(menuName))
    local copy = self.openMenu["current"]
    self.openMenu["last"] = copy
    self.openMenu["current"] = tostring(menuName)
    
    print("debugMenu: now last: "..tostring(self.openMenu["last"]))
    print("debugMenu: current: "..tostring(self.openMenu["current"]))
    
end
--- gets the current open menu
-- @return the current menu name
function debugMenu:getCurrentMenu()
    print("currentMenu returned ", self.openMenu["current"])
    if self.openMenu["current"] == nil then return "None" end
    return self.openMenu["current"]
end
--- gets the last open menu
-- @return the last menu name
function debugMenu:getLastMenu()
    print("lastMenu returned ", self.openMenu["last"])
    if self.openMenu["last"] == nil then return "None" end
    return self.openMenu["last"]
end

--- gets the orientation of the app according to isLandscape variable set by the platform.
-- @return "landscape" if the orientation is landscape, portrait otherwise
function debugMenu:getOrientation()
    print("in debugMenu:isLandscape")
    if self.isLandscape == 1 then
        return "landscape"
    else
        return "portrait"
    end
end

-- @todo merge these into one function
--- gets a position depending on the orientation.
-- @param x the x position for landscape
-- @param xOffset the offset for portrait (optional: default is 0)
-- @return x if landscape and x+xOffset for portrait
function debugMenu:getPositionX(x, xOffset)
    xOffset = xOffset or 0
    if debugMenu:getOrientation() == "landscape" then
        return x
    else
        -- portrait case
        return x + xOffset
    end
end

--- gets a position depending on the orientation.
-- @param y the y position for landscape
-- @param yOffset the offset for portrait (optional: default is 0)
-- @return y if landscape and y+yOffset for portrait
function debugMenu:getPositionY(y, yOffset)
    yOffset = yOffset or 0
    if debugMenu:getOrientation() == "landscape" then
        return y
    else
        -- portrait case
        return y + yOffset
    end
end

--- checks for rewarded ads availability.
-- @return "RewardedAds: available" if available, "RewardedAds: not available" otherwise
function debugMenu:getRewardedAdsAvailability()
    local isAvailable = services:rewardedAdsHasVideo()
    if (isAvailable) then
        return "RewardedAds: available"
        else
        return "RewardedAds: not available"
    end
end

--- gets the android back button visibility. This function returns the correct string for the label (button).
-- @return "Hide Back Button" if the android back button is shown, "Show Back Button" otherwise
function debugMenu:getBackButtonVisibility()
    if self.shouldShowBackButton == true then
        return "Hide Back Button"
    else
        return "Show Back Button"
    end
end
--- gets the correct label text for the scale scene action.
-- @return "Scale Scene" if the scene is not scaled currently, "Unscale Scene" otherwise
function debugMenu:shouldScaleSceneText()
    if self.shouldScaleScene == 0 then
        return "Scale Scene"
    else
        return "Unscale Scene"
    end
end
--- toggles scale scene.
function debugMenu:toggleShouldScaleScene()
    if self.shouldScaleScene == 0 then
        self.shouldScaleScene = 1
    else
        self.shouldScaleScene = 0
    end
end

--- gets the notification for toggleAdsBlockingView according to its state
-- @return "showAdsDebug" if the ads blocking view is not shown, "hideAdsDebug" otherwise
function debugMenu:getToggleAdsBlockingViewNotification()
    self.adsBlockingViewShown = vars:getFloatVar("adsBlockingViewShown")
    if self.adsBlockingViewShown == 0 then
        return "showAdsDebug"
    else
        return "hideAdsDebug"
    end
end

--- gets the position for each key
-- @param key the key to get the position for
-- @return table with {x,y} the position of the key
function debugMenu:getKeyBoardPosition(key)
    local buttonX, buttonY
    if  debugMenu:getOrientation() == "portrait" then
        buttonX = self.keyboard.buttonSize.width/768*100
        buttonY = self.keyboard.buttonSize.height/1024*100
    end
    if  debugMenu:getOrientation() == "landscape" then
        buttonX = self.keyboard.buttonSize.width/1024*100
        buttonY = self.keyboard.buttonSize.height/768*100
    end
    local xPos, yPos
    if key == "delete" then
        --buttonX = self.keyboard.buttonSize.width/768*100
        xPos = self.keyboard.xStartPosition + (tonumber(11)*buttonX)
        yPos = 66.7391
    elseif key == "." then
        --buttonX = self.keyboard.buttonSize.width/768*100
        xPos = self.keyboard.xStartPosition + (tonumber(10)*buttonX)
        yPos = 66.7391
    elseif key == "0" then
        xPos = self.keyboard.xStartPosition + (tonumber(9)*buttonX)
        yPos = 66.7391
    else
        xPos = self.keyboard.xStartPosition + ((tonumber(key)-1)*buttonX)
        yPos = 66.7391
    end
    print("in debugMenu xButton: ",xPos, key)
    --print("in debugMenu xButton: ",yPos, key)
    return {x=xPos, y=yPos}
end

function debugMenu:splitIP(ip)
    local splitIP=split(ip, ".")
    return splitIP
end
--- saves the ip to persistency
-- @param ip the ip to set to persistency, starts with "ip:"
function debugMenu:saveIpToPersistency(ip)
    local ipToSplit = string.sub(ip, 4)
    local splitIP=split(ipToSplit, ".")
    -- @todo add validation for this
    if splitIP[1] ~= nil then
        self.persistency:setValue("ip1", tonumber(splitIP[1]))
    end
    if splitIP[2] ~= nil then
        self.persistency:setValue("ip2", tonumber(splitIP[2]))
    end
    if splitIP[3] ~= nil then
        self.persistency:setValue("ip3", tonumber(splitIP[3]))
    end
    if splitIP[4] ~= nil then
        self.persistency:setValue("ip4", tonumber(splitIP[4]))
    end
end

--- gets the ip from persistency
-- @return "enter ip" if all numbers constructing the ip are 0. otherwise return the ip as string.
function debugMenu:getIpFromPersistency()
    local ip1 = self.persistency:getValue("ip1")
    local ip2 = self.persistency:getValue("ip2")
    local ip3 = self.persistency:getValue("ip3")
    local ip4 = self.persistency:getValue("ip4")
    if ip1 == 0 and ip2 == 0 and ip3 == 0 and ip4 == 0 then
        print("in debugMenu:getIpFromPersistency returned nothing")
        return "enter ip"
    else
        print("in debugMenu:getIpFromPersistency returned:", tostring(ip1).."."..tostring(ip2).."."..tostring(ip3).."."..tostring(ip4))
        return tostring(ip1).."."..tostring(ip2).."."..tostring(ip3).."."..tostring(ip4)
    end
end
--- check whether the ip was previously set(persistency)
-- @return true if the ip has been set before, else otherwise (checks whether one of the ip numbers is non-zero).
function debugMenu:isIpSet()
    local ip1 = self.persistency:getValue("ip1")
    local ip2 = self.persistency:getValue("ip2")
    local ip3 = self.persistency:getValue("ip3")
    local ip4 = self.persistency:getValue("ip4")
    if ip1 == 0 and ip2 == 0 and ip3 == 0 and ip4 == 0 then
        print("in debugMenu:getIpFromPersistency returned nothing")
        return false
    else
        return true
    end
end

function debugMenu:startLuaDebug()
    print("inside debugMenu:startLuaDebug")
    mobdebug.startDebug()
    
end

-- initiate (singleton)
debugMenu = debugMenu()

 