---
layout: post
title: "My first Object Oriented Application(s): Console Based Black Jack"
date: 2014-09-01 13:36:33 +1000
comments: true
categories: 
  - beginner
  - object oriented
---
Before i developed the console-based Black Jack, i tried developing a slightly simpler game, also console based: Tic-Tac-Toe. Here are the problem statements for both the apps:

<!-- more -->

## Problem Statement for Tic-Tac-Toe:
On an empty board of 3x3 squares, a player and the computer (or another player) pick empty squares to put their ```X``` or `O` (symbols) in. The first one to have their symbols in a row (or column or diagonal) of 3 wins.

<h3 class='no_extra_new_line'>Extracted Nouns:</h3>
- Board
- Square (or Position)
- Player (this would also address the other player/computer?)
- Game (that would be the engine)

Note: The Tic-Tac-Toe code can be a perfect foundation for a "connect-4" game!
  ... or even a 'expandable' version of Tic-Tac-Toe (4x4, 5x5, etc.)!!

## Problem Statement for BlackJack:
BlackJack is a card game played between a dealer and player(s). The dealer starts out with dealing 2 cards from a deck to each player. A player wins if he/she hits a BlackJack (score of 21), unless the dealer has also hit a BlackJack. If neither have hit a BlackJack, player can choose to hit (get dealt another card) till he/she decides to stop/stay, scores 21, or loses (scores more than 21). If the player decides to stay (i.e. < 21), next player chooses to hit or stay. If no player hits a BlackJack, dealer can choose to hit (draw one card at a time) till he/she loses (>21), reaches 17, or wins (hits BlackJack). If dealer reaches anywhere between (>=) 17 and (<) 21, the highest scorer wins.

### Class Design:

|Nouns       | Properties | Behaviours|
|------------|------------|-----------|
|BlackJack   |  dealer, Player, Deck | check_winner? game-sequence|
|Deck        |  cards |  pop_out_card (to be dealt/drawn), shuffle_cards|
|Card        |  suit, denomination | value|
|Dealer      |  hand(of cards) | deal_card (or/and draw_card to self), hit, stay|
|Player      |  hand(of cards) | hit, stay|
|Hand        |  cards, total | calculate_total, busted?, display|


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
