---
layout: post
title: "Rails References"
date: 2014-09-16 10:15:46 +1000
comments: true
categories:
  - rails 
  - tutorial
  - TeaLeaf
---
I just started the [second](http://www.gotealeaf.com/curriculum#!rails) of the 3 [TeaLeaf](http://www.gotealeaf.com/) courses for back-end web-application development using Ruby on Rails.

<!-- more -->

The last exercise in Course 1 was an introduction to web-app development in Ruby using the Sinatra framework. Rails, as I understand so far, is a much more intense framework as compared to Sinatra. So, it has a much steeper learning curve. All the more true, for a web-app newbie.

Listed below are some of the key notes i made as i went through the precourse material and attempted the exercises.

<h3 class='no_extra_new_line'>Major Takeaways:</h3>
- The first few things to look at in a pre-existing Rails app's code
  - .README.markdown
  - ./Gemfile: Gives an idea of the complexity of the app based on the variety of gems it depends on
  - ./config/routes.rb: Has code to generate various routes the app has
  - use `rake routes` or <APP_HOMEPAGE>\rails\info route to list various routes
  - ./config/database.yml: database related info 
- Rails has a lot of "magic" going on in the background owing mainly to its conventions (expectations and auto creation of files & code based on a single line of code / shell command)
- For the same reason, lot of hands-on practice would be needed to get used to all (or most) things going on in rails, ranging from folder & file structure to more advanced features
- `rails generate ...` should be used sparingly as it can be confusing and/or redundant (generates lot of unnecessary files/code)
- no data from the database is actually pushed to Git (.gitignore file is set to ignore the default db's '.sqlite3' files for git operations)
  - the migration file and schema.rb which is modified by the `rake db:migrate` command is what goes into the repository

<h3 class='no_extra_new_line'>Learning Resources:</h3>
1. <div><a href='http://guides.rubyonrails.org/getting_started.html'>The getting started guide</a>: This is pretty good as a first-time Rails tutorial... i just powered through as many questions were raised following the steps listed! The page has links to more detailed descriptions of the concepts; some important ones are:</div>
  - [Rails Database Migrations](http://guides.rubyonrails.org/migrations.html)
  - [Layouts And Rendering In Rails](http://guides.rubyonrails.org/layouts_and_rendering.html)
  - [Active Record Associations](http://guides.rubyonrails.org/association_basics.html)
2. [The Rails Tutorial (Book)](https://www.railstutorial.org/book): This looks like a good comprehensive tutorial and i plan to use it to refresh my Rails knowledge a while after i finish the course!

<h3 class='no_extra_new_line'>Related Repos:</h3>
- [Rails Blog](https://github.com/ppj/railsBlog)
- [Rails 1-Many and Many-Many Association Trials](https://github.com/ppj/railsAssociationsTrial)


