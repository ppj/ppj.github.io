---
layout: post
title: "Before Developing My First Object Oriented Application: Notes To Self"
date: 2014-08-19 13:23:18 +1000
comments: true
categories:
  - beginner
  - object oriented
---

These are generic notes made when i learnt the basics of Object Oriented programming using Ruby.

<!-- more -->

- Modules can reference public instance methods of the class, for e.g.

``` ruby Modules Referencing Instance Methods
module Walkable
  def walk
    "#{name} is walking"
  end
end

Class Dog
  attr_accessor :name
  include Walkable
  def initialize(n)
    @name = n
  end
end
```

The above will work ONLY if the class that implements the module Walkable has a public method ```name``` (which is a getter in this case).
*It is a good practice to put a comment to that effect where the module is defined.*

- Only two things evaluate to the boolean ```false``` in Ruby, they are a null object ```nil``` and ```false```

- Every expression returns something in Ruby.
The return value is shown after an hash-rocket sign ```=>``` in an IRB session after executing a
  line of code.

- It's a good idea to just return a string from a method and then using ```puts``` on the method call to display the desired string rather than doing a ```puts``` in the method itself.

<ul>
 <li><a href='http://www.skorks.com/2009/09/ruby-exceptions-and-exception-handling'>Exceptions in Ruby</a></li>
 <ul>
 <li><a href='http://stackoverflow.com/questions/1485114/ruby-constructors-and-exceptions'>Raising exceptions during object instansiation</a></li>
 </ul>
</ul>

- A good way to start developing/design an OO application is following the steps below:
  1. Write the problem statement for the application
  2. Extract nouns from the problem statement: can be good indicators for required classes
  3. Extract verbs and associate them with the nouns: can be good indicators of required methods and responsibilities

Note: The above method was put to use [here](/blog/2014/09/01/my-first-object-oriented-application-s-console-based-black-jack/)


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
