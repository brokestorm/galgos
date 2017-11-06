-- HD GENERATOR -- Program for building simple Hard Data
-- By Raphael Bandeira and Conrado Costa

-- Love Load Function
function love.load()
  version = "4.0.0"

  -- Cursor
  cursor = {
    x,
    y
  }
  --
  
  -- Coordenates which the user has selected in Training Image
  coord = {
    x = {};
    y = {}
    }
  --
  
  -- Data about the Hard Data
  HD = {
    radius = 4;
    previous_Radius,
    color = 255;
    numPoints = 0;
    rad = {}
  }
  
  --
  
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
  file = {
    name = {};
    bytes = {};
    size = {
      x = {},
      y = {},
      z = {};
    };
  }
  --
  block_s = {
    x = {},
    y = {},
    w = {},
    h = {},
    state = {};
    lim_x,
    lim_y,
    lim_w,
    lim_h,
  }
  --
  block_w = {
    x = {},
    y = {},
    w = {},
    h = {},
    state = {};
    value = {};
  }
  --
  
  amountBlocks = 14
  -- Opening Config Files
	entries = 1
	parameters = {}
	for word in love.filesystem.lines("HardData/HD_config.txt") do
		parameters[entries] = word
		entries = entries + 1
	end
	
  
  for k = 1, amountBlocks do
    block_w.value[k] = 1
    block_w.value[k] = tonumber(parameters[k * 2])
    block_w.state[k] = false
    if block_w.value[k] == nil then
      block_w.value[k] = 0
    end
  end
  HD.radius = tonumber(parameters[amountBlocks*2 + 2])
  folder_Path = (parameters[amountBlocks*2 + 4])

  
  -- Setting Parameters
  love.window.setTitle("HD Generator - " .. version)
  training_Image.image = 1
  desktop_width, desktop_height = love.window.getDesktopDimensions(1)
  HD.previous_Radius = HD.radius
  text = ''
  text_buffer = ''
  fileIsLoaded = false
  fileHasBeenChosen = false
  fileChosen = 1
  mode1 = false
  mode2 = false
  quit = true
  love.keyboard.setKeyRepeat(true)
  isSelecting = true
  HDwasSelected = false
  scrollbar_lock = false
  aboveStartButton = false
  isBidimensional = false
  scrollbar = 0
  last_state = 1
  block_height = 15
  block_width = 53
  startButton_x = 0
  startButton_y = 0
  startButton_w = 0
  startButton_h = 0
  ti_buffer = 0
  hd_buffer = 0

  last_state_b = 1
  -- Adjusting HD.radius to a minimum
  --if (HD.radius < 0.5) then
  --  HD.radius = 0.5
  --end
  --
  --
  ----Adjusting HD.radius to a maximum
  --if HD.radius * training_Image.scale.x * 2 >= training_Image.size.x * training_Image.scale.x then
  --  HD.radius = ((training_Image.size.x) - 10) / (2)
  --end
  --if HD.radius * training_Image.scale.y * 2 >= training_Image.size.y * training_Image.scale.y then
  --  HD.radius = ((training_Image.size.y) - 10) / (2)
  --end
  love.window.setMode(desktop_width/2, desktop_height/2)
  local k
    --assuming that our path is full of lovely files (it should at least contain main.lua in this case)
  local files = love.filesystem.getDirectoryItems("images/")
  for k, files in ipairs(files) do
    file.name[k] = files
    
    block_s.state[k] = false
  local f = love.filesystem.newFile("images/" .. files)
  f:open("r")
  file.bytes[k] = f:getSize()
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
      file.size.x[k] = tonumber(sizeN)
    elseif(final == 1) then
      file.size.y[k] = tonumber(sizeN)
    elseif(final == 2) then
      file.size.z[k] = tonumber(sizeN)
    end
    final = final + 1
  end
    amountFiles = k
  end
  
  for k = 1, 14 do
    block_w.state[k] = false -- pattern size
  end
  
  
end

--
--
function saveConfig ()
  local file = love.filesystem.newFile("HardData/HD_config.txt")
  file:open("w")
  
  for k = 1, amountBlocks do
    file:write(parameters[2*k - 1] .. "\r\n")
    file:write(block_w.value[k] .. "\r\n")
  end
  file:write(parameters[amountBlocks*2 + 1] .. "\r\n")
  file:write(HD.radius .. "\r\n")
  file:write(parameters[amountBlocks*2 + 3] .. "\r\n")
  file:write(folder_Path .. "\r\n")
  
  
  
  file:close()
