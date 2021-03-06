# Mastering Ruby In 7 Days

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



约定 over 配置

+ 优点
  + 学习良好的习惯
  + 合作时增加共识

+ 缺点
  + 采用默认约定时调用规则不明显
  + 需要修改默认配置的时候不方便

Agile

+ 敏捷 设计到实现
+ 测试驱动，迭代实现

MVC Model–view–controller

+ view 不维护状态，model 保持状态
+ view 上 action 1. 触发 controller 改变 model，或者 2. 切换 view
+ model 改变后重新渲染新状态下的 view
+ 可以多个 view 对应 一个 model

Restful

+ Stateless Server
+ Resource Identifier
  + 对象资源
  + `/resources/1/action` 对应方法
  + `/resources/action` 对应类方法
  + 单实例类 `/resource/action/`





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

- `model:references` equals  `model_id:integer`

- `timestamp` equals `created_at:datetime updated_at:datetime`

Query

+ find
+ find_by
+ find_or_initialize_by

Modify

+ `#save`
+ `#create` `#update`
+ ...! 





### Step 4 View



**Form**



form_for

中文 i18n



`_form.html.erb`

```erb
<%= form_for post do |form| %>
  <div><%= form.label :title %><%= form.text_field :title %></div>
  <div><%= form.label :body %><%= form.text_area :body %></div>
  <div><%= form.submit %></div>
<% end %>
```

Data Binding

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

form_tag 用于不绑定到 model 的表单

new_record? 规则 

path action

path action



belong_to

collection_select 

collection_check_box







**选项框**

固定选项

不固定，读取选项

单选

多选





Layout `application.html.erb` `<div><%= yield %></div>`

Flash

- controller  `redirect_to ..., notice: '...' ` 

  + 用于执行提交成果，转到 #show 或 #index

  - 等价于 `flash[:notice] = ...; redirect_to ...`
  - 另一种 `flash.now[:notice] = ...; render ...` 
  - 用于提交失败可重新提交 用于 #create 或 #update 

- view  `<p id="notice"><%= notice %></p>` 

params

+ 可用于 view 保持状态，结合 post + render 使用



**Actions**

url_for

+ `url_for "Recent" controller: 'posts', action: 'recent' ` 通过 action

link_to

+ `link_to "Show", controller: "posts", action: "show", id: @post` 通过 id + action
+ `link_to "Show", posts_path` 通过 routes
+ `link_to "Show", @post` 通过 model 默认 controller#show
+ `link_to "List", controller: "posts"` 默认 #index
+ `link_to "List", {controller: "posts", page: 1}` 加参数

button_to

+ 默认 `method: :post` 
+ 附加field `params: {...}`

form_tag

+ 可以带用户表单作为参数

对资源的操作会用到

```erb
<%= link_to 'New Post', new_post_path %>
<%= link_to 'Show', post %>
<%= link_to 'Edit', edit_post_path(post) %>
<%= link_to 'Destroy', post, method: :delete, data: { confirm: 'Are you sure?' } %>
<%= link_to 'Back', posts_path %>
```



**Helper** 

helper 在 view 使用，无状态

返回渲染的字符串

render partial

yield block





### Step 5 Controller



method



render

+ 默认不用显式写出 render

+ `render :action`
+ `render 'controller/action'`

redirect_to

+ `redirect_to record` #show
+ `redirect_to ..._path` 通过 routes
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

#new_record?



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

路由产生 `(路径，controller#action，名称)` 元组

rails routes

http://localhost:3000/rails/info/routes

root

首页

```ruby
root 'posts#index'
```

相当于

```ruby
root to: 'posts#index'
get '', action: :index, controller: 'posts', as: :root
```



Resource

```ruby
resources :posts
```

相当于 添加 7 条 默认 actions

```ruby
get 'posts',          to: 'posts#index',   as: :posts
get 'posts/:id/new',  to: 'posts#new',     as: :new_post
post 'posts',         to: 'posts#create',  as: :posts
get 'posts/:id',      to: 'posts#show',    as: :post
get 'posts/:id/edit', to: 'posts#edit',    as: :edit_post
put 'posts/:id',      to: 'posts#update',  as: :post
delete 'posts/:id',   to: 'posts#destroy', as: :post
```





