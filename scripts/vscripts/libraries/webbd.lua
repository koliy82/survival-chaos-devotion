WebBD = {}

function WebBD:CreateTransaction()
    local transaction = {}
    transaction.queries = {}
    transaction.gets_index = 1
    transaction.queries.gets = {}
    transaction.getfuncs = {}
    transaction.sets_index = 1
    transaction.queries.sets = {}
    transaction.setfuncs = {}
    transaction.Get = WebBD.getfunc
    transaction.Set = WebBD.setfunc
    transaction.Commit = WebBD.commitfunc
    transaction.HaveQueries = WebBD.havefunc
    return transaction
end

WebBD.getfunc = function(self, query, func)
    self.queries.gets[tostring(self.gets_index)] = query
    self.getfuncs[tostring(self.gets_index)] = func
    self.gets_index = self.gets_index + 1
end

WebBD.setfunc = function(self, query, func)
    self.queries.sets[tostring(self.sets_index)] = query
    if func ~= nil then
        table.insert( self.setfuncs, func )
    end
    self.sets_index = self.sets_index + 1
end

WebBD.havefunc = function(self)
    return self.gets_index == 1 and self.sets_index == 1
end

WebBD.commitfunc = function(self, onresult)
    print(json.encode(self.queries))
    local req = CreateHTTPRequestScriptVM( "POST", "https://dotascd.ru/webbd.php")
    if req then
        req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKeyV3("3"))
        req:SetHTTPRequestGetOrPostParameter("query", json.encode(self.queries))
        req:Send(function(result)
            print(result.Body)
            if result.Body == "" then
                if onresult then
                    onresult({})
                end
            else
                -- [SCD-FIX] мусор/nil из сети не валит колбэк
                local ok, loctable = pcall(json.decode, result.Body)
                if not ok or loctable == nil then
                    print("[SCD-DIAG] webbd.php bad json")
                    if onresult then onresult({}) end
                    return
                end
                if onresult then
                    onresult(loctable)
                end
                if loctable["error"] == nil then
                    for i=1, self.gets_index do
                        local getfunc = self.getfuncs[tostring(i)]
                        if getfunc then
                            getfunc(loctable[tostring(i)])
                        end
                    end
                    for _, setfunc in ipairs(self.setfuncs) do
                        if setfunc then
                            setfunc()
                        end
                    end
                end
            end
        end)
    end
end