---
layout: post
title: "Developing Web-based BlackJack"
date: 2014-09-04 12:24:46 +1000
comments: true
categories:
  - JavaScript
  - Ajax
---

So, i am finally done developing the web-version of the BlackJack game! Like i mentioned in the previous post, it was suggested in the TeaLeaf course to use procedural programming to keep it simple and focused on web application development learning!

<!-- more -->

Quoted below are the reasons for two major simplifications adopted in this first web-app development exercise -

<div><strong>Why procedural programming instead of OOP</strong>:</div>
> We chose to not use OOP to manage our code. We've seen that many people get stuck on OOP and can't move forward, and we want people to focus on web development and primary, HTTP in this lesson.  

<div><strong>Why simpler session-based persistence (cookies) instead of databases:</strong></div>
> We chose to not include databases in this section, and instead chose to use the session, which is cookie-backed, for cheap persistence. Again, the reason is because many people get stuck on database concepts, which are important, but we want to direct focus on dealing with HTTP.  

Relational database will be introduced and used in the subsequent TeaLeaf courses.

<h3 class='no_extra_new_line'>Sinatra Files/Folder Structure for <a href="https://github.com/ppj/blackjack_web"><em>My</em> App</a>:</h3>
- [*main.rb*](https://github.com/ppj/blackjack_web/blob/master/main.rb): the main Ruby file with handlers for the HTTP requests
- [*config.ru*](https://github.com/ppj/blackjack_web/blob/master/config.ru): Sinatra settings and launcher file
  - use `rackup -p ABCD` to initiate a local WeBrick server @ port *ABCD* (defaults to 9292)  
- [**public**](https://github.com/ppj/blackjack_web/tree/master/public)
  - stores [custom JavaScript](https://github.com/ppj/blackjack_web/blob/master/public/application.js) and [CSS](https://github.com/ppj/blackjack_web/blob/master/public/application.css) *files* 
  - [**images**](https://github.com/ppj/blackjack_web/tree/master/public/images): stores the image files used in the app
  - [**vendor**](https://github.com/ppj/blackjack_web/tree/master/public/vendor): can store third party 'plugins', like Twitter-Bootstrap files  
- [**views**](https://github.com/ppj/blackjack_web/tree/master/views)
  - [*layout.erb*](https://github.com/ppj/blackjack_web/blob/master/views/layout.erb): default (but customizable) erb layout to encompass the other erb templates in
  - other erb templates (use `, :layout false` while rendering to avoid embedding these in the *layout.erb*)

<h3 class='no_extra_new_line'>Thumb Rules Followed:</h3>
- `/GET` requests generally render '.erb' (**E**mbedded **R**u<strong>b</strong>y HTML templates)
- `/POST` requests generally `redirect` to another request (typically a `\GET` request handler)

<h3 class='no_extra_new_line'>Salient Features:</h3>
- Empty string or blank spaces not allowed as player name
- Initial chip-count or bet cannot be empty/blank, non-numeric, or > remaining chips
- Auto adjusts bet amount if set > remaining chips and warns player accordingly
- Using the `session` hash the app remembers the following:
  - last player's name
  - previous bet amount
- Tracks and displays chip-count on the round, and betting pages
- Player wins - message in green
- Player loses - message in red
- Game pushes (ties) - message in blue
- "AJAXified" the Hit, Stay and Dealer Next Card buttons - avoids reloading the entire page

<h3 class='no_extra_new_line'>Key Takeaways:</h3>
- the difference between client side vs server side code
- what the DOM means and how to use jQuery to manipulate it
- unobtrusive JavaScript, and AJAX: when, and how, to use them
- dealing with re-binding issues when the DOM changes (the green highlighted lines are preferred over the red highlighted ones in the AJAX code below)
```diff
$(document).ready(function() {
 
- $('#hit_form input').click(function() {
+ $(document).on('click', '#hit_form input', function() {

    $.ajax({
      type: 'POST',
      url: '/round/player/hit'
    }).done(function(msg) {

-     $('#game_area').html(msg);
+     $('#game_area').replaceWith(msg);

    });
    // prevent from further execution of the route
    return false; // or event.preventDefault();
  });
});
```


<h3 class='no_extra_new_line'>Other Notes:</h3>
- The equivalent of ShotGun gem for Windows is the Sinatra/Reloader gem. Both enable on the fly changes to the code; i.e. the local server instance need not be restarted to see the changes made to the code, a simple page refresh is enough once the changes are saved.
``` ruby
if RUBY_PLATFORM.downcase.include?('w32')
  require 'sinatra/reloader'
end
```

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
