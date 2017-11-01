-- Program for building simple Hard Data
version = "2.5.0"

cursor = {x=0, y=0}
coordX = {}
coordY = {} 

for i=1, 10000 do
	coordX[i] = 0
	coordY[i] = 0
end

HD = {
	radius;
  defaut,
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
  rad = {}
}

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

function square(x)
	return x*x
end

---------------------------------LOADING FILES-------------------------------------------

function love.load()
  isCircleCursor = true
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
	training_Image.facies = tonumber(parameters[i])
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
  final = 0
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
  
  HD.radius = 4
  -- Selecting Colors
  if HD.radial_selection.color == 1 then ------ Red
    HD.radial_selection.red = 255
    HD.radial_selection.green = 0
    HD.radial_selection.blue = 0
  elseif HD.radial_selection.color == 2 then -- Green
    HD.radial_selection.red = 128
    HD.radial_selection.green = 255
    HD.radial_selection.blue = 0
  elseif HD.radial_selection.color == 3 then -- Orange
    HD.radial_selection.red = 255
    HD.radial_selection.green = 128
    HD.radial_selection.blue = 0
  elseif HD.radial_selection.color == 4 then -- Magenta
    HD.radial_selection.red = 204
    HD.radial_selection.green = 0
    HD.radial_selection.blue = 204
  elseif HD.radial_selection.color == 5 then -- Yellow
    HD.radial_selection.red = 255
    HD.radial_selection.green = 255
    HD.radial_selection.blue = 0
  else ---------------------------------------- Blue
    HD.radial_selection.red = 0
    HD.radial_selection.green = 255
    HD.radial_selection.blue = 255
  end
  
  if HD.pixel_selection.color == 1 then ------- Red
    HD.pixel_selection.red = 255
    HD.pixel_selection.green = 0
    HD.pixel_selection.blue = 0
  elseif HD.pixel_selection.color == 2 then --- Green
    HD.pixel_selection.red = 128               
    HD.pixel_selection.green = 255             
    HD.pixel_selection.blue = 0                
  elseif HD.pixel_selection.color == 3 then  -- Orang
    HD.pixel_selection.red = 255               
    HD.pixel_selection.green = 128             
    HD.pixel_selection.blue = 0                
  elseif HD.pixel_selection.color == 4 then  -- Magen
    HD.pixel_selection.red = 204               
    HD.pixel_selection.green = 0               
    HD.pixel_selection.blue = 204              
  elseif HD.pixel_selection.color == 5 then  -- Yello
    HD.pixel_selection.red = 255               
    HD.pixel_selection.green = 255             
    HD.pixel_selection.blue = 0                
  else ---------------------------------------- Blue
    HD.pixel_selection.red = 0
    HD.pixel_selection.green = 255
    HD.pixel_selection.blue = 255
  end
  
  
  
  
  
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
  
  HD.defaut = HD.radius
  
  training_Image.matrix = {}
  i = 1
  value = 0
  for word in love.filesystem.lines(matrix_Path) do
  	if (value > 2) then
      for w=1, training_Image.facies do
        if(tonumber(word) == w - 1) then
				training_Image.matrix[i] = word
				i = i + 1
        end
			end
		else
      value = value + 1
 		end
  end
  f:close()
	
	-- Sets image scaled
	love.window.setMode(training_Image.size.x * training_Image.scale.x + (desktop_width/8), training_Image.size.y * training_Image.scale.y)
	
end

---------------------------------UPDATING IMAGE-------------------------------------------