seven default actions

`get '/posts/:id', to: 'posts#show', as: 'post'`

可以增加成员方法和类方法

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





Nested Resources 嵌套资源

用于 has_many

name space



Singular Resources 单数资源



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

- save  返回 Boolean 表示是否验证通过
  + #create `Post.new(params[:model]).save`
  + #update `Post.find(params[:id]).update(params[:model])` 

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

通过 `model.errors` 

+ `model.errors.any?`
+ `model.errors.full_messages`

`_form.html.erb`

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

### Step 1 New

```ruby
rails new myblog
cd myblog
rails generate scaffold Post title:string body:text
rails db:migrate
rails server
```

open http://127.0.0.1:3000/posts/

说明

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





### Step 2 Associations

shell

```sh
rails generate scaffold Comment name:string body:text post:references
rails db:migrate
```

ruby

自动生成的

```ruby
class Comment
  belongs_to :post
end
```

相当于

```ruby
class Comment
  def post
    Post.find(self.id)
  end
  def post=(record)
    self.post_id = record.id
  end
end
```

其中

+ `bolongs_to` 不影响数据库的结构，仅用来生成了方便使用的 #post，#post= 方法。

+ `belongs_to :post`  中的`:post` 为所增加的属性的名称 `attr_accessor :post`

+ 按照命名约定 等价于 `belongs_to :post, class_name: 'Post', foreign_key: 'post_id'  ` 

+ 即 comments 表中存在列外键 post_id， Comment#post 返回 Post 类型



对应的可以手工添加

```ruby
class Post
  has_many :comments
end
```

相当于（不严格）

```ruby
class Post
  def comments
    Comment.where(post_id: self.id)
  end
  def comments_build
    Comment.new(post_id: self.id)
  end
  def comments_size
    comments.count
  end    
  def comments=(objects)
    comments.update_all(post_id: self.id)
  end
end
```

其中

+ has_many 不影响数据库结构，当前表中不需要字段，对应表中存在外键
+ `class Post; has_many :comments; end` 添加 `attr_accessor :comments`
+ 约定为 `has_many :comments, class_name: 'Comment', foreign_key: 'post_id'`



Routes



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
  
  protected
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

 authorize



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

application.css.scss

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

局部刷新



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
  has_many :group_users
  has_many :groups, through: :group_users
end

class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
end

class GroupUser < ApplicationRecord
  belongs_to :user
  belongs_to :group
end
```



其中

```ruby
class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
end
```

相当于

```ruby

```

根据命名约定等价于

```ruby
class Group < ApplicationRecord
  has_many :group_users, class_name: 'UserGroup', foreign_key: 'group_id'
  has_many :users, through: :group_users, source: ''
end
```

相当于

```ruby
class Group
  has_many :group_users
  def users
    self.group_users
  end
end
```

也相当于

```ruby
class Group
  def users
  end
end
```





has_many :through 和 join model 配合使用





sessions

model

```ruby
class User
  def authenticate(password)
    self.password == password
  end
end
```

view

helper.rb

```ruby
module SessionsHelper
  def login?
    session[:user_id] != nil
  end   
  def current_user
    User.find_by(session[:user_id])
  end
end
```

new.html.erb

```erb
<%= form_tag controller: "sessions", action: "create", method: "post" do |form| %>
  <div>
    <%= label_tag :name %>
    <%= text_field_tag :name, params[:name] %>
  </div>
  <div>
    <%= label_tag :password %>
    <%= password_field_tag :password %>
  </div>
  <div>
    <%= submit_tag "Login" %>
  </div>
<% end %>
```

application.html.erb



controller

```ruby
class ApplicationController < ActionController::Base
  before_action :authorize
  
  protected
  def authorize
    unless session[:user_id]
      redirect_to login_path
    end
  end
