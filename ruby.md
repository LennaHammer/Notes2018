# Learn Ruby In 7 Days

## Day 1 Sinatra

### Step 1 Hello World

```ruby
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  'Hello'
end

```



open http://127.0.0.1:4567/ in browser



### Step 2 Active Record

```ruby
require 'sinatra'
require 'sinatra/reloader'
require 'active_record'


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

get '/' do
  @posts = Post.last(10).reverse
  erb :index
end

post '/add' do
  body = params[:body]
  x = Post.new
  x.body = body
  x.save
  redirect to '/'
end

__END__

@@ index
<form action='/add' method='post'>
  <input type='text' name='body'>
  <input type='submit' value='Submit'>
</form>
<p>
<% @posts.each do |post| %>
  <%= post.body.encode(xml: :text) %> <br/>
<% end %>
</p>

```



默认映射规则类名 Post 是 表名 posts 的单数形式。

通过 find(id) find_by() 查找对象

执行 sql

+ execute
+ exc_query
+ Model.select_all
+ add_table



```
presence present?
```

### Step 3 Guest Book



```ruby

```



```ruby
class Paginator
end
```



flash + redirect

### Step 4 File Upload

定时删除

```ruby
require 'sinatra'
require 'sinatra/reloader'
require 'active_record'


ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'datebase.sqlite3'
)

ActiveRecord::Base.connection.execute("
  create table if not exists files (
    id integer primary key,
    filename varchar(255) not null
    created_at datetime not null
  )
")

class Post < ActiveRecord::Base
end

get '/' do
  @posts = Post.all
  erb :index
end


```



## Day 2 Rails

### Step 1 Hello

```sh
rails new project
cd project
rails server
```

open http://127.0.0.1:3000/



约定over配置

优点

学习良好的习惯

合作时增加共识

缺点

采用默认约定时调用规则不明显

需要修改默认配置的时候不方便



restful

对象资源 

`/resources/1/action` 对应方法

`/resources/action` 对应类方法

单实例类 `/resource/action/`



agile

敏捷 设计到实现

### Step 2 Scaffold

```bash
rails generate scaffold Post title:string body:text
rails db:migrate
```

open http://127.0.0.1:3000/posts/



### Step 3 Model

 用来操作数据库，本身不包含数据库信息。



Type

- `string`, `text`, `binary`
- `integer`, `float`, `decimal`, `boolean`
- `datetime`, `date`,  `time`
- `timestamp` equals `created_at:datetime updated_at:datetime`
- `model:references` equals  `model_id:integer`

Query

+ find
+ find_by
+ find_or_initialize_by

Modify

+ `#save`
+ `#update`
+ ...! 





### Step 4 View

Form



form_for

中文



`_form.html.erb`

```erb
<%= form_for post do |form| %>
  <div><%= form.label :title %><%= form.text_field :title %></div>
  <div><%= form.label :body %><%= form.text_area :body %></div>
  <div><%= form.submit %></div>
<% end %>
```

`new.html.erb` `edit.html.erb`

```erb
<h1>New/Edit Post</h1>
<%= render 'form', post: @post %>
```



```haml
%p#notice= notice
%h1 Posts
%table
  %thead
    %tr
      %th Title
      %th Body
  %tbody
    - @posts.each do |post|
      %tr
        %td= post.title
        %td= post.body
```





`show.html.erb` 

```erb
<p id="notice"><%= notice %></p>
<p>Title:<%= @post.title %></p>
<p>Body:<%= @post.body %></p>
```

`_post.html.erb`

```erb
<p>Title:<%= post.title %></p>
<p>Body:<%= post.body %></p
```



`index.html.erb`

```erb
<p id="notice"><%= notice %></p>
<h1>Posts</h1>
<table>
  <thead>
    <tr><th>Title</th><th>Body</th></tr>
  </thead>
  <tbody>
    <% @posts.each do |post| %>
      <tr><td><%= post.title %></td><td><%= post.body %></td></tr>
    <% end %>
  </tbody>
</table>
```







form_for

form_tag



Flash



`<p id="notice"><%= notice %></p> `

flash.now

