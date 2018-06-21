# Learn Ruby

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





## Day 2 Posts

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



```
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
rails g controller blogs index show
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
get 'blogs/:id',to: 'blogs#show'
```

application.html.erb

```html
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>
```

show.htm.erb

```erb
<h1><%= @post.title %></h1>
<p id="notice"><%= notice %></p>
<p>
  <%= @post.body %>
</p>
<ul>
  <% @post.comments.each do |comment| %>
    <li>
      (<%= comment.name %>)<%= comment.body %>
    </li>
  <% end %>
</ul>

<%= render 'comments/form', comment: @post.comments.build %>
```



### Step 4 Session

shell

```sh
rails g controller session new create destory
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
      redirect_to "/"
    else
      render "new"
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
      redirect_to root_path
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

## Day 3 Users



### Step 1 Users

用户系统

权限系统

shell

```sh
rails generate scaffold User name:string password:string 
rails generate model Group name:string
rails generate model UserGroup user:references group:references
rails generate controller session new create destory
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
# User
class UserController
  
end

# Session
class SessionController
  
end
```



routes

```ruby
get 'signup', to: 'users#new'
post 'signup', to 'user#create'

get 'login', to: 'session#new'
post 'login', to: 'session#post'
get 'logout', to: 'session#destory'
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
rails generate model Friendships user:references following_id:integer
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



得到的sql语句是

### Step 3 Timeline

shell

```sh
rails generate scaffold Post body:string user:references 
```

model

```ruby
class User < ApplicationRecord
  has_many :posts, dependent: :destroy
end
```

controller

```ruby
def timeline
  sql = "SELECT * FROM posts WHERE user_id IN (SELECT to_id FROM relationships WHERE from_id = :id) OR user_id = :id ORDER BY created_at DESC LIMIT 10"
  @posts = Post.find_by_sql(sql, {id:params[:id]})
end
```

view `timeline.htm.erb`

```erb
<% @posts.each do |post| %>
  <%= post.user.name %>
  <%= post.user.body %>
<% end %>
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

## Day 4 CMS



自定义表格类型，栏目。

Drupal+XAMPP

查询优化

timestamp

counter cache

1+n

后台任务



## Day 5 Shop

shell

```sh
rails generate scaffold User name:string password:string 
rails generate controller session new create destory

rails generate scaffold Goods name:string desc:string pic:string
rails generate scaffold Cart name:string password:string

rails generate scaffold Order name:string password:string
rails generate model GoodsOrder name:string password:string

rails generate scaffold Index name:string password:string
```



work flow



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



