--main.lua

    require "luaTester.luaTesterExtensions.luaTesterExtensions"
    
    --TODO: write your test code here!

    
  
      tiles.initiateRelayLevel (2, 0)
      print (tiles.getItemX(2))
      print (tiles.getTwinX(2))
      print (tiles.getItemX(3))
      print (tiles.getTwinX(3))
      print (tiles.isClearTile(10))
      print (tiles.isObstacle(10))
      print (tiles.isPowerUp(10))
      print (tiles.isTimerTile(10))
      print (tiles.isFadeOutTile(10))
      print ("tile.touched"..5 - 1)
      print (tiles.nextLevelIsRelayMode ())
      
      
     -- print (tiles.isObstacle(19))
     -- print (tiles.isObstacle(20))
     -- print (tiles.isObstacle(21))
     -- print (tiles.isObstacle(22))
     -- print (tiles.isPowerUp(23))
     -- print (tiles.nextStep())
     -- print (tiles.getCurrentTwin())
     -- print (tiles.nextStep())
     -- print (tiles.nextStep())
     -- print (tiles.getCurrentTwin())
     -- print (tiles.getCurrentTile())
--  print ("