params



url_for

+ `url_for controller: 'posts', action: 'recent' `

link_to

+ `link_to "Show", @post`

+ `link_to "Show", controller: "posts", action: "show", id: @post`
+ `link_to "Show", posts_path`
+ `link_to "List", controller: "posts"`

```erb
<%= link_to 'New Post', new_post_path %>
<%= link_to 'Show', post %>
<%= link_to 'Edit', edit_post_path(post) %>
<%= link_to 'Destroy', post, method: :delete, data: { confirm: 'Are you sure?' } %>
<%= link_to 'Back', posts_path %>
```



helper



### Step 5 Controller



method



render

+ `render :action`
+ `render 'controller/action'`

redirect_to

+ `redirect_to record` show
+ `redirect_to ..._path`
+ `redirect_back`

self.rescue_from

+ `rescue_from` 

self.before_action

+ `before_action :method` :only :except









Action

GET `index, show, new, edit`

```ruby
# GET /posts
def index
  @posts = Post.all
end

# GET /posts/new
def new
  @post = Post.new
end

# GET /posts/1
def show
  # @post = Post.find(params[:id])
end

# GET /posts/1/edit
def edit
  # @post = Post.find(params[:id])
end
```



POST `create, update, destroy`

```ruby
# POST /posts
def create
  @post = Post.new(params[:post])
  if @post.save
    redirect_to @post, notice: 'Post was successfully created.'
  else
    render :new
  end
end

# PATCH/PUT /posts/1
def update
  # @post = Post.find(params[:id])
  if @post.update(params[:post])
    redirect_to @post, notice: 'Post was successfully updated.'
  else
    render :edit
  end
end

# DELETE /posts/1
def destroy
  # @post = Post.find(params[:id])
  @post.destroy
  redirect_to posts_url, notice: 'Post was successfully destroyed.'
end
```

根据 form 是否含 id 调用 new->create, edit->update



Member `show, edit, update, destroy` `params[:id]` 

```ruby
before_action :set_post, only: [:show, :edit, :update, :destroy]

private
def set_post
  @post = Post.find(params[:id])
end
```

params white list `params[:post]`

```ruby
# params[:post]
def post_params
  params.require(:post).permit(:title, :body)
end
```






### Step 6 Routes



Resource

seven default actions

`get '/posts/:id', to: 'posts#show', as: 'post'`

```ruby
resources :photos do
  member do
    get 'preview'
  end
  collection do
    get 'search'
  end
end
namespace :admin do

end
```



Nested Resources

Singular Resources

root

get 

get 'home', to: 'posts#show'

get 'home', action: :show, controller: 'posts'

post

namespace

 Route Globbing and Wildcard Segments

get '/stories', to: redirect('/articles')


### Step 7 Validation

model

`validates :field, presence: true`

```ruby
class Post< ApplicationRecord
  validates :title, presence: true
end
```

controller

- create `Post.new(params[:model]).save`
- update `@model.update(params[:model])` 

```ruby
def create
  @post = Post.new(params[:post])
  if @post.save
    redirect_to @post
  else 
    render :new 
  end
end

def update
  @post = Post.find(params[:id])
  if @post.update(params[:post])
    redirect_to @post
  else
    render :edit
  end
end
```



view

`record.errors` 

`record.errors.full_messages`



```erb
<% if post.errors.any? %>
  <div id="error_explanation">
    <h2><%= pluralize(post.errors.count, "error") %>:</h2>
    <ul>
    <% post.errors.full_messages.each do |message| %>
      <li><%= message %></li>
    <% end %>
    </ul>
  </div>
<% end %>
```

### Step 8 Test



## Day 3 Posts

### Step 1 Start

```ruby
rails new myblog
cd myblog
rails server
```

open http://127.0.0.1:3000/

约定over配置

restful

### Step 2 Scaffold

```bash
rails generate scaffold Post title:string body:text
rails db:migrate
```

open http://127.0.0.1:3000/posts/

说明

#### Model

Type

+ `string`, `text`, `binary`
+ `integer`, `float`, `decimal`, `boolean`
+ `datetime`, `date`,  `time`
+ `timestamp` equals `created_at:datetime updated_at:datetime`
+ `references` equals  `model_id:integer`