function love.update(dt)
  
	cursor.x = love.mouse.getX()
	cursor.y = love.mouse.getY()
	
  local border_lim = 1.25
  -- Selection wont be out from border this way!
	if (cursor.x - (HD.radius * training_Image.scale.x)/ border_lim < 0) then
		cursor.x = (HD.radius * training_Image.scale.x) / border_lim
	end	
	
	if (cursor.x + (HD.radius * training_Image.scale.x) / border_lim > training_Image.size.x * training_Image.scale.x) then
		cursor.x = (training_Image.size.x * training_Image.scale.x) - (HD.radius * training_Image.scale.x)/2
	end	
	
	if (cursor.y - (HD.radius * training_Image.scale.y) / border_lim < 0) then
		cursor.y = (HD.radius * training_Image.scale.y) / border_lim
	end	
	
	if (cursor.y + (HD.radius * training_Image.scale.y) / border_lim > training_Image.size.y * training_Image.scale.y) then
		cursor.y = (training_Image.size.y * training_Image.scale.y) - (HD.radius * training_Image.scale.y)/2
	end	
	
	if (isCircle) then			-- ESTE BLOCO NAO PERMITE QUE UM CÍRCULO SOBREESCREVA OUTRO
		for i=1, HD.numPoints do
			if( (math.abs(coordX[i] - cursor.x))     <= (HD.radius * training_Image.scale.x) and
         	    (math.abs(coordY[i] - cursor.y)) <= (HD.radius * training_Image.scale.y) ) then
				isCircle = false
			end			
		end
	   	
	   	if (isCircle) then
			HD.numPoints = HD.numPoints + 1
			coordX[HD.numPoints] = cursor.x;
			coordY[HD.numPoints] = cursor.y;
      HD.rad[HD.numPoints] = HD.radius;
			isCircle = false
		end   	
   	end
end

---------------------------------DRAWING-------------------------------------------


