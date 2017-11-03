-- HD GENERATOR -- Program for building simple Hard Data
-- By Raphael Bandeira and Conrado Costa

-- Love Load Function
function love.load()
  version = "3.0.0"

  -- Cursor
  cursor = {
    x,
    y
  }
  --
  
  -- Coordenates which the user has selected in Training Image
  coord = {
    x = {};
    y = {};
    }
  --
  
  -- Data about the Hard Data
  HD = {
    radius = 4;
    previous_Radius,
    color = 255;
    pixel_selection = {
      red,
      green,
      blue,
      color
    };
    radial_selection = {
      red,
      green,
      blue,
      color
      };
    numPoints = 0;
    rad = {};
    simGrid = {
      x1,
      y1,
      z1,
      x2,
      y2,
      z2
    };
  }
  --
  
  -- Data about the Training Image
  training_Image = {
    image,
    size={
      x,
      y,
      z
    };
    sgems,
    matrix = {},
    overlap,
    Pattern,
    facies,
    scale = {
      x,
      y
    };
  }
  --
  
  quit = true
  
  firstIsWriting = false
  secondIsWriting = false
  thirdIsWriting = false
  forthIsWriting = false
  fifthIsWriting = false
  sixthIsWriting = false
  
  love.keyboard.setKeyRepeat(true)
  isSelecting = true
  HDwasSelected = false
  accessible =  love.filesystem.mount('HD_Generator', "HD_Generator")
  love.window.setTitle("HD Generator - " .. version)
  training_Image.image = 0
  -- Opening Config Files
	data = love.filesystem.newFile("HD_config.txt")
	data:open("r")
	
	local i = 1
	local parameters = {}
	
	for word in love.filesystem.lines("HD_config.txt") do
		parameters[i] = word
		i = i + 1
	end
	
  -- Inicializing Parameters
  i = 2
  matrix_name = (parameters[i])
	matrix_Path = "images/"..(parameters[i])
	i = i + 2  
	HD.radial_selection.color = tonumber(parameters[i])
	i = i + 2
	HD.pixel_selection.color = tonumber(parameters[i])
	i = i + 2
	training_Image.Pattern = tonumber(parameters[i])
	i = i + 2
	training_Image.overlap = tonumber(parameters[i])
  
  data:close()
  
  local f = love.filesystem.newFile(matrix_Path)
  f:open("r")
  local final = 0
  while final < 3 do -- reads the size in sgens!
    n1 = f:read(1)
    sizeN = n1
    n1 = f:read(1)
    while not ((n1 == " ") or (n1 == "\n") or (n1 == "\r")) do
      sizeN = sizeN .. n1
      n1 = f:read(1)
    end
    
    if(final == 0) then
      training_Image.size.x = tonumber(sizeN)
    elseif(final == 1) then
      training_Image.size.y = tonumber(sizeN)
    elseif(final == 2) then
      training_Image.size.z = tonumber(sizeN)
    end
    final = final + 1
  end
  f:close()
  
  HD.simGrid.x1 = 1
  HD.simGrid.y1 = 1
  HD.simGrid.z1 = 1
  HD.simGrid.x2 = training_Image.size.x
  HD.simGrid.y2 = training_Image.size.y
  HD.simGrid.z2 = training_Image.size.z
  
  -- Defines color to Radial mode selector
  if HD.radial_selection.color == 1 then ------ Red
    HD.radial_selection.red = 255
    HD.radial_selection.green = 0
    HD.radial_selection.blue = 0
  elseif HD.radial_selection.color == 2 then -- Green
    HD.radial_selection.red = 0
    HD.radial_selection.green = 255
    HD.radial_selection.blue = 0
  elseif HD.radial_selection.color == 3 then -- Blue
    HD.radial_selection.red = 0
    HD.radial_selection.green = 0
    HD.radial_selection.blue = 255
  elseif HD.radial_selection.color == 4 then -- Yellow
    HD.radial_selection.red = 210
    HD.radial_selection.green = 210
    HD.radial_selection.blue = 0
  elseif HD.radial_selection.color == 5 then ----------- Magenta
    HD.radial_selection.red = 210
    HD.radial_selection.green = 0
    HD.radial_selection.blue = 210
  else 
    HD.radial_selection.red = 0
    HD.radial_selection.green = 210
    HD.radial_selection.blue = 210
  end
  --
  
  -- Defines color to Pixel mode selector
  if HD.pixel_selection.color == 1 then ------- Red
    HD.pixel_selection.red = 255
    HD.pixel_selection.green = 0
    HD.pixel_selection.blue = 0
  elseif HD.pixel_selection.color == 2 then --- Green
    HD.pixel_selection.red = 0               
    HD.pixel_selection.green = 255             
    HD.pixel_selection.blue = 0                             
  elseif HD.pixel_selection.color == 3 then  -- Blue
    HD.pixel_selection.red = 0               
    HD.pixel_selection.green = 0               
    HD.pixel_selection.blue = 255              
  elseif HD.pixel_selection.color == 4 then  -- Yellow
    HD.pixel_selection.red = 210             
    HD.pixel_selection.green = 210            
    HD.pixel_selection.blue = 0
  elseif HD.pixel_selection.color == 5 then  -- Magenta
    HD.pixel_selection.red = 210              
    HD.pixel_selection.green = 0             
    HD.pixel_selection.blue = 210
  else ---------------------------------------- Blue
    HD.pixel_selection.red = 0
    HD.pixel_selection.green = 210
    HD.pixel_selection.blue = 210
  end
  --
  
  -- Adjusting scale to a maximum
  desktop_width, desktop_height = love.window.getDesktopDimensions(1)
  training_Image.scale.x = (desktop_width - (desktop_width/6)) / training_Image.size.x
  training_Image.scale.y = (desktop_height - (desktop_height/6)) / training_Image.size.y
  
  if training_Image.scale.x > training_Image.scale.y then
    training_Image.scale.x = training_Image.scale.y
  else
    training_Image.scale.y = training_Image.scale.x
  end
  

  -- Adjusting training_Image.scale.x to a minimum
  if (training_Image.scale.x <= 0) then
    training_Image.scale.x = 0.1
  end
  
  
  -- Adjusting training_Image.scale.y to a minimum
  if (training_Image.scale.y <= 0) then
    training_Image.scale.y = 0.1
  end
  
  
  -- Adjusting HD.radius to a minimum
  if (HD.radius < 0.5) then
    HD.radius = 0.5
  end
  
  
  -- Adjusting HD.radius to a maximum
  if HD.radius * training_Image.scale.x * 2 >= training_Image.size.x * training_Image.scale.x then
    HD.radius = ((training_Image.size.x) - 10) / (2)
  end
  if HD.radius * training_Image.scale.y * 2 >= training_Image.size.y * training_Image.scale.y then
    HD.radius = ((training_Image.size.y) - 10) / (2)
  end
  
  HD.previous_Radius = HD.radius
  
  training_Image.matrix = {}
  training_Image.facies = 0
  local aux = 0
  i = 1
  local line = 0
  for word in love.filesystem.lines(matrix_Path) do
  	if (line > 2) then
      training_Image.matrix[i] = tonumber(word)
      i = i + 1
      if(tonumber(word) > aux) then
        aux = tonumber(word)
        training_Image.facies = aux + 1
      end
		else
      line = line + 1
 		end
  end
  f:close()
	
	-- Sets image scaled
  window_Height = math.floor(desktop_height - (desktop_height/10))
	love.window.setMode(training_Image.size.x * training_Image.scale.x + (desktop_width/8), window_Height)
  base = math.floor((window_Height - training_Image.size.y * training_Image.scale.y) / 2)
  text = ''
  text_buffer = ''
