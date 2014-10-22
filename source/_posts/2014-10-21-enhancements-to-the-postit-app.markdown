---
layout: post
title: "Enhancements To the PostIt App"
date: 2014-10-21 16:16:17 +1100
comments: true
categories: 
  - Rails
  - SJR
  - AJAX
  - Slug
  - DRY
  - Role
  - Timezone
---
The final lesson (Lesson 4) of Course 2 involved adding some more functionality to the [PostIt](ppj-postit.heroku.com) app (the Reddit clone).

<!-- more -->

1. <a name='ajaxt'></a>['AJAX'ifying voting](#ajax)
2. <a name='slugt'></a>['Slug'ifying routes](#slug)
3. <a name='rolet'></a>[Simple Role Implementation](#role)
4. <a name='timet'></a>[Time-zone Setting](#time)

<a name='ajax'></a>
###1. 'AJAX'ifying the voting
In Rails, this is slightly different from the way this is implemented in a non-Rails based web application. Called Server-generated JavaScript Response (SJR), Rails can dynamically create a JavaScript that implements an AJAX action.

``` ruby
link_to vote_post_path(post_object, vote: value), method: 'post', remote: true do
  icon.html_safe
end
```

The `remote: true` switch dictates AJAX implementation of that particular link. 

Another thing to note is that the `method: 'post'` switch dynamically (using a JavaScript) injects a form with 'POST' submission to the same link as indicated by the `vote_post_path(post_object)` call.

The action that handles the new request needs to be modified to deal with a JavaScript response now:
``` ruby
  respond_to do |format|
    format.html do
      if @vote.valid?
        flash[:notice] = 'Your vote was cast.'
      else
        flash[:error]  = 'You can vote only once on this post.'
      end
      redirect_to :back
    end

    format.js # by default renders the [action_name].js.erb template in the views/[controller_name] folder
  end
```

The code in the [action_name].js.erb could be something as simple as:
`$('#post_<%= @post.id %>_votebox').html("<%= @post.total_votes %>");`
or a bit more complicated as in [this file](https://github.com/ppj/postit/blob/master/app/views/posts/vote.js.erb)

<div>Refer to these commits to the PostIt app for details of code changes:</div>
- [AJAXified voting for posts](https://github.com/ppj/postit/commit/d2a716df3e0730fda75255fbd9c65e721704be7d)
- [AJAXified voting for comments](https://github.com/ppj/postit/commit/2ae2aa22ed08058227d07463d348cf51e27354c1)

[Back](#ajaxt)

<a name='slug'></a>
###2. 'Slug'ifying the routes
There is a security concern with URLs that look like 'ppj-postit.heroku.com/users/3' with the '3' representing the ID of the User object. Same is the case with Posts and Categories. A more appropriate URL for the above would be 'ppj-postit.heroku.com/users/testman' where 'testman' is automatically generated from the `username` attribute of a user. This is what is called a 'slug' in web development jargon. To achieve this, the `to_param()` method of the model object has to be over-ridden, because this is the method used by the named-route methods like `user_path`, et al.

First a 'slug' column needs to be added to the models (tables) to store the respective slugs. The models also need to have a way to automatically generate and save the slug. The former can be done by simple column creating migration. The generation of the slug can also be done in the same migration (for existing records). The slug-generator will take the appropriate attribute of the model, the `:username` attribute in case of the Users table. 

Writing a `generate_slug` method for the model will be useful for auto-generation of slugs. This method can then be called to create a slug every time a new User object is created using the `before_save` [ActiveRecord callback](http://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html).

<div>These modifications to the User model show a simple implementation of the above technique:</div>
{% codeblock lang:Ruby ./app/models/user.rb %}
class User < ActiveRecord::Base
  before_save :generate_slug
  .
  # rest of the code omitted for brevity
  .
  def generate_slug
    self.slug = self.username
  end

  def to_param
    self.slug # overrides the default self.id
  end

end
{% endcodeblock %}
<div>The URL will now have the value of the `:username` attribute and so the view templates now need to search the User object by slug instead of ID:</div>
``` diff
   def set_user
-    @user = User.find(params[:id])
+    @user = User.find_by(slug: params[:id])
   end
```

Note: The implementation of `generate_slug` shown above is very simplistic. A robust implementation should ensure that the slugs are never repeated for the same model. This is especially applicable for the models where slugs will be generated from a non-unique attribute (e.g. Posts.title). The code below shows exactly that:

``` ruby
  def generate_slug!
    the_slug = to_slug(self.title)

    count = 1
    record = Post.find_by slug: the_slug
    while record and record != self
      the_slug = make_unique(the_slug, count)
      record = Post.find_by slug: the_slug
      count += 1
    end

    self.slug = the_slug
  end

  def to_slug(str)                # str=" @#$@ My First @#2@%#@ Post!!  "
    str = str.strip               #  -->"@#$@ My First @#2@%#@ Post!!"
    str.gsub!(/[^A-Za-z0-9]/,'-') #  -->"-----My-First---2-----Post--"
    str.gsub!(/-+/,'-')           #  -->"-My-First-2-Post-"
    str.gsub!(/^-+/,'')           #  -->"My-First-2-Post-"
    str.gsub!(/-+$/,'')           #  -->"My-First-2-Post"
    str.downcase                  #  -->"my-first-2-post"
  end
 
  def make_unique(the_slug, count)
    arr = the_slug.split('-')
    if arr.last.to_i == 0
      the_slug = the_slug + '-' + count.to_s
    else
      the_slug = arr[0...-1].join('-') + '-' + count.to_s
    end
    the_slug
  end
```
<div>Refer to these commits to the PostIt app for details of code changes:</div>
- [Slugifying the Post model](https://github.com/ppj/postit/commit/64e1e4eb49f1485c8684e01b67bac6a6a64d327b)
- [Robust slug generation algorithm](https://github.com/ppj/postit/commit/715a2d8a2ba415d048bc776c09c0d4438757201f)

[Back](#slugt)

<a name='role'></a>
###3. Simple Role Implementation
<div>A very common requirement for an app that user-authentication is a need to differentiate between users on the basis of permissions they have. A simple way to enable roles for users:</div>
1. add a 'role' columns to the Users table using a simple migration
2. <div>add methods to the model to check whether a particular user has a specific role (indicated by a string in the role column)</div>
``` ruby
    def admin?
      self.role == 'admin'
    end
```
3. <div>enable/disable features in the controllers...
``` ruby application_controller.rb  
    def require_admin
      access_denied "You need admin access to do that!" unless logged_in? and current_user.admin?
    end
```
  or in the view templates...
``` ruby
  <% if logged_in? and current_user.admin? %>
    <li><%= link_to "Create New Category", new_category_path %></li>
  <% end %>
```
  based on the role checks</div>

A more serious implementation would call for defining a Role model and a Permission model. A has-many through associations will define Users can have many Roles `through: :permissions`. The role checks can now be done through this association. Chris Lee, the instructor of the 2nd course suggests that this should be avoided unless absolutely necessary, because this rolls into a massive net of checks and nested models. The simple implementation shown above suffices our need.

<div>Refer to these commits to the PostIt app for details of code changes:</div>
- [Adding role to User table](https://github.com/ppj/postit/commit/2f43e69028a34f13585328db7993de34401dbc96)
- [Only 'admin's can create categories](https://github.com/ppj/postit/commit/4e04e1f03d592ac5bd06d5b0374411dd7ba6a48f)
- [Only author or admins can edit a post](https://github.com/ppj/postit/commit/39c5a1a6c9725069ba5e51e2f727f5cee99f7c5e)

[Back](#rolet)

<a name='time'></a>
###4. Time-zone Setting
The app has a default time-zone (UTC) which can be overridden by specifying a different one in the './config/application.rb' file.  
Adding `config.time_zone = 'Melbourne'` to this file will set the default time-zone of the application to Melbourne time overriding the default (UTC)

Note: All available time-zones can be listed by running the rake task `rake time:zones:all`.  

Now that the application has a default time-zone, each user should be able to set his/her own. That would need a dedicated column to save that user's 'timezone' in. This can be added by a simple migration:

1. `rails generate migration add_timezone_to_users`  
2. <div>Add time-zone column to the User table:</div>
``` ruby
class AddTimezoneToUsers < ActiveRecord::Migration
  def change
    add_column :users, :timezone, :string
  end
end
```
3. `rake db:migrate`

Time to modify the view template to allow setting of the time-zone: the common form partial used for User registration (User#new) and profile-update (User#edit). The following addition to the existing form partial will address this need:  
```
  <div class='control-group'>
    <%= f.label :timezone %>
    <%= f.time_zone_select :timezone, nil, default: Time.zone.name %>
  </div>
```

The strong parameters need to include the new attribute `:timezone` for the above to work through the web interface.  
`params.require(:user).permit(:username, :password, :timezone)`

For time to be displayed in the logged in user's time-zone, the time-display helper now needs to be modified:

``` diff
   def fix_time(time)
-    time.localtime.strftime("(%d-%b-%Y %I:%M%p %Z)")
+    if logged_in?
+      time = time.in_time_zone(current_user.timezone)
+    end
+    time.strftime("(%d-%b-%Y %I:%M%p %Z)")
   end

```
Refer to [this commit](https://github.com/ppj/postit/commit/82c43c1a65aebfafc830b6d7cf361636689ba6b6) to the PostIt app for details of code changes.  

[Back](#timet)


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
