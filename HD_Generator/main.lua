-- Program for building simple Hard Data
version = "1.0.0"

cursor = {x=0, y=0}
coordX = {}
coordY = {} 

for i=1, 10000 do
	coordX[i] = 0
	coordY[i] = 0
end

HD = {
	radius;
  color = {
    red,
    green,
    blue
  };
	numPoints = 0;
}

training_Image = {
	image,
	size={
		x,
		y
	};
	sgems,
	matrix = {}
}

function square(x)
	return x*x
end

---------------------------------LOADING FILES-------------------------------------------

function love.load()

  love.window.setTitle("HD Generator - " .. version)
  
	data = love.filesystem.newFile("HD_config.txt")
	data:open("r")
	
	local i = 1
	local parameters = {}
	
	for word in love.filesystem.lines("HD_config.txt", " ") do
		parameters[i] = word
		i = i + 1
	end
	
  image_Path = parameters[2]
  matrix_Path = parameters[4]
  hd_directory = parameters [6]
	training_Image.size.x = tonumber(parameters[8])
	training_Image.size.y = tonumber(parameters[10])
  window_Width = tonumber(parameters[12])
  window_Height = tonumber(parameters[14])
	HD.radius = tonumber(parameters[16])
  HD.color.red = tonumber(parameters[18])
  HD.color.green = tonumber(parameters[20])
  HD.color.blue = tonumber(parameters[22])
  
  -- Adjusting Color to a maximum
  if(HD.color.red > 255) then
    HD.color.red = 255
  end
  if(HD.color.green > 255) then
    HD.color.green = 255
  end
  if(HD.color.blue > 255) then
    HD.color.blue = 255
  end
  
  if window_Height <= window_Width then
    scale = (window_Height) / training_Image.size.x
  elseif window_Height > window_Width then
    scale = (window_Width) / training_Image.size.y
  end
  
  -- Adjusting scale to a maximum
  desktop_width, desktop_height = love.window.getDesktopDimensions(1)
  if training_Image.size.x * scale >= desktop_width then
    scale = (desktop_width) / training_Image.size.x
  end
  if training_Image.size.y * scale >= desktop_height then
    scale = (desktop_height - 80) / training_Image.size.y
  end
  
  -- Adjusting scale to a minimum
  if (scale <= 0) then
    scale = 0.1
  end
  
  -- Adjusting HD.radius to a minimum
  if (HD.radius < 0.5) then
    HD.radius = 0.5
  end
  
  -- Adjusting HD.radius to a maximum
  if HD.radius * scale * 2 >= training_Image.size.x * scale then
    HD.radius = ((training_Image.size.x) - 10) / (2)
  end
  if HD.radius * scale * 2 >= training_Image.size.y * scale then
    HD.radius = ((training_Image.size.y) - 10) / (2)
  end
  
	-- Checks if theres a image corresponding to parameter
  if not love.filesystem.exists(image_Path) then
    print("It was not possible to read the Image Path")
    os.exit()
  end
  training_Image.image = love.graphics.newImage(image_Path)
  
  -- Sets image scaled
	love.window.setMode(training_Image.size.x * scale, training_Image.size.y * scale)
  canvas = love.graphics.newCanvas( )

	data:close()
end

---------------------------------UPDATING IMAGE-------------------------------------------

function love.update(dt)
  
	cursor.x = love.mouse.getX()
	cursor.y = love.mouse.getY()
	
  local border_lim = 1.25
  -- Selection wont be out from border this way!
	if (cursor.x - (HD.radius * scale)/ border_lim < 0) then
		cursor.x = (HD.radius * scale) / border_lim
	end	
	
	if (cursor.x + (HD.radius * scale) / border_lim > training_Image.size.x * scale) then
		cursor.x = (training_Image.size.x * scale) - (HD.radius * scale)/2
	end	
	
	if (cursor.y - (HD.radius * scale) / border_lim < 0) then
		cursor.y = (HD.radius * scale) / border_lim
	end	
	
	if (cursor.y + (HD.radius * scale) / border_lim > training_Image.size.y*scale) then
		cursor.y = (training_Image.size.x * scale) - (HD.radius * scale)/2
	end	
	
	if (isCircle) then			-- ESTE BLOCO NAO PERMITE QUE UM CÍRCULO SOBREESCREVA OUTRO
		for i=1, HD.numPoints do
			if((math.abs(coordX[i] - cursor.x)) <= (HD.radius * scale) and (math.abs(coordY[i] - cursor.y)) <= (HD.radius * scale)) then
				isCircle = false
			end			
		end
	   	
	   	if (isCircle) then
			HD.numPoints = HD.numPoints + 1
			coordX[HD.numPoints] = cursor.x;
			coordY[HD.numPoints] = cursor.y;
			isCircle = false
		end   	
   	end
end

---------------------------------DRAWING-------------------------------------------

