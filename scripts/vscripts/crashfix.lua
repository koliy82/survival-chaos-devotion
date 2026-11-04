print("StartCrashFix")

if CBodyComponent.needcrashtest then return end
CBodyComponent.needcrashtest = true
CDOTA_Buff.needcrashtest = true
CEntities.needcrashtest = true
CEntityInstance.needcrashtest = true

local funcs = {}

-- local i = 1
-- for fnName,fdesc in pairs( FDesc ) do

--     print('"'..i..'"')
--     print("{")
--     print('"name" "'..fnName..'"')
--     -- print('"parameterCount" "'..#fdesc..'"')
--     print('"parameters"')
--     print("{")
    
--     local minii = 1
--     -- local parameterList = {}
--     for i = 0, #fdesc-1 do
--         local prmType, prmName = unpack( fdesc[i] )
--         -- if prmName == nil or prmName == "" then prmName = string.format( "%s_%d", prmType, i+1 ) end
--         -- table.insert( parameterList, prmName )
--         print('"'..minii..'" "'..prmType..'"')
--         minii = minii + 1
--     end

--     print("}")
--     print("}")
--     i = i + 1

--     -- funcs[{name = fnName}] = #fdesc--#fdesc = parameterCount
--     -- table.insert(funcs_str, string.format( "function %s( %s ) end\n", fnName, table.concat( parameterList, ", " ) ))
-- end
-- for className,cdesc in pairs( CDesc ) do
--     for fnName,fdesc in pairs( cdesc.FDesc ) do

--         print('"'..i..'"')
--         print("{")
--         print('"class" "'..className..'"')
--         print('"name" "'..fnName..'"')
--         -- print('"parameterCount" "'..#fdesc..'"')
--         print('"parameters"')
--         print("{")

--         local minii = 1
--         -- local fnName = string.format( "%s.%s", className, locfnName )
--         local parameterList = {}
--         for i = 0, #fdesc-1 do
--             local prmType, prmName = unpack( fdesc[i] )
--             -- if prmName == nil or prmName == "" then prmName = string.format( "%s_%d", prmType, i+1 ) end
--             -- table.insert( parameterList, prmName )
--             print('"'..minii..'" "'..prmType..'"')
--             minii = minii + 1
--         end

--         print("}")
--         print("}")
--         i = i + 1
    
--         -- funcs[{class = className, name = fnName}] = #fdesc--#fdesc = parameterCount
--         -- table.insert(funcs_str, string.format( "function %s( %s ) end\n", fnName, table.concat( parameterList, ", " ) ))
--     end
-- end

local funcs = LoadKeyValues("scripts/kv/crashfix.kv")
-- DeepPrintTable(funcs)

local types = {
    string = {true, '"string"', true},
    utlstringtoken = {false, '"string"', true},
    int = {true, '"number"', false},
    float = {true, '"number"', false},
    unsigned = {true, '"number"', false},
    uint64 = {true, '"number"', false},
    ehandle = {true, '"number"', false},
    bool = {true, '"boolean"', false},
    Vector = {true, '"userdata"', false},
    QAngle = {false, '"userdata"', true},
    Quaternion = {false, '"userdata"', true},
    handle = {false, '"table"', true},
    table = {false, '"table"', true},
}

for _,fnData in pairs( funcs ) do
    local fnClass = fnData.class
    local fnName = fnData.name
    local newparameters = {}
    for key,parameterType in pairs( fnData.parameters ) do
        newparameters[tonumber(key)] = parameterType
    end
    local parameterCount = #newparameters
    local otherparamsStr = ""
    local allparamsCode = ""
    for i=1,parameterCount do
        otherparamsStr = otherparamsStr.."param"..i
        if i ~= parameterCount then
            otherparamsStr = otherparamsStr..","
        end
        if types[newparameters[i]][1] then
            allparamsCode = allparamsCode..' local param'..i..'type = type(param'..i..') if param'..i..'type ~= '..types[newparameters[i]][2]
            -- if types[newparameters[i]][2] == "handle" then
            --     allparamsCode = allparamsCode..' and param'..i..'type ~= "function"'
            -- end
            if types[newparameters[i]][3] then
                allparamsCode = allparamsCode..' and param'..i..'type ~= "nil"'
            end
            allparamsCode = allparamsCode..' then print(param'..i..'type) error("param'..i..' wrong type") end'-- and param'..i..'.needcrashtest and param'..i..':IsNull()
        end
    end
    local allparamsStr = otherparamsStr
    if fnClass then
        if otherparamsStr ~= "" then
            allparamsStr = "param0," .. otherparamsStr
        else
            allparamsStr = "param0"
        end
        if loadstring("return "..fnClass..".needcrashtest")() then
            allparamsCode = 'if type(param0) == "table" and param0.needcrashtest and param0:IsNull() then error("param0:IsNull()") end' .. allparamsCode
        end
        fnName = fnClass.."."..fnName
    end
    local code = '--[['..fnName..']]local func = '..fnName..'; '..fnName..' = function('..allparamsStr..') '..allparamsCode..' return func('..allparamsStr..') end'--print("Override '..fnName..'"); 
    -- print(code)
    loadstring(code)()
end