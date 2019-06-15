function table.shuffle(t)
	math.randomseed( os.time() )
	local rand = math.random 
	
	for i = #t, 2, -1 do
		local j = rand(i)
		t[i], t[j] = t[j], t[i]
	end
end

function table.shallowcopy(orig)
	local orig_type = type(orig)
	local copy

	if orig_type == "table" then
		copy = {}

		for k, v in pairs(orig) do
			copy[k] = v
		end
	else
		copy = orig
	end

	return copy
end

function table.deepcopy(orig)
	local orig_type = type(orig)
	local copy
	
	if orig_type == 'table' then
		copy = {}
		
		for k, v in next, orig, nil do
			copy[table.deepcopy(k)] = table.deepcopy(v)
		end
		
		setmetatable(copy, table.deepcopy(getmetatable(orig)))
	else
		copy = orig
	end

	return copy
end

function table.isKeyExists(t, key)
	local isExists = false

	for k, v in pairs(t) do
		if k == key then
			isExists = true
			break
		end
	end

	return isExists
end

function table.isValueExists(t, value)
	local isExists = false
	
	for k, v in pairs(t) do
		if v == value then
			isExists = true
			break
		end
	end

	return isExists
end

function table.getKeyByValue(t, value)
	local key

	for k, v in pairs(t) do
		if v == value then
			key = k
			break
		end
	end

	return key
end

function table.length(t)
	local length = 0

	for k, v in pairs(t) do
		length = length + 1
	end

	return length
end

function table.merge(t1, t2)
	for i = 1, #t2 do
		table.insert(t1, t2[i])
	end
end

function table.print(t)
	local print_r_cache={}
	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			print(indent.."*"..tostring(t))
		else
			print_r_cache[tostring(t)]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						print(indent.."["..pos.."] => "..tostring(t).." {")
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
						print(indent..string.rep(" ",string.len(pos)+6).."}")
					elseif (type(val)=="string") then
						print(indent.."["..pos..'] => "'..val..'"')
					else
						print(indent.."["..pos.."] => "..tostring(val))
					end
				end
			else
				print(indent..tostring(t))
			end
		end
	end
	if (type(t)=="table") then
		print(tostring(t).." {")
		sub_print_r(t,"  ")
		print("}")
	else
		sub_print_r(t,"  ")
	end
	print()
end

function table.clean(t)
	for i = #t, 1, -1 do
		table.remove(t, i)
	end
end