end
--
-- Love Update function
function love.update(dt)
	cursor.x = love.mouse.getX()
	cursor.y = love.mouse.getY()
  if not(fileIsLoaded) then
    if (cursor.x >= startButton_x and cursor.x <= startButton_x + startButton_w and cursor.y >= startButton_y and cursor.y <= startButton_y + startButton_h) then
      aboveStartButton = true
    else
      aboveStartButton = false
    end
    if (fileHasBeenChosen) then
      fileLoad()
      fileIsLoaded = true
    end
  else
    storeHDCoord() 
  end
end
--

--
function fileLoad()
  -- Reads the TI facies
  training_Image.matrix = {}
  training_Image.facies = 0
  local aux = 0
  i = 1
  local line = 0
  for word in love.filesystem.lines("images/" .. file.name[fileChosen]) do
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
  -- End reading
  
  training_Image.Pattern = tonumber(block_w.value[1])
  training_Image.overlap = tonumber(block_w.value[2])
  
  training_Image.size.x = file.size.x[fileChosen]
  training_Image.size.y = file.size.y[fileChosen]
  training_Image.size.z = file.size.z[fileChosen]
  if training_Image.size.z <= 1 then
    isBidimensional = true
  end
  
  if training_Image.Pattern > training_Image.size.x then
    training_Image.Pattern = training_Image.size.x
  end
  if training_Image.overlap >= training_Image.Pattern then
    training_Image.overlap = training_Image.Pattern - 1
  end
  
  training_Image.scale.x = (desktop_width - (desktop_width/6)) / training_Image.size.x
  training_Image.scale.y = (desktop_height - (desktop_height/6)) / training_Image.size.y
  
  if training_Image.scale.x > training_Image.scale.y then
    training_Image.scale.x = training_Image.scale.y
  else
    training_Image.scale.y = training_Image.scale.x
  end
  
  window_Height = math.floor(desktop_height - (desktop_height/10))
  love.window.setMode(training_Image.size.x * training_Image.scale.x + (desktop_width/8), window_Height)
  base = math.floor((window_Height - training_Image.size.y * training_Image.scale.y) / 2)
  
  -- Adjusting training_Image.scale.x to a minimum
  if (training_Image.scale.x <= 0) then
    training_Image.scale.x = 0.1
  end
  
  
  -- Adjusting training_Image.scale.y to a minimum
  if (training_Image.scale.y <= 0) then
    training_Image.scale.y = 0.1
  end
  drawTrainingImage()
end
--

