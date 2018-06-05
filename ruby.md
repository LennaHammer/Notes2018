# Ruby

## Sinatra

### Hello World

```ruby
require 'sinatra'
require 'sinatra/reloader'

get '/' do
  'Hello'
end
  
```



### Active Record

```ruby
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db.sqlite3'
)

class Post < ActiveRecord::Base
end

get '/' do
  @posts = Post.all()
  erb :index
end

post '/add' do

end


```



## Rails

### Step 1 Start

```ruby
rails new myblog
cd myblog
rails server
```

### Step 2 Scaffold

```bash
rails scaffold posts title, body:string 
rails comments user,body, post_id
```

type 

### Step 3 Ass

Model

```ruby
# add to 
has_one :post
# add to PostModel
has_many :comment
```

View

```ruby
# add to
```





### Step 4 Session



before_action



### Step 5 pagination

### Step 6 bootstrap

### Step 7 Ajax




## Ref

+ http://sinatrarb.com/