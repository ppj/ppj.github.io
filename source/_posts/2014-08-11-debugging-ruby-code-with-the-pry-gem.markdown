---
layout: post
title: "Debugging Ruby Code With the Pry Gem"
date: 2014-08-11  09:49:00 + 10:00
comments: true
categories:
 - pry
 - Ruby
 - Ruby debugging
 - pry quick reference
---

This is a quick reference guide for using ‘pry’ gem for debugging Ruby code.

<!-- more -->


<h3 class='no_extra_new_line'>Installation:</h3>
- `gem list pry`: lists whether it is already installed  
- `gem install pry`: installs the pry gem


<h3 class='no_extra_new_line'>Use:</h3>
1. `require 'pry'`
  - insert the above line at the top of the ruby file you intend to debug
2. `binding.pry`
  - insert the above line to stop execution at a particular point in the code
  - insert this after the line where you want to pause the program execution
3. run the program
  - type the debugging stuff (variable names, method names etc.) once the program pauses
4. `step`
  - type ‘step’ to go to the next line
5. Ctrl+D
  - use the above key combo to move to the next ‘binding.pry’ statement in the program


[Here’s a good screen cast](http://knomedia.github.io/blog/2013/01/21/debugging-ruby-with-pry) describing the debugging features of Pry.

However, debugging is just one of the many things that can be done using Pry. One other main feature is replacing IRB. A good reference page (with screen-casts and all) can be found [here](http://pryrepl.org/).

<h3 class='no_extra_new_line'>Other useful links:</h3>
- [Latest Pry & Documentation](https://rubygems.org/gems/pry-doc)
- [Pry WiKi on GitHub](https://github.com/pry/pry/wiki)


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