--
function fileLoadingState ()
  
  local side_Width = 20
  local limit_v1 = side_Width
  local limit_v2 = side_Width * 4 -- where the ORANGE line rectangle's height starts
  local dg_rectangle_height = (desktop_height/2) - (side_Width*2)
  local o_rectangle_height = (desktop_height/2) - (side_Width*8)
  local bar_height = (o_rectangle_height) /2
  local limit_y1 = o_rectangle_height + limit_v2 -- where the ORANGE line rectangle's height ends
  local limit_y2 = dg_rectangle_height +  side_Width - limit_y1
  local item_height = (side_Width*1.5)
  local item_start = side_Width * 5
  local item_width = (desktop_width/2) - (side_Width*10)
  local pox_v = (side_Width*2.5)
  local limit_x1 = side_Width * 4 + (desktop_width/2) - (side_Width*8) - 5
  local speed =  ( pox_v * amountFiles + item_height - (o_rectangle_height)) / ( (o_rectangle_height - bar_height) )

  love.graphics.clear(255, 128, 0)
  love.graphics.setColor(200, 100, 0)
  love.graphics.rectangle("fill", side_Width/2 , side_Width /2, (desktop_width/2) - (side_Width*2) + side_Width, dg_rectangle_height + side_Width)
  love.graphics.setColor(80, 80, 80)
  love.graphics.rectangle("fill", side_Width, side_Width, (desktop_width/2) - (side_Width*2), dg_rectangle_height)
  
  local model
  local pox_y = limit_v2 + pox_v - item_height
  local aux = limit_v2 + pox_v - item_height
  love.graphics.setColor(150, 150, 150)
  love.graphics.rectangle("fill", side_Width * 4, side_Width * 4, (desktop_width/2) - (side_Width*8), o_rectangle_height)
  
  for k = 1, amountFiles  do
    aux = pox_y - scrollbar * speed
    if limit_v2 + bar_height + scrollbar >= limit_y1 then
      scrollbar_lock = true
    end
    pox_y = pox_y + pox_v
    
    if(aux <= side_Width * 4 + (desktop_height/2) - (side_Width*8) and aux + item_height >= side_Width * 4)then
    if block_s.state[k] then
      love.graphics.setColor(255, 128, 0)
    else
      love.graphics.setColor(200, 100, 0)
    end
    love.graphics.rectangle("fill", item_start, aux, item_width, item_height)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("line", item_start + 5,  aux + 5, item_width - 10, item_height - 10)
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("fill", item_start + 5, aux + 5, item_width - 10, item_height - 10)
    love.graphics.setColor(0, 0, 0)
    if file.size.z[k] <= 1 then
      model = "2D"
    else
      model = "3D"
    end
    love.graphics.printf(" | ".. k..". ".. file.name[k], side_Width * 5 + 15,  aux + 5 + 2, (item_width - 10) * 2/3, "left")
    love.graphics.printf(" | Model: "..model.." | Size: " .. file.bytes[k].. " bytes".. "  |  X: ".. file.size.x[k] .. "  |  Y: ".. file.size.y[k] .. "  |  Z: ".. file.size.z[k] .. " | ", item_start,  aux + 5 + 2, item_width - 20, "right")
    
     
     block_s.y[k] = aux
     
    end
  end
  block_s.x = item_start
  block_s.w = item_width
  block_s.h = item_height
  
  block_s.lim_x = side_Width * 4
  block_s.lim_y = limit_v2
  block_s.lim_w = (desktop_width/2) - (side_Width*8)
  block_s.lim_h = o_rectangle_height
  
  
  love.graphics.setColor(80, 80, 80) -- Hiden Rectangle bottom
  love.graphics.rectangle("fill", side_Width * 4, limit_y1 , (desktop_width/2) - (side_Width*8), limit_y2)
  love.graphics.setColor(80, 80, 80) -- Hiden Rectangle top
  love.graphics.rectangle("fill", side_Width * 4, limit_v1 , (desktop_width/2) - (side_Width*8), limit_v2 - limit_v1)
  
  love.graphics.setColor(230, 100, 0) -- title
  love.graphics.printf ("HD GENERATOR", side_Width * 5, side_Width * 2, o_rectangle_height + side_Width * 5 , "center",0 ,1.5, 1.5)
  

  
  -- drawing the scrollbar
  love.graphics.setColor(200, 200, 200)
  love.graphics.rectangle("fill", limit_x1 - 5, limit_v2, 10, o_rectangle_height)
  love.graphics.setColor(255, 128, 0)
  love.graphics.rectangle("fill", limit_x1 - 5, limit_v2 + scrollbar, 10, bar_height)
  love.graphics.setColor(200, 80, 0)
  love.graphics.rectangle("line", limit_x1 - 5, limit_v2 + scrollbar, 10, bar_height)
  
  love.graphics.setColor(255, 128, 0) -- ORANGE LINE RECTANGLE
  love.graphics.rectangle("line", side_Width * 4, limit_v2, (desktop_width/2) - (side_Width*8), o_rectangle_height)
  --
  
  block_w.x[1] = side_Width * 10
  block_w.x[2] = side_Width * 10
  block_w.y[1] = limit_v2 + o_rectangle_height + 10
  block_w.y[2] = limit_v2 + o_rectangle_height + block_height + 15
  block_w.w[1] = block_width
  block_w.w[2] = block_width
  block_w.h[1] = block_height
  block_w.h[2] = block_height
  -- block (value, x, y, w, h, state, name)
  love.graphics.setColor(200, 80, 0)
  block_w.value[1] = block (block_w.value[1], block_w.x[1], block_w.y[1], block_w.w[1], block_w.h[1], block_w.state[1],"Pattern Size", 99999, 0)
  love.graphics.setColor(200, 80, 0)
  block_w.value[2] = block (block_w.value[2], block_w.x[2], block_w.y[2], block_w.w[2], block_w.h[2], block_w.state[2],"Overlap Size", 99999, 0)
  
  startButton_w = block_width * 3
  startButton_x =  (desktop_width/2) - (side_Width*8) + side_Width * 4 - block_width * 3
  startButton_y = limit_v2 + o_rectangle_height + 8
  startButton_h = block_height * 3
  
  if aboveStartButton then
    love.graphics.setColor(255, 128, 0)
  else
    love.graphics.setColor(200, 100, 0)
  end
  love.graphics.rectangle("fill", startButton_x, startButton_y, startButton_w, startButton_h)
  love.graphics.setColor(150, 80, 0)
  love.graphics.rectangle("line", startButton_x, startButton_y, startButton_w, startButton_h)
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf("START", startButton_x + startButton_w/3, startButton_y + startButton_h/3, startButton_w, "left", 0, 1.5, 1.5)
  
end
--

-- Love Draw Function
function love.draw()
  
  if not(fileIsLoaded) then
    fileLoadingState()
  else
    
    if not(training_Image.image == ti_buffer) then
      drawTrainingImage()
      ti_buffer = training_Image.image
    end

      

    
    love.graphics.setColor(255,255,255)
    love.graphics.draw(canvas, 0, 0)
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
  
end
--

