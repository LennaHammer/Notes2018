# Ruby

## Day 1 Sinatra

### Step 1 Hello World

```ruby
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  'Hello'
end

```



open http://127.0.0.1:4567/



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



```
presence present?
```

### Step 3 Guest Book



```ruby

```



flash + redirect

### Step 4 File





## Day 2 Rails

### Step 1 Start

```ruby
rails new myblog
cd myblog
rails server
```

open http://127.0.0.1:3000/

### Step 2 Scaffold

```bash
rails generate scaffold Post title:string body:text
rails db:migrate
```

open http://127.0.0.1:3000/posts/



type

+ `string`, `text`, `binary`
+ `integer`, `float`, `decimal`, `boolean`
+ `datetime`, `date`,  `time`
+ `timestamp` equals `created_at:datetime updated_at:datetime`
+ `references` equals  `model_id:integer`

Controller

+ redirect_to
+ render
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

routes

+ `/config/routes.rbs` `resources :posts ` `root 'posts#index' `
+ `rails routes`
+ resources
+ `get '...'` `get '...', to: 'posts#show'` 

view

+ helper 
+ layout
+ flash C `redirect_to`  V `notice` `redirect_to @post, notice: '...' `
+ redirect_to redirect_back
+ form 
  + `_form` 
  + `new` `edit`
  + `params[:post]` Hash permit
  + form helper
  + `form.label :name; form.text_field :name`
  + `form.text_area` `form.submit`
+ render Partial
+ render ""

test

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

R

```ruby
# Nested Resources

```



 Relation `belongs_to`

+ one 2 many `has_many`
+ many 2 many `has_many`
+ one 2 one `has_one`

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



### Step 4 Login

shell

```
rails g controller session login logout user_login
```

session_controller.rb

```erb
class SessionController < ApplicationController
  
  def login

  end

  def logout

  end

  def user_login
    name = params[:name]
    password = params[:password]
    if name=="1" and password==""
      session[:user] = :admin
      redirect_to "/"
    end
  end

  def check_login
    session[:user] == :admin
  end
end

```



login.html.erb

```erb
<%= form_tag controller: "session", action: "user_login", method: "post" do |form| %>
  <div class="field">
    <%= label_tag :name %>
    <%= text_field_tag :name %>
  </div>
  <div class="field">
    <%= label_tag :password %>
    <%= text_area_tag :password %>
  </div>
  <div class="actions">
    <%= submit_tag %>
  </div>
<% end %>
```



session

before_action

```ruby
before_action :logged_in_user only except
```

helper



Validation

### Step 5 Pagination

用插件

will_paginate

kaminari

bundle install 

```ruby
@microposts = @user.microposts.paginate(page: params[:page])
@posts =  Post.paginate(:page => params[:page])

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

restarted the server



### Step 7 Ajax

s

rails3 rjs

 call insert_html, replace_html, remove, show, hide, visual_effect

ActionView::Helpers::PrototypeHelper::JavaScriptGenerator::GeneratorMethods	

## Day 3 Users

```bash
rails generate scaffold User name:string password:string 
rails generate model Group name:string
rails generate model UserGroup user:integer group:integer
```

用户系统

权限系统

关注 Follow





Day 4 CMS



Drupal





## w



```bash
gem install sinatra sinatra-contrib activerecord sqlite3
gem install rails rails-bootstrap
```

'require.js'

haml




## Ref

+ http://sinatrarb.com/ 
+ http://sinatrarb.com/intro.html
+ http://www.screencasts.org/episodes/activerecord-with-sinatra
+ http://guides.rubyonrails.org/
+ http://api.rubyonrails.org/
+ https://www.railstutorial.org/
+ https://sqlitestudio.pl/index.rvt