---
layout: post
title: "Quiz for Rails Beginners 3"
date: 2014-10-12 16:22:01 +1100
comments: true
categories:
  - quiz
  - Rails
  - beginner
  - MVC
  - polymorphic
  - associations
  - user authentication
  - security
---
Here's the third quiz for people who are just getting started learning web-application development. 
This revisits the basics of MVC, implementing basic user-authentication and polymorphic associations.

<!-- more -->

1. <a name='q1'></a>[What's the difference between rendering and redirecting? What's the impact with regards to instance variables, view templates?](#a1)

2. <a name='q2'></a>[If I need to display a message on the view template, and I'm redirecting, what's the easiest way to accomplish this?](#a2)

3. <a name='q3'></a>[If I need to display a message on the view template, and I'm rendering, what's the easiest way to accomplish this?](#a3)

4. <a name='q4'></a>[Explain how we should save passwords to the database.](#a4)

5. <a name='q5'></a>[What should we do if we have a method that is used in both controllers and views?](#a5)

6. <a name='q6'></a>[What is memoization? How is it a performance optimization?](#a6)

7. <a name='q7'></a>[If we want to prevent unauthenticated users from creating a new comment on a post, what should we do?](#a7)

8. <a name='q8'></a>[Suppose we have the following table for tracking "likes" in our application. How can we make this table polymorphic? Note that the "user_id" foreign key is tracking who created the like.](#a8)  

    id | user_id | photo_id | video_id | post_id
    --:|:-------:|:--------:|:--------:|:-------:
    1  | 4       |          | 12       |
    2	 | 7       |          |          | 3
    3  | 2       | 6

9. <a name='q9'></a>[How do we set up polymorphic associations at the model layer? Give example for the polymorphic model (eg, Vote) as well as an example parent model (the model on the 1 side, eg, Post).](#a9)

10. <a name='q10'></a>[What is an ERD diagram, and why do we need it?](#a10)

### MY ANSWERS:
<a name='a1'></a>
__A1__: Rendering a view template happens as (the final) part of a single HTTP request, whereas redirecting means end of a request and initiation a whole new request. And because of that, redirecting would not enable use of instance variables in the view templates unlike direct rendering.  
[Back](#q1)

<a name='a2'></a>
__A2__: Using a hash referenced in the layout would be the easiest way to display messages if redirecting. For example:  
`flash[:notice] = 'You have successfully updated the profile'`
`flash[:error] = 'The login credentials you entered are incorrect'`  
[Back](#q2)

<a name='a3'></a>
__A3__: For generic messages, using the same hash as described in [A2](#a2) above would work. If error messages on a model-object stored in an instance variable need to be displayed, that instance variable can be used directly in the view template using something like  
``` ruby
<% if model_obj.errors.any? %>
  <div class='row'>
    <div class='alert alert-error span8'>
      <h5>Please fix the errors below to submit successfully:</h5>
      <ol>
        <% model_obj.errors.full_messages.each do |msg| %>
          <li><%= msg %></li>
        <% end %>
      </ol>
    </div>
  </div>
<% end %>
```
[Back](#q3)


<a name='a4'></a>
__A4__: Passwords should definitely never be stored directly as strings in the database. They should be auto converted to complex strings (obfuscated) using a dedicated gem (like __bcrypt-ruby__). Such a gem can help obfuscate the user-entered password using the same mechanism to obfuscate the originally set password. Thus the comparison between the user entered and originally set password can happen indirectly through the obfuscated strings. This obfuscation is one-way, that means the stored string cannot be converted back to the actual password string.
In case of the bcrypt-ruby gem, the database table for the model needs to have a column named 'password_digest' that can hold a string. The model itself needs to have the `has_secure_password` validation declared in its class-definition. bcrypt-ruby gives a method named `authenticate` for the model-object which can be used to match the user-entered password to the stored one.  
[Back](#q4)

<a name='a5'></a>
__A5__: If a helper method defined in the ApplicationController class (which each of the controllers inherit from) needs to be used by both the views, and the controllers, the `helper_method` needs to be called in the ApplicationController class definition with the helper-method names passed to it as arguments (as `:symbol`s). So, a line like the one below in the ApplicationController class definition  
`helper_method :current_user, :logged_in?`  
will allow the methods `current_user` and `logged_in?` to be used in both views and controllers. Note that a call to `helper_method` is not necessary if these only need to be used in the controllers.  
[Back](#q5)

<a name='a6'></a>
__A6__: 'Memoization' (a play on the word 'memoir') is an optimization technique used to speed up computer programs by storing the results of expensive function calls and returning the cached result when the same operation is requested repeatedly.  
It can be implemented in Ruby using the operator `||=` to assign a value to an instance variable. This can be used effectively to store results from a repeated database query (which can be quite performance intensive). The statement below is 'memoization' in action:  
`@current_user ||= User.find(session[:user_id]) if session[:user_id]`  
If the `current_user` instance variable is already populated (say, from a previous call to this statement), the cached result will be returned and evaluation of the right side of the above expression will be avoided.  
[Back](#q6)

<a name='a7'></a>
__A7__: The rendering and submission of new comment form (Comments#new and Comments#create actions) should be allowed only if a user is logged in. This can be achieved by a common helper method that checks whether a valid user is logged in. This method will be defined in the parent controller class ApplicationController. This method can be called in the Comments controller class using the `before_action` keyword which will trigger checking of a valid user before executing certain actions.
`before_action :logged_in?, only: [:new, :create]`  
[Back](#q7)

<a name='a8'></a>
<div class='no_extra_new_line'>__A8__: The table below shows the polymorphic version of the one shown in the question:</div>
<table style='margin-left:2em'>
  <thead>
    <tr>
      <th style="text-align: right">id</th>
      <th style="text-align: center">user_id</th>
      <th style="text-align: center">likeable_type</th>
      <th style="text-align: center">likeable_id</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align: right">1</td>
      <td style="text-align: center">4</td>
      <td style="text-align: center">Video</td>
      <td style="text-align: center">12</td>
    </tr>
    <tr>
      <td style="text-align: right">2</td>
      <td style="text-align: center">7</td>
      <td style="text-align: center">Post</td>
      <td style="text-align: center">3</td>
    </tr>
    <tr>
      <td style="text-align: right">3</td>
      <td style="text-align: center">2</td>
      <td style="text-align: center">Photo</td>
      <td style="text-align: center">6</td>
    </tr>
  </tbody>
</table>  
[Back](#q8)

<a name='a9'></a>
<div class='no_extra_new_line'>__A9__: The 'like' model would look like this</div>
```Ruby like.rb
class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :likeable, polymorphic: true
end
```
The User model (creator of the 'like's) will look like this  
```Ruby User.rb
class User < ActiveRecord::Base
  has_many :photos
  has_many :videos
  has_many :posts
  has_many :likes
end
```
Finally, the 'likeable's: Photo, Video and Post models, are shown below  
```Ruby photo.rb
class Photo < ActiveRecord::Base
  belongs_to :poster, foreign_key: 'user_id', class_name: 'User'
  has_many :likes, as: :likeable
end
```
```Ruby video.rb
class Video < ActiveRecord::Base
  belongs_to :poster, foreign_key: 'user_id', class_name: 'User'
  has_many :likes, as: :likeable
end
```
```Ruby post.rb
class Post < ActiveRecord::Base
  belongs_to :poster, foreign_key: 'user_id', class_name: 'User'
  has_many :likes, as: :likeable
end
```
[Back](#q9)

<a name='a10'></a>
__A10__: Entity Relationship Diagrams show individual ActiveRecord models and their association with each other. Individual models are represented as blocks and also show the columns that model's database table needs to have. These are really handy when we are setting up the database models and associations between them.  
See the ERD below for the PostIt application (Courtesy - Tealeaf Academy):
![Final ERD](http://d3ncao0pifc37i.cloudfront.net/images/ERD_final.jpg)   
[Back](#q10)


<div id="disqus_thread"></div>
<script type="text/javascript">
    /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
    var disqus_shortname = 'ppjgithubio'; // required: replace example with your forum shortname

    /* * * DON'T EDIT BELOW THIS LINE * * */
    (function() {
        var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
        dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
    })();
</script>
<noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
<a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>
