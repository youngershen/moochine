#!/usr/bin/env lua
-- -*- lua -*-
-- Copyright 2012 Appwill Inc.
-- Author : KDr2, Younger.shen
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

module('mch.request',package.seeall)
local utils = require('mch.util')

Request={}

function Request:new()
    local ret={
        method=ngx.var.request_method,
        schema=ngx.var.schema,
        host=ngx.var.host,
        hostname=ngx.var.hostname,
        uri=ngx.var.request_uri,
        path=ngx.var.uri,
        filename=ngx.var.request_filename,
        query_string=ngx.var.query_string,
        headers=ngx.req.get_headers(),
        user_agent=ngx.var.http_user_agent,
        remote_addr=ngx.var.remote_addr,
        remote_port=ngx.var.remote_port,
        remote_user=ngx.var.remote_user,
        remote_passwd=ngx.var.remote_passwd,
        content_type=ngx.var.content_type,
        content_length=ngx.var.content_length,
        uri_args=ngx.req.get_uri_args(),
        socket=ngx.req.socket
    }

    setmetatable(ret,self)
    self.__index=self
    return ret
end

function Request:get_cookies()
-- add by younger
-- to apply the cookie string to a table
    local cookies = ngx.req.get_headers()['Cookie']
    local rtu = utils.string_spliter(cookies, ';')
    local cookies_table = {}

    for k,v in ipairs(rtu) do
        local a_record = {}
        local s,e = string.find(v, '=')
        local key = string.sub(v, 1, s - 1)
        local value = string.sub(v, s+1, #v)
        a_record.key = key
        a_record.value = value
        table.insert(cookies_table, a_record)
    end

    return cookies_table
end


function Request:read_body()
    ngx.req.read_body()
    self['post_args']=ngx.req.get_post_args()
end

function Request:get_cookie(key, decrypt)
    local value = ngx.var['cookie_'..key]

    if value and value~="" and decrypt==true then
        value=ndk.set_var.set_decode_base64(value)
        value=ndk.set_var.set_decrypt_session(value)
    end

    return value
end

function Request:rewrite(uri, jump)
    return ngx.req.set_uri(uri, jump)
end

function Request:set_uri_args(args)
    return ngx.req.set_uri_args(args)
end

-- to prevent use of casual module global variables
getmetatable(mch.request).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '
            .. debug.traceback())
end

