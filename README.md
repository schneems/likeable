Use Redis to Make your Ruby objects Likeable!
======

You like this
-------------
Likeable is the easiest way to allow your models to be liked by users, just drop a few lines of code into your model and you're good to go.

```ruby

    class Comment
      attr_accessor :id

      # ...
    end

    Likeable.setup do |likeable|
      likeable.classes = [Comment]
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
```


Setup
=======
Gemfile:

    gem 'Likeable'

Next set up your Redis connection and specify models to like in initializers/likeable.rb:

```ruby
    Likeable.setup do |likeable|
      likeable.classes = [Comment, Spot]
      likeable.redis   = Redis.new
    end
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

Contribution
============

Fork away. If you want to chat about a feature idea, or a question you can find me on the twitters [@schneems](http://twitter.com/schneems).  Put any major changes into feature branches. Make sure all tests stay green, and make sure your changes are covered.


licensed under MIT License
Copyright (c) 2011 Schneems. See LICENSE.txt for
further details.
