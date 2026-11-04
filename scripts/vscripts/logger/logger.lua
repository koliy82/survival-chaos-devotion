function Log(msg)
    CustomGameEventManager:Send_ServerToAllClients( "log", { msg = msg})
end