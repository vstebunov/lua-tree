local etalon = {
	{ class = 3, lake_num = 0, bay_num = 2, lid_num = 2, bay_above_bay = 1, lid_rightof_bay = 0, bay_above_lake = 0, l_b_i = 0 },
	{ class = 4, lake_num = 0, bay_num = 2, lid_num = 2, bay_above_bay = 1, lid_rightof_bay = 0, bay_above_lake = 0, l_b_i = 1 },
	{ class = 5, lake_num = 0, bay_num = 2, lid_num = 2, bay_above_bay = 1, lid_rightof_bay = 1, bay_above_lake = 0, l_b_i = 0 },
	{ class = 7, lake_num = 0, bay_num = 1, lid_num = 1, bay_above_bay = 0, lid_rightof_bay = 0, bay_above_lake = 0, l_b_i = 0 },
	{ class = 1, lake_num = 0, bay_num = 1, lid_num = 1, bay_above_bay = 0, lid_rightof_bay = 0, bay_above_lake = 0, l_b_i = 0 },
	{ class = 1, lake_num = 0, bay_num = 0, lid_num = 0, bay_above_bay = 0, lid_rightof_bay = 0, bay_above_lake = 0, l_b_i = 0 },
	{ class = 7, lake_num = 0, bay_num = 2, lid_num = 2, bay_above_bay = 0, lid_rightof_bay = 1, bay_above_lake = 0, l_b_i = 0 },
	{ class = 7, lake_num = 0, bay_num = 1, lid_num = 1, bay_above_bay = 0, lid_rightof_bay = 0, bay_above_lake = 0, l_b_i = 0 },
	{ class = 1, lake_num = 0, bay_num = 1, lid_num = 1, bay_above_bay = 0, lid_rightof_bay = 0, bay_above_lake = 0, l_b_i = 0 },
	{ class = 2, lake_num = 0, bay_num = 2, lid_num = 2, bay_above_bay = 1, lid_rightof_bay = 1, bay_above_lake = 0, l_b_i = 0 },
	{ class = 2, lake_num = 0, bay_num = 2, lid_num = 2, bay_above_bay = 0, lid_rightof_bay = 1, bay_above_lake = 0, l_b_i = 1 },
	{ class = 2, lake_num = 0, bay_num = 2, lid_num = 2, bay_above_bay = 1, lid_rightof_bay = 1, bay_above_lake = 0, l_b_i = 0 },
	{ class = 5, lake_num = 0, bay_num = 2, lid_num = 2, bay_above_bay = 1, lid_rightof_bay = 1, bay_above_lake = 0, l_b_i = 0 },
	{ class = 3, lake_num = 0, bay_num = 2, lid_num = 2, bay_above_bay = 1, lid_rightof_bay = 0, bay_above_lake = 0, l_b_i = 0 },
	{ class = 0, lake_num = 1, bay_num = 0, lid_num = 0, bay_above_bay = 0, lid_rightof_bay = 0, bay_above_lake = 0, l_b_i = 0 },
	{ class = 9, lake_num = 1, bay_num = 1, lid_num = 1, bay_above_bay = 0, lid_rightof_bay = 0, bay_above_lake = 0, l_b_i = 0 },
	{ class = 6, lake_num = 1, bay_num = 1, lid_num = 1, bay_above_bay = 0, lid_rightof_bay = 1, bay_above_lake = 1, l_b_i = 0 },
	{ class = 8, lake_num = 2, bay_num = 0, lid_num = 0, bay_above_bay = 0, lid_rightof_bay = 1, bay_above_lake = 1, l_b_i = 0 },
};

function P_c( etalon, class )
	local count = 0
	for i, v in pairs(etalon) do
		if (v.class == class) then
			count = count + 1
		end
	end
	return count / #etalon
end

function P_f( etalon, f_name, f_value )
	local count = 0
	for i, v in ipairs(etalon) do
		if (v[f_name] == f_value ) then
			count = count + 1
		end
	end
	return count / #etalon
end

function P_c_f( etalon, class, f_name, f_value )
	local count = 0
	for i, v in ipairs(etalon) do
		if (v[f_name] == f_value and v.class == class) then
			count = count + 1
		end
	end
	return count / #etalon
end

function log2( value )
	if value == 0 then
		return 0
	end
	return math.log(value) / math.log(2)
end

function get_all_class(etalon)
	local classes = {}
	for i, v in ipairs(etalon) do
		local is_not_in_classes = true
		for j, z in ipairs(classes) do
			if v.class == z then
				is_not_in_classes = false
				break
			end
		end
		if is_not_in_classes then
			table.insert(classes, v.class)
		end
	end
	return classes
end

function get_all_mods(etalon, f_name)
	local mods = {}
	for i, v in ipairs(etalon) do
		local is_not_in_classes = true
		for j, z in ipairs(mods) do
			if v[f_name] == z then
				is_not_in_classes = false
				break
			end
		end
		if is_not_in_classes then
			table.insert(mods, v[f_name])
		end
	end
	return mods 
end

function I(etalon, F)
	local classes = get_all_class(etalon)
	local mods = get_all_mods(etalon, F)
	local result = 0
	for i, c in ipairs(classes) do
		for j, m in ipairs(mods) do
			result = result + P_c_f( etalon, c, F, m) * 
				log2( P_c_f( etalon, c, F, m) / (P_c(etalon, c) * P_f(etalon, F, m)))
		end
	end
	return result
end

function get_all_f(etalon)
	local f = {}
	for f_name, _ in pairs(etalon[1]) do
		if f_name ~= 'class' then
			table.insert(f, f_name)
		end
	end
	return f 
end

function get_root(etalon)
	local f = get_all_f(etalon)
	local max = 0
	local max_name = f[1]
	for _, f_name in ipairs(f) do
		local inf = I(etalon, f_name)
		if (inf > max) then
			max = inf
			max_name = f_name
		end
	end
	return max_name
end

function divide_etalon(etalon, divider)
	assert(nil ~= divider)
	local etalons = {}
	for i, v in pairs(etalon) do
		if (etalons[ v[divider] ] == nil) then
			etalons[ v[divider] ] = {}
		end
		table.insert( etalons[ v[divider] ], v )
		local t = etalons[ v[divider] ][ #etalons[v[divider]] ]
		t[divider] = nil
	end
	return etalons
end

function print_arr(t)
	for i, v in pairs(t) do
		print(i,v)
	end
end

function divide(etalon)
	local root = get_root(etalon)
	local etalons = divide_etalon( etalon, root )
	local result = { root = root, nodes = {} }
	local finitie_classes = {}
	for val, sub in pairs(etalons) do
		local first_class = sub[1].class
		local is_have_different_classes = false
		for _, v in pairs(sub) do
			if first_class ~= v.class then
				is_have_different_classes = true
				break
			end
		end
		if not is_have_different_classes then
			table.insert(result.nodes, { name = val, value = first_class } )
			table.insert(finitie_classes, first_class)
		else
			if nil == get_root(sub) then
				table.insert(result.nodes, { name = val, value = table.concat(get_all_class(sub), ',') })
			else
				table.insert(result.nodes, { name = val, tree = divide(sub) })
			end
		end
	end
	return result 
end

function print_tree(tree, space)
	local p = string.rep( ' ', space )
	print( p .. tree.root )
	for _, v in pairs(tree.nodes) do
		if (not v.value) then
			io.write( p .. '-' .. v.name .. '->' )
			print_tree(v.tree, space + 2)
		else
			print ( p .. '-' .. v.name .. '->' .. v.value )
		end
	end
end

print_tree(divide(etalon), 0)