function love.draw()
	love.graphics.setColor(255,255,255) 

	love.graphics.draw(training_Image.image, 0,0, 0, scale, scale)

	love.graphics.setColor(HD.color.red,HD.color.green,HD.color.blue)
	love.graphics.circle("line", cursor.x, cursor.y, (HD.radius * scale), 100)
	

	for i=1, HD.numPoints do
		love.graphics.circle("line", coordX[i], coordY[i], (HD.radius * scale), 100)
	end	   	  
end

function love.mousereleased(x, y, button)
	if button == "l" or button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
   		isCircle = true
	end
end

function love.keypressed(enter)
	love.event.quit()
end

function love.keypressed(escape)
	love.event.quit()
end

---------------------------------QUITING AND MAKING HD FILE-------------------------------------------

function love.quit()

  -- open training_Image which will be used to make the matrix
  if not love.filesystem.exists(matrix_Path) then
    print("It was not possible to read the matrix Path")
    os.exit()
  end
  
  local f = io.open(matrix_Path, "r")
  
  -- Inicialize Matrix
	local tbllines = {}
	for i = 1, training_Image.size.x do
		tbllines[i] = {}
		for j = 1, training_Image.size.y do
			tbllines[i][j] = 0
		end
	end
  
  -- read values from the Strebelle_Pixelled
	local i = 0
	local j = 0
  while j < 250 do
    j =j + 1
    n1 = 0
    for i = 1, training_Image.size.x do
      n1 = f:read(1)
      
      if n1 == nil then 
        break 
      end
      if n1 == "," then
        n1 = f:read(1)
      end
      if n1 == "\n" then
        n1 = f:read(1)
      end
      if n1 == "1" or n1 == "2" then
        tbllines[i][j] = n1
        --print("<"..i..","..j..">".." - ".. tbllines[i][j])
      end   
    end   
  end
  
  f:close()
  
  -- Counting Hard Datas
  local count = 0
  if(HD.radius >= 1) then
    for current=1, HD.numPoints do
      for j = math.floor(coordY[current]/scale) - HD.radius, math.floor(coordY[current]/scale) + HD.radius do
        for i = math.floor(coordX[current]/scale) - HD.radius, math.floor(coordX[current]/scale) + HD.radius do 
          if (math.sqrt(square(math.floor(coordX[current]/scale) - i) + square(math.floor(coordY[current]/scale) - j)) <= HD.radius) then
            if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
              count = count + 1
            end
          end
        end
      end
    end
  elseif (HD.radius < 1 and HD.radius >= 0) then
    for current=1, HD.numPoints do
      i = math.floor(coordX[current]/scale)
      j = math.floor(coordY[current]/scale)
      if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
        count = count + 1
      end
    end
  end
  
 
  
  -- print HD points in file txt
	local file = io.open(hd_directory .. "/" .. ((os.time())%100000) .. "_" .. "HD_" .. count .. ".txt", "w")
  if(HD.radius >= 1) then
    for current=1, HD.numPoints do
      print("<".. math.floor(coordX[current]/scale) ..", " .. math.floor(coordY[current]/scale) .. "> -- Point selected")
      for j = math.floor(coordY[current]/scale) - HD.radius, math.floor(coordY[current]/scale) + HD.radius do
        for i = math.floor(coordX[current]/scale) - HD.radius, math.floor(coordX[current]/scale) + HD.radius do 
          if (math.sqrt(square(math.floor(coordX[current]/scale) - i) + square(math.floor(coordY[current]/scale) - j)) <= HD.radius) then
            if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
              file:write((i) .." ".. (j) .." 0 ".. tbllines[i + 1][j + 1] .."\n")
              print((i) .." ".. (j) .." -- HD listed ") --tbllines[i][j]
            else
              print((i) .." ".. (j) .. "-- It will not be listed") --tbllines[i][j]
            end
          end
        end
      end
    end
  elseif (HD.radius < 1 and HD.radius >= 0) then
    for current=1, HD.numPoints do
      print("<".. math.floor(coordX[current]/scale) ..", " .. math.floor(coordY[current]/scale) .. "> -- Point selected")
      i = math.floor(coordX[current]/scale)
      j = math.floor(coordY[current]/scale)
      if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
        file:write((i) .." ".. (j) .." 0 ".. tbllines[i + 1][j + 1] .."\n")
        print((i) .." ".. (j) .." -- HD listed ") --tbllines[i][j]
      else
        print((i) .." ".. (j) .. "-- It will not be listed") --tbllines[i][j]
      end
    end
  end
  file:close()
  
  h = training_Image.size.y *scale
  w = training_Image.size.x *scale
  
  img =  love.graphics.newScreenshot( )
  data = img:getString()
  iData = love.image.newImageData( w, h, data )
  iData:encode( "png", hd_directory .. "/" .. ((os.time())%100000) .. "_" .. "HDimage_" .. count .. ".png" )
end

