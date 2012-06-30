#!/usr/bin/env lua
---*-coding:utf-8-*-
--2012 appwill inc
--author:younger.shen

--TODO 
--add session support to this web framework


-- SessionManager ---->manager the session
-- session   ---------> the session entity

module('mch.session', package.seeall)
local utils = require "mch.utils"

SessionManager = {}

function SessionManager:new()
    
   self.__storage = {} 
   if self.__instance then
    
       return instance
   end
   
   self.__instance = true
   local instance = {}
   setmetatable(instance, self)
   self.__index = self.__storage
   return instance
end

function SessionManager:load_session(session_id)
    --过期时间神马的还木有处理好，fix it later
    if self.__storage then
    
        if self.__storage[session_id] then
            return self.__storage[session_id]
        end
    end
    error('no session find')
    return nil
end

function SessionManager:create_session(_data, _session_name, _domain, _path, _maxAge)

    local session_check = self:check_session()
    if session_check then
        -- already got the session_id
    else
        -- has no session_id
        local now = ngx.time()
        local expire = now + _maxAge
        local session = Session:new(_data, _session_name, _domain, _path, expire)
    end
end

function SessionManager:check_session()
    local headers = ngx.req.get_headers()['Cookies']
    local cookies_str = utils.string_spliter(headers, ';')
    
    local cookies_table = {}

    for k,v in ipairs(cookies_str) do
        local a_record = {}
        local s,e = string.find(v, '=')
        local key = string.sub(v, 1, s - 1)
        local value = string.sub(v, s+1, #v)
        if key == 'session_id' then
            return value    
        end
    end
    
    return nil
end 


Session = {}

function Session:new(_data, _session_name, _domain, _path, _expiredate)

    local ret = {
    
        data = _data,
        session_name = _session_name,
        domain = _domain,
        path = _path,
        expiredate = _expiredate
    }

    return ret
end