end

--

-- Love Update function
function love.update(dt)
  
	cursor.x = love.mouse.getX()
	cursor.y = love.mouse.getY()
  
  --borderLimit() -- I don't want to use this! 
	storeHDCoord()
  changingSGBoxes()  
end
--

-- Love Draw Function
function love.draw()
  drawTrainingImage()
  drawHDSelected()
  drawSG()
  
  if isSelecting then
      drawHDSelector()
  else ------ FINISHING PROGRAM
    interface() -- Draws interface to Screenshot
    img =  love.graphics.newScreenshot() -- stores Screenshot information
  	
    drawGrid() -- Clears everything in the window and draws a Grid
    drawHardData()
    
    interface() -- Draws interface to Screenshot 
    HD_img =  love.graphics.newScreenshot() -- stores Screenshot information
    
    makeHDList()
    
    love.event.quit()
 end
 
  interface()
end
--

-- Draw Simulation Grid
function drawSG()
  local x1 = tonumber(HD.simGrid.x1)
  local y1 = tonumber(HD.simGrid.y1)
  local x2 = tonumber(HD.simGrid.x2)
  local y2 = tonumber(HD.simGrid.y2)
  if training_Image.image + 1 >= tonumber(HD.simGrid.z1) and training_Image.image + 1 <= tonumber(HD.simGrid.z2) then
    if x1 >= 1 and x1 < training_Image.size.x and x2 > 1 and x2 <= training_Image.size.x and y1 >= 1 and y1 < training_Image.size.y and y2 > 1 and y2 <= training_Image.size.y  then
      love.graphics.setColor(255, 128, 0)
      love.graphics.line((x1-1) * training_Image.scale.x, (y1-1) * training_Image.scale.y + base, (x1-1) * training_Image.scale.x, (y2-1) * training_Image.scale.y + base)
      love.graphics.line((x1-1) * training_Image.scale.x, (y1-1) * training_Image.scale.y + base, (x2-1) * training_Image.scale.x, (y1-1) * training_Image.scale.y + base)
      love.graphics.line((x2-1) * training_Image.scale.x, (y1-1) * training_Image.scale.y + base, (x2-1) * training_Image.scale.x, (y2-1) * training_Image.scale.y + base)
      love.graphics.line((x1-1) * training_Image.scale.x, (y2-1) * training_Image.scale.y + base, (x2-1) * training_Image.scale.x, (y2-1) * training_Image.scale.y + base)
    else
      love.graphics.setColor(255, 128, 0)
      love.graphics.line(0, base, 0, training_Image.size.y * training_Image.scale.y + base)
      love.graphics.line(0, base, training_Image.size.x * training_Image.scale.x, base)
      love.graphics.line(0, training_Image.size.y * training_Image.scale.y + base, 0, training_Image.size.y * training_Image.scale.y + base)
      love.graphics.line(0, training_Image.size.y * training_Image.scale.y + base, training_Image.size.x * training_Image.scale.x, training_Image.size.y * training_Image.scale.y + base)
    end
  end
end
--

