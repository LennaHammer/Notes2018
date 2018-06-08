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

### Step 3 Associations



```sh
rails generate scaffold Comment name:string body:text post_id:integer
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
```



C

```ruby
# controllers/posts_controller.rb
@comments = @post.comments
```



 





### Step 4 Session

session

before_action

```ruby
before_action :logged_in_user
```



Validation

### Step 5 pagination

will_paginate

bundle install 

```ruby
@microposts = @user.microposts.paginate(page: params[:page])
```



### Step 6 bootstrap

rails generate bootstrap:install

https://github.com/seyhunak/twitter-bootstrap-rails

### Step 7 Ajax

s
## w



```bash
gem install sinatra sinatra-contrib activerecord sqlite3
gem install rails rails-bootstrap
```

'require.js'


## Ref

+ http://sinatrarb.com/ 
+ http://sinatrarb.com/intro.html
+ http://www.screencasts.org/episodes/activerecord-with-sinatra
+ http://guides.rubyonrails.org/
+ http://api.rubyonrails.org/
+ https://www.railstutorial.org/