--- A MapBehavior module responsible of the map behavior
-- @module MapBehavior
return function(self)

    print("In MapBehavior Constructor")

	self.property{name = "mapMode", initial = "normal"}
	self.property{name = "swipeMode", initial = "normal"}
	self.property{name = "locations", initial = "a"}

	self.currentPoint = 1
	self.isSwipe = false

	self.currentScreen = 1
  self.lastPositions  = 0
  self.isLandscape = vars:getFloatVar("isLandscape")



----------------------------------------
-- Private functions -------------------
----------------------------------------

	--- Private function: convert percentage to screen pixels
	-- @function prcTo_w
	-- @param w
	-- @return screen pixels width
    local function prcTo_w(w)
      if self.isLandscape == 1 then
        return w*(1024/100)
      else
        return w*(768/100)
      end
    end

  --- Private function: convert percentage to screen pixels
	-- @function prcTo_h
	-- @param h
	-- @return screen pixels height
    local function prcTo_h(h)
      if self.isLandscape == 1 then
        return h*(768/100)
      else
        return h*(1024/100)
      end
    end

  --- Private function: convert width to screen percentage
	-- @function w_toPrc
	-- @param w
	-- @return percentage of w
    local function w_toPrc(w)
      if self.isLandscape == 1 then
        return w/1024
      else
        return w/768
      end
    end
  --- Private function: convert height to screen percentage
	-- @function h_toPrc
	-- @param h
	-- @return percentage of h
    local function h_toPrc(h)
      if self.isLandscape == 1 then
        return h/768
      else
        return h/1024
      end
    end
  --- Private function: convert percentage width to screen pixesls
	-- @function prcToLocX
	-- @param x
	-- @return secreen pixels of x
    local function prcToLocX(x)
      if self.isLandscape == 1 then
        return x*(100/1024)
      else
        return x*(100/768)
      end
    end
  --- Private function: convert percentage height to screen pixesls
	-- @function prcToLocX
	-- @param y
	-- @return percentage of y
    local function prcToLocY(y)
      if self.isLandscape == 1 then
        return y*(100/768)
      else
        return y*(100/1024)
      end
    end

	--- Private function: calculate the closest point (from the set of points defined in self.locations.values) to the center of the screen.
	-- @function getClosestPoint
	-- @param x
	-- @param y
	-- @return the closest point index.
	local getClosestPoint = function(x,y)
		print("===calculateClosestPoint to point: x ,y ",x,y)
		local minDistance = math.huge
		local closestPointIndex = 0
		for i=1, #self.locations.values do
			local point = self.locations.values[i].bound
			local distance = math.sqrt(math.pow((x-prcToLocX(((point.x+(point.w/2))),2))) + math.pow((y-prcToLocY(((point.y+(point.h/2))),2))))
			if (distance <= minDistance) then
				minDistance = distance
				closestPointIndex = i
			end
		end
		return closestPointIndex
	end

	--- Private function: calculate the closest point (from the set of ponts defined in self.locations.values) when all the points have the same y value.
	-- @function getSwipeClosestPoint
	-- @param x
	-- @param y
	-- @return the closest point index.
	local getSwipeClosestPoint = function(x,y)
		local minDistance = math.huge
		local closestPointIndex = 0
		for i=1, #self.locations.values do
			local point = self.locations.values[i].bound
			local distance = math.abs(x-prcToLocX(point.x))
			if (distance <= minDistance) then
				minDistance = distance
				closestPointIndex = i
			end
		end
		return closestPointIndex
	end

	--- Private function: calculate the closest point (from the set of ponts defined in self.locations.values) according to the direction of the swipe.
	-- @function getClosestPointByDirection
	-- @param direction
	-- @param startPointX
	-- @param startPointY
	-- @param a
	-- @param b
	-- @param c
	-- @return the closest point index.
	local getClosestPointByDirection = function(direction,startPointX,startPointY,a,b,c)
		local minDistance = math.huge
		local closestPointIndex = 0
		for i=1, #self.locations.values do
			local point = self.locations.values[i].bound
			local pointDirection = getDirection(startPointX,startPointY, point.x,point.y)
			print("=== point direction: ",self.locations.values[i].id,pointDirection)
			if(pointDirection == direction) then
				local distance = getPointDistanceFromLine(a,b,c,(point.x+(point.w/2)),(point.y+(point.h/2)))
				print("point Direction: ",self.locations.values[i].id,pointDirection, distance)
				if (distance <= minDistance) then
					minDistance = distance
					closestPointIndex = i
				end
			end
		end
		return closestPointIndex
	end

	--- Private function: calculate the offset of x and y according to the velocity.
	-- @function calculateMovingBy
	-- @param velocityX
	-- @param velocityY
	-- @param x1
	-- @param y1
	-- @param x2
	-- @param y2
	-- @return a point with x and y values which represents the offsets.
	local calculateMovingBy = function(velocityX, velocityY, x1, y1, x2, y2)
		local c1 = math.sqrt(math.pow((x2-x1),2) + math.pow((y2-y1),2)) + 1
		local c2 = 50 * math.max(math.pow(velocityX/1000,2) , math.pow(velocityY/1000,2))
		local ratio = c2/c1
		local point = {}
		point.x = (x2-x1)*ratio
		point.y = (y2-y1)*ratio
		return point
	end

	--- Private function: get the direction of the swipe (rightUp/rightDown/leftUp/leftDown).
	-- @function getDirection
	-- @param startPointX
	-- @param startPointY
	-- @param endPointX
	-- @param endPointY
	-- @return the direction.
	local getDirection = function(startPointX,startPointY, endPointX, endPointY)
		if ((endPointX>startPointX) and (endPointY>startPointY)) then
			return "rightUp"
		elseif((endPointX>startPointX) and (endPointY<startPointY)) then
			return "rightDown"
		elseif((endPointX<startPointX) and (endPointY>startPointY)) then
			return "leftUp"
		elseif((endPointX<startPointX) and (endPointY<startPointY)) then
			return "leftDown"
		elseif((endPointX<startPointX) and (endPointY==startPointY)) then
			return "leftDown"
		elseif((endPointX>startPointX) and (endPointY==startPointY)) then
			return "rightDown"
		elseif((endPointX==startPointX) and (endPointY>startPointY)) then
			return "rightUp"
		elseif((endPointX==startPointX) and (endPointY<startPointY)) then
			return "rightDown"
		end
	end

	--- Private function: get the angle of a line.
	-- @function getAngleOfLineBetweenTwoPoints
	-- @param p1X
	-- @param p1Y
	-- @param p2X
	-- @param p2Y
	-- @return the angle.
	local getAngleOfLineBetweenTwoPoints = function(p1X, p1Y, p2X, p2Y)
		local xDiff = p2X - p1X
		local yDiff = p2Y - p1Y
		local angle = math.deg(math.atan2(yDiff, xDiff))
		return angle
	end


	--- Private function: get the direction of the swipe (right/left) - does not include up or down movements.
	-- @function getDirection
	-- @param startPointX
	-- @param startPointY
	-- @param endPointX
	-- @param endPointY
	-- @return the direction.
	local getSwipeDirection = function(startPointX,startPointY, endPointX, endPointY)
		print("angle: ",getAngleOfLineBetweenTwoPoints(startPointX,startPointY, endPointX, endPointY))
		local angle = getAngleOfLineBetweenTwoPoints(startPointX,startPointY, endPointX, endPointY)
		if ((angle >= -45) and (angle <= 45)) then
			return "right"
		elseif(((angle >= 135) and (angle <= 180)) or ((angle >= -180) and (angle <= -135))) then
			return "left"
		end
	end

	--- Private function: get the distance of the given point from the line with the coefficient a,b,c.
	-- @function getPointDistanceFromLine
	-- @param a
	-- @param b
	-- @param c
	-- @param xPoint
	-- @param yPoint
	-- @return the distance.
	local getPointDistanceFromLine = function(a,b,c,xPoint,yPoint)
		return (math.abs(a*xPoint + b*yPoint + c))/math.sqrt(math.pow(a,2) + math.pow(b,2))
	end

	--- Private function: move the screen to a bounding box that is defined in self.locations.values[index].
	-- @function moveToBoundingBox
	-- @param index
	-- @param duration
	local moveToBoundingBox = function(index,duration, flag)
		self.currentScreen = index
		local scale = self._behaviorTarget:getScale()
		local pos = self._behaviorTarget:getPosition()
		print("POSSSSS : ",pos.x, pos.y)
		print("the scale is: "..scale)
		self.currentPoint = index
		if ((self.mapMode == "target") and (self.swipeMode == "normal")) then
			local xPix = self.locations.values[index].bound.x
			local yPix = self.locations.values[index].bound.y
      self._behaviorTarget:setPosition(pos.x,0)
      self._behaviorTarget:moveTo(duration,prcToLocX(-xPix)*scale, prcToLocY(-yPix)*scale)
		else
			local xPix = self.locations.values[index].bound.x - (self.locations.values[index].bound.w/2)
			local yPix = self.locations.values[index].bound.y - (self.locations.values[index].bound.h/2)
			local scale = 1/h_toPrc(self.locations.values[index].bound.h)
			self._behaviorTarget:setPosition(pos.x,0)
			self._behaviorTarget:moveTo(duration,prcToLocX(-xPix)*scale, prcToLocY(-yPix)*scale)
			self._behaviorTarget:setScale(scale)
		end
	end

	local normalizedMapToPixels = function(p)
		local point = {}
		point.x = prcTo_w(p.x)
		point.y = prcTo_h(p.y)
		return point
	end

	local pixelsToNormalizedMap = function(p)
		local point = {}
		point.x = prcToLocX(p.x)
		point.y = prcToLocY(p.y)
		return point
	end

	--set the values to be: 0-100 according to the scale (represents the screen)
	local screenToNormalizedMap = function(p)
		local pos = self._behaviorTarget:getPosition()
		local scale = self._behaviorTarget:getScale()
		print("MAP POS:", pos.x, pos.y)
		local point = {}
		point.x = p.x-(pos.x/scale)
		point.y = p.y-(pos.y/scale)
		print("point after normalization: ",point.x,point.y)
		return point
	end

	local screenToPixels = function(p)
		local pos = self._behaviorTarget:getPosition()
		local scale = self._behaviorTarget:getScale()
		local point = {}
		point.x = (prcTo_w((p.x-pos.x)))/scale
		point.y = (prcTo_h((p.y-pos.y)))/scale
		return point
	end

	local pixelsToScreen = function(p)
		local pos = self._behaviorTarget:getPosition()
		local scale = self._behaviorTarget:getScale()
		local point = {}
		point.x = (prcToLocX(p.x))*scale+pos.x
		point.y = (prcToLocY(p.y))*scale+pos.y
		return point
	end
----------------------------------------
-- Public functions -------------------
----------------------------------------
	self.init = function()
		print("MapBehavior init1", self.isLandscape)
        --mobdebug.startDebug()

	end

	self.update = function()
		print("MapBehavior Update.")
        local pos = self._behaviorTarget:getPosition()
        print("position is: "..tostring(pos.x).." , "..tostring(pos.y))
    end

    self.gestureStarted = function(type)
        if (type == "pan") then
            local pos = self._behaviorTarget:getPosition()
			print("MapBehavior::gestureStarted - "..type.." , and original position is: "..tostring(pos.x).." , "..tostring(pos.y))
        elseif (type =="pinch") then
            self._startedScale = self._behaviorTarget:getScale()
			print("MapBehavior::gestureStarted - "..type.." , and original scale is: "..tostring(self._startedScale))
        end
    end

	self.gestureEnded = function(type)
        local scale = self._behaviorTarget:getScale()


        if scale < 0.55 then

            self._behaviorTarget:setPosition(-25,-25)
            self._behaviorTarget:setScale(0.5)

            pos = self._behaviorTarget:getPosition()
            print("position is: "..tostring(pos.x).." , "..tostring(pos.y))

        end
        return true
    end




    return self

end