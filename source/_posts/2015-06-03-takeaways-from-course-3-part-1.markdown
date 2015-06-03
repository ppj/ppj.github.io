---
layout: post
title: "Takeaways from Course 3 - Part 1"
date: 2015-06-03 10:55:35 +1000
comments: true
categories:
- Rails
- TDD
- RSpec
- beginner
---
These are some key takeaways from the [3rd course](http://www.gotealeaf.com/curriculum#!production-apps) for me based on the reviews i received from the TAs for every module (aka Week).

This is my beginner-TDD phase, so a lot these pertain to that in general and RSpec in specific(!), since that is what will be used in the course as the testing framework.

<!--more-->

### Module 1
* Show success or failure flash-messages when handling post requests to notify the user
* Standard validations on a models attribute can be written in a single line, like this:  
```validates :email, length: {minimum: 5}, uniqueness: true```
Whether it should be done or not depends on how much it affects readability
* Why (it used to be necessary to) end a file with a blank line? [Read here](http://stackoverflow.com/questions/729692/why-should-files-end-with-a-newline).

### Module 2
* As a beginner-TDDer,
  1. Start putting stuff in views assuming public interfaces of classes/models and Controller#actions. And then get into writing failing tests (first functional/controller and then unit/model).*
  2. Write spec titles for as many scenarios as you can think of starting with the most obvious ones through to edge cases, *without over-analyzing it* (you can always add more tests!).
  3. Start the red-green-refactor cycle in the same order.  
  4. Do not test the code you do not own. For example, whether a `GET` request to `books#index` renders the "books/index.html.haml" template. That is pretty much Rails' responsibility!  
* Make sure the test setup is not too far from the action and assertion in a spec. This tends to happen when using `let`, `let!`, `before` in RSpec.  
* Loved the use of the [Fabrication](http://www.fabricationgem.org/) and [Faker](https://github.com/stympy/faker) gems in generating test data!  

\* **Let BDD drive TDD**: Outside-in development comes more naturally to me. [Here's a great article](http://webuild.envato.com/blog/making-the-most-of-bdd-part-1/) about this approach.



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
