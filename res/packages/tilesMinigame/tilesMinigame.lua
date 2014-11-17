
--tiles--
tiles = {}
m_persist = persistency:getPackagePersistency("tilesMinigame")
m_config = getPackageConfig("tilesMinigame")

tiles.generatePossitionsPool = function ()
  tiles.possitionsPool = {}
  for i = 1, numberOfTiles
    do
      tiles.possitionsPool[i] = {}
      tiles.possitionsPool[i] = {}
      if (isRandomized == 1) then 
      tiles.possitionsPool[i].x = math.random (25, 75) 
    else 
      local randomPos = math.random (1, 100) 
      randomPos = math.random (1, 3) 
      if (randomPos == 1) then tiles.possitionsPool[i].x = 25 elseif (randomPos == 2) then tiles.possitionsPool[i].x = 50 elseif (randomPos == 3) then tiles.possitionsPool[i].x = 75 end
      end
    end
end

tiles.generateTwinsPossitionsPool = function ()
  tiles.twinsPossitionsPool = {}
    for i = 1, numberOfTiles
      do
        tiles.twinsPossitionsPool[i] = {}
        if (tiles.possitionsPool[i].x >= 50) then
          tiles.twinsPossitionsPool[i].x = tiles.possitionsPool[i].x - 25
          else tiles.twinsPossitionsPool[i].x = tiles.possitionsPool[i].x + 25
        end
      end
end

tiles.getCurrentDifficulty = function ()
      local currDiff = m_persist:getValue("levelOfDifficulty")
      if (currDiff == nil or currDiff < 1) then 
        currDiff = 1 
        local tempVal = m_persist:setValue("levelOfDifficulty", currDiff)
      end
      
      return currDiff
    end

tiles.increaseDifficulty = function ()
        local currDiffVal = tiles.getCurrentDifficulty ()
          if (currDiffVal + 1 < 31) then
           currDiffVal = currDiffVal + 1
          end
        local tempVal = m_persist:setValue("levelOfDifficulty", currDiffVal)
    end

tiles.setDifficulty = function (level)
        currDiffVal = level
        local tempVal = m_persist:setValue("levelOfDifficulty", currDiffVal)
        local tempVal2 = m_persist:setValue("levelPlayedCount1", 0)
        local tempVal3 = m_persist:setValue("levelPlayedCount2", 0)
        local tempVal4 = m_persist:setValue("levelPlayedCount3", 0)
        local tempVal5 = m_persist:setValue("levelPlayedCount4", 0)
        local tempVal6 = m_persist:setValue("levelPlayedCount5", 0)
        local tempVal7 = m_persist:setValue("levelPlayedCount6", 0)
        local tempVal8 = m_persist:setValue("levelPlayedCount7", 0)
        local tempVal9 = m_persist:setValue("levelPlayedCount8", 0)
        local tempVal10 = m_persist:setValue("levelPlayedCount9", 0)
        local tempVal11 = m_persist:setValue("levelPlayedCount10", 0)
        local tempVal12 = m_persist:setValue("levelPlayedCount11", 0)
        local tempVal13 = m_persist:setValue("levelPlayedCount12", 0)
        local tempVal14 = m_persist:setValue("levelPlayedCount13", 0)
        local tempVal15 = m_persist:setValue("levelPlayedCount14", 0)
        local tempVal16 = m_persist:setValue("levelPlayedCount15", 0)
        local tempVal17 = m_persist:setValue("levelPlayedCount16", 0)
        local tempVal18 = m_persist:setValue("levelPlayedCount17", 0)
        local tempVal19 = m_persist:setValue("levelPlayedCount18", 0)
        local tempVal20 = m_persist:setValue("levelPlayedCount19", 0)
        local tempVal21 = m_persist:setValue("levelPlayedCount20", 0)
        local tempVal22 = m_persist:setValue("levelPlayedCount21", 0)
        local tempVal23 = m_persist:setValue("levelPlayedCount22", 0)
        local tempVal24 = m_persist:setValue("levelPlayedCount23", 0)
        local tempVal25 = m_persist:setValue("levelPlayedCount24", 0)
        local tempVal26 = m_persist:setValue("levelPlayedCount25", 0)
    end

tiles.resetDifficulty = function ()
        local tempVal = m_persist:setValue("levelOfDifficulty", 1)
    end