function love.draw()
	
  
  HD.color = math.floor(255/(training_Image.facies - 1))
	--draw training image as a matrix.
	for j=1, training_Image.size.y do
		for i=1, training_Image.size.x do
      for w=1, training_Image.facies do
        if (tonumber(training_Image.matrix[i + ((training_Image.size.y - j) * training_Image.size.x) + (training_Image.image * (training_Image.size.x * training_Image.size.y))]) == w - 1) then
        	love.graphics.setColor(HD.color * (w - 1), HD.color * (w - 1), HD.color * (w - 1))
        end
      end
       		love.graphics.rectangle("fill", (i-1)*training_Image.scale.x, (j-1)*training_Image.scale.y, training_Image.scale.x,training_Image.scale.y)
    end
	end
  
  for i=1, HD.numPoints do
    if (HD.rad[i] <= 1) then
      love.graphics.setColor(HD.pixel_selection.red,HD.pixel_selection.green,HD.pixel_selection.blue)
      love.graphics.rectangle("line", math.floor(coordX[i] - training_Image.scale.x/2), math.floor(coordY[i] - training_Image.scale.y/2), training_Image.scale.x, training_Image.scale.y)
    else
      love.graphics.setColor(HD.radial_selection.red,HD.radial_selection.green,HD.radial_selection.blue)
      love.graphics.ellipse("line", coordX[i], coordY[i], math.floor(HD.rad[i] * training_Image.scale.x), math.floor(HD.rad[i] * training_Image.scale.y))
    end
	end
  
  
  
  
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------
  if isCircleCursor then
    -- PRINT
    if (HD.radius <= 1) then
        love.graphics.setColor(HD.pixel_selection.red,HD.pixel_selection.green,HD.pixel_selection.blue)
        love.graphics.rectangle("line", math.floor(cursor.x - training_Image.scale.x/2), math.floor(cursor.y - training_Image.scale.x/2), training_Image.scale.x, training_Image.scale.y)
      else
        love.graphics.setColor(HD.radial_selection.red,HD.radial_selection.green,HD.radial_selection.blue)
        love.graphics.ellipse("line", cursor.x, cursor.y, math.floor(HD.radius * training_Image.scale.x), math.floor(HD.radius * training_Image.scale.y))
      end
    
    distance = HD.radius
    if(distance <= 1) then
      distance = 1
    end
    
    
  	if math.floor(cursor.x/training_Image.scale.x) > 230 and math.floor(cursor.y/training_Image.scale.y) > 240 then
  		love.graphics.print(math.floor(cursor.x/training_Image.scale.x).. ", "..math.floor(cursor.y/training_Image.scale.y), cursor.x - 2.75 * distance * training_Image.scale.x, cursor.y - 1.75 * distance * training_Image.scale.y)
  	elseif math.floor(cursor.x/training_Image.scale.x) > 230 and math.floor(cursor.y/training_Image.scale.y) <= 240 then
		love.graphics.print(math.floor(cursor.x/training_Image.scale.x).. ", "..math.floor(cursor.y/training_Image.scale.y), cursor.x - 2.75 * distance * training_Image.scale.x, cursor.y + distance * training_Image.scale.y)
  	elseif math.floor(cursor.x/training_Image.scale.x) <= 230 and math.floor(cursor.y/training_Image.scale.y) > 240 then
  		love.graphics.print(math.floor(cursor.x/training_Image.scale.x).. ", "..math.floor(cursor.y/training_Image.scale.y), cursor.x + distance * training_Image.scale.x, cursor.y - 1.75 * distance * training_Image.scale.y)
  	else
  		love.graphics.print(math.floor(cursor.x/training_Image.scale.x).. ", "..math.floor(cursor.y/training_Image.scale.y), cursor.x + distance * training_Image.scale.x, cursor.y + distance * training_Image.scale.y)
  	end
    
  else ------ FINISHING PROGRAM
  	imgIsCreated = true
    interface()
    img =  love.graphics.newScreenshot()
		love.graphics.clear(255, 255, 255)
    
		-- print table
    local i = training_Image.Pattern
    local j = training_Image.Pattern
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("0", training_Image.scale.x, training_Image.scale.y)
    while i < training_Image.size.x do 
      love.graphics.setColor(0, 0, 0)
      love.graphics.print(i, training_Image.scale.x, j*training_Image.scale.y + 1)
      love.graphics.print(j, i * training_Image.scale.x + 1, training_Image.scale.y)
      love.graphics.setColor(210,210,210)
      love.graphics.line(0, j*training_Image.scale.y, training_Image.size.x*training_Image.scale.x, j*training_Image.scale.y)
      love.graphics.line(i*training_Image.scale.x, 0, i*training_Image.scale.x, training_Image.size.x*training_Image.scale.x)
      love.graphics.line(0, j*training_Image.scale.y - training_Image.overlap * training_Image.scale.y, training_Image.size.x*training_Image.scale.x, j*training_Image.scale.y - training_Image.overlap * training_Image.scale.y)
      love.graphics.line(i*training_Image.scale.x - training_Image.overlap * training_Image.scale.x, 0, i*training_Image.scale.x - training_Image.overlap * training_Image.scale.x, training_Image.size.x*training_Image.scale.x)
      i = i + training_Image.Pattern - training_Image.overlap
      j = j + training_Image.Pattern - training_Image.overlap
    end    
    
		
		-- Counting Hard Datas
  	local count = 0
    for current=1, HD.numPoints do
      
  	  distance = HD.rad[current]
      if (distance <= 1) then
        distance = 1 
      end
      
        love.graphics.setColor(255,0,0)

        if math.floor(coordX[current]/training_Image.scale.x) > 230 and math.floor(coordY[current]/training_Image.scale.y) > 240 then
  			love.graphics.print(math.floor(coordX[current]/training_Image.scale.x).. ", "..math.floor(coordY[current]/training_Image.scale.y), coordX[current] - 2.75 * distance * training_Image.scale.x, coordY[current] - 1.75 * distance * training_Image.scale.y)
  		elseif math.floor(coordX[current]/training_Image.scale.x) > 230 and math.floor(coordY[current]/training_Image.scale.y) <= 240 then
			love.graphics.print(math.floor(coordX[current]/training_Image.scale.x).. ", "..math.floor(coordY[current]/training_Image.scale.y), coordX[current] - 2.75 * distance * training_Image.scale.x, coordY[current] + distance * training_Image.scale.y)
  		elseif math.floor(coordX[current]/training_Image.scale.x) <= 230 and math.floor(coordY[current]/training_Image.scale.y) > 240 then
  			love.graphics.print(math.floor(coordX[current]/training_Image.scale.x).. ", "..math.floor(coordY[current]/training_Image.scale.y), coordX[current] + distance * training_Image.scale.x, coordY[current] - 1.75 * distance * training_Image.scale.y)
  		else
  			love.graphics.print(math.floor(coordX[current]/training_Image.scale.x).. ", "..math.floor(coordY[current]/training_Image.scale.y), coordX[current] + distance * training_Image.scale.x, coordY[current] + distance * training_Image.scale.y)
  		end
      if(math.floor(HD.rad[current]) > 1) then
  	    for j = math.floor(coordY[current]/training_Image.scale.y - HD.rad[current]), math.floor(coordY[current]/training_Image.scale.y + HD.rad[current]) do
  	      for i = math.floor(coordX[current]/training_Image.scale.x - HD.rad[current]), math.floor(coordX[current]/training_Image.scale.x + HD.rad[current]) do 
  	        if (math.sqrt(square(coordX[current]/training_Image.scale.x - i) + square(coordY[current]/training_Image.scale.y - j)) < HD.rad[current]) then
  	          if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
  	            count = count + 1
                HD.color = math.floor(255/(training_Image.facies - 1))
                for w=1, training_Image.facies do
                  if (tonumber(training_Image.matrix[i+1 + ((training_Image.size.y - (j + 1)) * training_Image.size.x) + (training_Image.image * (training_Image.size.x * training_Image.size.y))]) == w - 1) then
                    love.graphics.setColor(HD.color * (w - 1), 0, 255 - HD.color * (w - 1))
                  end
                end
                love.graphics.rectangle("fill", i*training_Image.scale.x, j*training_Image.scale.y, training_Image.scale.x, training_Image.scale.y)
  	          end
  	        end
  	      end
  	    end
      elseif (math.floor(HD.rad[current]) <= 1) then
  	    i = math.floor(coordX[current]/training_Image.scale.x)
  	    j = math.floor(coordY[current]/training_Image.scale.y)
  	    if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
  	      count = count + 1
          HD.color = math.floor(255/(training_Image.facies - 1))
            for w=1, training_Image.facies do
              if (tonumber(training_Image.matrix[i+1 + ((training_Image.size.y - (j + 1)) * training_Image.size.x) + (training_Image.image * (training_Image.size.x * training_Image.size.y))]) == w - 1) then
                love.graphics.setColor(HD.color * (w - 1), 0, 255 - HD.color * (w - 1))
              end
            end
          love.graphics.rectangle("fill", i*training_Image.scale.x, j*training_Image.scale.y, training_Image.scale.x,training_Image.scale.y)
  	    end
  	  end
  	end
    interface()
		HD_img =  love.graphics.newScreenshot( )
		
    love.event.quit()
 end
 
  interface()
    