-- Draw Simulation Grid
function drawSG()
  local x1 = tonumber(block_w.value[3])
  local y1 = tonumber(block_w.value[5])
  local x2 = tonumber(block_w.value[4])
  local y2 = tonumber(block_w.value[6])
  if not(block_w.value[7] == '') or not(block_w.value[8] == '') then
    if training_Image.image >= tonumber(block_w.value[7]) and training_Image.image <= tonumber(block_w.value[8]) then
      if x1 >= 1 and x1 < training_Image.size.x and x2 > 1 and x2 <= training_Image.size.x and y1 >= 1 and y1 < training_Image.size.y and y2 > 1 and y2 <= training_Image.size.y  then
        love.graphics.setColor(255, 128, 0)
        love.graphics.line((x1-1) * training_Image.scale.x, (y1-1) * training_Image.scale.y + base, (x1-1) * training_Image.scale.x, (y2) * training_Image.scale.y + base)
        love.graphics.line((x1-1) * training_Image.scale.x, (y1-1) * training_Image.scale.y + base, (x2) * training_Image.scale.x, (y1-1) * training_Image.scale.y + base)
        love.graphics.line((x2) * training_Image.scale.x, (y1-1) * training_Image.scale.y + base, (x2) * training_Image.scale.x, (y2) * training_Image.scale.y + base)
        love.graphics.line((x1-1) * training_Image.scale.x, (y2) * training_Image.scale.y + base, (x2) * training_Image.scale.x, (y2) * training_Image.scale.y + base)
      else
        love.graphics.setColor(255, 128, 0)
        love.graphics.line(0, base, 0, training_Image.size.y * training_Image.scale.y + base)
        love.graphics.line(0, base, training_Image.size.x * training_Image.scale.x, base)
        love.graphics.line(0, training_Image.size.y * training_Image.scale.y + base, 0, training_Image.size.y * training_Image.scale.y + base)
        love.graphics.line(0, training_Image.size.y * training_Image.scale.y + base, training_Image.size.x * training_Image.scale.x, training_Image.size.y * training_Image.scale.y + base)
      end
    end
  end
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
		HDwasSelected = true
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
  canvas = love.graphics.newCanvas()
  love.graphics.setCanvas(canvas)
  
  HD.color = math.floor(255/(training_Image.facies - 1))
  love.graphics.clear(100, 100, 100)
	--draw training image as a matrix.
	for j=1, training_Image.size.y do
		for i=1, training_Image.size.x do
      for w=1, training_Image.facies do
        if (training_Image.matrix[i + ((training_Image.size.y - j) * training_Image.size.x) + ((training_Image.image-1) * (training_Image.size.x * training_Image.size.y))] == w - 1) then
        	love.graphics.setColor(HD.color * (w - 1), HD.color * (w - 1), HD.color * (w - 1))
        end
      end
       		love.graphics.rectangle("fill", (i-1)*training_Image.scale.x, base + (j-1)*training_Image.scale.y, training_Image.scale.x,training_Image.scale.y)
    end
	end
  love.graphics.setCanvas()
end
--

-- Draws Hard Data selected
function drawHDSelected()
	
	if HD.numPoints >= 1 then
		for i=1, HD.numPoints do
			if (HD.rad[i] <= 1) then
				love.graphics.setColor(block_w.value[12],block_w.value[13],block_w.value[14])
				love.graphics.rectangle("line", math.floor(coord.x[i] - training_Image.scale.x/2), math.floor(coord.y[i] + base - training_Image.scale.y/2), training_Image.scale.x, training_Image.scale.y)
			else
			love.graphics.setColor(block_w.value[9],block_w.value[10],block_w.value[11])
			love.graphics.ellipse("line", coord.x[i], coord.y[i] + base, math.floor(HD.rad[i] * training_Image.scale.x), math.floor(HD.rad[i] * training_Image.scale.y))
			end
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
  return ( i + ((training_Image.size.y - j) * training_Image.size.x) + ((training_Image.image-1) * (training_Image.size.x * training_Image.size.y)) )
end
--

-- Receives the coordenates and returns the faciesIterator in the Training Image matrix in all depth
function faciesIterator3D(i, j, k)
  return ( i + ((training_Image.size.y - j) * training_Image.size.x) + (k * (training_Image.size.x * training_Image.size.y)) )
end
--

