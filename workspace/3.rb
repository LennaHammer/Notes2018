#encoding: utf-8
require 'sinatra'
require 'sinatra/reloader'
require 'active_record'

Encoding.default_external = Encoding.find('utf-8')

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'datebase.sqlite3'
)

ActiveRecord::Base.connection.execute("
  create table if not exists posts (
    id integer primary key,
    body text not null
  )
")

class Post < ActiveRecord::Base
end


enable :sessions
set :sessions, :expire_after => 2592000
set :session_store, Rack::Session::Pool

get '/' do
  @posts = Post.last(10).reverse
  @total= Post.count
  haml :index,layout: :layout
end

post '/add' do
  body = params[:body]
  x = Post.new
  x.body = body
  x.save
  session[:flash] = "留言成功"
  redirect to '/'
end

post 'admin/clear' do
  session[:flash] = "全部清除"
  Post.delete_all
  redirect to '/'
end

post 'admin/delete' do
    id = params[:body]
    session[:flash] = "删除成功"
    Post.find(id).destory
    redirect to '/'
end

get '/login' do
  haml :login
end

get '/logout' do
  session[:user] = nil
  redx('/',"成功登出")
end

post '/login' do
  name = params[:name]
  password = params[:password]
  if name=="1" && password==""
    #session[:flash] = "登录成功"
    #redirect to '/'
    session[:user] = :admin
    redx('/',"登录成功")
  else
    #redirect to '/login'
    redx('/login',"用户名或密码错误")
  end
end
def redx(path,notice)
    session[:flash] = notice
    redirect to path
end
helpers do
  def flash
    text = session[:flash]
    session[:flash] = nil
    text
  end
  def notice
    if x=flash
      yield x 
    end
  end
  def login?
    p  session[:user]
    session[:user] == :admin
  end
end

__END__
@@ layout
!!! 5
%html
  %head
    %meta{charset: "utf-8"}
    %meta(name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no")
    %title 留言簿
    %link(href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet")
    %script(src="https://code.jquery.com/jquery-3.3.1.slim.min.js")
    %script(src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js")
    %script(src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js") 
  %body
  %div.container
    %div.navbar.navbar-dark.bg-dark.sticky-top
      %a.navbar-brand{href:'/'} 留言簿
      - if login?
        %a{href:'/logout'} 登出
      - else
        %a{href:'/login'} 登录
    %p.alert= flash
    = yield


@@ index
- notice do |text|
  %div.alert.alert-primary= text
%form{method:'post', action:'/add'}
  %p 留言栏
  %div.form-group
    %textarea.form-control{type:'text', name:'body'}
  %input.btn.btn-primary{type:'submit', value:'留言'}
= "有 #{@total} 条留言"
%div
  - @posts.each do |post|
    %div.media
      %pre.media-body
        &= post.body
      - if login?
        %a{href:"#" data-toggle="modal" data-target="#conform"} 删除
    %br
%form{method:'post', action:'/clear'}
  %input{type:'submit', value:'清除'}
%div.modal#conform
  %div.modal-dialog
    %div.modal-header
      %h5.modal-title 确认删除？
      %button(type="button" class="close" data-dismiss="modal")
        %span &times;
    %div.modal-body
      确认要删除该条留言么？一旦删除不可恢复。
    %div.modal-footer
      %button(type="button" class="btn btn-secondary" data-dismiss="modal") 关闭
      %button(type="button" class="btn btn-primary") 删除


@@ login
%h1 管理员登录
- notice do |text|
  %div.alert.alert-danger= text
%form{method: :post, action: :login}
  %div.form-group
    %label 用户名
    %input.form-control{type:'text', name:'name'}
    %label 密码
    %input.form-control{type:'text', name:'password'}
  %input.btn.btn-primary{type:'submit', value:'登录'}