end

function interface ()
  prt_size = 0.17
  love.graphics.setColor(255, 130, 0)
  love.graphics.rectangle("fill", training_Image.size.x * training_Image.scale.x, 0, ((desktop_width/8)), training_Image.size.y * training_Image.scale.y)
  
  love.graphics.setColor(50, 50, 50)
  love.graphics.rectangle("fill", training_Image.size.x * training_Image.scale.x + 10, 10, ((desktop_width/8) - 20), training_Image.size.y * training_Image.scale.y - 20)
  
  love.graphics.setColor(230, 230, 230)
  love.graphics.rectangle("fill", training_Image.size.x * training_Image.scale.x + 20, 20, ((desktop_width/8) - 40), training_Image.size.y * training_Image.scale.y - 40)
  
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("line", training_Image.size.x * training_Image.scale.x + 20, 20, ((desktop_width/8) - 40), training_Image.size.y * training_Image.scale.y - 40)
  
  local pox = (desktop_height / 80)
  love.graphics.setColor(255, 128, 0)
  love.graphics.print("HD GENERATOR ", training_Image.size.x * training_Image.scale.x + 70, 20 + pox)
  
  pox = pox + (desktop_height / 80) * 2
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("IMAGE FILE: ", training_Image.size.x * training_Image.scale.x + 80, 20 + pox)
  
  pox = pox + (desktop_height / 80)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print(matrix_name, training_Image.size.x * training_Image.scale.x + 30, 20 + pox)
  
  pox = pox + (desktop_height / 80) * 2
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("IMAGE SIZE: ", training_Image.size.x * training_Image.scale.x + 80, 20 + pox)
  
  pox = pox + (desktop_height / 80)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("X: " .. training_Image.size.x, training_Image.size.x * training_Image.scale.x + 30, 20 + pox)
  
  pox = pox + (desktop_height / 80)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Y: " .. training_Image.size.y, training_Image.size.x * training_Image.scale.x + 30, 20 + pox)
  
  pox = pox + (desktop_height / 80)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Z: " .. training_Image.size.z, training_Image.size.x * training_Image.scale.x + 30, 20 + pox)
  
  
  pox = pox + (desktop_height / 80) * 2
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("HD POINTS: " .. HD.numPoints, training_Image.size.x * training_Image.scale.x + 30, 20 + pox)
  
  pox = pox + (desktop_height / 80)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("MODE: ", training_Image.size.x * training_Image.scale.x + 30, 20 + pox)
  
  if HD.radius < 1 then
    love.graphics.print("Pixel", training_Image.size.x * training_Image.scale.x + 85, 20 + pox)
  else
    love.graphics.print("Radial", training_Image.size.x * training_Image.scale.x + 85, 20 + pox)
  end
  pox = pox + (desktop_height / 80)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("RADIUS SIZE: ".. math.floor(HD.radius), training_Image.size.x * training_Image.scale.x + 30, 20 + pox)
  
  pox = pox + (desktop_height / 80)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("PATTERN SIZE: ".. training_Image.Pattern, training_Image.size.x * training_Image.scale.x + 30, 20 + pox)
  
  pox = pox + (desktop_height / 80)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("OVERLAP SIZE: ".. training_Image.overlap, training_Image.size.x * training_Image.scale.x + 30, 20 + pox)
  
  pox = pox + (desktop_height / 80) * 2
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("CURSOR POSITION: ", training_Image.size.x * training_Image.scale.x + 60, 20 + pox)
  
  pox = pox + (desktop_height / 80)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("X: " .. math.floor(cursor.x/training_Image.scale.x), training_Image.size.x * training_Image.scale.x + 30, 20 + pox)
  
  pox = pox + (desktop_height / 80)
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("Y: " .. math.floor(cursor.y/training_Image.scale.y), training_Image.size.x * training_Image.scale.x + 30, 20 + pox)
  
  pox = pox + (desktop_height / 80) * 2
  love.graphics.setColor(0, 0, 0)
  love.graphics.print("HEIGHT (axi Z): " .. training_Image.image, training_Image.size.x * training_Image.scale.x + 30, 20 + pox)
  
  
