---
layout: post
title: "Takeaways From Course 3 - Part 2"
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
<ul>
<li><code>QueueItem.find_by(id: params[:id], user: current_user)</code>
does not throw a "RecordNotFound" exception in rails. Doing this <code>current_user.queue_items.find(params[:id])</code> does. Use either knowingly!</li>
<li>Do not prefix method names with <code>get_</code> or <code>set_</code>. Instead come up with better names to indicate what they do.</li>
<li>Use <code>method: delete</code> instead of the default <code>get</code> for destroying a record so that the route cannot be bookmarked.</li>
<li>Use <code>find_by</code> instead of <code>where(...).first</code> for searching a single record.</li>
<li>Prefix <code>self.</code> when assigning value to an instance variable but it is not necessary when using the variable in an instance method.</li>
</ul>

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
