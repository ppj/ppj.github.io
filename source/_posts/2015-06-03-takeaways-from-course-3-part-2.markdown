---
layout: post
title: "Takeaways from course 3 part 2"
date: 2015-06-03 12:59:46 +1000
comments: true
categories:
- Rails
- TDD
- RSpec
- beginner
---
These are some key takeaways from the [3rd course](http://www.gotealeaf.com/curriculum#!production-apps) for me based on the curriculum as well as the feedback received from the TAs for every module (aka Week).

<div class="no_extra_new_line">In Module 3, focus was on learning...</div>
<ul>
<li>to keep controllers skinny</li>
<li>ActiveRecord transactions (all or none!)</li>
<li>RSpec macros and shared_examples</li>
<li>Capybara introduction and first feature spec</li>
</ul>

<!--more-->

### Module 3
* Outside-in development in action with feature-specs in Capybara: Starting with a feature-spec (BDD) and letting it drive the design (models/routes/controllers) seems to be coming a bit more naturally to me than the other way round
* Single-Assertion Principle can (and should) be violated in feature-specs: not just to DRY up the code, but mainly because feature specs are expensive to run!
* ActiveRecord transactions was one of the primary learnings when trying to update the video positions in the queue. Got introduced to [ACID](http://en.wikipedia.org/wiki/ACID), thanks to the missus!
* RSpec shared_examples and macros are very helpful in DRYing up the specs.
* Got re-exposed to :xpath based search of elements in the view template! DOM tree, XPath, had heard and read about these a long time ago for some thing totally different!

#### Finer points:
<li>```QueueItem.find_by(id: params[:id], user: current_user)```  
does not throw a "RecordNotFound" exception in rails. Doing this  
```current_user.queue_items.find(params[:id])```  
does. Use either knowingly!</li>
<li>Do not prefix method names with 'get\_' or 'set_'. Instead come up with better names to indicate what they do.</li>
<li>Use `method: delete` instead of `get` for destroying a record so that the route cannot be bookmarked.</li>
<li>Use `find_by` instead of `where(...).first` for searching a single record.</li>
<li>Prefix `self.` when assigning value to an instance variable but it is not necessary when using the variable in an instance method.</li>