-- Draws HD in Grid
function drawHardData()
  local x1 = tonumber(block_w.value[3])
  local y1 = tonumber(block_w.value[5])
  local x2 = tonumber(block_w.value[4])
  local y2 = tonumber(block_w.value[6])
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
  	      if (math.sqrt(square(math.floor(coord_x) - i) + square(math.floor(coord_y) - j)) < math.floor(HD.rad[current])) then
  	        if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and (j >= 0) and (i < x2) and (j < y2) and (i >= (x1-1)) and (j >= (y1-1)))  then
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
  	  i = math.floor(coord_x)
  	  j = math.floor(coord_y)
  	  if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and (j >= 0) and (i < x2) and (j < y2) and (i >= (x1-1)) and (j >= (y1-1)))  then
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
  local x1 = tonumber(block_w.value[3])
  local y1 = tonumber(block_w.value[5])
  local x2 = tonumber(block_w.value[4])
  local y2 = tonumber(block_w.value[6])
  local z1 = tonumber(block_w.value[7])
  local z2 = tonumber(block_w.value[8])
  
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
                  file:write(i - (x1 - 1) .." ".. j - (y1 - 1) .." "..(k - 1).." "..( tonumber(training_Image.matrix[faciesIterator3D(i + 1, j + 1, k - 1)]) + 1 ).."\r\n")
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
            file:write(i - (x1 - 1) .." ".. j - (y1 - 1) .." "..(k - 1).." "..( tonumber(training_Image.matrix[faciesIterator3D(i + 1, j + 1, k - 1)]) + 1 ).."\r\n")
          end
        end
      end
    end
  end
  file:close()
  saveConfig()
end
--

-- Draws HD selector
function drawHDSelector()
  if isCursorInTi() then
    if (HD.radius <= 1) then
      love.graphics.setColor(block_w.value[12],block_w.value[13],block_w.value[14])
      love.graphics.rectangle("line", math.floor(cursor.x - training_Image.scale.x/2), math.floor(cursor.y - training_Image.scale.x/2), training_Image.scale.x, training_Image.scale.y)
    else
      love.graphics.setColor(block_w.value[9],block_w.value[10],block_w.value[11])
      love.graphics.ellipse("line", cursor.x, cursor.y, math.floor(HD.radius * training_Image.scale.x), math.floor(HD.radius * training_Image.scale.y))
    end
    
    prtCoord(cursor.x, cursor.y, HD.radius)
  end
end
--

-- print coordenates (receives the coordenates from training image scaled)
function prtCoord(x, y, radius)
  local delta_pixel_x = 30
  local delta_pixel_y = 30
  local x1 = tonumber(block_w.value[3])
  local y1 = tonumber(block_w.value[5])
  local x2 = tonumber(block_w.value[4])
  local y2 = tonumber(block_w.value[6])
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
      love.graphics.print(cursor_pox - (x1 - 1).. ", "..cursor_poy - (y1 - 1), x - 2 * delta_pixel_x  - distance * training_Image.scale.x, y - delta_pixel_y - distance * training_Image.scale.y)
      
    elseif cursor_pox > limit_x and cursor_poy <= limit_y then -- left
      love.graphics.print(cursor_pox - (x1 - 1).. ", "..cursor_poy - (y1 - 1), x - 2 * delta_pixel_x - distance * training_Image.scale.x, y + distance * training_Image.scale.y)
      
    elseif cursor_pox <= limit_x and cursor_poy > limit_y then -- bottom
      love.graphics.print(cursor_pox - (x1 - 1).. ", "..cursor_poy - (y1 - 1), x + distance * training_Image.scale.x, y - delta_pixel_y - distance * training_Image.scale.y)
      
    else
      love.graphics.print(cursor_pox - (x1 - 1).. ", "..cursor_poy - (y1 - 1), x + distance * training_Image.scale.x, y + distance * training_Image.scale.y)
    end
  end
end
--

--
function writingBlock(value, state, limit, start)
  if (state) then
    value = writing(state, value)
    if value == nil or  value == '' then
      return 0
    else
      return value
    end
  else
    if tonumber(value) < 1 then
      return start
    elseif tonumber(value) > limit then
      return limit
    else
      return tonumber(value)
    end
  end
end
--

