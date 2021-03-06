#!/usr/bin/env lua
-- -*- lua -*-
-- copyright: 2012 Appwill Inc.
-- author : KDr2
--


module("test",package.seeall)

local JSON = require("cjson")

function hello(req, resp, name)
    if req.method=='GET' then
        -- resp:writeln('Host: ' .. req.host)
        -- resp:writeln('Hello, ' .. ngx.unescape_uri(name))
        -- resp:writeln('name, ' .. req.uri_args['name'])
        resp.headers['Content-Type'] = 'application/json'
        resp:write(JSON.encode(req.uri_args))
    elseif req.method=='POST' then
        -- resp:writeln('POST to Host: ' .. req.host)
        req:read_body()
        resp.headers['Content-Type'] = 'application/json'
        resp:writeln(JSON.encode(req.post_args))
    end 
end


function ltp(req,resp,...)
    resp:ltp('ltp.html',{v=123})
end

function sss(req, resp)
    resp:set_cookie('session_id', 'sfsdfsde', true, 1000, '/')
    resp:set_cookie('test_id', 'sfsdf', true, 10000000000, '/test') 
    resp:set_cookie('sssss', 'sfsdf', true, 100, '/')
    local headers  = req.headers
    local cookies = req.get_cookies()
    
    
    resp:write(JSON.encode(cookies))
end

