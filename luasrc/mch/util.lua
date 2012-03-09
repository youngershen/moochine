#!/usr/bin/env lua
-- -*- lua -*-
-- Copyright 2012 Appwill Inc.
-- Author : KDr2
--
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.
--
--


module('mch.util',package.seeall)

function read_all(filename)
    local file = io.open(filename, "r")
    local data = ((file and file:read("*a")) or nil)
    if file then
        file:close()
    end
    return data
end

function app_name()
    return ngx.var.MOOCHINE_APP_NAME or "mch_defaut_app"
end

function split(str,sep)
    local ret={}
    local s,e=string.find(str,sep)
    if not s then
        ret[#ret+1]=str
        return ret
    end
    
    while true do
        ns,e,s=e+1,s-1,1
        ret[#ret+1]=string.sub(str,s,e)
        str=string.sub(str,ns)
        s,e=string.find(str,sep)
        if not s then
            ret[#ret+1]=str
            break
        end
    end
    
    return ret
end

function moochine_require(str)
    local app_name=app_name()
    _G[app_name] = _G[app_name] or {}
    local mod=_G[app_name][str]
    if mod then return mod end
    local path_str=string.gsub(str,"%.","/")
    local path=ngx.var.MOOCHINE_APP_PATH .. "/app/" .. path_str .. ".lua"
    
    ngx.log(ngx.ERR,"!!!",path,"\n\t",tostring(_G),tostring(mch))
    local module=loadfile(path)(str)
    
    if type(module) == "table" then
        _G[app_name][str]=module
        return module
    else
        module=package.loaded[str]
        if module then
            _G[app_name][str]=module
            return module
        end
    end
    return nil
end

function setup_app_env(mch_home,app_path,app_name,global)
    local request=require("mch.request")
    local response=require("mch.response")
    global['MOOCHINE_MODULES']={}
    global['MOOCHINE_MODULES']['request']=request
    global['MOOCHINE_MODULES']['response']=response
end