-- block where the value can be changed
function block (value, x, y, w, h, state, name, limit, start)
  -- First Block
  love.graphics.printf(name .. " :", 0, y, x - 3, "right")
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", x, y, w, h)
  
  if (state) then
    love.graphics.setColor(255, 80, 0)
  else
    love.graphics.setColor(0, 0, 0)
  end 
  value = writingBlock(value, state, limit, start)
  value = writingBlock(value, state, limit, start)
  love.graphics.rectangle("line", x, y, w, h)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(value, x + 3, y + 1)
  
  return value
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
  love.graphics.printf("HD GENERATOR - " .. version, rectangle_left + 20, 20 + pox, rectangle_width - 40, "center")
  
  pox = pox + Distance * 1.5
  love.graphics.setColor(255, 80, 0)
  love.graphics.printf("IMAGE FILE: ", rectangle_left + 20, 20 + pox, rectangle_width - 40, "center")
  
  pox = pox + Distance
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf(file.name[fileChosen], rectangle_left + 20, 20 + pox, rectangle_width - 40,"center")
  
  pox = pox + Distance * 1.5
  love.graphics.setColor(255, 80, 0)
  love.graphics.printf("IMAGE SIZE: ", rectangle_left + 20, 20 + pox, rectangle_width - 40,"center")
  pox = pox + Distance
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("X : " .. training_Image.size.x .. " | Y : " .. training_Image.size.y .." | Z : " .. training_Image.size.z, rectangle_left + 20, 20 + pox, rectangle_width - 40,"center")
  
  pox = pox + Distance * 1.5
  love.graphics.setColor(255, 80, 0)
  love.graphics.printf("SIMULATION GRID: ", rectangle_left + 20, 20 + pox, rectangle_width - 40, "center")
  love.graphics.setColor(0, 0, 0)
  
  -- First Block
  pox = pox + Distance + 5
  block_w.x[3] = rectangle_left + 55
  block_w.y[3] = 19 + pox
  block_w.value[3] = block (block_w.value[3], block_w.x[3], block_w.y[3], block_width, block_height, block_w.state[3], "X1", training_Image.size.x - 1, 1)
  
  -- Forth Block
  block_w.x[4] = rectangle_left + 155
  block_w.y[4] = 19 + pox
  block_w.value[4] = block (block_w.value[4], block_w.x[4], block_w.y[4], block_width, block_height, block_w.state[4], "X2", training_Image.size.x, 2)
  
  -- Second Block
  pox = pox + Distance
  block_w.x[5] = rectangle_left + 55
  block_w.y[5] = 19 + pox
  block_w.value[5] = block (block_w.value[5], block_w.x[5], block_w.y[5], block_width, block_height, block_w.state[5], "Y1", training_Image.size.y - 1, 1)
    
  -- fifth Block
  block_w.x[6] = rectangle_left + 155
  block_w.y[6] = 19 + pox
  block_w.value[6] = block (block_w.value[6], block_w.x[6], block_w.y[6], block_width, block_height, block_w.state[6], "Y2", training_Image.size.y , 2)
  
  -- Third Block
  pox = pox + Distance
  block_w.x[7] = rectangle_left + 55
  block_w.y[7] = 19 + pox
  local limit_z
  if(isBidimensional) then
    limit_z1 = 1
  else
    limit_z1 = training_Image.size.z - 1
  end
  block_w.value[7] = block (block_w.value[7], block_w.x[7], block_w.y[7], block_width, block_height, block_w.state[7], "Z1", limit_z1, 1)
  
  -- Sixth Block
  block_w.x[8] = rectangle_left + 155
  block_w.y[8] = 19 + pox
  
  if(isBidimensional) then
    start_z2 = 1
  else
    start_z2 = 2
  end
  block_w.value[8] = block (block_w.value[8], block_w.x[8], block_w.y[8], block_width, block_height, block_w.state[8], "Z2", training_Image.size.z, start_z2)
  
    pox = pox + Distance * 1.5
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("AMOUNT OF FACIES: ", rectangle_left + 30, 20 + pox)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(training_Image.facies, rectangle_left + 160, 20 + pox)
  
  -- HD POINTS
  pox = pox + Distance
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("HD POINTS: ", rectangle_left + 30, 20 + pox)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(HD.numPoints, rectangle_left + 130, 20 + pox)
  
  -- MODE
  pox = pox + Distance
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("MODE: ", rectangle_left + 30, 20 + pox)
  if HD.radius <= 1 then
    love.graphics.setColor(0,0,0)
    love.graphics.print("Pixel", rectangle_left + 130, 20 + pox)
  else
    love.graphics.setColor(0,0,0)
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
  
  pox = pox + Distance
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("DEPTH: ", rectangle_left + 30, 20 + pox)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(training_Image.image, rectangle_left + 130, 20 + pox)
  
  pox = pox + Distance * 1.5
  love.graphics.setColor(255, 80, 0)
  love.graphics.printf("COORDINATE: ", rectangle_left + 20, 20 + pox, rectangle_width - 40, "center")
  pox = pox + Distance
  if (cursor.x >= 0 and cursor.x < training_Image.scale.x * training_Image.size.x and cursor.y > base and cursor.y < training_Image.size.y * training_Image.scale.y + base) then
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("X: " .. math.floor(cursor.x/training_Image.scale.x) .. " | Y: ".. math.floor((cursor.y - base)/training_Image.scale.y), rectangle_left + 20, 20 + pox, rectangle_width - 40, "center")
  end
  
  pox = pox + Distance * 1.5
  love.graphics.setColor(255, 80, 0)
  love.graphics.printf("Navigation Buttons: ", rectangle_left + 20, 20 + pox, rectangle_width - 40, "center")
  
  pox = pox + Distance
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("Z - increases the value of DEPTH, moving to a deeper plane", rectangle_left + 30, 20 + pox, rectangle_width - 45, "left")
  
  pox = pox + Distance * 3
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("X - decreases the value of DEPTH, moving to a more superficial plane", rectangle_left + 30, 20 + pox, rectangle_width - 45, "left")
  
  pox = pox + Distance * 3
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("Right click - Quickly changes between Pixel Mode and Radial Mode", rectangle_left + 30, 20 + pox, rectangle_width - 45, "left")
  
  pox = pox + Distance * 3
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("Left click - Selects the Hard Data. ", rectangle_left + 30, 20 + pox, rectangle_width - 45, "left")

  
  pox = pox + Distance * 2
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("Mouse Wheel - Changes the size of RADIUS.", rectangle_left + 30, 20 + pox, rectangle_width - 45, "left")
  
  pox = pox + Distance * 2
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("press ESC or close the window to generate the list", rectangle_left + 30, 20 + pox, rectangle_width - 45, "left")
  
  pox = pox + Distance * 2
  love.graphics.setColor(0, 0, 0)
  love.graphics.printf("press DEL to erase last HD selection", rectangle_left + 30, 20 + pox, rectangle_width - 45, "left")
  
  pox = pox + Distance * 2
  love.graphics.setColor(255, 80, 0)
  love.graphics.printf("COLORS: ", rectangle_left + 25, 20 + pox, rectangle_width - 40, "center")
  pox = pox + Distance 
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("Radius: ", rectangle_left + 50, 20 + pox)
  love.graphics.setColor(255, 80, 0)
  love.graphics.print("Pixel: ", rectangle_left + 150, 20 + pox)

  love.graphics.setColor(0, 0, 0)
  -- R1
  pox = pox + Distance
  block_w.x[9] = rectangle_left + 50
  block_w.y[9] = 19 + pox
  block_w.value[9] = block (block_w.value[9], block_w.x[9], block_w.y[9], block_width, block_height, block_w.state[9], "R", 255, 0)
  -- P1
  block_w.x[12] = rectangle_left + 150
  block_w.y[12] = 19 + pox
  block_w.value[12] = block (block_w.value[12], block_w.x[12], block_w.y[12], block_width, block_height, block_w.state[12], "R", 255, 0)
  
  pox = pox + Distance
  -- R2
  block_w.x[10] = rectangle_left + 50
  block_w.y[10] = 19 + pox
  block_w.value[10] = block (block_w.value[10], block_w.x[10], block_w.y[10], block_width, block_height, block_w.state[10], "G", 255, 0)
  -- P2
  block_w.x[13] = rectangle_left + 150
  block_w.y[13] = 19 + pox
  block_w.value[13] = block (block_w.value[13], block_w.x[13], block_w.y[13], block_width, block_height, block_w.state[13], "G", 255, 0)
  pox = pox + Distance
  -- R3
  block_w.x[11] = rectangle_left + 50
  block_w.y[11] = 19 + pox
  block_w.value[11] = block (block_w.value[11], block_w.x[11], block_w.y[11], block_width, block_height, block_w.state[11], "B", 255, 0)
  -- P3
  block_w.x[14] = rectangle_left + 150
  block_w.y[14] = 19 + pox
  block_w.value[14] = block (block_w.value[14], block_w.x[14], block_w.y[14], block_width, block_height, block_w.state[14], "B", 255, 0)
  
  pox = pox + Distance
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", rectangle_left + 50, 19 + pox, block_width, block_height)
  love.graphics.setColor(block_w.value[9], block_w.value[10], block_w.value[11])
  love.graphics.rectangle("fill", rectangle_left + 50, 19 + pox, block_width, block_height)
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", rectangle_left + 150, 19 + pox, block_width, block_height)
  love.graphics.setColor(block_w.value[12], block_w.value[13], block_w.value[14])
  love.graphics.rectangle("fill", rectangle_left + 150, 19 + pox, block_width, block_height)
  
  