-- Changes the values from parameters of simulation grid 
function changingSGBoxes()
   -- changing x1
  HD.simGrid.x1 = writing(firstIsWriting, HD.simGrid.x1)
  if HD.simGrid.x1 == nil or  HD.simGrid.x1 == '' then
    HD.simGrid.x1 = 0
    else
    if not(firstIsWriting) and tonumber(HD.simGrid.x1) < 1 then
      HD.simGrid.x1 = 1
    elseif not(firstIsWriting) and tonumber(HD.simGrid.x1) > training_Image.size.x then
      HD.simGrid.x1 = training_Image.size.x - 1
    end  
  end
  --
  
  -- changing x2
  HD.simGrid.x2 = writing(forthIsWriting, HD.simGrid.x2)
  if HD.simGrid.x2 == nil or  HD.simGrid.x2 == '' then
    HD.simGrid.x2 = 0
    else
    if not(forthIsWriting) and tonumber(HD.simGrid.x2) < 1 then
      HD.simGrid.x2 = 2
    elseif not(forthIsWriting) and tonumber(HD.simGrid.x2) > training_Image.size.x then
      HD.simGrid.x2 = training_Image.size.x
    end  
  end
  --
  
  -- changing y1
  HD.simGrid.y1 = writing(secondIsWriting, HD.simGrid.y1)
  if HD.simGrid.y1 == nil or  HD.simGrid.y1 == '' then
    HD.simGrid.y1 = 0
    else
    if not(secondIsWriting) and tonumber(HD.simGrid.y1) < 1 then
      HD.simGrid.y1 = 1
    elseif not(secondIsWriting) and tonumber(HD.simGrid.y1) > training_Image.size.y then
      HD.simGrid.y1 = training_Image.size.y - 1
    end  
  end
  --
  
  -- changing y2
  HD.simGrid.y2 = writing(fifthIsWriting, HD.simGrid.y2)
  if HD.simGrid.y2 == nil or  HD.simGrid.y2 == '' then
    HD.simGrid.y2 = 0
    else
    if not(fifthIsWriting) and tonumber(HD.simGrid.y2) < 1 then
      HD.simGrid.y2 = 2
    elseif not(fifthIsWriting) and tonumber(HD.simGrid.y2) > training_Image.size.y then
      HD.simGrid.y2 = training_Image.size.y
    end  
  end
  --
  
  -- changing z1
  HD.simGrid.z1 = writing(thirdIsWriting, HD.simGrid.z1)
  if HD.simGrid.z1 == nil or  HD.simGrid.z1 == '' then
    HD.simGrid.z1 = 0
    else
    if not(thirdIsWriting) and tonumber(HD.simGrid.z1) < 1 then
      HD.simGrid.z1 = 1
    elseif not(thirdIsWriting) and tonumber(HD.simGrid.z1) > training_Image.size.z then
      HD.simGrid.z1 = training_Image.size.z - 1
    end  
  end
  --
  
  -- changing z2
  HD.simGrid.z2 = writing(sixthIsWriting, HD.simGrid.z2)
  if HD.simGrid.z2 == nil or  HD.simGrid.z1 == '' then
    HD.simGrid.z2 = 0
    else
    if not(sixthIsWriting) and tonumber(HD.simGrid.z2) < 1 then
      HD.simGrid.z2 = 2
    elseif not(sixthIsWriting) and tonumber(HD.simGrid.z2) > training_Image.size.z then
      HD.simGrid.z2 = training_Image.size.z
    end  
  end
  --
end
--

-- Stores all HD coordenates
function storeHDCoord()
  if (isCircle) then			-- This won't allow a circle to override another
		if HD.numPoints >= 1 then
      for i=1, HD.numPoints do
        if((math.abs(coord.x[i] - cursor.x)) <= (HD.radius * training_Image.scale.x) and (math.abs(coord.y[i] - (cursor.y))) <= (HD.radius * training_Image.scale.y)) then
          isCircle = false
        end			
      end
    end
    
    if (isCircle) then -- Store HD coordenate
			HD.numPoints = HD.numPoints + 1
			coord.x[HD.numPoints] = cursor.x;
			coord.y[HD.numPoints] = cursor.y - base;
      HD.rad[HD.numPoints] = HD.radius;
			isCircle = false
		end   	
  end
end
--

-- Set a limit the cursor
function borderLimit()
  
  local border_lim = 1.25
  -- Selection wont be out from border this way!
	if (cursor.x - (HD.radius * training_Image.scale.x)/ border_lim < 0) then
		cursor.x = (HD.radius * training_Image.scale.x) / border_lim
	end	
	
	if (cursor.x + (HD.radius * training_Image.scale.x) / border_lim > training_Image.size.x * training_Image.scale.x) then
		cursor.x = (training_Image.size.x * training_Image.scale.x) - (HD.radius * training_Image.scale.x)/2
	end	
	
	if (cursor.y - (HD.radius * training_Image.scale.y) / border_lim < base) then
		cursor.y = (HD.radius * training_Image.scale.y) / border_lim + base
	end	
	
	if (cursor.y + (HD.radius * training_Image.scale.y) / border_lim > training_Image.size.y * training_Image.scale.y + base) then
		cursor.y = (training_Image.size.y * training_Image.scale.y + base) - (HD.radius * training_Image.scale.y)/2
	end	
end
--

-- Draws Training Image
function drawTrainingImage()
  HD.color = math.floor(255/(training_Image.facies - 1))
  love.graphics.clear(100, 100, 100)
	--draw training image as a matrix.
	for j=1, training_Image.size.y do
		for i=1, training_Image.size.x do
      for w=1, training_Image.facies do
        if (training_Image.matrix[i + ((training_Image.size.y - j) * training_Image.size.x) + (training_Image.image * (training_Image.size.x * training_Image.size.y))] == w - 1) then
        	love.graphics.setColor(HD.color * (w - 1), HD.color * (w - 1), HD.color * (w - 1))
        end
      end
       		love.graphics.rectangle("fill", (i-1)*training_Image.scale.x, base + (j-1)*training_Image.scale.y, training_Image.scale.x,training_Image.scale.y)
    end
	end
end
--

-- Draws Hard Data selected
function drawHDSelected()
  for i=1, HD.numPoints do
    if (HD.rad[i] <= 1) then
      love.graphics.setColor(HD.pixel_selection.red,HD.pixel_selection.green,HD.pixel_selection.blue)
      love.graphics.rectangle("line", math.floor(coord.x[i] - training_Image.scale.x/2), math.floor(coord.y[i] + base - training_Image.scale.y/2), training_Image.scale.x, training_Image.scale.y)
    else
      love.graphics.setColor(HD.radial_selection.red,HD.radial_selection.green,HD.radial_selection.blue)
      love.graphics.ellipse("line", coord.x[i], coord.y[i] + base, math.floor(HD.rad[i] * training_Image.scale.x), math.floor(HD.rad[i] * training_Image.scale.y))
    end
	end