Query

+ find
+ find_by
+ find_or_initialize_by

#### Controller

Method

+ redirect_to
+ render :action
+ redirect_to :back 
+ `def rescue_from`
+ `if save rediredt to else render end`
+ `def before_action` 

Action

+ index `@posts = Post.all` 
+ new, create `@post = Post.new` 
+ show, edit, update, destroy `@post = Post.find(params[:id])` `before_action` 
+ create, update `params` `Post.new(params) `  `@post.update(params)` 
+ request
  + index, new, show, edit `view` get
  + create, update, destroy post redirect
  + new -> create, edit -> update
+ render "..."
+ redirect_to redirect_back

Routes

+ `/config/routes.rb` `resources :posts ` `root 'posts#index' `
+ `rails routes`
+ resources
+ `get '...'` `get '...', to: 'posts#show'` 
+ `***_path`


#### View

+ helper 
+ Layout `application.html.erb` `<div><%= yield %></div>`
+ Flash
  + controller  `redirect_to ..., notice: '...' `

    +  `flash[:notice] = ...; redirect_to ...`

    + `flash.now[:notice] = ...; render ...`

  + view  `<p id="notice"><%= notice %></p>` 
+ form 
  + `_form` 
  + `new` `edit`
  + `params[:post]` Hash permit
  + form helper
  + `form.label :name; form.text_field :name`
  + `form.text_area` `form.submit`
+ render Partial 文件名 `_****.html.erb`
+ helper
  + `<%= link_to 'Destroy', post, method: :delete, data: { confirm: 'Are you sure?' } %>` 

#### Validation

+ model `Validation`
+ controller
  + create `@model.save`
  + update `@model.update(params[:model])` 
+ view `model.errors` `model.errors.full_messages`



model

```ruby
class Post< ApplicationRecord
  validates :title, presence: true
end
```



controller

```ruby
def create
  @post = Post.new(params[:post])
  if @post.save
    redirect_to @post
  else 
    render :new 
  end
end

def update
  if @post.update(params[:post])
    redirect_to @post
  else
    render :edit
  end
end
```

view `_form.html.erb`

```erb
<% if post.errors.any? %>
  <div id="error_explanation">
    <h2>
      <%= pluralize(post.errors.count, "error") %> prohibited this post from being saved:
    </h2>
    <ul>
      <% post.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
    </ul>
  </div>
<% end %>
```



#### Test

+ 



### Step 3 Associations

shell

```sh
rails generate scaffold Comment name:string body:text post:references
rails db:migrate
```

ruby

```ruby
# models/post.rb
has_many :comments
# config/routes.rb
resources :posts do
  resources :comments
end
```

html

```erb
<%= link_to 'Comments', post_comments_path(@post) %>
```



```sh
sed -i 's/_comment/_post_comment/g;s/comments_path/post_comments_path/g' ./app/views/comments/*.html.erb

new_comment_path
new_post_comment_path
Comment
@post = Post.find(params[:post_id])

@post.comments.build
```



Model

```ruby
# add to models/post.rb
has_many :comments
# add to model/comment.rb
belongs_to :post
```

View

```erb
# add to
    <% if @user.microposts.any? %>
      <h3>Microposts (<%= @user.microposts.count %>)</h3>
      <ol class="microposts">
        <%= render @microposts %>
      </ol>
      <%= will_paginate @microposts %>
    <% end %>
```



```erb
<%= render @comments %>
<%= form_for [comment.post, comment] do |form| %>
```



Controllers

```ruby
# controllers/posts_controller.rb
@comments = @post.comments
```

Routes

```ruby
# Nested Resources
resources :posts do
  resources :comments
end
```



Relation `belongs_to` 外键

belongs_to class_name foreigner_key



+ one-to-many `has_many`
+ many-to-many `has_many :throgh`
  + join table 不一定要用
+ one-to-one `has_one`



关联视图

subform

### Step 3 Home 

shell

```bash
rails g controller Blogs index show
```

blogs_controller.rb

