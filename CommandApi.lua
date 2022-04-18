local API = {}

API.Prefix = nil
API.Commands = {}

function API:Initialize(prefix, id)
    if type(prefix) == "nil" and type(id) == "nil" then
        API.Prefix = "'"
        API.GamepassId = 1798417
    else
        API.Prefix = tostring(prefix)
        API.GamepassId = tonumber(id)
    end
end

function API:AddCommand(name, alias, callback)
    if type(alias) == "function" then
        alias, callback = callback, alias
    end
    if type(alias) ~= "table" then
        alias = {
            alias
        }
    end
    for _, v in pairs({
        name,
        unpack(alias or {})
    }) do
        self.Commands[v] = callback
    end
end

function API:Parse(cmd)
    if string.sub(cmd, 1, 1) == self.Prefix then
        if #cmd == 1 then
            return
        else
            local line = string.sub(cmd, 2, #cmd)
            local commands, args = nil, {}
            for i in line:gmatch("[%w%p]+") do
                if commands == nil then
                    commands = i
                else
                    table.insert(args, i)
                end
            end
            if self.Commands[commands] then
                self.Commands[commands](args)
            else
                warn("Invalid command:", commands)
            end
        end
    end
end

return API
