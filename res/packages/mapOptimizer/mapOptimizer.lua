return function(self)
        print("hello2222")
        self.positions={}
        for i=1,10 do
            self.positions[i]=50
        end
        self.positions.counter = 0
        self.layersToUnload = {}
        self.layerNamesToUnload = {}
        self.layerNamesToLoad = {}
        for i=4,10 do
            self.layersToUnload[i]=true
            self.layerNamesToUnload[i-3]="map"..tostring(i)
        end
        for i=1,3 do
            self.layersToUnload[i]=false
            self.layerNamesToLoad[i] = "map"..tostring(i)
        end
        self.lastLayersLoaded = {}
        self.lastLayersLoaded[1]=1
        self.lastLayersLoaded[2]=2
		self.lastLayersLoaded[3]=3
        self.maxFramesOnLoading = 4 -- the number of the last 4 positions of the layer (if all 4 are identical the layer is static)
        self.movingDirection = 1  -- (1 = right), (-1 = left or static)


        self.init = function()
            self.pos = self._behaviorTarget:getPositionInMainLayer()
        end

        self.printMapPosition = function()
            self.pos = self._behaviorTarget:getPositionInMainLayer()
            print("Map position is "..tostring(self.pos.x).." "..tostring(self.pos.y))
        end

        self.updatePositions = function()
            if (self.positions.counter < self.maxFramesOnLoading) then
                self.positions.counter = self.positions.counter + 1
            else
                self.positions.counter = 1
            end
            self.pos = self._behaviorTarget:getPositionInMainLayer()
			print("POSITION X , Y: ",self.pos.x, self.pos.y)
            self.positions[self.positions.counter] = self.pos.x
            if (self.getMovingDirection() ~= 0) then
                self.movingDirection = self.getMovingDirection()
            end
        end

        self.getMovingDirection = function()
            if (self.positions.counter >= 2) then
                print("mapOptimizer: direction1 "..tostring(self.positions[self.positions.counter] - self.positions[self.positions.counter-1]))
                if ((self.positions[self.positions.counter] - self.positions[self.positions.counter-1]) > 0) then
					return 1
                else
                    if ((self.positions[self.positions.counter] - self.positions[self.positions.counter-1]) == 0) then
						return 0
					end
                    return -1
                end
            else
				print("mapOptimizer: direction2 "..tostring(self.positions[1] - self.positions[self.maxFramesOnLoading]))
                if ((self.positions[1] - self.positions[self.maxFramesOnLoading]) > 0) then
                    return 1
                else
					if ((self.positions[1] - self.positions[self.maxFramesOnLoading]) == 0) then
						return 0
					end
                    return -1
                end
            end
        end

        self.isStatic = function()
            local currentPos = self.positions[1]
            for i=2,self.maxFramesOnLoading do
                if currentPos ~= self.positions[i] then
                    return false
                end
            end
            print("mapOptimizer: map is static")
            return true
        end

        self.setLayersToUnload = function(k,j, l)
            --exclude k,j layers
            for i =1, 10 do
                if i~=k and i~=j and i~=l then
                    self.layersToUnload[i] = true
                else
                    self.layersToUnload[i] = false
                end
            end
        end

        self.setLayersToLoad = function(k,j,l)
            self.layersToUnload[k] = false
            self.layersToUnload[j] = false
            self.layersToUnload[l] = false
        end

        self.getLayersToLoad = function(pos)
            local delta = 50 - pos
            local mod = math.floor(delta / 100)
            if self.movingDirection ==  1 then
                print("mapOptimizer: moving right")
                print("mapOptimizer: maps to load "..tostring(mod+1).." "..tostring(mod+2).." "..tostring(mod+3))
                if mod == 0 then
                    return mod+1, mod+2, mod+3
                else
                    return mod, mod+1, mod+2
                end
            else
                print("mapOptimizer: moving left")
                return mod+1, mod +2, mod+3
            end
        end

        self.prepareForOutput = function()
            local n1=1
            local n2=1
            for i = 1, 10 do
                if self.layersToUnload[i] == true then
                    self.layerNamesToUnload[n1]="map"..tostring(i)
                    print("mapOptimizer: prepared for output to unload: "..self.layerNamesToUnload[n1].." "..tostring(n1))
                    n1 = n1+1
                else
                    self.layerNamesToLoad[n2]="map"..tostring(i)
                    print("mapOptimizer: prepared for output to load: "..self.layerNamesToLoad[n2])
                    n2 = n2+1
                end
            end
        end

        self.handleLayers = function()
            local currentPos = self.positions[1]
            local k,j,l = self.getLayersToLoad(currentPos)
            if self.lastLayersLoaded[1]~=k then
                self.lastLayersLoaded[1]=k
            end
            if self.lastLayersLoaded[2]~=j then
                self.lastLayersLoaded[2]=j
            end
            if self.lastLayersLoaded[3]~=l then
                self.lastLayersLoaded[3]=l
            end
            --self.setLayersToLoad(k,j)
            self.setLayersToUnload(k,j,l)
            self.prepareForOutput()
            if self.isStatic() == true then
                self._behaviorTarget:activateActionsGroup("unLoadLayers")
                self._behaviorTarget:activateActionsGroup("loadLayers")
            end
        end

        self.getLayerNameToUnload = function(s)
            print("mapOptimizer: layer name to unload is "..tostring(self.layerNamesToUnload[s]).. ", s= "..tostring(s))
            return self.layerNamesToUnload[s]
        end

        self.getLayerNameToLoad = function(k)
            return self.layerNamesToLoad[k]
        end

        --for future use
        self.update = function()
            --print("hello")
        end

        --export
        mapLayersHandler = {}
        mapLayersHandler.getLayerNameToUnload = self.getLayerNameToUnload
        mapLayersHandler.getLayerNameToLoad = self.getLayerNameToLoad
        --print("TESTTEST "..tostring(mapLayersHandler.getLayerNameToLoad).." "..tostring(mapLayersHandler.getLayerNameToLoad(1)))


		return self

	end




--no need for now:
--return "TestBehavior"