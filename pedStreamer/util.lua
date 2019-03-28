function check_int(n)
	-- checking not float
	if(n - math.floor(n) > 0) then
		outputDebugString("trying to use bitwise operation on non-integer!")
	end
end

function to_bits(n)
	check_int(n)
	if(n < 0) then
		-- negative
		return to_bits(bit.bnot(math.abs(n)) + 1)
	end
	
	-- to bits table
	local tbl = {}
	local cnt = 1
	while (n > 0) do
		local last = math.mod(n, 2)
		if(last == 1) then
			tbl[cnt] = 1
		else
			tbl[cnt] = 0
		end
		n = (n-last)/2
		cnt = cnt + 1
	end
	
	return tbl
end

function tbl_to_number(tbl)
	local n = table.getn(tbl)
	local rslt = 0
	local power = 1
	
	for i = 1, n do
		rslt = rslt + tbl[i]*power
		power = power*2
	end
	
	return rslt
end

function expand(tbl_m, tbl_n)
	local big = {}
	local small = {}
	
	if(table.getn(tbl_m) > table.getn(tbl_n)) then
		big = tbl_m
		small = tbl_n
	else
		big = tbl_n
		small = tbl_m
	end
	
	-- expand small
	for i = table.getn(small) + 1, table.getn(big) do
		small[i] = 0
	end
end

function bit_and(m, n)
	local tbl_m = to_bits(m)
	local tbl_n = to_bits(n)
	expand(tbl_m, tbl_n)
	
	local tbl = {}
	local rslt = math.max(table.getn(tbl_m), table.getn(tbl_n))
	
	for i = 1, rslt do
		if(tbl_m[i]== 0 or tbl_n[i] == 0) then
			tbl[i] = 0
		else
			tbl[i] = 1
		end
	end
	
	return tbl_to_number(tbl)
end

function to_dec(hex)
	if(type(hex) ~= "string") then
		outputDebugString("non-string type passed in.")
	end
	
	head = string.sub(hex, 1, 2)
	
	if( head ~= "0x" and head ~= "0X") then
		outputDebugString("wrong hex format, should lead by 0x or 0X.")
	end
	
	v = tonumber(string.sub(hex, 3), 16)
	
	return v;
end
