helper = {}

helper.dump = function(o)
    if type(o) == 'table' then
        local s = '{ '

        for k, v in pairs(o) do
            if type(k) ~= 'number' then
                k = '"' .. k .. '"'
            end

            s = s .. '[' .. k .. '] = ' .. helper.dump(v) .. ','
        end

        return s .. '} '
    else
        return tostring(o)
    end
end

helper.print = function(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20)
    local string = ""

    arr = { p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20 }

    for i,var in pairs(arr) do
        if(i == 1) then
            string = tostring(var)
        else 
            string = string .. ",  " .. tostring(var)
        end
    end

    DebugPrint(string)
end


helper.scale = function(num, r1, r2)
    return (num * r1) / r2
end