-- Introduction to Urho3D

-- Maze building algorithm

function buildMaze(width, height)
	local maze=
	{
		width=width,
		height=height,
		cells={}
	}
	
	maze.getCell=function(self,x,y)
		if x<1 or x>self.width or y<1 or y>self.height then return 0 end
		local idx=(y-1)*self.width+x
		if idx>#self.cells then return 0 end
		return self.cells[idx]
	end
	
	maze.setCell=function(self,x,y,val)
		if x<1 or x>self.width or y<1 or y>self.height then return end
		local idx=(y-1)*self.width+x
		if idx>#self.cells then return end
		self.cells[idx]=val
	end
	
	maze.dump=function(self, filename)
		local img=CArray2Dd(self.width, self.height)
		local x,y
		for y=1,self.height,1 do
			for x=1,self.width,1 do
				local cell=self:getCell(x,y)
				img:set(x-1,y-1,cell)
			end
		end
		
		saveDoubleArray(filename, img)
	end
	
	maze.getNeighborCode=function(self,x,y)
		local cell=self:getCell(x,y)
		local code=0
		if x+1<=self.width and self:getCell(x+1,y)==cell then code=code+1 end
		if x-1>0 and self:getCell(x-1,y)==cell then code=code+8 end
		if y+1<=self.height and self:getCell(x,y+1)==cell then code=code+2 end
		if y-1>0 and self:getCell(x,y-1)==cell then code=code+4 end
		
		return code
	end
	
	
	local y,x
	for y=1,height,1 do
		for x=1,width,1 do
			if x==1 or x==width or y==1 or y==height then
				table.insert(maze.cells, 1)
			else
				table.insert(maze.cells, 0)
			end
			
		end
	end
	
	return maze
	
end

function generateRandomLocation(width, height, gran)
	-- Given a set of dimensions and a granularity, generate a random starting location
	local xrange=math.floor(width/gran)
	local yrange=math.floor(height/gran)
	local x=math.random(1,xrange-1)*gran
	local y=math.random(1,yrange-1)*gran
	
	return x,y
end

function generateRandomStartLocation(maze, gran, maxtries)
	local tries=0
	
	local x,y=generateRandomLocation(maze.width, maze.height, gran)
	while maze:getCell(x,y)==1 and tries<maxtries do
		x,y=generateRandomLocation(maze.width, maze.height, gran)
	end
	
	if maze:getCell(x,y)==0 then return x,y else return nil end
end

function buildRandomWall(maze, gran, tries, minlength, maxlength)
	if minlength==nil then minlength=1 end
	if maxlength==nil then maxlength=math.max(maze.width, maze.height) end
	
	local x,y=generateRandomStartLocation(maze, gran, tries)
	local xinc,yinc=0,0
	
	--print("Random wall start: "..x..","..y.."\n")
	
	if x and y then
		local dir=math.random(1,4)
		if dir==1 then xinc=1
		elseif dir==2 then xinc=-1
		elseif dir==3 then yinc=1
		else yinc=-1
		end
		
		local len=math.random(minlength,maxlength)*gran
		
		while len>0 and maze:getCell(x,y)==0 do
			maze:setCell(x,y,1)
			x=x+xinc
			y=y+yinc
			len=len-1
		end
	end
end

function buildRandomMaze(width, height, mingranularity, maxgranularity, minlength, maxlength, walls, tries)
	local maze=buildMaze(width,height)
	
	local gran=maxgranularity
	while gran>=mingranularity do
		local wall
		for wall=1,walls,1 do
			buildRandomWall(maze, gran, tries, minlength, maxlength)
		end
		gran=math.floor(gran/2)
	end
	
	return maze
end