tiles.nextLevelIsRelayMode = function ()
        local isRelay = m_config.levels["level"..tiles.getCurrentDifficulty ()].isRelayMode
  
      return isRelay
    end

tiles.initiateRelayLevel = function (levelNumber, isRandom)
  
    math.randomseed (os.time())
    math.randomseed (os.time())
    math.randomseed (os.time())
    math.randomseed (os.time())
    local sceneName = "level"..tostring(tiles.getCurrentDifficulty ())
    print ("Level initiation started for: "..sceneName)
    tileMovementSpeed  = m_config.levels[sceneName].tileMovementSpeed--will update with dynamic value from gameconfig--
    tileDistance  = m_config.levels[sceneName].tileDistance --will update with dynamic value from gameconfig--
    numberOfTiles = m_config.levels[sceneName].numberOfTiles  --will update with dynamic value from gameconfig--
    numberOfPowerUps = m_config.levels[sceneName].numberOfJetPacks  --will update with dynamic value from gameconfig--
    numberOfObstacles = m_config.levels[sceneName].numberOfBrokenTiles --will update with dynamic value from gameconfig--
    numberOfFadeOutTiles = m_config.levels[sceneName].numberOfFadeOutTiles --will update with dynamic value from gameconfig--
    numberOfTimerTiles = m_config.levels[sceneName].numberOfTimerTiles --will update with dynamic value from gameconfig--
    timeLimit = m_config.levels[sceneName].timeLimit --will update with dynamic value from gameconfig--
    fadeInTime = m_config.levels[sceneName].fadeInTime --will update with dynamic value from gameconfig--
    fadeOutTime = m_config.levels[sceneName].fadeOutTime --will update with dynamic value from gameconfig--
    isRandomized = m_config.levels[sceneName].isRandomized
    -- movementSpeed = 1 not used in relay mode--
    currentSequence = 1
    tiles.tilesPool = {}
    tiles.twinsPool = {}
    tiles.generatePossitionsPool ()
    tiles.generateTwinsPossitionsPool ()
    print ("Tiles Possitions initiation started... ")
        for i = 1, numberOfTiles do   --generating tiles possitions
          tiles.tilesPool[i] = tiles.getItemPossitions (i)
          tiles.twinsPool[i] = tiles.getTwinPossitions (i)
        end
    tiles.generatePowerUps ()
    tiles.generateObstacles ()
    tiles.generateFadeOutTiles ()
    tiles.generateTimerTiles ()
    tiles.usedPowerUpCount = 0
    end

    tiles.nextStep = function ()
     currentSequence = currentSequence + 1
    print ("increasedStep to: "..currentSequence)
    end
    
    tiles.increaseSteps = function (numberOfSteps)
     currentSequence = currentSequence + numberOfSteps
    end
    
    tiles.setStep = function (itemId)
     currentSequence = itemId
    end
    
    tiles.setFadeOutUsedUp = function (itemId)
     tiles.tilesPool[itemId].isFadeOutTileUsedUp = false
    end
    
    tiles.setTileActivated = function (itemId)
     tiles.tilesPool[itemId].isActivated = true
    end
    
    tiles.decreaseSteps = function ()
    print("inside decreaseSteps")
     currentSequence = currentSequence - 1
    end
    
    tiles.checkCorrectStep = function (itemId)
     if (itemId == currentSequence) then return 1 else return 0 end
    end

    tiles.getCurrentStep = function ()
     return currentSequence
    end
    
    tiles.getTimeLimit = function ()
     return timeLimit
    end
    
    tiles.getCurrentTwin = function ()
      local sequenceNo = currentSequence - 1
      local twinId = tostring("helper"..sequenceNo)
     return twinId
    end
    
    tiles.getCurrentTile = function ()
      local sequenceNo = currentSequence - 1
      sequenceNo = tostring(sequenceNo)
     return sequenceNo
    end
    
    
    tiles.getItemPossitions = function (itemId)
      local randomIndex = math.random (1, #tiles.possitionsPool)
      local posX = tiles.possitionsPool[randomIndex].x
      local posY = itemId * tileDistance
      local result = {}
      result.x = posX
      result.y = posY
      randomTwinIndex = randomIndex
      table.remove (tiles.possitionsPool, randomIndex)
      return result
    end

    tiles.getTwinPossitions = function (itemId)
      local posX = tiles.twinsPossitionsPool[randomTwinIndex].x
      local posY = itemId * tileDistance
      local result = {}
      result.x = posX
      result.y = posY
      table.remove (tiles.twinsPossitionsPool, randomTwinIndex)
      return result
    end

    tiles.isFadeOutTile = function (itemId)
    if (tiles.tilesPool[itemId].isFadeOutTile ~= nil) then return 1 else return 0 end
    end

    tiles.isFadeOutTileUsedUp = function (itemId)
    if (tiles.tilesPool[itemId].isFadeOutTileUsedUp ~= nil and tiles.tilesPool[itemId].isFadeOutTileUsedUp == true) then return 1 else return 0 end
    end

    tiles.isObstacle = function (itemId)
    if (tiles.tilesPool[itemId].isObstacle ~= nil) then return 1 else return 0 end
    end

    tiles.isClearTile = function (itemId)
    if (tiles.tilesPool[itemId].isObstacle ~= true and tiles.tilesPool[itemId].isPowerUp ~= true and tiles.tilesPool[itemId].isFadeOutTile ~= true and tiles.tilesPool[itemId].isTimerTile ~= true) then return 1 else return 0     end
    end

    tiles.isPowerUp = function (itemId)
      if (tiles.tilesPool[itemId].isPowerUp ~= nil) then return 1 else return 0 end
    end

    tiles.isActivated = function (itemId)
    print ("insideIsActivated")
      if (tiles.tilesPool[itemId].isActivated == true) then return 0 else return 1 end
    end

    tiles.isTimerTile = function (itemId)
      if (tiles.tilesPool[itemId].isTimerTile ~= nil) then return 1 else return 0 end
    end

    tiles.shouldTileRelay = function (itemId)
      if (currentSequence > itemId - 2) then return 1 else return 0 end
    end

    tiles.getTileRelayPosition = function (itemId)
      if (itemId == currentSequence) then return 60 elseif 
          (itemId == currentSequence - 1) then return 30 elseif
           (itemId == currentSequence - 2) then return 00 elseif
            (itemId == currentSequence + 1) then return 90 elseif
              (itemId == currentSequence + 2) then return 120 end

    end

    tiles.shouldGlideRelay = function (itemId)
      if (currentSequence > itemId - 1) then return 1 else return 0 end
    end

    tiles.generateObstacles = function ()
      local obstacleLimit = numberOfTiles - 2
      local i = 1
      if (numberOfObstacles > 0) then
        while (i <= numberOfObstacles) do
          local randomIndex = math.random (2, obstacleLimit)
          local neighbour = randomIndex - 10
          if (tiles.tilesPool[neighbour] ~= nil and tiles.tilesPool[neighbour].isPowerUp ~= true) then
          if (tiles.tilesPool[randomIndex] ~= nil and tiles.tilesPool[randomIndex].isObstacle ~= true and tiles.tilesPool[randomIndex].isPowerUp ~= true) then tiles.tilesPool[randomIndex].isObstacle = true i = i + 1
            end
           end
        end
      end
    end
    
    tiles.generatePowerUps = function ()
      local powerUpLimit = numberOfTiles - 11
      local i = 1
      if (numberOfPowerUps > 0) then
        while (i <= numberOfPowerUps) do
          local randomIndex = math.random (5, powerUpLimit)
          local neighbour = randomIndex + 10
          local neighbour2 = randomIndex - 10
          if (tiles.tilesPool[randomIndex].isPowerUp ~= true) then 
            if (tiles.tilesPool[neighbour] ~= nil and tiles.tilesPool[neighbour].isPowerUp ~= true and tiles.tilesPool[neighbour2] ~= nil and tiles.tilesPool[neighbour2].isPowerUp ~= true) then tiles.tilesPool[randomIndex].isPowerUp = true i = i + 1
            end
            end
           end
        end
    end
    tiles.generateFadeOutTiles = function ()
      local fadeOutLimit = numberOfTiles - 3
      local i = 1
      if (numberOfFadeOutTiles > 0) then
        while (i <= numberOfFadeOutTiles) do
          local randomIndex = math.random (2, fadeOutLimit)
          local neighbour = randomIndex - 1
          local neighbour2 = randomIndex + 1
          local neighbour3 = randomIndex - 10
          if (tiles.tilesPool[randomIndex].isObstacle ~= true and tiles.tilesPool[neighbour].isObstacle ~= true and tiles.tilesPool[randomIndex].isPowerUp ~= true and tiles.tilesPool[randomIndex].isFadeOutTile ~= true ) 
          then if (tiles.tilesPool[neighbour] ~= nil and tiles.tilesPool[neighbour].isFadeOutTile ~= true and tiles.tilesPool[neighbour2] ~= nil and tiles.tilesPool[neighbour2].isFadeOutTile ~= true and tiles.tilesPool[neighbour2].isObstacle ~= true and tiles.tilesPool[neighbour3] ~= nil and tiles.tilesPool[neighbour3].isPowerUp ~= true) 
            then           
            tiles.tilesPool[randomIndex].isFadeOutTile = true tiles.tilesPool[randomIndex].isFadeOutTileUsedUp = true  i = i + 1
            end
           end
           end
        end
    end
    
    tiles.generateTimerTiles = function ()
      local timersLimit = numberOfTiles - 1
      local i = 1
      if (numberOfTimerTiles > 0) then
        while (i <= numberOfTimerTiles) do
          local randomIndex = math.random (2, timersLimit)
          local neighbour3 = randomIndex - 10
          if (tiles.tilesPool[randomIndex].isObstacle ~= true and tiles.tilesPool[randomIndex].isPowerUp ~= true and tiles.tilesPool[randomIndex].isFadeOutTile ~= true and tiles.tilesPool[randomIndex].isTimerTile ~= true)
          then if (tiles.tilesPool[neighbour3] ~= nil and tiles.tilesPool[neighbour3].isPowerUp ~= true) then 
            tiles.tilesPool[randomIndex].isTimerTile = true i = i + 1
            end
           end
         end
        end
    end
    
    tiles.getItemX = function (itemId)
      return tiles.tilesPool[itemId].x
    end
    
    tiles.getTwinX = function (itemId)
      return tiles.twinsPool[itemId].x
    end
    
    tiles.getNumberOfItems = function ()
      return numberOfTiles
    end

    tiles.getClosestInactiveItem = function ()
      for i = 1, numberOfTiles
      do
        if (tiles.tilesPool[i].isActivated ~= true) then
          print ("Closest inactive itemId: "..i) return i
        end
      end
    end


    tiles.getRandomNumberSprite = function (a, b)
     local tempVal = math.random (1, 100) 
     tempVal = math.random (1, 100) 
     tempVal = math.random (1, 2) 
      if (tempVal == 1) then return a else return b end
    end
    
    tiles.getCurrentDate = function ()
      return tostring(os.date("%d"))
    end

    
    tiles.getCurrentLevelPlayedCount = function ()
          local currLevelPlayedCount = m_persist:getValue("levelPlayedCount"..tiles.getCurrentDifficulty ())
          if (currLevelPlayedCount == nil or currLevelPlayedCount < 1) then 
            currLevelPlayedCount = 0
          end
          
          return currLevelPlayedCount
        end

    tiles.increaseCurrentLevelPlayedCount = function ()
            local currLevelPlayedCount = tiles.getCurrentLevelPlayedCount ()
               currLevelPlayedCount = currLevelPlayedCount + 1
            local tempVal = m_persist:setValue("levelPlayedCount"..tiles.getCurrentDifficulty (), currLevelPlayedCount)
        end
        
    tiles.countUsedPowerUps = function ()
      tiles.usedPowerUpCount = tiles.usedPowerUpCount + 1
    end
    
    tiles.getUsedPowerUpBool = function ()
      return tiles.usedPowerUpCount
    end
    
    tiles.getCompletedPercentage = function ()
      local completedPercentage = ((100 / tiles.getNumberOfItems ()) * tiles.getCurrentStep ())
      return completedPercentage
    end
          tiles.initiateRelayLevel (1)

    
      tiles.initiateRelayLevel (1)
      print (tiles.tilesPool[1].x, tiles.tilesPool[1].y)
      print (tiles.tilesPool[2].x, tiles.tilesPool[2].y)
      print (tiles.getItemX(1))
      print (tiles.isPowerUp(19))
