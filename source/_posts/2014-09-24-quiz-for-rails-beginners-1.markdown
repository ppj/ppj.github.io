---
layout: post
title: "Quiz for Rails Beginners - 1"
date: 2014-09-24 11:56:38 +1000
comments: true
categories: 
---

Here's a quiz for people who are just getting started learning web-application development. Most questions are specific to Rails, others are generic. Each question is a link pointing to my corresponding answer as i understand the concepts the today.

<!-- more -->

1. <a name='q1'></a>[Why do they call it a relational database?](#a1)

2. <a name='q2'></a>[What is SQL?](#a2)

3. <a name='q3'></a>[There are two predominant views into a relational database. What are they, and how are they different?](#a3)

4. <a name='q4'></a>[In a table, what do we call the column that serves as the main identifier for a row of data? We're looking for the general database term, not the column name.](#a4)

5. <a name='q5'></a>[What is a foreign key, and how is it used?](#a5)

6. <a name='q6'></a>[At a high level, describe the ActiveRecord pattern. This has nothing to do with Rails, but the actual pattern that ActiveRecord uses to perform its ORM duties.](#a6)

7. <a name='q7'></a>[If there's an ActiveRecord model called "CrazyMonkey", what should the table name be?](#a7)

8. <a name='q8'></a>[If I'm building a 1:M association between Project and Issue, what will the model associations and foreign key be?](#a8)

9. <a name='q9'></a><div class='no_extra_line'>Given this code</div>
``` Ruby
class Zoo < ActiveRecord::Base
  has_many :animals
end
```
    - [What do you expect the other model to be and what does database schema look like?](#a9)
    - [What are the methods that are now available to a zoo to call related to animals?](#a9.2)
    - [How do I create an animal called "jumpster" in a zoo called "San Diego Zoo"?](#a9.3)
<br/><br/>

10. <a name='q10'></a>[What is mass assignment? What's the non-mass assignment way of setting values?](#a10)

11. <a name='q11'></a>[What does this code do?](#a11) `Animal.first`

12. <a name='q12'></a>[If I have a table called "animals" with columns called "name", and a model called Animal, how do I instantiate an animal object with name set to "Joe". Which methods makes sure it saves to the database?](#a12)

13. <a name='q13'></a>[How does a M:M association work at the database level?](#a13)

14. <a name='q14'></a>[What are the two ways to support a M:M association at the ActiveRecord model level? Pros and cons of each approach?](#a14)

15. <a name='q15'></a>[Suppose we have a User model and a Group model, and we have a M:M association all set up. How do we associate the two?](#a15)

### MY ANSWERS:

<a name='a1'></a>
__A1__: The way data is represented in tuples (ordered list or array) of attribute-values that are grouped in a [relation](http://en.wikipedia.org/wiki/Relation_(database)) (tuple with attribute/title/header) makes this database a relational database. [Source](http://en.wikipedia.org/wiki/Relational_model)  
[Back](#q1)

<a name='a2'></a>
__A2__: Structured Query Language is a language to create, read, update, and destroy information in a Relational Database.  
[Back](#q2)

<a name='a3'></a>
<div>__A3__:</div>
<ul><li> The __schema view__ shows what columns are in a table and what type of data (string/integer/boolean/...) each columns can store</li>
<li> The __data view__ shows the actual table with the data that is currently stored in it (like a spreadsheet view)</li></ul>
[Back](#q3)

<a name='a4'></a>
__A4__: Primary Key  
[Back](#q4)

<a name='a5'></a>
__A5__: Foreign key is an index stored in one table that refers to the row index (primary key) of another table.  
[Back](#q5)

<a name='a6'></a>
__A6__: Active Record pattern is an approach to accessing data in a database. Typical operations it helps perform on the database are inserting, updating and deleting data. [Reference](http://www.martinfowler.com/eaaCatalog/activeRecord.html)  
[Back](#q6)

<a name='a7'></a>
__A7__: crazy_monkeys  
[Back](#q7)

<a name='a8'></a>
__A8__:
```Ruby Project Model
class Project < ActiveRecord::Base
  has_many :issues
end
```
```Ruby Issue Model
class Issue < ActiveRecord::Base
  belongs_to :project
end
```

Foreign Key: `project_id`

[Back](#q8)

<a name='a9'></a>
<div>__A9__:</div>

__The Animal Model and Schemas__
``` Ruby Animal Model
class Animal < ActiveRecord::Base
  belongs_to :zoo
end
```

<div>The Zoo table schema:</div>
- `id` (integer, primary_key, unique)
- `name` (string)

<div>The Animal table schema:</div>
- `id` (integer, primary_key, unique)
- `name`/`species` (string)
- `zoo_id` (integer, foreign_key)

<a name='a9.2'></a>

<div><strong>Methods available to a 'zoo' object to call related to animals</strong>:</div>  
- `animals`
- `animals << animal_object`
- `animals.delete(object, ...)`
- `animals.destroy(object, ...)`
- `animals=animal_objects`
- `animal_ids`
- `animal_ids=ids`
- `animals.clear`
- `animals.empty?`
- `animals.size`
- `animals.find(...)`
- `animals.where(...)`
- `animals.exists?(...)`
- `animals.build(attributes = {}, ...)`
- `animals.create(attributes = {})`
- `animals.create!(attributes = {})`

<a name='a9.3'></a>

<div><strong>To create an animal called "jumpster" in a zoo called "San Diego Zoo"</strong>:</div>  
``` Ruby Rails Console
zoo=Zoo.find_by(name: "San Diego Zoo")
zoo.animals << Animal.create(name: "jumpster")
```
[Back](#q9)

<a name='a10'></a>
<div>__A10__:</div>
<ul><li> Mass assignment - `Animal.create(name: 'tiger', zoo_id: '3')`</li>
<li> Non-mass assignment -
``` Ruby
a = Animal.create()
a.name = 'tiger'
a.zoo_id = 3
```</li></ul>
[Back](#q10)

<a name='a11'></a>
__A11__: It will fetch the first defined object (row) in the `animals` table in the database  
[Back](#q11)

<a name='a12'></a>
<div>__A12__:</div>
<ul><li> `Animal.create(name: 'Joe')`</li>
<li> `Animal.create!(name: 'Joe')`</li></ul>
[Back](#q12)

<a name='a13'></a>
__A13__: It works through a join table which has attributes to store foreign keys (IDs) of the two tables it joins.  
[Back](#q13)

<a name='a14'></a>
<div>__A14__:</div>
<ul><li> `has_many, :through` (hmt)
  <ul><li> Pro: Join medium is a model (can have additional attributes)</li></ul></li>
<li> `has_and_belongs_to_many` (habtm)
  <ul><li> Con: Only Join-Table, no Join-Model so cannot have custom attributes (as against the 'Pro' for 'hmt' type association)</li></ul></li></ul>
[Back](#q14)

<a name='a15'></a>
<div><strong>A15</strong>:</div>
``` Ruby Rails Console
user  = User.find(1)
group = Group.find(1)
user.group << group
```
[Back](#q15)