end
class SessionsController < ApplicationController
  skip_before_action :authorize
  def new
  end

  def create
    user = User.find_by(name:params[:name])
    if user && user.authenticate(params[:password])
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
```

user.authenticate(password)





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
    <%= text_field_tag :name, params[:name] %>
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



accounts

application.html.erb

```erb
  <% unless login? %>
  <%=link_to "login", new_session_path%>
<% else %>
  <%= current_user.name %><%=link_to "logout", session_path, method: :delete %>
<% end %>
```



```ruby

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

### Step 2 Role

```
rails generate scaffold User name:string password:string 
rails generate scaffold Role name:string
rails generate model RoleUser user:references role:references
rails generate controller Sessions new create destory
rails generate controller Admin/Users new create destory
rails db:migrate
```

```ruby
class User < ApplicationRecord
  has_many :role_users
  has_many :groups, through: :role_users
end

class Role < ApplicationRecord
  has_many :role_users
  has_many :users, through: :role_users
end

class RoleUser < ApplicationRecord
  belongs_to :user
  belongs_to :role
end
```



### Step 2 Grid

```sh
rails g scaffold Table name:string
rails g model Field table:references name:string type:string
rails db:migrate
rails g controller Rows edit update
```



```ruby
class Table < ApplicationRecord
  has_many :fields
  def data
    class_name = "Table#{id}"
    t = Class.new(ApplicationRecord) do
        def self.name
          "Row"
        end
    end
    t.table_name=("_table#{id}")
    t.reset_column_information
    t
  end
end
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



### Step 3 Tree



多层级导航目录（左侧 layout）

```sh
rails add parent_id:integer folder:boolean index:integer
rails db:migrate
rails g controller Admin::Trees  
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





state

Continuations

print and pause

### Step 3 Transaction

金额精度

Pessimistic Locking

```ruby
Item.transaction do
  i = Item.lock.first
  i.name = 'Jones'
  i.save!
end
```

Optimistic Locking



a column called lock_version of type integer. 



## Day 6 Bootstrap

### Step 1 HTML



+ p `<p>...</p>`
+ link `<a href="...">...</a>`
+ image `<img src="..." alt="...">`
+ list `<ul><li>...</li><li>...</li></ul>`

table `<table></table>`

+ header `<th><td>...</td><td>...</td></th>`

+ row `<tr><td>...</td><td>...</td></tr>`

form

+ input
+ text area
+ select
+ submit



### Step 2 CSS

block `<div>...</div>`, inline `<span>...</span>`

width height border

color

图文混合排版

文字 背景框

### Step 3 Bootstrap

layout container row col



### Tree View



后台管理界面，登陆界面，新闻展示界面，

theme 抽象

### Step 1 Post

html

css



### Step 2 Layout



### Step 1 Login

登录界面

### Step 2 News

新闻展示首页，纵向布局，加分栏

### Step 3 Admin

后台管理界面

头

侧边

内容

 Step 4 Table

Step 5 Form

 Step 1 Navbar

 Step 2 Layout

 Step 3 Button

## Day 7 Admin

### Day 1 Namespace

### Day 2 Layout

## Day 8 Now

### Step 1 Cache

### Step 1 Active Resource

### Step 3 Active Job

perform_later

### Step 2 Action Cable

### Server

capistrano

·#authenticate  ·

Active Resource supports the token based authentication

Response (201)

code (204)

At GitHub we use Resque to process the following types of jobs:

Warming caches
Counting disk usage
Building tarballs
Building Rubygems
Firing off web hooks
Creating events in the db and pre-caching them
Building graphs
Deleting users
Updating our search index

rabbitmq+

https://www.rabbitmq.com/tutorials/tutorial-one-ruby.html


## w



```bash
gem install sinatra sinatra-contrib activerecord sqlite3
gem install rails
gem install nokogiri
gem install rails rails-bootstrap
```

'require.js' 管理多个 js 文件

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

命令

```sh
rails new project
cd project
bundle install
rails g scaffold Post title:string
rails g model Post title:string
rails g controller Posts index show new create edit update destroy
rails db:migrate
rails routes
rails c #console reload!
rails destroy #destroy
```



函数

.present?

reset_column_information 


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



