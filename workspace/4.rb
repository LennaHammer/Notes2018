#encoding: utf-8
require 'sinatra'
require 'sinatra/reloader'
require 'active_record'

Encoding.default_external = Encoding.find('utf-8')

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'datebase.sqlite3'
)

# 显示表格