end
--

-- if Mouse is clicked
function love.mousereleased(x, y, button)
  if not(fileIsLoaded) then
    if button == "l" or button == 1 then
      local noblock = true
      for k = 1, 2 do
        if (cursor.x > block_w.x[k] and cursor.x <= block_w.x[k] + block_width and cursor.y > block_w.y[k] and cursor.y <= block_w.y[k] +block_height) then
          if not(last_state_b == k) then
            block_w.state [last_state_b] = false
          end
          block_w.state [k] = true
          last_state_b = k
          text = tostring(block_w.value[k])
          noblock = false
        end
      end
      --
      if noblock then
        for k = 1, 2 do
          block_w.state[k] = false
        end
        text = ''
        text_buffer = ''
      end
      --
      
      if (cursor.x >= startButton_x and cursor.x <= startButton_x + startButton_w and cursor.y >= startButton_y and cursor.y <= startButton_y + startButton_h) then
        for k = 1, amountFiles do
          if  block_s.state [k] then
            fileHasBeenChosen = true
            fileChosen = k
          end
        end
      -- area
      elseif (cursor.x > block_s.lim_x and cursor.x < block_s.lim_x + block_s.lim_w and cursor.y > block_s.lim_y and cursor.y < block_s.lim_y + block_s.lim_h) then
        for k = 1, amountFiles do
          if (cursor.x >= block_s.x and cursor.x <= (block_s.x + block_s.w) and cursor.y >= block_s.y[k] and cursor.y <= (block_s.y[k] + block_s.h)) then
            if not(last_state == k) then
              block_s.state [last_state] = false
            end
            block_s.state [k] = true
            last_state = k        
          end 
        end
      end
      --start button
      
      --
      
    end
    -- ends button 1
  else -- here ends fileIsloaded condition
    local value
    
    -- 
    if button == "l" or button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
      if cursor.x >= 0 and cursor.x < training_Image.size.x * training_Image.scale.x and cursor.y >= base and cursor.y < training_Image.size.y * training_Image.scale.y + base then
        isCircle = true
      end
      
      local noblock = true
      for k = 3, amountBlocks do
        if (cursor.x > block_w.x[k] and cursor.x <= block_w.x[k] + block_width and cursor.y > block_w.y[k] and cursor.y <= block_w.y[k] +block_height) then
          if not(last_state_b == k) then
            block_w.state [last_state_b] = false
          end
          block_w.state [k] = true
          last_state_b = k
          text = tostring(block_w.value[k])
          noblock = false
        end
      end
      --
      if noblock then
        for k = 3, amountBlocks do
          block_w.state[k] = false
        end
        text = ''
        text_buffer = ''
      end
      --
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
      -- Adjusting HD.radius to a maximum
      elseif training_Image.size.x > training_Image.size.y then
        if HD.radius >= training_Image.size.y then
          HD.radius = ((training_Image.size.y) - 1) / 2
        elseif HD.radius * 2 >= training_Image.size.x then
          HD.radius = ((training_Image.size.x) - 1) / 2
        end
      end
      --
      
    end
    --
  end
  --
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
	if t >= '0' and t <= '9' and string.len(text) <= 5 then
    text = text .. t
  end
