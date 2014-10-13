---
layout: post
title: "Quiz for Rails Beginners 2"
date: 2014-10-06 13:49:13 +1100
comments: true
categories: 
  - quiz
  - Rails
  - resources
  - REST
  - routes
  - helpers
  - partials
---
Here's the second quiz for people who are just getting started learning web-application development. This focuses more on the resources routes and related concepts in Rails.

<!-- more -->

Each question is a link pointing to my corresponding answer as i understand the concepts the today.

1. <a name='q1'></a>[Name all the 7 (or 8) routes exposed by the `resources` keyword in the `routes.rb` file. Also name the 4 named routes, and how the request is routed to the controller/action.](#a1)

2. <a name='q2'></a>[What is REST and how does it relate to the `resources` routes?](#a2)

3. <a name='q3'></a>[What's the major difference between model backed and non-model backed form helpers?](#a3)

4. <a name='q4'></a>[How does `form_for` know how to build the `<form>` element?](#a4)

5. <a name='q5'></a>[What's the general pattern we use in the actions that handle submission of model-backed forms (ie, the `create` and `update` actions)?](#a5)

6. <a name='q6'></a>[How exactly do Rails validations get triggered? Where are the errors saved? How do we show the validation messages on the user interface?](#a6)

7. <a name='q7'></a>[What are Rails helpers?](#a7)

8. <a name='q8'></a>[What are Rails partials?](#a8)

9. <a name='q9'></a>[When do we use partials vs helpers?](#a9)

10. <a name='q10'></a>[When do we use non-model backed forms?](#a10)

### MY ANSWERS:

<a name='a1'></a>
__A1__: Having `resources :dogs` in the block in the routes.rb file is going to give us the following routes

       Prefix | Verb   |  URI Pattern             | Controller#Action
       -------|--------|--------------------------|-------------------
        dogs  | GET    | /dogs(.:format)          | dogs#index
              | POST   | /dogs(.:format)          | dogs#create
     new_dog  | GET    | /dogs/new(.:format)      | dogs#new
    edit_dog  | GET    | /dogs/:id/edit(.:format) | dogs#edit
         dog  | GET    | /dogs/:id(.:format)      | dogs#show
              | PATCH  | /dogs/:id(.:format)      | dogs#update
              | PUT    | /dogs/:id(.:format)      | dogs#update
              | DELETE | /dogs/:id(.:format)      | dogs#destroy

[Back](#q1)

<a name='a2'></a>
__A2__: REST (<strong>RE</strong>presentational <strong>S</strong>tate <strong>T</strong>ransfer) is a way to maintain data persistence in <strong>stateless</strong> data-transfer protocol (which is HTTP in our case). The `resources` keyword in the routes.rb file creates the most used 7 routes (listed above) in a Rails application. These routes are RESTful because they conform to the [REST architectural constraints](http://en.wikipedia.org/wiki/Representational_state_transfer#Architectural_constraints) for web application development. 
[Back](#q2)

<a name='a3'></a>
__A3__: The major difference is a model-backed helper requires, and directly works on, a ActiveRecord Model object for creation of equivalent HTML tags. This is makes it very tightly integrated with the model object and it's attributes. A non-model backed helper is a more generic helper to create HTML tags and do not need any ActiveRecord Model object to work on.  
[Back](#q3)

<a name='a4'></a>
__A4__: Because the `form_for` is a model-backed form helper, it takes an ActiveRecord Model object to create an HTML form for using the model object's real and virtual attributes.  
[Back](#q4)

<a name='a5'></a>
<div>__A5__: The general pattern we use in actions that handle model-backed form submission is:</div>
<ol>
  <li>Create/Update Model Object in Memory</li>
  <li>Try to save it in the database</li>
  <li>If the save succeeds, redirect to the relevant page (showing the saved item by itself or in a list)</li>
  <li>If the save fails, render the page that submitted the form again, with the error messages (stored on the in-memory object) displayed</li>
</ol>
The equivalent code for the ```create``` action of the Category controller would look like this:
```Ruby
def create
  @category = Category.new(params.require(:category).permit(:name))

  if @category.save
    flash[:notice] = 'New category created.'
    redirect_to categories_path
  else
    render :new
  end
end
```
Slightly different from the `create` action, the `update` action would like like this:
```Ruby
def update
  @category = Category.find(params[:id])

  if @category.update(params.require(:category).permit(:name))
    flash[:notice] = 'Category updated.'
    redirect_to category_path(@category)
  else
    render :edit
  end
end
```
[Back](#q5)

<a name='a6'></a>
<div>__A6__:</div>
<ul class='no_extra_new_line'>
  <li>Model validations are triggered when the database is accessed for update, for example: the `save` or `create` methods are called on a model object</li>
  <li>f there are validation errors triggered during the above operation, they are saved on the model object itself which can be accessed by calling `#errors` on it</li>
  Note: model_obj.errors.full_messages can be used to retrieve an array of error messages
  <li>This object cab be saved in an instance variable of the controller class and then can be used in the rendered template to display errors as shown below</li>
</ul>
```Ruby
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
[Back](#q6)

<a name='a7'></a>
__A7__: Rails helpers are methods that can be defined to contain repetitive logic for the presentation layer (used by the view templates). These helper methods usually go in the `app\helpers\application_helper.rb` file under the Rails project folder.  
[Back](#q7)

<a name='a8'></a>
__A8__: Rails partials are HTML snippets which need to be reused in many view templates with no or minimum modifications (that can be handled by arguments). Filenames for partials begin with an `_`, for example: `_errors.html.erb`. This partial can be used by calling the render method on it, as in `<%= render 'shared/errors', model_obj: @post %>` where `model_obj` is an argument variable name that will be used in the partial (refer to the HTML code in [Answer 6](#a6) above).  
[Back](#q8)

<a name='a9'></a>
__A9__: Partials should be preferred over helpers when too much HTML needs to be embedded. Helpers should be reserved more for the logic (parsing / reformating / calculations) than the presentation itself.   
[Back](#q9)

<a name='a10'></a>
__A10__: Non-model backed form helpers should be used whenever user-input elements need to be generated for properties which are not the associated attributes of an ActiveRecord Model object.  
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