```ruby
class BlogsController < ApplicationController
  def index
    @posts = Post.all
  end
  def show
    @post = Post.find(params[:id])
  end
end
```

routes.rb

```ruby
root 'blogs#index'
get 'blogs/:id', to: 'blogs#show'
```

application.html.erb

```html
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
```

blogs/show.htm.erb

```erb
<h1><%= @post.title %></h1>
<p id="notice"><%= notice %></p>
<p><%= @post.body %></p>
<ul>
  <% @post.comments.each do |comment| %>
    <li>(<%= comment.name %>)<%= comment.body %></li>
  <% end %>
</ul>
<%= render 'comments/form', comment: @post.comments.build %>
```

blogs/index.htm.erb



### Step 4 Session

shell

```sh
rails g controller Session new create destory
```

session

```ruby
session[:key] = 'value'
```

controller `session_controller.rb`

```ruby
class SessionController < ApplicationController
  
  def new

  end

  def destory
    session[:user] = nil
    redirect_to root_path
  end

  def create
    name = params[:name]
    password = params[:password]
    if name=="1" and password==""
      session[:user] = "admin"
      redirect_to root_path
    else
      render :new
    end
  end
end

```
helper

```ruby
module SessionHelper
  def login?
    session[:user] == "admin"
  end
end
```

routes

```ruby
get 'login', to: 'session#new'
post 'login', to: 'session#create'
get 'logout', to: 'session#destory'
```

view `new.html.erb`

```erb
<%= form_tag controller: "session", action: "create", method: "post" do |form| %>
  <div class="field">
    <%= label_tag :name %>
    <%= text_field_tag :name %>
  </div>
  <div class="field">
    <%= label_tag :password %>
    <%= password_field_tag :password %>
  </div>
  <div class="actions">
    <%= submit_tag %>
  </div>
<% end %>
```

view `application.html.erb`

```erb
<% unless login? %>
  <%=link_to "login", login_path%>
<% else %>
  <%=link_to "logout", logout_path%>
<% end %>
```

controller `before_action` filter

```ruby
class ApplicationController < ActionController::Base
  before_action :authenticate!
  def authenticate!
    if session[:user] != 'admin'
      redirect_to login_path
    end
  end
end

class BlogsController < ApplicationController
  skip_before_action :authenticate!
end

class SessionController < ApplicationController
  skip_before_action :authenticate!
end

class CommentsController < ApplicationController
  skip_before_action :authenticate!, only: [:create, :show]
end
```





### Step 5 Pagination

use third-party gem will_paginate

will_paginate

gem `Gemfile`

```ruby
gem 'will_paginate'
```

shell

```sh
bundle install 
```

Controller 

```ruby
def index
  @posts = Post.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
end
```

View `index.htm.erb`

```erb
<%= will_paginate @posts %>
```

restart the server

```shell
rails server
```

说明

网址中有 `?page=1` 参数



kaminari 功能和主题多一些

```ruby
@users = User.order(:name).page(params[:page]) #.per(10)
<%= paginate @users %>
```



bundle install 

```ruby
@microposts = @user.microposts.paginate(page: params[:page])
@posts =  Post.paginate(page: params[:page])

<%= will_paginate @posts %>
```

will_paginate-bootstrap

```erb
@users = User.order(:name).page params[:page]
<%= paginate @users %>
```



### Step 6 Bootstrap

rails generate bootstrap:install

https://github.com/seyhunak/twitter-bootstrap-rails

application.scss

```scss
@import "bootstrap";
```

application.js 

```js
// = require jquery3 
// = require popper 
// = require bootstrap
```

application.html.erb

```html


```

restart the server



用到 assert pipeline



### Step 7 Ajax

s

rails3 rjs

 call insert_html, replace_html, remove, show, hide, visual_effect

ActionView::Helpers::PrototypeHelper::JavaScriptGenerator::GeneratorMethods	

button_to

link_to

Prototype-rails

## Day 3 Users



### Step 1 Users

用户系统

权限系统

shell

```sh
rails generate scaffold User name:string password:string 
rails generate model Group name:string
rails generate model UserGroup user:references group:references
rails generate controller Sessions new create destory
rails db:migrate
```

