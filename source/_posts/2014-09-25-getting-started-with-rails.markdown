---
layout: post
title: "Getting Started With Rails: RDBMS, Associations, Resources"
date: 2014-09-25 14:27:22 +1000
comments: true
categories:
  - Rails
  - associations
  - migrations
  - resources
  - relational database
---
<a name='top'></a>

<div>Concepts covered in the first session of the <a href='http://www.gotealeaf.com/curriculum#!rails'>'Rapid Prototyping with Ruby on Rails'</a> course at <a href='http://www.gotealeaf.com/'>TeaLeaf Academy</a>:</div>
- [Basics of Relational Databases](#rdbms)
- [ActiveRecord](#ar)
- [Migrations](#mig)
- [Associations (1:M and M:M)](#assoc)
- [Resources](#res)

<!-- more -->
<a name='rdbms'></a>  

<h3 class='no_extra_new_line'>Basics of Relational Databases</h3>
- A single table in a relational db, in its simplest form, can be imagined to be like a spread-sheet (rows and columns)
- Each column has a title (attribute) and can store only one predefined type of data (integer, string, boolean, ...) and this is where it differs from a generic spreadsheet
- Each row represents the data stored in the form of attribute values as per the columns
- Each row is identified by a unique integer attribute called the 'primary_key' of the table
- There can be multiple (linked or unlinked) tables in the database, just like one file can have multiple spread-sheets
- One table refers to the rows of one other table using an integer attribute called the 'foreign_key' (see image below for illustration - Courtesy: http://publib.boulder.ibm.com)  
![Courtesy: http://publib.boulder.ibm.com](http://publib.boulder.ibm.com/infocenter/soliddb/v6r3/topic/com.ibm.swg.im.soliddb.sql.doc/figure/ReferentialConstraint.gif "Primary Key - Foreign Key")  
__The CUST_ID is foreign key in Accounts table and primary key for the Customers table__
- The foreign-key column is used to set up a 1-to-Many association between two tables (Foreign Key is on the 'Many' table)
- Rails offers SQLite3 as the default database ([SQLiteStudio](http://sqlitestudio.pl/) is a good free viewer available for SQLite3 among many other free and paid ones)
- A db table has two views
  - _schema view_: shows the columns in each table and the type of data each column can store
  - _data view_: shows the actual data in the table (much like the spread-sheet view)

[Top](#top)

<a name='ar'></a>

<h3 class='no_extra_new_line'>ActiveRecord</h3>
- ActiveRecord is a pattern which helps abstract queries to the database through something called <strong>O</strong>bject <strong>R</strong>elational <strong>M</strong>apper (ORM)
- ORM helps generate SQL queries using a Object#method syntax, for example (in Rails)
  - code like `Post.all` would generate an SQL query that looks like
  - `SELECT "posts".* FROM "posts"` which extracts all rows from the Post table in the database
- Each instance of an ActiveRecord Model object represents a row in the corresponding table
- Each object has getter and setter methods for the real attributes (columns) as well as virtual attributes (created based on associations)
- ActiveRecord in Rails is a thus a very simple, yet powerful (convenient) ORM implementation that saves lot of verbosity
- Although not obvious to new web developers (like me :-)), but the simplicity of Rails ActiveRecord brings in a harsh limitation on Rails
  - the more complex the database(s) gets (big banks, hospitals, large corporations, etc.), the harder it is to translate code to SQL commands when data for one object spans over multiple tables across multiple linked databases
  - these large and complex databases need to be optimized for other aspects (for example, analytics) than just simple traversing
- See the image below (Courtesy: Tealeaf Academy) to get the basic idea of the implementation of ActiveRecord in Rails
![ActiveRecord in Rails](http://d3ncao0pifc37i.cloudfront.net/images/ar_db_connection.jpg "ActiveRecord in Rails")

[Top](#top)

<a name='mig'></a>

<h3 class='no_extra_new_line'>Migrations</h3>
- Migrations are modifications done to the database schema (additions, deletions, modifications of or to the individual tables in the database)
- Migrations should be created using the `rails generate migrations new_migration_name` task (this is the only worthwhile use of the `rails generate` task)
  - the created migration file (Ruby) could be then modified manually to fine-tune the changes to be made to the schema 
- Migrations should be effected using the `rake db:migrate` rake task
  - this will modify the schema.rb file to record the changes made to the schema (this file should be checked into the version control system)
  - this task will also make the implement the changes in the db (which is not checked in to the repository)
- see the [Migrations documentation](http://guides.rubyonrails.org/migrations.html) for details

[Top](#top)

<a name='assoc'></a>

<h3 class='no_extra_new_line'>Associations</h3>
- 1-to-Many (1:M) associations between two Models (each table in the db represents an ActiveRecord Model) can be set up using the foreign-key attribute
- The model class for each entity needs to have the appropriate command that Rails provides to set up this association correctly (See the image below as an example - Courtesy: Tealeaf Academy)
![1:M Association Setup](http://d3ncao0pifc37i.cloudfront.net/images/1-M_association.png "1:M Association Setup")
- Many-to-Many (M:M) associations are essentially two 1:M associations set up __through__ an intermediary table, called the join-table
- the preferred way to set up a M:M association is using a `has_many, through:` (hmt) method (see the diagram below - Courtesy: Tealeaf Academy)
![M:M Association Setup](http://d3ncao0pifc37i.cloudfront.net/images/M-M_association.png "M:M Association Setup")
- the 'hmt' method lets us have the join-table as an ActiveRecord Model, which means it can have additional attributes (like created_at if we want to keep track of how long the association exists between the two objects of the end models)
- the non-preferred way to set up a M:M is with a `has_and_belongs_to_many` method
- the 'habtm' way needs a join-table too but does not give us a join-model, which limits the way we can use the join-table
- see the [Associations Basics documentation](http://guides.rubyonrails.org/association_basics.html) for details

[Top](#top)

<a name='res'></a>

<h3 class='no_extra_new_line'>Resources</h3>
- The routes.rb file defines all the routes the web application can take
- Individual routes can be added to this file using the syntax `HTTP_METHOD '/route', to: 'controller#action'`
  - `get '/posts', to: 'posts#index'` will set a route for a GET request to the /posts path to be handled by the Posts controller's `index` action
- <div>The most common routes required for a controller named, say Posts, can be added by a single line of code in the routes.rb file</div>
  - just having `resources :posts` in the block in the routes.rb file is going to give the following routes

       Prefix | Verb   |  URI Pattern              | Controller#Action
       -------|--------|---------------------------|-------------------
        posts | GET    | /posts(.:format)          | posts#index
              | POST   | /posts(.:format)          | posts#create
     new_post | GET    | /posts/new(.:format)      | posts#new
    edit_post | GET    | /posts/:id/edit(.:format) | posts#edit
         post | GET    | /posts/:id(.:format)      | posts#show
              | PATCH  | /posts/:id(.:format)      | posts#update
              | PUT    | /posts/:id(.:format)      | posts#update
              | DELETE | /posts/:id(.:format)      | posts#destroy

- <div>This can be customized by using the <code>except:</code> or <code>only:</code> options</div>
  - `resources :posts, except: :destroy` would set all routes except the DELETE (last one in the list above)
  - `resources :posts, only: [:index, :new, :create]` will set routes only for the first three actions in the list above
- See this [Rails Routing Guide page](http://guides.rubyonrails.org/routing.html) for details


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

