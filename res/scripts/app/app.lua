--hidden objects--
    hiddenObj = {}

  --------------The initialization of the valid objects----------------------------

  hiddenObj.initHiddenObjects = function(gameObjectsCount, targetObjectsCount)
    math.randomseed (os.time())
    validPool = {}
    validObjects = {}
    validRemainigObjects = {}
    gameObjectsImages = {}
    objectsForGeneration = {}

    for i = 1, gameObjectsCount do
      objectsForGeneration[i] = i
    end

    howManyToRemove = gameObjectsCount - targetObjectsCount

    for i = 1, howManyToRemove do
      local randomItem = math.random (1, #objectsForGeneration)
      print ("Removing value .."..randomItem)
      table.remove (objectsForGeneration, randomItem)
    end
    validRemainigObjects = objectsForGeneration
  end
  --------------------------------------------------------------------------------


  ----------- Adding of an object's possitions to the pool for thrown objects ----

  hiddenObj.addPoint = function (x,y)
  print ("Adding the point: "..x.." "..y)
  tempPoint = {}
  tempPoint.x = x
  tempPoint.y = y
  table.insert (validPool, tempPoint)
  end
  --------------------------------------------------------------------------------

  --Get function for getting posX and posY from the pool that we added possitions-

  hiddenObj.getOneItemPossitions = function ()
  print ("Getting one item's pos from the pool...")
  whatItemIndex = math.random (1, #validPool)
  whatItem = validPool[whatItemIndex]
  for i, v in ipairs (validPool) do
    if (v.x == whatItem.x and v.y == whatItem.y) then table.remove (validPool, i)
    end
  end
  whatItemX = whatItem.x
  whatItemY = whatItem.y

  print ("The item has X: "..whatItemX.." Y: "..whatItemY)
  return whatItem.x, whatItem.y
  end

  --------------------------------------------------------------------------------

  ------------ Get function for getting a number of a valid object thrown --------

  hiddenObj.getValidObject = function ()
  
  local theValidObjectIndex = math.random (1, #validRemainigObjects)
  local tempValidObject = validRemainigObjects[theValidObjectIndex]
  table.remove (validRemainigObjects, theValidObjectIndex)
  print ("Getting one valid object from pool..."..tempValidObject)
  return tempValidObject
  end

  --------------------------------------------------------------------------------

  -------------------- Initialization of valid objects ---------------------------

  hiddenObj.generateObjects = function ()
  for i = 1, 10 do
    local randomItem = math.random (1, #objectsForGeneration)
    print ("Removing value .."..randomItem)
    table.remove (objectsForGeneration, randomItem)
  end
  end
  --------------------------------------------------------------------------------


  ---------Bool for checking valid objects----------------------------------------

  hiddenObj.isThisAValidObject = function (index)
  for i, v in ipairs (objectsForGeneration) do
    if (index == v) then print ("This item: "..index.." is valid item.") return 1
    end
  end
  print ("This item: "..index.."  is not a valid item") return 0
  end



  --- Below this line are unneded functions, keeping for refference purposes only --

    --------------------------------------------------------------------------------
  hiddenObj.getRandomPoint = function ()
  print ("Getting a random point")
  theNumberIndex = math.random (1, #pointsArray)
  return pointsArray[theNumberIndex]
  end
  --------------------------------------------------------------------------------

  hiddenObj.printSet = function (s)
  print ("Number of items in set: "..#s)
  for i, v in ipairs (s) do
    print (v)
  end
  end
  --------------------------------------------------------------------------------
  hiddenObj.getOneItemPosX = function ()
  whatItemIndex = math.random (1, #validPool)
  whatItem = validPool[whatItemIndex]
  for i, v in ipairs (validPool) do
    if (v.x == whatItem.x and v.y == whatItem.y) then table.remove (validPool, i)
    end
  end
  print ("Getting one item's X pos from the pool... "..whatItemX)
  whatItemX = whatItem.x
  whatItemY = whatItem.y
  return whatItemX
  end
  ----------------------------------------------------------------------------------
  hiddenObj.getOneItemPosY = function ()
  print ("Getting one item's Y from the pool... "..whatItemY)
  return whatItemY
  end
  -------------------code for hint randomization------------------------------------
  remainingObjects = {}
  testVar=0
  
  hiddenObj.setValidObjects = function (x)
	remainingObjects = x
	testVar = remainingObjects[1]
  end
  ----------------------------------------------------------------------------------
  hiddenObj.removeFoundObjects = function (foundObj)
	listLenght = #remainingObjects
	for i=1,listLenght do
		if remainingObjects[i]==foundObj then
			table.remove(remainingObjects, i)
		end
	end
  end
  ----------------------------------------------------------------------------------
  hiddenObj.randomHint = function ()
	listLenght = #remainingObjects
	math.randomseed (os.time())
	math.random()
	math.random()
	math.random()
	hintNum = remainingObjects[math.random(1,listLenght)]
	return hintNum
  end
  ------------------Randomization for locks scene-----------------------------------

    t = {}    
    p = {}
    app = {}
    --create the array of n integers
    app.createRegularArray = function(n)
            for i = 1, n do
           t[i] = i
        end
     end    
     app.createRegularArrayLock = function(n)
            for i = 1, n do
           p[i] = i
        end
     end

    --randomize the elements of the array (invoke once at the begining)
    app.createRandomArray = function(n)
        math.randomseed (os.time())
        math.random()
        math.random()
        math.random()
        
        app.createRegularArray(n)

        for i = 1, n do
           j = math.random(i, n)
           t[i], t[j] = t[j], t[i]
        end
    end

    --return the elements of the array (each time different element)
    app.returnRandom = function(x)
       return t[x]
    end    

        --randomize the elements of the array (invoke once at the begining)
    app.createRandomArrayLock = function(n)
        math.randomseed (os.time())
        math.random()
        math.random()
        math.random()
        math.random()
        math.random()
        
        app.createRegularArrayLock(n)

        for i = 1, n do
           j = math.random(i, n)
           p[i], p[j] = p[j], p[i]
        end
    end

    app.returnRandomLock = function(x)
       return p[x]
    end 

    app.getLockPositionX = function(id)
     return "lock0"..tostring(id).."@X" 
    end

    app.getLockPositionY = function(id)
     return "lock0"..tostring(id).."@Y" 
    end

    app.sceneEntered = function (sceneName)
      enteredScene = sceneName
    end
    
    app.getEnteredScene = function ()
      return enteredScene 
    end
    
    app.setSceneFinished = function ()
      local sceneString = app.getEnteredScene ()
      vars:setVar(sceneString, 1)
      print ("var setting passed, set value to: "..sceneString.." = 1")
    end

--isAndroid
srvc = {}

srvc.isAndroid = function()
    print("srvc.isAndroid "..tostring(isAndroid).."")
    return (isAndroid == 1)
end