model

```ruby
class User < ApplicationRecord
  has_many :user_groups
  has_many :groups, through: :user_groups
end

class Group < ApplicationRecord
  has_many :user_groups
  has_many :users, through: :user_groups
end

class UserGroup < ApplicationRecord
  belongs_to :user
  belongs_to :group
end
```

controller

```ruby
class SessionsController < ApplicationController
  def new
  end

  def create
    name = params[:name]
    password = params[:password]
    user = User.find_by(name: name, password: password)
    if user
      session[:user_id] = user.id
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end

module SessionsHelper
    def login?
        session[:user_id] != nil
    end   
    def current_user
        User.find_by(session[:user_id])
    end
end
```



routes

```ruby
resources :users
resource :session
```

session/new.html.erb

```erb
<%= form_tag controller: "sessions", action: "create", method: "post" do |form| %>
  <div class="field">
    <%= label_tag :name %>
    <%= text_field_tag :name %>
  </div>
  <div class="field">
    <%= label_tag :password %>
    <%= password_field_tag :password %>
  </div>
  <div class="actions">
    <%= submit_tag "Login" %>
  </div>
<% end %>
```



```erb
    <%= form_for(:session, url: login_path) do |f| %>

      <%= f.label :email %>
      <%= f.email_field :email, class: 'form-control' %>

      <%= f.label :password %>
      <%= f.password_field :password, class: 'form-control' %>

      <%= f.submit "Log in", class: "btn btn-primary" %>
    <% end %>

    <p>New user? <%= link_to "Sign up now!", signup_path %></p>
```





application.html.erb

```erb
  <% unless login? %>
  <%=link_to "login", new_session_path%>
<% else %>
  <%= current_user.name %><%=link_to "logout", session_path, method: :delete %>
<% end %>
```







`belongs_to` 对应数据库的外键

+ `bolongs_to :parent` 约定 外键为 `parent_id` 

`has_many` 用于 一对多关系，约定 存在 类 Item 有属性 post_id 

+ `has_many :items`
+ 等价于 `has_many :items, class_name: 'Item', source: item`

`has_many :through` 用于 many-to-many 关系

+  `has_many :users, through: :user_groups`
+ 等价于 `has_many :users, through: :user_groups, class_name: 'User', source: :user`



### Step 2 Follow

shell

```sh
rails generate scaffold Friendship user:references following_id:integer
```

Migration

```ruby
add_index :friendships, :following_id
add_index :friendships, [:user_id, :following_id], unique: true
```

model


```ruby
class Friendship
  belongs_to :user
  belongs_to :following, class_name: 'User'
end

class User < ApplicationRecord
  
  has_many :friendships
  has_many :following, through: :friendships
  
#  has_many :friendships_v, class_name: 'Friendship', foreign_key: 'following_id'
#  has_many :followers, through: :friendships_v, source: :user
    
  def followers
    Friendship.find_by_following(self.id).users
  end

end
```




```ruby
class User < ApplicationRecord
  def following
    User.exc_query(
        'select user.* from users join follows on users.id==follows.to_id where follows.from_id=?',
        self.id
    )
  end
  def followers
    Follow.find(self.id).following
  end
end

  has_many :follower_relationships, foreign_key: :following_id, class_name: 'Follow'
  has_many :followers, through: :follower_relationships, source: :follower

  has_many :following_relationships, foreign_key: :follower_id, class_name: 'Follow'
  has_many :following, through: :following_relationships, source: :following

class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  .
  .
  .
end
```



得到的 sql 语句是

### Step 3 Timeline

shell

```sh
rails generate scaffold Post body:string user:references 
rails generate controller Home timeline
```

model

```ruby
class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  def messages
    sql = "SELECT * FROM posts WHERE user_id IN (SELECT following_id FROM friendships WHERE user_id = ?) OR user_id = ? ORDER BY created_at DESC LIMIT 10"
    Post.find_by_sql([sql, self.id, self.id])
  end
end
```

controller

