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
    id integer primary key autoincrement,
    name varchar(255) not null,
    body text not null,
    created_at datetime not null
  )
")

class Post < ActiveRecord::Base
end


enable :sessions
set :sessions, :expire_after => 2592000
set :session_store, Rack::Session::Pool

get '/' do
  @page = params[:page]&.to_i || 1 #.to_i || 1 #.present?
  #@page = @page&.to_i || 1
  @posts = Post.order(id: :desc).offset((@page-1)*10).limit(10)
  @total = Post.count
  haml :index,layout: :layout
end

post '/add' do
  body = params[:body]
  if body.blank?
    session[:flash] = "留言不能为空"
    return redirect to '/'
    
  end
  x = Post.new
  x.name = request.ip
  x.body = body
  x.save!
  session[:flash] = "留言成功"
  redirect to '/'
end

post 'admin/clear' do
  session[:flash] = "全部清除"
  Post.delete_all
  redirect to '/'
end

post '/admin/delete' do
    id = params[:id]
    session[:flash] = "删除成功"
    Post.find(id).destroy
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
    session[:user] == :admin
  end
end
before '/admin/*' do
  session[:user] == :admin or fail
end

not_found do
    'This is nowhere to be found.'
end
__END__
@@ layout
-# coding: utf-8
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
%div.card
  %div.card-header 留言框
  %div.card-body
    %form{method:'post', action:'/add'}
      %div.form-group
        %textarea.form-control{type:'text', name:'body'}
      %input.btn.btn-primary{type:'submit', value:'留言'}
%p= "第#{@page}页 共有 #{@total} 条留言"
%div
  - @posts.each do |post|
    %p
      %div.card
        %div.card-header 用户 #{post.name} 时间 #{post.created_at.strftime '%Y-%m-%d %H:%M:%S' }
        %pre.card-body
          &= post.body
        - if login?
          %button.btn(href="" data-toggle="modal" data-target="#conform" data-whatever="#{post.id}") 删除
%ul.pagination
  - if @page>1
    %li.page-item
      %a.page-link{href:"/?page=#{@page-1}"} 上一页
  - else
    %li.page-item.disabled
      %a.page-link 上一页
  - (1..(@total/10.0).ceil).each do |i|
    - if @page==i
      %li.page-item.active
        %a.page-link{href:"/?page=#{i}"} #{i}
    - else
      %li.page-item
        %a.page-link{href:"/?page=#{i}"} #{i}
  - if @page*10<@total
    %li.page-item
      %a.page-link{href:"/?page=#{@page+1}"} 下一页
  - else
    %li.page-item.disabled
      %a.page-link 下一页   
  

%div.modal.fade(tabindex="-1" role="dialog" id="conform")
  %div.modal-dialog
    %div.modal-content
      %div.modal-header
        %div.modal-title 确认删除？
        %button(type="button" class="close" data-dismiss="modal")
          %span &times;
      %div.modal-body
        确认要删除该条留言么？删除不可恢复。
      %div.modal-footer
        %form{action:"/admin/delete",method:"post"}
          %button(type="button" class="btn btn-secondary" data-dismiss="modal") 关闭
          %input{id:"delete_button",name:'id',type:'hidden'}
          %button(type="submit" class="btn btn-primary") 确认删除
:javascript
    $('#conform').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget) // Button that triggered the modal
        var recipient = button.data('whatever') // Extract info from data-* attributes
        // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
        // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
        var modal = $(this)
        modal.find('#delete_button').val(recipient)
    })


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