---
layout: post
title: "How To Start Writing a (Procedural) Program"
date: 2014-08-18 13:13:27 +1000
comments: true
categories: 
  - beginner
  - procedural programming
---
I have starter trouble... always. I either spend way too much time 'planning' and 'collecting information' when i want to start something new, or, the other extreme (but less often), just dive right into it and then suffer due to under preparation.

<!-- more -->

The fundamental technique i learnt during the first course in the first [TeaLeaf](http://www.gotealeaf.com/) course on Ruby basics was how to start writing a program. In other words, how much preparation is just enough to start writing a procedural program.

A quick side-note: Although, procedural programming is (almost) a thing of the past, and all for the right reasons, it is still a great way to start learning programming IMO. The primary reason, i believe, is our brains are wired to think sequentially or serially: first do this, then get the result, then do that... and so on. At least mine is.

So to get over that starting trouble, the technique to start writing a program that best helped me is writing psuedo-code. "Pseudo" as in made up syntax, not bother about whether it will run, because it will not! The psuedo-code is almost plain English, or very close to it. Just enough to guide you in writing the actual code.

Just jot down the logical steps (loops, conditionals, operations) you think are required to solve the programming problem. One rule i stuck to when doing this exercise is: use consistent indentation for readability.

As an example, this is the psuedo code i wrote for a console-based player-vs-computer Tic-Tac-Toe game:

```
Start with an empty 3x3 board
until board full or winner
  ask player to chose empty square to mark his/her 'X'
  display board
  if player won?
    announce winner and end game
  else if board full?
    end game
  else
    generate a random number and let the computer choose an empty square to mark its 'O'
  end
  display board
  if computer won
    announce winner and end game
  elsif board full?
    end game
  end
end
```

<div>Some features of this technique are:</div>
- it highlights my logic of developing a solution
- it helps to keep focus on the current coding task
- it helps to bring focus back to the next coding task if the previous one took longer than normal for whatever reasons (new language, syntactical errors)
- it need not be perfect (or updated all the time for small changes in the actual implementation)
- The final Ruby code for this simple application (if it can be called that!) can be found [here](https://github.com/ppj/tealeaf1_Lesson1/blob/master/tic_tac_toe.rb) 
