manifestParser = {}
manifestParser.requireBehaviors = false
      
 --TODO: validation: no main manifest, no package manifest

--[[ ALL FUNCTIONS RELATED TO DEPENDENCY READING... --]] 
local function strip(s)
   return string.gmatch(s, "%w+")()
end
     
local function parseargs(s)
  local arg = {}
  string.gsub(s, "([%w]+)%s*=%s*([\"'%w]+)", function(w,k)
  arg[w] = strip(k)
end)
 
  return arg
end
    
local function collect(s)
  local stack = {}
  local top = {}
  table.insert(stack, top)
  local ni,c,label,xarg, empty
  local i, j = 1, 1
  while true do
    ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
    if not ni then break end
    local text = string.sub(s, i, ni-1)
    if not string.find(text, "^%s*$") then
      table.insert(top, text)
    end
    if empty == "/" then  -- empty element tag
      table.insert(top, {label=label, xarg=parseargs(xarg), empty=1})
    elseif c == "" then   -- start tag
      top = {label=label, xarg=parseargs(xarg)}
      table.insert(stack, top)   -- new level
    else  -- end tag
      local toclose = table.remove(stack)  -- remove top
      top = stack[#stack]
      if #stack < 1 then
        error("nothing to close with "..label)
      end
      if toclose.label ~= label then
        error("trying to close "..toclose.label.." with "..label)
      end
      table.insert(top, toclose)
    end
    i = j+1
  end
  local text = string.sub(s, i)
  if not string.find(text, "^%s*$") then
    table.insert(stack[#stack], text)
  end
  if #stack > 1 then
    error("unclosed "..stack[#stack].label)
  end
  return stack[1]
end
--[[END OF FUNCTIONS RELATED TO DEPENDENCY READING... --]]

local function getArg(table, name)
  if table["xarg"] == nil then
    return nil 
  else
    return table["xarg"][name]
  end
  
end

local function getLabels(xmlTable,label)
local res = {}

local function findLabel(xmlTable, label)
  local i=1
  local rootTable = xmlTable
  if rootTable ~= nil and type(rootTable) == "table" then
    for k,v in pairs(rootTable) do
      if k =="label" and v == label then 
        table.insert(res, rootTable ) 
       --print("found") 
      end
      if type(k) == "number" then 
        findLabel(rootTable[k], label) 
        --print("findLabel again") 
      end
    end
  end
  
end

findLabel(xmlTable,label)
return res
end

local function getDependencies(manifestFile)
--TODO: change name later
  local res = {}
  local file = io.open(manifestFile, "r")
  if file == nil then
    services:debugMessageBox("MANIFESTPARSER:", "WARNING NO MANIFEST FOR PACAKGE "..manifestFile)
    --print("MANIFESTPARSER WARNING: NO MANIFEST FOR PACAKGE "..manifestFile)
    return nil 
  end
  local TabTaleManifestString = file:read("*all")
  print("manifestParser: reading "..manifestFile)
  local TabTaleManifestTable = collect(TabTaleManifestString)
  --TODO: add validation
  local res1 = getLabels(TabTaleManifestTable, "Dependencies")
  local res2 = getLabels(res1, "Packages")
  local res3 = getLabels(res2, "Package")
  if res3 == nil then return nil end
  for i=1, #res3 do
    if getArg(res3[i], "type") == "behavior" then
      res[i] = {getArg(res3[i], "name") , "behavior"}
    else
      res[i]= {getArg(res3[i],"name"), "normal"}
      --print(res[i])
    end
  end
  
  return res
end   


local function getLuaFileNamesInDir(path)
  local bool = os.execute("cd "..path)
  local luaFiles = {}
  print("the bool is "..tostring(bool))
  if bool == nil then
    services:debugMessageBox("MANIFESTPARSER:", "WARNING PACKAGE IN PATH "..path.." IS MISSING")
    return luaFiles
  else
    local command = "cd "..path.." && ls"
    local f = io.popen(command)
    for mod in f:lines() do
      if string.find(mod, ".lua") ~= nil then
    
      mod = string.gsub(mod, ".lua", "")
    --print(mod)
      table.insert(luaFiles,mod)
      end
    end
    return luaFiles
  end
end

local function isPackageAlreadyAdded(table, name)
  for k,v in pairs(table) do
    if string.lower(v) == string.lower(name) then
      return true
    end
  end
  return false
  
end



function manifestParser.executeRequires(manifest)
  local paths1 = {}
  local paths2 = {}
  local manifestPaths = {}
  local requires = {}
  --exclude the following packages to prevent zerobrane issues
  local packageNames = {"mobdebug", "luasocket", "socket"}
  function buildPaths(manifest)
    local mainDependencies = getDependencies(manifest)
    if mainDependencies == nil or #mainDependencies == 0 then 
      --print("done") 
      return 
    end

    for i=1, #mainDependencies do
      --TODO: define the paths
      paths1[i]= "res/packages/"..mainDependencies[i][1]
      paths2[i] = "res.packages."..mainDependencies[i][1]
      manifestPaths[i] = paths1[i].."/"..mainDependencies[i][1]..".manifest"
      
      
      if isPackageAlreadyAdded(packageNames, mainDependencies[i][1]) == false then
        table.insert(packageNames, mainDependencies[i][1])
        
        --print("manifest path is "..manifestPaths[i])
        --print(paths[i])
        if mainDependencies[i][2] == "normal" then
          luaFilesInDir = getLuaFileNamesInDir(paths1[i])
          for j=1, #luaFilesInDir do
            table.insert(requires, "res.packages."..mainDependencies[i][1].."."..luaFilesInDir[j])
            --print("res/packages/"..mainDependencies[i].."/"..luaFilesInDir[j])
          end
        end
        if manifestParser.requireBehaviors == true and mainDependencies[i][2] == "behavior" then  
           luaFilesInDir = getLuaFileNamesInDir(paths1[i])
          for j=1, #luaFilesInDir do
            table.insert(requires, "res.packages."..mainDependencies[i][1].."."..luaFilesInDir[j])
            --print("res/packages/"..mainDependencies[i].."/"..luaFilesInDir[j])
          end 
        end
        
        buildPaths(manifestPaths[i])
      else
        --package already added
        
      end 
      
    end
  end
  buildPaths(manifest)
  local i= #requires  
  while i>0 do
    --here goes the require itself
    require(requires[i])
    --m_config = getPackageConfig("items")
    print("manifestParser: required ".. requires[i])
    i = i-1
  end
end


 