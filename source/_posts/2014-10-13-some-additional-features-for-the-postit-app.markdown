---
layout: post
title: "Some additional features for the PostIt App"
date: 2014-10-13 14:30:40 +1100
comments: true
categories: 
  - Rails
  - destroy model object
---

Almost at the end of [Lesson 3](/2014/10/12/quiz-for-rails-beginners-3/), i decided to add a couple of additional features to my [PostIt](http://ppj-postit.herokuapp.com/) web application i am developing as a part of the [second course](http://www.gotealeaf.com/curriculum#!rails) at [Tealeaf Academy](http://www.gotealeaf.com/)

<!-- more -->

Here are the two features i have attempted to add:

1. [Creation Of A New Category On The Go](#new_category)
2. [Deletion Of A Vote](#vote_deletion)

<a name='new_category'></a>
### Create A New Category On The Go
In the default application (as instructed in the course), the only way to create a new category was through the Categories dropdown button in the navigation bar as show in the image below:

<center>![Add new category](/images/dropdown_new_category.jpg)</center>

This is not very helpful when a user would want to add a new category during creation of a new post. So, i added a new category creation form inside the Posts-new view template. But that meant making sure the validation on the category name fired from here without destroying the new post contents. This also necessitated the use of non-model backed form helpers (although Category is a model, the text-field to pass new category name is not in a Category model-backed form).

This helper in the Posts controller class helps to determine whether to create a new category or not:
```Ruby posts_controller.rb : create_new_category
def create_new_category

  if params[:new_category].strip.empty?
    false
  else
    category_names = Category.all.map(&:name)
    index = category_names.index(params[:new_category])
    if index
      @category = Category.find_by(name: category_names[index])
      @category.id
    else
      @category = Category.new(name: params[:new_category])
      if @category.save
        @category.id
      else
        false
      end
    end
  end

end
```

The following code in the Posts#create uses the above helper:
```Ruby posts_controller.rb : create
    category_index = create_new_category

    if category_index
      flash[:notice] = "Category & Post created successfully!"
      category_check_passed = true
    elsif @category
      category_check_passed = @category.errors.empty?
    else
      category_check_passed = true
    end

    if @post.save && category_check_passed
      @post.categories << @category if category_index
      flash[:notice] ||= "Post created successfully!"
      redirect_to posts_path
    else
      @new_category = params[:new_category]
      render :new
    end
```

It is used in a similar way in the Posts#update action.

Here's how it looks in the create-new-post form now:
<center>![New Category Blank](/images/new_category_blank.JPG)</center>

If, new category creation fails:
<center>![New Category Error](/images/new_category_error.JPG)</center>

Here's the post after the validation passes:
<center>![New Category Success](/images/new_category_success.JPG)</center>

The changes in the form partial are highlighted in the git-diff below:
```diff views/posts/\_form.html.erb
 <div class='well'>
   <%= render 'shared/errors', model_obj: @post %>
   <%= form_for @post do |f| %>
     <div class='control-group'>
       <%= f.label :title %>
       <%= f.text_field :title %>
     </div>
     <div class='control-group'>
       <%= f.label :url %>
       <%= f.text_field :url %>
     </div>
     <div class='control-group'>
       <%= f.label :description %>
       <%= f.text_area :description, rows: 4 %>
     </div>
     <br/>
     <div class='control-group'>
       <%= f.label :category_ids, "Categories" %>
       <%= f.collection_check_boxes :category_ids, Category.all, :id, :name do |b| %>
         <% b.label(class: "checkbox inline") { b.check_box(class: "checkbox inline") + b.text } %>
       <% end %>
+      <%= render('shared/errors', model_obj: @category) if @category %>
+      <% new_category = @new_category ? @new_category : "" %>
+      <%= label_tag :new_category, "Create a new category: " %>
+      <%= text_field_tag :new_category, new_category %>
     </div>
     <%= f.submit class: 'btn btn-primary'%>
   <% end %>
 </div>
```

<a name='vote_deletion'></a>
### Deletion Of A Vote
One user cannot vote more than once on a post or a comment through this validation in the Votes model:
`validates_uniqueness_of :creator, scope: [:voteable_type, :voteable_id]`

What if a user voted by mistake or changed his/her mind on a particular post or comment? Adding this capability meant that I needed to do primarily two things:
- If the logged in user has voted (up or down) on a particular item, show an icon to delete the vote instead of an icon to cast a vote (the thumbs-up or thumbs-down icon)
- The vote deletion icon should call an action to delete this user's vote on that item

I added these by writing one helper method for each 'voteable' model, comment, and post. Shown below is the one for comment (the more complex of the two). The one for post is very similar.
``` Ruby /app/helpers/application_helper.rb
module ApplicationHelper

  def link_based_on_current_users_vote_on_comment(comment_object, value)
    if Vote.find_by(creator: current_user, vote: value, voteable: comment_object)
      link_to vote_destroy_post_comment_path(comment_object.post, comment_object), method: 'delete' do
        "<i class='icon-fire'></i>".html_safe
      end
    else
      icon = value ? "<i class='icon-thumbs-up'></i>" : "<i class='icon-thumbs-down'></i>"
      link_to vote_post_comment_path(comment_object.post, comment_object, vote: value), method: 'post' do
        icon.html_safe
      end
    end
  end

end

```

Using this helper method in the view template is illustrated below:
``` Ruby \_comments.html.erb
  <% if logged_in? %>
    <%= link_based_on_current_users_vote_on_comment(comment, true) %>
    <br>
  <% end %>
  <%= "<strong>#{comment.vote_count}</strong> <small>(#{pluralize(comment.votes.size, "Vote")})</small>".html_safe %>
  <% if logged_in? %>
    <br>
    <%= link_based_on_current_users_vote_on_comment(comment, false) %>
  <% end %>
```

The images below show the conditional rendering:

When user has not voted on the item | When the user has voted 'up' an item
:----------------------------------:|:------------------------------------:
![Vote Box No Delete](/images/Votes_no_delete.JPG) | ![Vote Box No Delete](/images/Votes_with_delete.JPG)


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
 
