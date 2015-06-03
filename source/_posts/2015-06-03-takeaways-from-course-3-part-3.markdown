---
layout: post
title: "Takeaways From Course 3 - Part 3"
date: 2015-06-03 15:48:12 +1000
comments: true
categories:
- Rails
- TDD
- RSpec
- beginner
---
These are some key takeaways from the [3rd course](http://www.gotealeaf.com/curriculum#!production-apps) for me based on the curriculum as well as the feedback received from the TAs for every module (aka Week).

<div class="no_extra_new_line">In Module 4, focus was on learning...</div>
<ul>
<li>self-referential associations (a user following another user)</li>
<li>ActionMailer: sending emails</li>
<li>token generation for password reseting</li>
</ul>

<!--more-->

### Module 4
<div class="no_extra_new_line">This week i was reminded of some basics again (which i had forgotten!). Primarily:</div>
<ul>
<li>Avoid rendering from a POST request unless there's an error.</li>
<li>Try to keep the test setup close to the action and assertion (double check the use of <code>let</code> and <code>before</code> after writing specs). This helps in readability of the specs.</li>
<li>Single-Assertion Principle (more of a guideline than a law): Avoid unrelated assertions in a single spec.</li>
<li>Name the shared_examples well enough to be understood clearly.
<li>Use <code>flash.now["alert message"]</code> for <code>render</code>ing instead of <code>flash["alert message"]</code>. The latter carries over to the next request which is why it is used with <code>redirect_to</code> - a new request.
</ul>

<div class="no_extra_new_line">Other tips i appreciated in my code review were:</div>
<ul>
<li>Use <code>pluck</code> instead of <code>map</code> for performance. <code>pluck</code> pulls only the ids from the database and loads the data into an array. It saves a lot of processing time and power over loading every record into memory using <code>map</code>. However, <a href="http://6ftdan.com/allyourdev/2015/05/13/rails-dont-pluck-unnecessarily">here's an article</a> that talks about when <code>pluck</code> is unnecessary.</li>
<li>For efficient single-record search, use <code>find_by(attribute: value)</code> than the fancy <code>find_by_attribute(value)</code>, which goes through <code>method_missing</code>, and doesn't even save much typing!</li>
<li>Avoid writing migrations for populating data. Write a <a href="http://guides.rubyonrails.org/command_line.html#custom-rakek">custom rake task</a> under 'lib/tasks' instead.</li>
<li>Clear ActionMailer deliveries using <code>ActionMailer::Base.deliveries.clear</code> in <code>before</code> or <code>after</code> hooks instead of in a particular spec to ensure their purging.
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
