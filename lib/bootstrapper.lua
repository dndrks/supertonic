json = require "json"

function xox(riddim)
  -- return riddim detector
  -- beat starts on 1
  return function (beat)
    beat = ((beat-1) % #riddim) + 1
    return riddim:sub(beat, beat) ~= '-'
  end
end

function os.capture(cmd,raw)
  local f=assert(io.popen(cmd,'r'))
  local s=assert(f:read('*a'))
  f:close()
  if raw then return s end
  s=string.gsub(s,'^%s+','')
  s=string.gsub(s,'%s+$','')
  s=string.gsub(s,'[\n\r]+',' ')
  return s
end

function pattern_random(density_min,density_max)
	if density_min==nil then
		density_min=0
	end
	if density_max==nil then 
		density_max=1
	end
	local density=-1
	local pattern_string=""
	while density<density_min or density>density_max do
		pattern_string = os.capture("shuf -n1 ../data/patterns.json")
		num_xs=0
		num_dashes=0
		for c in pattern_string:gmatch"." do
			if c=="-" then
				num_dashes = num_dashes + 1
			elseif c=="x" then
				num_xs=num_xs+1
			end
		end
		density = num_xs / (num_xs+num_dashes)
	end
	local p = json.decode(pattern_string)
	for k,v in pairs(p) do
		print(k,v)
	end
	return p
end

pattern_random(0,0.2)

part=xox("x---x-----x-")
for i=1,16 do 
	print(i,part(i))
end


function lines_from(file)
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

function trim(s)
   return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local file = '../data/microtonic.preset'
local lines = lines_from(file)

drum_patches=false
local patches={}
i=0
for _,line in ipairs(lines) do
	line=trim(line)
	-- print(line)
	if string.find(line,"DrumPatches") then
		drum_patches=true
	end
	if drum_patches then
		if line:find("Name")==1 then
			i=i+1
			patches[i]={}
			patches[i].name=line
		elseif line:find("OscWave")==1 then
			patches[i].oscWave=0
			if string.find(line,"Triangle") then
				patches[i].oscWave=1
			elseif string.find(line,"TODO") then
				patches[i].oscWave=2
			end
		elseif line:find("OscFreq")==1 then
			local val=0
			for num in string.gmatch( line, "[0-9]+%.[0-9]+" ) do
				val=tonumber(num)
			end
			patches[i].oscFreq=val
		elseif line:find("OscAtk")==1 then
			local val=0
			for num in string.gmatch( line, "[0-9]+%.[0-9]+" ) do
				val=tonumber(num)
			end
			patches[i].oscAtk=val
		elseif line:find("OscDcy")==1 then
			local val=0
			for num in string.gmatch( line, "[0-9]+%.[0-9]+" ) do
				val=tonumber(num)
			end
			patches[i].oscDcy=val
		elseif line:find("ModMode")==1 then
			patches[i].modMode=0
			if string.find(line,"Decay") then
				patches[i].modMode=0
			elseif string.find(line,"Sine") then
				patches[i].modMode=1
			elseif string.find(line,"Noise") then
				patches[i].modMode=2
			end
		elseif line:find("ModRate")==1 then
			local val=0
			for num in string.gmatch( line, "[0-9]+%.[0-9]+" ) do
				val=tonumber(num)
			end
			patches[i].modRate=val
			if string.find(line,"Hz") then
				patches[i].modRate=1000/val
			end
		elseif line:find("ModAmt")==1 then
			local val=0
			for num in string.gmatch( line, "[0-9]+%.[0-9]+" ) do
				val=tonumber(num)
			end
			patches[i].modAmt=val
		elseif line:find("NFilMod")==1 then
			patches[i].nFilMod=0
			if string.find(line,"LP") then
				patches[i].nFilMod=0
			elseif string.find(line,"BP") then
				patches[i].nFilMod=1
			elseif string.find(line,"HP") then
				patches[i].nFilMod=2
			end
		elseif line:find("NFilFrq")==1 then
			local val=0
			for num in string.gmatch( line, "[0-9]+%.[0-9]+" ) do
				val=tonumber(num)
			end
			patches[i].nFilFrq=val
		elseif line:find("NFilQ")==1 then
			local val=0
			for num in string.gmatch( line, "[0-9]+%.[0-9]+" ) do
				val=tonumber(num)
			end
			patches[i].nFilQ=val
		elseif line:find("NStereo")==1 then
			patches[i].nStereo=1
			if string.find(line,"Off") then
				patches[i].nStereo=0
			end
		elseif line:find("NEnvMod")==1 then
			patches[i].nEnvMod=0
			if string.find(line,"Exp") then
				patches[i].nEnvMod=0
			elseif string.find(line,"Linear") then
				patches[i].nEnvMod=1
			elseif string.find(line,'"Mod"') then
				patches[i].nEnvMod=2
			end
		elseif line:find("NEnvAtk")==1 then
			local val=0
			for num in string.gmatch( line, "[0-9]+%.[0-9]+" ) do
				val=tonumber(num)
			end
			patches[i].nEnvAtk=val
		elseif line:find("NEnvDcy")==1 then
			local val=0
			for num in string.gmatch( line, "[0-9]+%.[0-9]+" ) do
				val=tonumber(num)
			end
			patches[i].nEnvDcy=val
		elseif line:find("Mix")==1 then
			local val=0
			for num in string.gmatch( line, "[0-9]+%.[0-9]+" ) do
				val=tonumber(num)
				break
			end
			patches[i].mix=val
		elseif line:find("DistAmt")==1 then
			local val=0
			for num in string.gmatch( line, "[0-9]+%.[0-9]+" ) do
				val=tonumber(num)
			end
			patches[i].distAmt=val
		elseif line:find("EQFreq")==1 then
			local val=0
			for num in string.gmatch( line, "[0-9]+%.[0-9]+" ) do
				val=tonumber(num)
			end
			patches[i].eQFreq=val
		elseif line:find("EQGain")==1 then
			local val=0
			for num in string.gmatch( line, "[0-9]+%.[0-9]+" ) do
				val=tonumber(num)
			end
			patches[i].eQGain=val
		elseif line:find("Level")==1 then
			local val=0
			for num in string.gmatch( line, "[0-9]+%.[0-9]+" ) do
				val=tonumber(num)
			end
			patches[i].level=val
		end
	end
end

for _,p in ipairs(patches) do
	print("// "..p.name)
	print("(")
	print('Synth("nanotonic",[')
	keys={}
	for k,v in pairs(p) do
		table.insert(keys,k)
	end
	table.sort(keys)
	for _,k in ipairs(keys) do
		local v=p[k]
		if k=="name" then
		else
			print("\\"..k..","..v..",")
		end
	end
	print("]);")
	print(")")
end


for _,p in ipairs(patches) do
	print('engine.nanotonic=(')
	keys={}
	for k,v in pairs(p) do
		table.insert(keys,k)
	end
	table.sort(keys)
	for _,k in ipairs(keys) do
		local v=p[k]
		if k=="name" then
		else
			print("self.patch."..k..",")
		end
	end
	print(")")
	break
end

for _,p in ipairs(patches) do
	keys={}
	for k,v in pairs(p) do
		table.insert(keys,k)
	end
	table.sort(keys)
	for i,k in ipairs(keys) do
		local v=p[k]
		if k=="name" then
		else
			print("\\"..k..", msg["..i.."],")
		end
	end
	break
end