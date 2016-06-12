function class()
    local cl = {}
    cl.__index = cl            -- cl будет использоваться как мета-таблица
    return cl
end

function object( cl, obj )
    obj = obj or {}            -- возможно уже есть заполненные поля
    setmetatable(obj, cl)
    return obj
end

function subclass( pcl )
    local cl = pcl:new()           -- создаем экземпляр
    cl.__index = cl          -- и делаем его классом
    return cl
end