end
--

-- Draws Grid
function drawGrid()
  love.graphics.clear(100, 100, 100)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", 0, base, training_Image.size.x*training_Image.scale.x, training_Image.size.y*training_Image.scale.y)
  
  -- print table
  local i = training_Image.Pattern
  local j = training_Image.Pattern
  local counter = 0
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("0", training_Image.scale.x,  base + training_Image.scale.y)
  while i < training_Image.size.x do 
    love.graphics.setColor(0, 0, 0)
      
    love.graphics.setColor(210,210,210)
    if (j < training_Image.size.y) then
      love.graphics.line(0, base + j*training_Image.scale.y,  training_Image.size.x*training_Image.scale.x, j*training_Image.scale.y + base)
      love.graphics.line(0, base + j*training_Image.scale.y - training_Image.overlap * training_Image.scale.y, training_Image.size.x*training_Image.scale.x, j*training_Image.scale.y - training_Image.overlap * training_Image.scale.y + base)
      if (counter % 2 == 0) then
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(i, training_Image.scale.x, base +  j*training_Image.scale.y + 1)
        love.graphics.setColor(255, 0, 0)
        love.graphics.line(0, j*training_Image.scale.y + base, 5 * training_Image.scale.x, j*training_Image.scale.y + base)
      end
    end
    love.graphics.setColor(210,210,210)
    love.graphics.line(i*training_Image.scale.x, base,  i*training_Image.scale.x, training_Image.size.y*training_Image.scale.y + base)
    love.graphics.line(i*training_Image.scale.x - training_Image.overlap * training_Image.scale.x, base, i*training_Image.scale.x - training_Image.overlap * training_Image.scale.x, training_Image.size.y*training_Image.scale.y + base)
      
    if (counter % 3 == 0) then
      love.graphics.setColor(0, 0, 0)
      love.graphics.print(j, i * training_Image.scale.x + 1, base +  training_Image.scale.y)
      love.graphics.setColor(255, 0, 0)
      love.graphics.line(i*training_Image.scale.x, base, i*training_Image.scale.x, base + 5 * training_Image.scale.y)
    end
      
    i = i + training_Image.Pattern - training_Image.overlap
    j = j + training_Image.Pattern - training_Image.overlap
    counter = counter + 1
  end
end
--

-- Simple math function
function square(x)
	return x*x
end
--

-- Receives the coordenates and returns the faciesIterator in the Training Image matrix for drawing the actual Depth
function faciesIterator2D(i, j)
  return ( i + ((training_Image.size.y - j) * training_Image.size.x) + (training_Image.image * (training_Image.size.x * training_Image.size.y)) )
end
--

-- Receives the coordenates and returns the faciesIterator in the Training Image matrix in all depth
function faciesIterator3D(i, j, k)
  return ( i + ((training_Image.size.y - j) * training_Image.size.x) + (k * (training_Image.size.x * training_Image.size.y)) )
end
--

