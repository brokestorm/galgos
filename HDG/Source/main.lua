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
  scale
  defaut,
  color = 255;
  selection = {
    red,
    green,
    blue
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
  facies
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
  countDontExists = true
  accessible =  love.filesystem.mount('HD_Generator', "HD_Generator")
  love.window.setTitle("HD Generator - " .. version)
  
	data = love.filesystem.newFile("HD_config.txt")
	data:open("r")
	
	local i = 1
	local parameters = {}
	
	for word in love.filesystem.lines("HD_config.txt") do
		parameters[i] = word
		i = i + 1
	end
	
  
  local x = 0
	--image_Path = (parameters[x + 2])
	x = x + 2
	matrix_Path = (parameters[x])
	x = x + 2
	matrix_extension = (parameters[x])
	x = x + 2
	training_Image.facies = tonumber(parameters[x])
	x = x + 2
	training_Image.size.x = tonumber(parameters[x])
	x = x + 2
	training_Image.size.y = tonumber(parameters[x])
	x = x + 2
	training_Image.size.z = tonumber(parameters[x])
	x = x + 2
	window_Width = tonumber(parameters[x])
	x = x + 2
	window_Height = tonumber(parameters[x])
	x = x + 2
	HD.radius = tonumber(parameters[x])
	x = x + 2  
	HD.selection.red = tonumber(parameters[x])
	x = x + 2
	HD.selection.green = tonumber(parameters[x])
	x = x + 2
	HD.selection.blue = tonumber(parameters[x])
	x = x + 2
	training_Image.Pattern = tonumber(parameters[x])
	x = x + 2
	training_Image.overlap = tonumber(parameters[x])
  
	
  
  -- Adjusting Color to a maximum
  if(HD.selection.red > 255) then
    HD.selection.red = 255
  end
  if(HD.selection.green > 255) then
    HD.selection.green = 255
  end
  if(HD.selection.blue > 255) then
    HD.selection.blue = 255
  end
  

    training_Image.scale.y = (window_Height) / training_Image.size.y
    training_Image.scale.x = (window_Width) / training_Image.size.y
  
  -- Adjusting scale to a maximum
  desktop_width, desktop_height = love.window.getDesktopDimensions(1)
  if training_Image.size.x * training_Image.scale.x >= desktop_width then
    training_Image.scale.x = (desktop_width) / training_Image.size.x
  end
  if training_Image.size.y * training_Image.scale.y >= desktop_height then
    training_Image.scale.y = (desktop_height - 90) / training_Image.size.y
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
  data:close()
  
	 -- Checks if theres a image corresponding to parameter
  --if not love.filesystem.exists(image_Path) then
 --   print("It was not possible to read the Image Path")
 --   os.exit()
 -- end
  --training_Image.image = love.graphics.newImage(image_Path)
  
  
  -- open training_Image which will be used to make the matrix
    local f = love.filesystem.newFile(matrix_Path)
  	f:open("r")
   --f (matrix_extension == "csv" or "txt") then
  	--	-- Inicialize Matrix
		--training_Image.matrix = {}
		--for i = 1, training_Image.size.x do
		--	training_Image.matrix[i] = {}
		--	for j = 1, training_Image.size.y do
		--		training_Image.matrix[i][j] = 0
		--	end
		--end
  	--
 	 ---- read values from the Strebelle_Pixelled
		--local i = 0
		--local j = 0
   --	local w = 0
  	--	while j < training_Image.size.y do
  	--		j =j + 1
   --  		i = 0
   --  		n1 = 0
  	--  		while i < training_Image.size.x  do
  	--    		i = i + 1
   --    		n1 = f:read(1)
  	--    
  	--    		if n1 == nil then 
   --     	 	--print("We have an error in: <"..i..","..j..">" .. "\n")
   --     	 	break end
   --      
   --    		if n1 == '1' or n1 == '2' then
  	--      		training_Image.matrix[i][j] = n1
   --      		--print("<"..i..","..j..">".." - ".. n1)
  	--    		else
   --      			i = i - 1
   --    		end
   --    
  	--  		end
   --  		--print(j)
   --  
  	--	end
  	--else
  		training_Image.matrix = {}
  		i = 1
  		value = false
  		for word in love.filesystem.lines(matrix_Path) do
  			if (value == true) then
				if((tonumber(word) == 1) or (tonumber(word) == 0)) then
					training_Image.matrix[i] = word
					i = i + 1
				end
			elseif word == "v" then
				value = true
 			end
		--end

end

		--training_Image.matrix = {}
		--for word in love.filesystem.lines(matrix_path) do
		--	training_Image.matrix[i] = word
		--	i = i+1
			
	--	end
  --
  	f:close()
	
	-- Sets image scaled
	love.window.setMode(training_Image.size.x * training_Image.scale.x, training_Image.size.y * training_Image.scale.y)
	
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
        if (tonumber(training_Image.matrix[i + (j - 1) * 50]) == w - 1) then
        	love.graphics.setColor(HD.color * (w - 1), HD.color * (w - 1), HD.color * (w - 1))
        end
       		love.graphics.rectangle("fill", (i-1)*training_Image.scale.x, (j-1)*training_Image.scale.y, training_Image.scale.x,training_Image.scale.y)
      end
		end
	end
		
--	love.graphics.draw(training_Image.image, 0,0, 0, scale, scale)

	love.graphics.setColor(HD.selection.red,HD.selection.green,HD.selection.blue)
  
  for i=1, HD.numPoints do
		love.graphics.circle("line", coordX[i], coordY[i], math.floor(HD.rad[i] * scale), 100)
	end	  
  
  if isCircleCursor then
  	if math.floor(cursor.x/scale) > 230 and math.floor(cursor.y/scale) > 240 then
  		love.graphics.print(math.floor(cursor.x/scale).. ", "..math.floor(cursor.y/scale), cursor.x - 2.75 * HD.radius * scale, cursor.y - 1.75 * HD.radius * scale)
  	elseif math.floor(cursor.x/scale) > 230 and math.floor(cursor.y/scale) <= 240 then
		love.graphics.print(math.floor(cursor.x/scale).. ", "..math.floor(cursor.y/scale), cursor.x - 2.75 * HD.radius * scale, cursor.y + HD.radius * scale)
  	elseif math.floor(cursor.x/scale) <= 230 and math.floor(cursor.y/scale) > 240 then
  		love.graphics.print(math.floor(cursor.x/scale).. ", "..math.floor(cursor.y/scale), cursor.x + HD.radius * scale, cursor.y - 1.75 * HD.radius * scale)
  	else
  		love.graphics.print(math.floor(cursor.x/scale).. ", "..math.floor(cursor.y/scale), cursor.x + HD.radius * scale, cursor.y + HD.radius * scale)
  	end

    love.graphics.circle("line", cursor.x, cursor.y, (HD.radius * scale), 100)
  else
  	imgIsCreated = true
    img =  love.graphics.newScreenshot()
		love.graphics.clear(255, 255, 255)
    
		-- print table
    local i = training_Image.Pattern
    local j = training_Image.Pattern
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("0", scale, scale)
    while i < training_Image.size.x do 
      love.graphics.setColor(0, 0, 0)
      love.graphics.print(i, scale, j*scale + 1)
      love.graphics.print(j, i * scale + 1, scale)
      love.graphics.setColor(210,210,210)
      love.graphics.line(0, j*scale, training_Image.size.x*scale, j*scale)
      love.graphics.line(i*scale, 0, i*scale, training_Image.size.x*scale)
      love.graphics.line(0, j*scale - training_Image.overlap * scale, training_Image.size.x*scale, j*scale - training_Image.overlap * scale)
      love.graphics.line(i*scale - training_Image.overlap * scale, 0, i*scale - training_Image.overlap * scale, training_Image.size.x*scale)
      i = i + training_Image.Pattern - training_Image.overlap
      j = j + training_Image.Pattern - training_Image.overlap
    end    
    
		
		-- Counting Hard Datas
  	local count = 0
    for current=1, HD.numPoints do
      
  	  
        love.graphics.setColor(255,0,0)

        if math.floor(coordX[current]/scale) > 230 and math.floor(coordY[current]/scale) > 240 then
  			love.graphics.print(math.floor(coordX[current]/scale).. ", "..math.floor(coordY[current]/scale), coordX[current] - 2.75 * math.floor(HD.rad[current]) * scale, coordY[current] - 1.75 * math.floor(HD.rad[current]) * scale)
  		elseif math.floor(coordX[current]/scale) > 230 and math.floor(coordY[current]/scale) <= 240 then
			love.graphics.print(math.floor(coordX[current]/scale).. ", "..math.floor(coordY[current]/scale), coordX[current] - 2.75 * math.floor(HD.rad[current]) * scale, coordY[current] + math.floor(HD.rad[current]) * scale)
  		elseif math.floor(coordX[current]/scale) <= 230 and math.floor(coordY[current]/scale) > 240 then
  			love.graphics.print(math.floor(coordX[current]/scale).. ", "..math.floor(coordY[current]/scale), coordX[current] + math.floor(HD.rad[current]) * scale, coordY[current] - 1.75 * math.floor(HD.rad[current]) * scale)
  		else
  			love.graphics.print(math.floor(coordX[current]/scale).. ", "..math.floor(coordY[current]/scale), coordX[current] + math.floor(HD.rad[current]) * scale, coordY[current] + math.floor(HD.rad[current]) * scale)
  		end
      if(math.floor(HD.rad[current]) >= 1) then
  	    for j = math.floor(coordY[current]/scale) - math.floor(HD.rad[current]), math.floor(coordY[current]/scale) + math.floor(HD.rad[current]) do
  	      for i = math.floor(coordX[current]/scale) - math.floor(HD.rad[current]), math.floor(coordX[current]/scale) + math.floor(HD.rad[current]) do 
  	        if (math.sqrt(square(math.floor(coordX[current]/scale) - i) + square(math.floor(coordY[current]/scale) - j)) < math.floor(HD.rad[current])) then
  	          if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
  	            count = count + 1
                 love.graphics.setColor(0,0,255)
                 if (tonumber(training_Image.matrix[i+1 + (j * 50)]) == 1) then
                   love.graphics.setColor(0,255,0)
                 end
                 love.graphics.rectangle("fill", i*scale, j*scale, scale, scale)
  	          end
  	        end
  	      end
  	    end
      elseif (math.floor(HD.rad[current]) < 1 and math.floor(HD.rad[current]) >= 0) then
  	    i = math.floor(coordX[current]/scale)
  	    j = math.floor(coordY[current]/scale)
  	    if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
  	      count = count + 1
           love.graphics.setColor(0,0,255)
           if (tonumber(training_Image.matrix[i + 1 + (j * 50)]) == 1) then
             love.graphics.setColor(0,255,0)
           end
           love.graphics.rectangle("fill", i*scale, j*scale, scale,scale)
  	    end
  	  end
  	end
    countDontExists = false
		HD_img =  love.graphics.newScreenshot( )
		
    love.event.quit()
 end
  
end



function love.mousereleased(x, y, button)
	if button == "l" or button == 1 then -- Versions prior to 0.10.0 use the MouseConstant 'l'
    isCircle = true
		HDwasSelected = true
	elseif button == "r" or button == 2 then
    if(HD.radius > 1) then
      HD.defaut = HD.radius
      HD.radius = 0.5
    else
      HD.radius = HD.defaut
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
    
  end
end

function love.wheelmoved(x, y)
    if y > 0 then
        HD.radius = HD.radius + 1
    elseif y < 0 then 
        HD.radius = HD.radius - 1
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
end

function love.keypressed(key)
  if key == "return" or key == "escape" then
    isCircleCursor = false
  end
end

---------------------------------QUITING AND MAKING HD FILE-------------------------------------------

function love.quit()
    if(HDwasSelected) then
      -- Counting Hard Datas
      local count = 0
    									 if (training_Image.size.z > 0) then --------------------------------	3D IMAGES	----------------------------------
        for current=1, HD.numPoints do
          if(math.floor(HD.rad[current]) >= 1) then
            for j = math.floor(coordY[current]/scale) - math.floor(HD.rad[current]), math.floor(coordY[current]/scale) + math.floor(HD.rad[current]) do
              for i = math.floor(coordX[current]/scale) - math.floor(HD.rad[current]), math.floor(coordX[current]/scale) + math.floor(HD.rad[current]) do 
                if (math.sqrt(square(math.floor(coordX[current]/scale) - i) + square(math.floor(coordY[current]/scale) - j)) < math.floor(HD.rad[current])) then
                  if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
                    count = count + (1 * training_Image.size.z)
                  end
                end
              end
            end
          elseif (math.floor(HD.rad[current]) < 1 and math.floor(HD.rad[current]) >= 0) then
            i = math.floor(coordX[current]/scale)
            j = math.floor(coordY[current]/scale)
            if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
              count = count + (1 * training_Image.size.z)
            end
          end
        end
         ----------------------------------------------------------------------------------------------	2D IMAGES	------------------------------
      									else
		

        for current=1, HD.numPoints do
          if(math.floor(HD.rad[current]) >= 1) then
            for j = math.floor(coordY[current]/scale) - math.floor(HD.rad[current]), math.floor(coordY[current]/scale) + math.floor(HD.rad[current]) do
              for i = math.floor(coordX[current]/scale) - math.floor(HD.rad[current]), math.floor(coordX[current]/scale) + math.floor(HD.rad[current]) do 
                if (math.sqrt(square(math.floor(coordX[current]/scale) - i) + square(math.floor(coordY[current]/scale) - j)) < math.floor(HD.rad[current])) then
                  if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
                    count = count + 1
                  end
                end
              end
            end
          elseif (math.floor(HD.rad[current]) < 1 and math.floor(HD.rad[current]) >= 0) then
            i = math.floor(coordX[current]/scale)
            j = math.floor(coordY[current]/scale)
            if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
              count = count + 1
            end
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
								      if (training_Image.size.z > 0) then --------------------------------	3D IMAGES	----------------------------------

      for current=1, HD.numPoints do
        print("<".. math.floor(coordX[current]/scale) ..", " .. math.floor(coordY[current]/scale) .. "> -- Point selected")
        if(math.floor(HD.rad[current]) >= 1) then
          for k = 1, training_Image.size.z do
            for j = math.floor(coordY[current]/scale) - math.floor(HD.rad[current]), math.floor(coordY[current]/scale) + math.floor(HD.rad[current]) do
              for i = math.floor(coordX[current]/scale) - math.floor(HD.rad[current]), math.floor(coordX[current]/scale) + math.floor(HD.rad[current]) do 
                if (math.sqrt(square(math.floor(coordX[current]/scale) - i) + square(math.floor(coordY[current]/scale) - j)) < math.floor(HD.rad[current])) then
                  if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
                    if (tonumber(training_Image.matrix[i+1 + (j * 50) + ((k - 1)* 2500)]) == nil) then
                      print(i .." "..j.." "..k.. " EH NULO")
                    else
                      file:write(i .." ".. j .." "..(k - 1).." "..( tonumber(training_Image.matrix[i+1 + (j * 50) + ((k - 1)* 2500)]) + 1 ).."\r\n")
                      --print((i + 1) .." ".. (j + 1) .." -- HD listed ") --training_Image.matrix[i][j]
                    end
                  end
                end
              end
            end
          end
        elseif (math.floor(HD.rad[current]) < 1 and math.floor(HD.rad[current]) >= 0) then
          i = math.floor(coordX[current]/scale)
          j = math.floor(coordY[current]/scale)
          for k = 1, training_Image.size.z do
            if ((i < training_Image.size.x ) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
              if (tonumber(training_Image.matrix[i+1 + (j * 50) + ((k - 1)* 2500)]) == nil) then
                print(i .." "..j.." "..k.. "EH NULO")
              else
                file:write(i .." ".. j .." "..(k - 1).." "..( tonumber(training_Image.matrix[i+1 + (j * 50) + ((k - 1)* 2500)]) + 1 ).."\r\n")
                --print((i + 1) .." ".. (j + 1) .." -- HD listed ") --training_Image.matrix[i][j]
              end
            end
          end
        end
      end

      ----------------------------------------------------------------------------------------------	2D IMAGES	------------------------------
      								else

      for current=1, HD.numPoints do
        print("<".. math.floor(coordX[current]/scale) ..", " .. math.floor(coordY[current]/scale) .. "> -- Point selected")
        if(math.floor(HD.rad[current]) >= 1) then
          for j = math.floor(coordY[current]/scale) - math.floor(HD.rad[current]), math.floor(coordY[current]/scale) + math.floor(HD.rad[current]) do
            for i = math.floor(coordX[current]/scale) - math.floor(HD.rad[current]), math.floor(coordX[current]/scale) + math.floor(HD.rad[current]) do 
              if (math.sqrt(square(math.floor(coordX[current]/scale) - i) + square(math.floor(coordY[current]/scale) - j)) < math.floor(HD.rad[current])) then
                if ((i < training_Image.size.x) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
                    file:write(i .." ".. j .." 0 ".. training_Image.matrix[i+1][j+1] .."\r\n")
                  	--print((i + 1) .." ".. (j + 1) .." -- HD listed ") --training_Image.matrix[i][j]
                end
              end
            end
          end
        elseif (math.floor(HD.rad[current]) < 1 and math.floor(HD.rad[current]) >= 0) then
          print("<".. math.floor(coordX[current]/scale) ..", " .. math.floor(coordY[current]/scale) .. "> -- Point selected")
          i = math.floor(coordX[current]/scale)
          j = math.floor(coordY[current]/scale)
          if ((i < training_Image.size.x ) and (i >= 0) and (j < training_Image.size.y) and j >= 0) then
            file:write(i .." ".. j .." 0 ".. training_Image.matrix[i+1][j+1] .."\n")
            --print((i + 1) .." ".. (j + 1) .." -- HD listed ") --training_Image.matrix[i][j]
          end
        end
      end
      
                  end
    file:close()
 end
end

