---
layout: post
title: "A Note About Creating An Associated Model"
date: 2015-02-25 00:09:06 +1100
comments: true
categories:
  - Rails
  - Rspec
  - Expectation
  - Messages
  - receive
---
For a Review model which `belongs_to` a Video (Video `has_many :reviews`), there are a few ways to create a new Review associated to a Video. Two of which are:

<!-- more -->
Given `test_video = Video.create(...) # attributes for video omitted`

1. `Review.create(video: test_video, ...) # other attributes for review omitted`, or
2. `test_video.reviews.create(...) # attributes for review omitted`

Here are the Review and Video models for reference:

```
class Video < ActiveRecord::Base
  # irrelevant stuff omitted
  before_validation :update_rating!

  has_many :reviews

  private

  def update_rating!
    # update the video's average rating based on it's reviews' ratings
  end
end
```

```
class Review < ActiveRecord::Base
  after_save :update_video_rating!

  # irrelevant stuff omitted
  belongs_to :video

  private

  def update_video_rating!
    video.save if video
  end
end
```
The difference between the two methods to create the Review became obvious because i had the following in the test for the Review model:
```ruby
expect(test_video).to receive(:update_rating!).with(no_args)
Review.create( ..., video: test_video)
```

The above test wouldn't pass because when the Review instance is created this way, the test_video instance in the test has a different memory location from the one which received the `update_rating!` call through the Review model `after_save :update_video_rating` callback.

When the Review instance is created using the 2nd way shown above, the same test passes because now the Video instance that receives the `update_rating!` call doesn't change.

However, i think i would still rewrite the expectation to accommodate for both calls this way:
`expect_any_instance_of(Video).to receive(:update_rating!).with(no_args)`


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