end

  

function love.mousereleased(x, y, button)
	if button == "l" or button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
    isCircle = true
		HDwasSelected = true
	elseif button == "r" or button == 2 then
    if(HD.radius > 1) then
      HD.defaut = HD.radius
      HD.radius = 0.9
    else
      HD.radius = HD.defaut
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

function love.keypressed(key)
  if key == "return" or key == "escape" then
    isCircleCursor = false
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
  
end

---------------------------------QUITING AND MAKING HD FILE-------------------------------------------

function love.quit()
    if(HDwasSelected) then
      -- Counting Hard Datas
      local count = 0
        for current=1, HD.numPoints do
          if(math.floor(HD.rad[current]) > 1) then
            for j = math.floor(coordY[current]/training_Image.scale.y - HD.rad[current]), math.floor(coordY[current]/training_Image.scale.y + HD.rad[current]) do
              for i = math.floor(coordX[current]/training_Image.scale.x - HD.rad[current]), math.floor(coordX[current]/training_Image.scale.x + HD.rad[current]) do 
                if (math.sqrt(square(coordX[current]/training_Image.scale.x - i) + square(coordY[current]/training_Image.scale.y - j)) < HD.rad[current]) then
                  if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
                    count = count + (1 * training_Image.size.z)
                  end
                end
              end
            end
          elseif (math.floor(HD.rad[current]) <= 1) then
            i = math.floor(coordX[current]/training_Image.scale.x)
            j = math.floor(coordY[current]/training_Image.scale.y)
            if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
              count = count + (1 * training_Image.size.z)
            end
          end
        end
    -- Create the Directories and save the image and the HD_list
      time = (os.time()%1000000)
      directory = ("HardData/" .. time .."_".. "HD_".. count)
      love.filesystem.createDirectory( directory )
    
    if imgIsCreated then
        img:encode('png', directory .. "/" .. time .. "_HDimage_"..count..'.png')
        HD_img:encode('png', directory .. "/" .. time .. "_HDpoints_"..count..'.png')
      end
      
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
        print("<".. math.floor(coordX[current]/training_Image.scale.x) ..", " .. math.floor(coordY[current]/training_Image.scale.y) .. "> -- Point selected")
        if(math.floor(HD.rad[current]) > 1) then
          for k = 1, training_Image.size.z do
            for j = math.floor(coordY[current]/training_Image.scale.y) - math.floor(HD.rad[current]), math.floor(coordY[current]/training_Image.scale.y) + math.floor(HD.rad[current]) do
              for i = math.floor(coordX[current]/training_Image.scale.x) - math.floor(HD.rad[current]), math.floor(coordX[current]/training_Image.scale.x) + math.floor(HD.rad[current]) do 
                if (math.sqrt(square(math.floor(coordX[current]/training_Image.scale.x) - i) + square(math.floor(coordY[current]/training_Image.scale.y) - j)) < math.floor(HD.rad[current])) then
                  if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
                    if (tonumber(training_Image.matrix[i+1 + ((training_Image.size.y - (j + 1)) * training_Image.size.x) + ((k - 1) * (training_Image.size.x * training_Image.size.y))]) == nil) then
                      print(i .." "..j.." "..k.. " EH NULO")
                    else
                      file:write(i .." ".. j .." "..(k - 1).." "..( tonumber(training_Image.matrix[i+1 + ((training_Image.size.y - (j + 1)) * training_Image.size.x) + ((k - 1) * (training_Image.size.x * training_Image.size.y))]) + 1 ).."\r\n")
                      --print((i + 1) .." ".. (j + 1) .." -- HD listed ") --training_Image.matrix[i][j]
                    end
                  end
                end
              end
            end
          end
        elseif (math.floor(HD.rad[current]) <= 1) then
          i = math.floor(coordX[current]/training_Image.scale.x)
          j = math.floor(coordY[current]/training_Image.scale.y)
          for k = 1, training_Image.size.z do
            if ((i < training_Image.size.x ) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
              if (tonumber(training_Image.matrix[i+1 + ((training_Image.size.y - (j + 1)) * training_Image.size.x) + ((k - 1) * (training_Image.size.x * training_Image.size.y))]) == nil) then
                print(i .." "..j.." "..k.. "EH NULO")
              else
                file:write(i .." ".. j .." "..(k - 1).." "..( tonumber(training_Image.matrix[i+1 + ((training_Image.size.y - (j + 1)) * training_Image.size.x) + ((k - 1) * (training_Image.size.x * training_Image.size.y))]) + 1 ).."\r\n")
                --print((i + 1) .." ".. (j + 1) .." -- HD listed ") --training_Image.matrix[i][j]
              end
            end
          end
        end
      end
    file:close()
 end
end