end
--

-- If wheel is moved
function love.wheelmoved(x, y)
    if not(fileIsLoaded) then
      if y > 0 then
        if (scrollbar >= 1) then
          scrollbar = scrollbar - 10
          scrollbar_lock = false
        end
      elseif y < 0 then
        if not(scrollbar_lock) then
          scrollbar = scrollbar + 10
        end
      end
    else
        
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
    
end
--

-- if Key is Pressed
function love.keypressed(key)
  if not(fileIsLoaded) then
    if key == "up" then
      if (scrollbar >= 1) then
        scrollbar = scrollbar - 10
        scrollbar_lock = false
      end
    elseif key == "down" then
      if not(scrollbar_lock) then
        scrollbar = scrollbar + 10
      end    
    elseif key == "backspace" then
      -- remove the last UTF-8 character.
      -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
      text = text:sub(1,-2)
      if text == nil then
        text = ''
      end
    elseif key == "return" then
      for k = 1, 2 do
        block_w.state[k] = false
      end
      text = ''
      text_buffer = ''
    end
    
    
  else
    if key == "escape" then
      isSelecting = false
      quit = true
    elseif key == "delete" then
      HD.numPoints = HD.numPoints - 1
      if HD.numPoints <= 0 then
        HD.numPoints = 0
        HDwasSelected = false
      end
    elseif key == "return" then
      for k = 1, amountBlocks do
        block_w.state[k] = false
      end
      text = ''
      text_buffer = ''
    elseif key == "z" then
      training_Image.image = training_Image.image + 1
      if(training_Image.image >= training_Image.size.z) then
        training_Image.image = training_Image.size.z
      end
    elseif key == "x" then
      training_Image.image = training_Image.image - 1
      if(training_Image.image < 1) then
        training_Image.image = 1
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
end
--

-- Checks whether the cursor is inside Training image or not
function isCursorInTi()
  if cursor.x >= 0 and cursor.x < training_Image.size.x * training_Image.scale.x and cursor.y >= base and cursor.y < training_Image.size.y * training_Image.scale.y + base then
    return true
  end
    return false
end
--

-- Quiting and making HD list
function love.quit()
  if not(fileIsLoaded) then
    return false
  end
  if (HDwasSelected) then
    if isSelecting then
      isSelecting = false
      return true
    else
      return false
    end
	else
	return false
  end
  return true
end

