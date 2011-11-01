Use Redis to Make your Ruby objects Likeable!
======

You like this
-------------
Likeable is the easiest way to allow your models to be liked by users, just drop a few lines of code into your model and you're good to go.

```ruby

    class Comment
      include Likeable

      # ...
    end

    class User
      include Likeable::UserMethods

      # ...
    end

    Likeable.setup do |likeable|
      likeable.redis   = Redis.new
    end

    comment = Comment.find(15)
    comment.like_count                  # => 0
    current_user.like!(comment)         # => #<Likeable::Like ... >
    comment.like_count                  # => 1
    comment.likes                       # => [#<Likeable::Like ... >]
    comment.likes.last.user             # => #<User ... >
    comment.likes.last.created_at       # => Wed Jul 27 19:34:32 -0500 2011

    comment.liked_by?(current_user)     # => true

    current_user.all_liked(Comment)     # => [#<Comment ...>, ...]

    liked_comment = Likeable.find_by_resource_id("Comment", 15)
    liked_comment == comment            # => true

```


Setup
=======
Gemfile:

    gem 'likeable'

Next set up your Redis connection in initializers/likeable.rb:

```ruby

    Likeable.setup do |likeable|
      likeable.redis  = Redis.new
    end
```

Then add the `Likeable::UserMethods` module to models/user.rb:

```ruby

    class User
      include Likeable::UserMethods
    end
```

Finally add `Likeable` module to any model you want to be liked:

```ruby

    class Comment
      include Likeable
    end
```

## Rails Info
If you're using Likeable in Rails this should help you get started

 controllers/likes_controller.rb

```ruby

  class LikesController < ApplicationController

    def create
      target = Likeable.find_by_resource_id(params[:resource_name], params[:resource_id])
      current_user.like!(target)
      redirect_to :back, :notice => 'success'
    end

    def destroy
      target = Likeable.find_by_resource_id(params[:resource_name], params[:resource_id])
      current_user.unlike!(target)
      redirect_to :back, :notice => 'success'
    end
  end

```

config/routes.rb

```ruby

    delete  'likes/:resource_name/:resource_id' => "likes#destroy", :as => 'like'
    post    'likes/:resource_name/:resource_id' => "likes#create",  :as => 'like'

```

helpers/like_helper.rb

```ruby

  def like_link_for(target)
    link_to "like it!!", like_path(:resource_name => target  .class, :resource_id => target.id), :method => :post
    end

    def unlike_link_for(target)
      link_to "unlike it!!", like_path(:resource_name => target.class, :resource_id => target.id), :method => :delete
    end

```

Then in any view you can simply call the helper methods to give your user a link

```ruby

    <%- if @user.likes? @comment -%>
      <%= unlike_link_for @comment  %>
    <%- else -%>
      <%= like_link_for @comment %>
    <%- end -%>


```



Thats about it.

               RedisRed            RedisRedi
            RedisRedisRedi       RedisRedisRedisR
          RedisRedisRedisRedi   RedisRedisRedisRedi
         RedisRedisRedisRedisRedisRedisRe       Redi
        RedisRedisRedisRedisRedisRedisRe         Redi
       RedisRedisRedisRedisRedisRedisRedisR       Redi
       RedisRedisRedisRedisRedisRedisRedisRedis      R
      RedisRedisRedisRedisRedisRedisRedisRedisRedi  Red
      RedisRedisRedisRedisRedisRedisRedisRedisRedisRe R
      RedisRedisRedisRedisRedisRedisRedisRedisRedisRedi
      RedisRedisRedisRedisRedisRedisRedisRedisRedisRedi
       RedisRedisRedisRedisRedisRedisRedisRedisRedisRe
        RedisRedisRedisRedisRedisRedisRedisRedisRedis
          RedisRedisRedisRedisRedisRedisRedisRedisRe
            RedisRedisRedisRedisRedisRedisRedisRe
               RedisRedisRedisRedisRedisRedisR
                  RedisRedisRedisRedisRedis
                    RedisRedisRedisRedis
                       RedisRedisRed
                         RedisRedi
                           RedisR
                            Redi
                             Re
Authors
=======
[Richard Schneeman](http://schneems.com) for [Gowalla](http://gowalla.com) <3


Contribution
============

Fork away. If you want to chat about a feature idea, or a question you can find me on the twitters [@schneems](http://twitter.com/schneems).  Put any major changes into feature branches. Make sure all tests stay green, and make sure your changes are covered.


licensed under MIT License
Copyright (c) 2011 Schneems. See LICENSE.txt for
further details.