-- Draws HD in Grid
function drawHardData()
  local x1 = tonumber(HD.simGrid.x1)
  local y1 = tonumber(HD.simGrid.y1)
  local x2 = tonumber(HD.simGrid.x2)
  local y2 = tonumber(HD.simGrid.y2)
  
  local count = 0
  for current=1, HD.numPoints do
    local coord_x = coord.x[current]/training_Image.scale.x
    local coord_y = coord.y[current]/training_Image.scale.y
    -- Print the HD coordinates in Grid
    love.graphics.setColor(255, 0, 0)
    if coord_x >= x1 - 1 and coord_x < x2 and coord_y >= y1 - 1 and coord_y < y2 then
      prtCoord(coord.x[current], coord.y[current] + base, HD.rad[current])
    end
    
    drawSG()  
    -- Draw the hard data!
    
    
    if(math.floor(HD.rad[current]) > 1) then
  	  for j = math.floor(coord_y - HD.rad[current]), math.floor(coord_y + HD.rad[current]) do
  	    for i = math.floor(coord_x - HD.rad[current]), math.floor(coord_x + HD.rad[current]) do 
  	      if (math.sqrt(square(coord.x[current]/training_Image.scale.x - i) + square(coord.y[current]/training_Image.scale.y - j)) < HD.rad[current]) then
  	        if (i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and (j >= 0) and (i < x2) and (j <  y2) and (i >= x1 - 1) and (j >=  y1 - 1)  then
  	          count = count + 1
              HD.color = math.floor(255/(training_Image.facies - 1))
              for w=1, training_Image.facies do
                if (tonumber(training_Image.matrix[faciesIterator2D(i + 1, j + 1)]) == w - 1) then
                  love.graphics.setColor(HD.color * (w - 1), 0, 255 - HD.color * (w - 1))
                end
              end
              love.graphics.rectangle("fill", i*training_Image.scale.x, base + j*training_Image.scale.y, training_Image.scale.x, training_Image.scale.y)
  	        end
  	      end
  	    end
  	  end
    elseif (math.floor(HD.rad[current]) <= 1) then
  	  i = coord_x
  	  j = coord_y
  	  if (i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and (j >= 0) and (i < x2) and (j <  y2) and (i >= x1 - 1) and (j >=  y1 - 1)  then
  	    count = count + 1
        HD.color = math.floor(255/(training_Image.facies - 1))
          for w=1, training_Image.facies do
            if (tonumber(training_Image.matrix[faciesIterator2D(i + 1, j + 1)]) == w - 1) then
              love.graphics.setColor(HD.color * (w - 1), 0, 255 - HD.color * (w - 1))
            end
          end
        love.graphics.rectangle("fill", i*training_Image.scale.x, base + j*training_Image.scale.y, training_Image.scale.x,training_Image.scale.y)
  	  end
  	end
  end
end
--

-- Makes HD list
function makeHDList()
  local x1 = tonumber(HD.simGrid.x1)
  local y1 = tonumber(HD.simGrid.y1)
  local x2 = tonumber(HD.simGrid.x2)
  local y2 = tonumber(HD.simGrid.y2)
  local z1 = tonumber(HD.simGrid.z1)
  local z2 = tonumber(HD.simGrid.z2)
  
  -- Counting Hard Datas
  local count = 0
  for current=1, HD.numPoints do
    if(math.floor(HD.rad[current]) > 1) then
      for j = math.floor(coord.y[current]/training_Image.scale.y - HD.rad[current]), math.floor(coord.y[current]/training_Image.scale.y + HD.rad[current]) do
        for i = math.floor(coord.x[current]/training_Image.scale.x - HD.rad[current]), math.floor(coord.x[current]/training_Image.scale.x + HD.rad[current]) do 
          if (math.sqrt(square(coord.x[current]/training_Image.scale.x - i) + square(coord.y[current]/training_Image.scale.y - j)) < HD.rad[current]) then
            if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and (j >= 0) and (i < x2) and (j < y2) and (i >= (x1-1)) and (j >= (y1-1)))   then
              count = count + (1 * (z2 - z1 + 1))
            end
          end
        end
      end
    elseif (math.floor(HD.rad[current]) <= 1) then
      i = math.floor(coord.x[current]/training_Image.scale.x)
      j = math.floor(coord.y[current]/training_Image.scale.y)
      if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and (j >= 0) and (i < x2) and (j < y2) and (i >= (x1-1)) and (j >= (y1-1)))  then
        count = count + (1 * (z2 - z1 + 1))
      end
    end
  end
  -- Create the Directories and save the image and the HD_list
  time = (os.time()%1000000)
  directory = ("HardData/" .. time .."_".. "HD_".. count)
  love.filesystem.createDirectory( directory )
  img:encode('png', directory .. "/" .. time .. "_HDimage_"..count..'.png')
  HD_img:encode('png', directory .. "/" .. time .. "_HDpoints_"..count..'.png')
    
  -- print HD points in file txt
  local file = love.filesystem.newFile(directory .. "/" .. time .. "_" .. "HD_" .. count .. ".txt")
  file:open("w")
  file:write("TESTE" .. count .. "\r\n")
  file:write("4".. "\r\n")
  file:write("X".. "\r\n")
  file:write("Y".. "\r\n")
  file:write("Z".. "\r\n")
  file:write("facies".. "\r\n")
  
  for current=1, HD.numPoints do
    print("<".. math.floor(coord.x[current]/training_Image.scale.x) ..", " .. math.floor((coord.y[current])/training_Image.scale.y) .. "> -- Point selected")
    if(math.floor(HD.rad[current]) > 1) then
      for k = 1, training_Image.size.z do
        for j = math.floor(coord.y[current]/training_Image.scale.y) - math.floor(HD.rad[current]), math.floor(coord.y[current]/training_Image.scale.y) + math.floor(HD.rad[current]) do
          for i = math.floor(coord.x[current]/training_Image.scale.x) - math.floor(HD.rad[current]), math.floor(coord.x[current]/training_Image.scale.x) + math.floor(HD.rad[current]) do 
            if (math.sqrt(square(math.floor(coord.x[current]/training_Image.scale.x) - i) + square(math.floor(coord.y[current]/training_Image.scale.y) - j)) < math.floor(HD.rad[current])) then
              if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and (j >= 0) and (i < x2) and (j < y2) and (i >= (x1-1)) and (j >= (y1-1)) and (k >= z1) and (k <= z2)) then
                if (tonumber(training_Image.matrix[faciesIterator3D(i + 1, j + 1, k - 1)]) == nil) then
                  print(i .." "..j.." "..k.. " is nil")
                else
                  file:write(i - x1 .." ".. j - y1 .." "..(k - 1).." "..( tonumber(training_Image.matrix[faciesIterator3D(i + 1, j + 1, k - 1)]) + 1 ).."\r\n")
                end
              end
            end
          end
        end
      end
    elseif (math.floor(HD.rad[current]) <= 1) then
      i = math.floor(coord.x[current]/training_Image.scale.x)
      j = math.floor(coord.y[current]/training_Image.scale.y)
      for k = 1, training_Image.size.z do
        if (i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and (j >= 0) and (i < x2) and (j <  y2) and (i >= x1-1) and (j >=  y1-1) and (k >= z1) and (k <= z2) then
          if (tonumber(training_Image.matrix[faciesIterator3D(i + 1, j + 1, k - 1)]) == nil) then
            print(i .." "..j .." "..k.. "is nil")
          else
            file:write(i - x1 .." ".. j - y1 .." "..(k - 1).." "..( tonumber(training_Image.matrix[faciesIterator3D(i + 1, j + 1, k - 1)]) + 1 ).."\r\n")
          end
        end
      end
    end
  end
  file:close()
end
--

-- Draws HD selector
function drawHDSelector()
  if isCursorInTi() then
    if (HD.radius <= 1) then
      love.graphics.setColor(HD.pixel_selection.red,HD.pixel_selection.green,HD.pixel_selection.blue)
      love.graphics.rectangle("line", math.floor(cursor.x - training_Image.scale.x/2), math.floor(cursor.y - training_Image.scale.x/2), training_Image.scale.x, training_Image.scale.y)
    else
      love.graphics.setColor(HD.radial_selection.red,HD.radial_selection.green,HD.radial_selection.blue)
      love.graphics.ellipse("line", cursor.x, cursor.y, math.floor(HD.radius * training_Image.scale.x), math.floor(HD.radius * training_Image.scale.y))
    end
    
    prtCoord(cursor.x, cursor.y, HD.radius)
  end
end
--

-- print coordenates (receives the coordenates from training image scaled)
function prtCoord(x, y, radius)
  local delta_pixel_x = 10 * training_Image.scale.x
  local delta_pixel_y = 10 * training_Image.scale.y
  local x1 = tonumber(HD.simGrid.x1)
  local y1 = tonumber(HD.simGrid.y1)
  local x2 = tonumber(HD.simGrid.x2)
  local y2 = tonumber(HD.simGrid.y2)
  local cursor_pox = math.floor(x/training_Image.scale.x)
  local cursor_poy = math.floor((y - base)/ training_Image.scale.y)
  
  
  local distance = radius
  if(distance <= 1) then
    distance = 1
  end
  
  local limit_x = x2 - 2 * delta_pixel_x - distance
  local limit_y = y2 - 2 * delta_pixel_y - distance
  if (cursor_pox >= (x1 - 1) and cursor_poy >= (y1 - 1) and cursor_pox < x2 and cursor_poy < y2) then
    if cursor_pox > limit_x and cursor_poy > limit_y then -- corner
      love.graphics.print(cursor_pox - (x1 - 1).. ", "..cursor_poy - (y1 - 1), x - 3 * delta_pixel_x  - distance * training_Image.scale.x, y - delta_pixel_y - distance * training_Image.scale.y)
      
    elseif cursor_pox > limit_x and cursor_poy <= limit_y then -- left
      love.graphics.print(cursor_pox - (x1 - 1).. ", "..cursor_poy - (y1 - 1), x - 3 * delta_pixel_x - distance * training_Image.scale.x, y + distance * training_Image.scale.y)
      
    elseif cursor_pox <= limit_x and cursor_poy > limit_y then -- bottom
      love.graphics.print(cursor_pox - (x1 - 1).. ", "..cursor_poy - (y1 - 1), x + distance * training_Image.scale.x, y - delta_pixel_y - distance * training_Image.scale.y)
      
    else
      love.graphics.print(cursor_pox - (x1 - 1).. ", "..cursor_poy - (y1 - 1), x + distance * training_Image.scale.x, y + distance * training_Image.scale.y)
    end
  end
end
--

-- User Interface
function interface ()
  local Distance = math.floor(desktop_height / 60)
  local rectangle_left = training_Image.size.x * training_Image.scale.x
  local rectangle_width = 240
  local rectangle_bottom = window_Height

  love.graphics.setColor(255, 130, 0)
  love.graphics.rectangle("fill", rectangle_left, 0, rectangle_width, rectangle_bottom)
  
  love.graphics.setColor(50, 50, 50)
  love.graphics.rectangle("fill", rectangle_left + 10, 10, rectangle_width - 20, rectangle_bottom - 20)
  
  love.graphics.setColor(230, 230, 230)
  love.graphics.rectangle("fill", rectangle_left + 20, 20, rectangle_width - 40, rectangle_bottom - 40)
  
  local pox = Distance
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("HD GENERATOR ", rectangle_left + 70, 20 + pox)
  
  pox = pox + Distance * 2
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("IMAGE FILE: ", rectangle_left + 30, 20 + pox)
  
  pox = pox + Distance
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(matrix_name, rectangle_left + 30, 20 + pox, 0, 0.8, 0.8)
  
  pox = pox + Distance * 1.5
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("AMOUNT OF FACIES: ", rectangle_left + 30, 20 + pox)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(training_Image.facies, rectangle_left + 160, 20 + pox)
  
  pox = pox + Distance * 1.5
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("IMAGE SIZE: ", rectangle_left + 30, 20 + pox)
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("X : " .. training_Image.size.x, rectangle_left + 130, 20 + pox)
  pox = pox + Distance
  love.graphics.print("Y : " .. training_Image.size.y, rectangle_left + 130, 20 + pox)
  pox = pox + Distance
  love.graphics.print("Z : " .. training_Image.size.z, rectangle_left + 130, 20 + pox)
  
  pox = pox + Distance * 1.5
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("SIMULATION GRID: ", rectangle_left + 30, 20 + pox)
  block_height = 15
  block_width = 50
  
  -- First Block
  pox = pox + Distance
  first_block_x = rectangle_left + 60
  first_block_y = 19 + pox
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("X1 : ", rectangle_left + 30, 20 + pox)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", first_block_x, first_block_y, block_width, block_height)
 
  if (firstIsWriting) then
    love.graphics.setColor(255, 80, 0)
  else
    love.graphics.setColor(0, 0, 0)
  end 

  love.graphics.rectangle("line", first_block_x, first_block_y, block_width, block_height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(HD.simGrid.x1, first_block_x + 10, first_block_y + 1)
  
  -- Forth Block
  forth_block_x = rectangle_left + 160
  forth_block_y = 19 + pox
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("X2 : ", rectangle_left + 130, 20 + pox)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", forth_block_x, forth_block_y, block_width, block_height)
  
  if (forthIsWriting) then
    love.graphics.setColor(255, 80, 0)
  else
    love.graphics.setColor(0, 0, 0)
  end 
  love.graphics.rectangle("line", forth_block_x, forth_block_y, block_width, block_height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(HD.simGrid.x2, forth_block_x + 10, forth_block_y + 1)
  
  -- Second Block
  pox = pox + Distance
  second_block_x = rectangle_left + 60
  second_block_y = 19 + pox
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Y1 : ", rectangle_left + 30, 20 + pox)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", second_block_x, second_block_y, block_width, block_height)
  
  if (secondIsWriting) then
    love.graphics.setColor(255, 80, 0)
  else
    love.graphics.setColor(0, 0, 0)
  end 
  love.graphics.rectangle("line", second_block_x, second_block_y, block_width, block_height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(HD.simGrid.y1, second_block_x + 10, second_block_y + 1)
    
  -- fifth Block
  fifth_block_x = rectangle_left + 160
  fifth_block_y = 19 + pox
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Y2 : ", rectangle_left + 130, 20 + pox)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", fifth_block_x, fifth_block_y, block_width, block_height)
  
  if (fifthIsWriting) then
    love.graphics.setColor(255, 80, 0)
  else
    love.graphics.setColor(0, 0, 0)
  end 
  love.graphics.rectangle("line", fifth_block_x, fifth_block_y, block_width, block_height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(HD.simGrid.y2, fifth_block_x + 10, fifth_block_y + 1)
  
  -- Third Block
  pox = pox + Distance
  third_block_x = rectangle_left + 60
  third_block_y = 19 + pox
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Z1 : ", rectangle_left + 30, 20 + pox)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", third_block_x, third_block_y, block_width, block_height)
  
  if (thirdIsWriting) then
    love.graphics.setColor(255, 80, 0)
  else
    love.graphics.setColor(0, 0, 0)
  end 
  love.graphics.rectangle("line", third_block_x, third_block_y, block_width, block_height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(HD.simGrid.z1,  third_block_x + 10, third_block_y + 1)
  
  -- Sixth Block
  sixth_block_x = rectangle_left + 160
  sixth_block_y = 19 + pox
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Z2 : ", rectangle_left + 130, 20 + pox)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", sixth_block_x, sixth_block_y, block_width, block_height)
  
  if (sixthIsWriting) then
    love.graphics.setColor(255, 80, 0)
  else
    love.graphics.setColor(0, 0, 0)
  end 
  love.graphics.rectangle("line", sixth_block_x, sixth_block_y, block_width, block_height)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(HD.simGrid.z2, sixth_block_x + 10, sixth_block_y + 1)
  
  -- HD POINTS
  pox = pox + Distance * 2
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("HD POINTS: ", rectangle_left + 30, 20 + pox)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(HD.numPoints, rectangle_left + 130, 20 + pox)
  
  -- MODE
  pox = pox + Distance
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("MODE: ", rectangle_left + 30, 20 + pox)
  
  if HD.radius <= 1 then
      love.graphics.setColor(HD.pixel_selection.red,HD.pixel_selection.green,HD.pixel_selection.blue)
    love.graphics.print("Pixel", rectangle_left + 130, 20 + pox)
  else
      love.graphics.setColor(HD.radial_selection.red,HD.radial_selection.green,HD.radial_selection.blue)
    love.graphics.print("Radial", rectangle_left + 130, 20 + pox)
  end
  
  -- Radius Size
  pox = pox + Distance
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("RADIUS SIZE: ", rectangle_left + 30, 20 + pox)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(math.floor(HD.radius), rectangle_left + 130, 20 + pox)
  
  pox = pox + Distance
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("PATTERN SIZE: ", rectangle_left + 30, 20 + pox)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(training_Image.Pattern, rectangle_left + 130, 20 + pox)
  
  pox = pox + Distance
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("OVERLAP SIZE: ", rectangle_left + 30, 20 + pox)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(training_Image.overlap, rectangle_left + 130, 20 + pox)
  
  pox = pox + Distance * 2
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("COORDINATE: ", rectangle_left + 30, 20 + pox)
  if (cursor.x >= 0 and cursor.x < training_Image.scale.x * training_Image.size.x and cursor.y > base and cursor.y < training_Image.size.y * training_Image.scale.y + base) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("X: " .. math.floor(cursor.x/training_Image.scale.x), rectangle_left + 130, 20 + pox)
    pox = pox + Distance
    love.graphics.print("Y: " .. math.floor((cursor.y - base)/training_Image.scale.y), rectangle_left + 130, 20 + pox)
  end
  
  pox = pox + Distance * 2
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("DEPTH: ", rectangle_left + 30, 20 + pox)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(training_Image.image, rectangle_left + 130, 20 + pox)
  
  pox = pox + Distance * 2
  love.graphics.setColor(255, 100, 0)
  love.graphics.print("Navigation Buttons: ", rectangle_left + 50, 20 + pox)
  
  pox = pox + Distance * 2
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Z - increases the value of", rectangle_left + 30, 20 + pox)
  pox = pox + Distance
  love.graphics.print("DEPTH, moving to a deeper", rectangle_left + 30, 20 + pox)
  pox = pox + Distance
  love.graphics.print("plane", rectangle_left + 30, 20 + pox)
  
  pox = pox + Distance * 2
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("X - decreases the value of", rectangle_left + 30, 20 + pox)
  pox = pox + Distance
  love.graphics.print("DEPTH, moving to a more", rectangle_left + 30, 20 + pox)
  pox = pox + Distance
  love.graphics.print("superficial plane", rectangle_left + 30, 20 + pox)
  
  pox = pox + Distance * 2
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Right click - Quickly changes", rectangle_left + 30, 20 + pox)
  pox = pox + Distance
  love.graphics.print("between Pixel Mode and ", rectangle_left + 30, 20 + pox)
    pox = pox + Distance
  love.graphics.print("Radial Mode", rectangle_left + 30, 20 + pox)
  
  pox = pox + Distance * 2
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Left click - Selects the", rectangle_left + 30, 20 + pox)
  pox = pox + Distance
  love.graphics.print("Hard Data. ", rectangle_left + 30, 20 + pox)
  
  pox = pox + Distance * 2
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Mouse Wheel - Changes the", rectangle_left + 30, 20 + pox)
  pox = pox + Distance
  love.graphics.print("size of RADIUS.", rectangle_left + 30, 20 + pox)
  
  pox = pox + Distance * 2
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("press ESC or close the", rectangle_left + 30, 20 + pox)
  pox = pox + Distance
  love.graphics.print("window to generate the list", rectangle_left + 30, 20 + pox)
  
  pox = pox + Distance * 2
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("press DEL to erase last", rectangle_left + 30, 20 + pox)
  pox = pox + Distance
  love.graphics.print("HD selection", rectangle_left + 30, 20 + pox)
  
  
end
--

-- if Mouse is clicked
function love.mousereleased(x, y, button)
	local value
  if button == "l" or button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
    if cursor.x >= 0 and cursor.x < training_Image.size.x * training_Image.scale.x and cursor.y >= base and cursor.y < training_Image.size.y * training_Image.scale.y + base then
      isCircle = true
      HDwasSelected = true
    end
    
    if (cursor.x > first_block_x and cursor.x <= first_block_x + block_width and cursor.y > first_block_y and cursor.y <= first_block_y + block_height) then
      firstIsWriting = true
      secondIsWriting = false
      thirdIsWriting = false
      forthIsWriting = false
      fifthIsWriting = false
      sixthIsWriting = false
      text = tostring(HD.simGrid.x1)
    elseif (cursor.x > second_block_x and cursor.x <= second_block_x + block_width and cursor.y > second_block_y and cursor.y <= second_block_y + block_height) then
      firstIsWriting = false
      secondIsWriting = true
      thirdIsWriting = false
      forthIsWriting = false
      fifthIsWriting = false
      sixthIsWriting = false
      text = tostring(HD.simGrid.y1)
    elseif (cursor.x > third_block_x and cursor.x <= third_block_x + block_width and cursor.y > third_block_y and cursor.y <= third_block_y + block_height) then
      firstIsWriting = false
      secondIsWriting = false
      thirdIsWriting = true
      forthIsWriting = false
      fifthIsWriting = false
      sixthIsWriting = false
      text = tostring(HD.simGrid.z1)
    elseif (cursor.x > forth_block_x and cursor.x <= forth_block_x + block_width and cursor.y > forth_block_y and cursor.y <= forth_block_y + block_height) then
      firstIsWriting = false
      secondIsWriting = false
      thirdIsWriting = false
      forthIsWriting = true
      fifthIsWriting = false
      sixthIsWriting = false
      text = tostring(HD.simGrid.x2)
    elseif (cursor.x > fifth_block_x and cursor.x <= fifth_block_x + block_width and cursor.y > fifth_block_y and cursor.y <= fifth_block_y + block_height) then
      firstIsWriting = false
      secondIsWriting = false
      thirdIsWriting = false
      forthIsWriting = false
      fifthIsWriting = true
      sixthIsWriting = false
      text = tostring(HD.simGrid.y2)
    elseif (cursor.x > sixth_block_x and cursor.x <= sixth_block_x + block_width and cursor.y > sixth_block_y and cursor.y <= sixth_block_y + block_height) then
      firstIsWriting = false
      secondIsWriting = false
      thirdIsWriting = false
      forthIsWriting = false
      fifthIsWriting = false
      sixthIsWriting = true
      text = tostring(HD.simGrid.z2)
    end    
  
	elseif button == "r" or button == 2 then
    if(HD.radius > 1) then
      HD.previous_Radius = HD.radius
      HD.radius = 0.9
    else
      HD.radius = HD.previous_Radius
    end
    -- Adjusting HD.radius to a minimum
    if (HD.radius <= 1) then
      HD.radius = 1
    end
  
    -- Adjusting HD.radius to a maximum
    if HD.radius * 2 >= training_Image.size.x then
      HD.radius = ((training_Image.size.x) - 1) / 2
    end
    if HD.radius * 2 >= training_Image.size.y then
      HD.radius = ((training_Image.size.y) - 1) / 2
    end
    
  end
end
--

--
function writing(isWriting, n)
  if isWriting then
    if not (text == text_buffer) then
      text_buffer = text
      if not (text_buffer == nil) then
          return text_buffer
      end
    end
  end
  return n
end
--

-- Text Input
function love.textinput(t)
	text = text .. t
end
--

-- If wheel is moved
function love.wheelmoved(x, y)
    if y > 0 then
        HD.radius = HD.radius + 1
    elseif y < 0 then 
        HD.radius = HD.radius - 1
    end
    -- Adjusting HD.radius to a minimum
    if (HD.radius <= 1) then
      HD.radius = 1
    end
  
    -- Adjusting HD.radius to a maximum
    if HD.radius * 2 >= training_Image.size.x then
      HD.radius = ((training_Image.size.x) - 1) / 2
    end
    if HD.radius * 2 >= training_Image.size.y then
      HD.radius = ((training_Image.size.y) - 1) / 2
    end
end
--

-- if Key is Pressed
function love.keypressed(key)
  if key == "escape" then
    isSelecting = false
    quit = true
  elseif key == "delete" then
    HD.numPoints = HD.numPoints - 1
    if HD.numPoints < 0 then
      HD.numPoints = 0
    end
  elseif key == "return" then
    firstIsWriting = false
    secondIsWriting = false
    thirdIsWriting = false
    forthIsWriting = false
    fifthIsWriting = false
    sixthIsWriting = false
    text = ''
    text_buffer = ''
  elseif key == "z" then
    training_Image.image = training_Image.image + 1
    if(training_Image.image >= training_Image.size.z) then
      training_Image.image = training_Image.size.z - 1
    end
  elseif key == "x" then
    training_Image.image = training_Image.image - 1
    if(training_Image.image < 0) then
      training_Image.image = 0
    end
  end
  
  if key == "backspace" then
    -- remove the last UTF-8 character.
    -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
    text = text:sub(1,-2)
    if text == nil then
      text = ''
    end
  end
end
--

-- Checks wheather the cursor is inside Training image or not
function isCursorInTi()
  if cursor.x >= 0 and cursor.x < training_Image.size.x * training_Image.scale.x and cursor.y >= base and cursor.y < training_Image.size.y * training_Image.scale.y + base then
    return true
  end
    return false
end
--

-- Quiting and making HD list
function love.quit()
  if quit then
    quit = not quit
    isSelecting = false
  else
    return quit
  end
  return true
end