```ruby
def timeline
  sql = "SELECT * FROM posts WHERE user_id IN (SELECT to_id FROM relationships WHERE from_id = :id) OR user_id = :id ORDER BY created_at DESC LIMIT 10"
  @posts = Post.find_by_sql(sql, {id:params[:id]})
end
```

view

 `timeline.htm.erb`

```erb
<ul>
  <% @posts.each do  |post| %>
  <li>(<%= post.user.name %>)<%= post.body%></li>
  <% end %>
</ul>
```

`users.html.erb`

```erb
<ul><% @users.each do  |user|  %>
<li> <%= user.id %> <%= user.name %>
<% unless Friendship.find_by(user_id:current_user.id, following_id: user.id)  %>
 <%= button_to 'Follow', action: "create", controller: "friendships", params: {friendship: {user_id:current_user.id, following_id: user.id}} %></li>
 <% else %>
 <%= button_to 'Unfollow', Friendship.find_by(user_id:current_user.id, following_id: user.id),method: :delete %></li>
<% end %>
<% end %>
</ul>
```

```erb
  <% unless login? %>
  <%=link_to "login", new_session_path%>
<% else %>
  <%= current_user.name %> <%=link_to "logout", session_path, method: :delete %>
<% end %>
```



c

```ruby
class HomeController < ApplicationController
  def timeline
    @posts = helpers.current_user.messages
  end

  def users
    @users = User.where('id!=?',helpers.current_user.id)
  end

end
```





### Step 4 Haml

```
gem 'haml-rails'
bundle install
```



### Step 4 Theme

bootstrap

### Step 5 Namespace 



shell

```
rails g controller admin/session
```

routes

```
namespace :admin do
  resources :cs
end
```



collection

member

### Step 6 Module

 `/lib`

## Day 4 CMS

### Step 1 Haml

```
gem 'haml-rails'
bundle install
```



### Step 2 Grid

```sh
model Tables name:string
model TableField table:reference name:string type:string
```



### Step 3 Form



gen form

```ruby
def form_field

end

def g_form(model_name, fields)
  
  form_for '' do
    for name, type in fileds
      f.label name
      form_field(type,name)
    end
  end
end
```





### Step 4 Menu

多层级导航目录（左侧 layout）

```sh
model TreeNode parent_id:integer name:string table:references
```



### Step 5 Index



### Step 6 Chart



自定义表格类型，栏目。

Drupal+XAMPP

查询优化

timestamp

counter cache

1+n

后台任务



## Day 5 Shop

### Step 1 Model

shell

```sh
rails generate scaffold User name:string password:string 
rails generate controller session new create destory

rails generate scaffold Products name:string desc:string pic:string
rails generate scaffold CartItems product:references user:references

rails generate scaffold Orders user:references
rails generate model OrderItems product:references

rails generate scaffold Index 
```



work flow

### Step 2 State Machine



## Day 6 Bootstrap

### Step 1 Navbar

### Step 2 Layout

### Step 3 Button

### Step 4 Modal



## w



```bash
gem install sinatra sinatra-contrib activerecord sqlite3
gem install rails
gem install nokogiri
gem install rails rails-bootstrap
```

'require.js'

haml / slim

simple_form

Paperclip Carrierwave 和 Paperclip

WiceGrid

CanCanCan

Devise 

Nokogiri

Whenever Sidekiq Grape

lazy_high_charts

RuCaptcha

https://ruby-china.org/wiki/gems

## 附录

rails m 使用

sqlite

类型




## References

+ http://sinatrarb.com/ 
  + http://sinatrarb.com/intro.html
  + http://www.screencasts.org/episodes/activerecord-with-sinatra
+ https://rubyonrails.org 
  + http://guides.rubyonrails.org/
  + http://api.rubyonrails.org/
+ https://www.railstutorial.org/
+ https://sqlitestudio.pl/
+ 
+ https://www.devwalks.com/lets-build-instagram-in-rails-part-1/
+ https://www.devwalks.com/lets-build-instagram-with-ruby-on-rails-part-6-follow-all-the-people/
+ https://ihower.tw/rails/index-cn.html
+ http://htmltohaml.com/



