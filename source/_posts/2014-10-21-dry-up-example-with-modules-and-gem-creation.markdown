---
layout: post
title: "DRY up example with modules and gem creation"
date: 2014-10-21 16:42:46 +1100
comments: true
categories: 
  - Rails
  - gem
  - Slug
  - DRY
---
Almost all the code enabling voting for the Posts and Comments in the PostIt app is common. Its original implementation screamed <strong>D</strong>on't <strong>R</strong>epeat <strong>Y</strong>ourself, or, in short <strong>DRY</strong>.

<!-- more -->

The same thing is true for the slug-generation and use functionality as well. The slug code is repeated for not two, but three models, namely Post, Category and User. DRYing up the slug code however represents one small challenge as compared to the voting code: slugs are generated from different attributes in each model, `:title` for Post, `:username` for User, and `:name` for Category.

This adds a degree of complexity to how the slug code can be DRYed, and that's why, this article uses slug as the example to explain the process. Voting DRYing up is not just similar, but much simpler.

1. <a name='modt'></a>[DRYing with Modules](#mod)
2. <a name='gemt'></a>[DRYing with Gems](#gem)

<a name='mod'></a>
###1. 'DRY'ing up code with Modules
For the application to load modules from a common location (./lib), the following line needs to be added to ./config/application.rb under the Application class definition:
`config.autoload_paths += %W(#{config.root}/lib)`

The above creates an array with application_root/lib path in a string format and adds it to the pre-existing array stored in `PostitTemplate::Application.config.autoload_paths`. This will ensure that all files stored in the ./lib folder will be automatically loaded at application startup.

Slugable.rb stored in this path will be populated by cutting the slug related code from any of the models that implements it (Post, Category, or User). In addition to that, the module file has a call to `extend ActiveSupport::Concern`. This enables some extra features like capability to add Class methods to the including class and the `included` hook to let some code to be executed only at the inclusion time. 

Shown below is the above implemented for the slugging code, which is also repeated in the User, Post and Category models.

``` ruby

module Slugable
  extend ActiveSupport::Concern

  included do
    class_attribute :slug_column
    before_save :generate_slug!
  end

  module ClassMethods
    def set_slug_column_to(column)
      self.slug_column = column
    end
  end

  def to_param
    self.slug
  end

  def generate_slug!
    the_slug = to_slug(self.send(self.class.slug_column))
    model = self.class.to_s

    count = 1
    record = self.class.find_by slug: the_slug
    while record and record != self
      the_slug = make_unique(the_slug, count)
      record = self.class.find_by slug: the_slug
      count += 1
    end

    self.slug = the_slug
  end

  def to_slug(str)                # str=" @#$@ My First @#2@%#@ Post!!  "
    str = str.strip               #  -->"@#$@ My First @#2@%#@ Post!!"
    str.gsub!(/[^A-Za-z0-9]/,'-') #  -->"-----My-First---2-----Post--"
    str.gsub!(/-+/,'-')           #  -->"-My-First-2-Post-"
    str.gsub!(/^-+/,'')           #  -->"My-First-2-Post-"
    str.gsub!(/-+$/,'')           #  -->"My-First-2-Post"
    str.downcase                  #  -->"my-first-2-post"
  end

  def make_unique(the_slug, count)
    arr = the_slug.split('-')
    if arr.last.to_i == 0
      the_slug = the_slug + '-' + count.to_s
    else
      the_slug = arr[0...-1].join('-') + '-' + count.to_s
    end
    the_slug
  end

end
```

What makes the Slugable module more complex is the need to handle varying attribute names for the model. This has to be specified by the model including this module. This is implemented using the `class_attribute :slug_column` and the class method `set_slug_column_to(column)`. 
So, apart from the `include Slugable` call, the models have to call the `set_slug_column_to` and pass the appropriate `:attribute_name` to it.  

Model     | should include this call
----------|--------------------------------
User      | `set_slug_column_to :username`
Post      | `set_slug_column_to :title`
Category  | `set_slug_column_to :name`

[Back](#modt)

<a name='gem'></a>
###2. 'DRY'ing up code with Gems
Once we have the Slugable module, it is fairly easy to create a gem from it. But why create a gem when we have DRY code already? The main reason is usability across multiple Rails projects. It will also enable other developers to use (a.k.a. 'consume') the gem if it is pushed to [RubyGems.org](http://rubygems.org/).

Note: One prerequisite for creating a gem is having a gem called 'gemcutter' installed. If you don't already have it (check using `gem list gemcutter`), install it by issuing `gem install gemcutter` in your shell.

Since the gem is going to be a separate project, we need to create a separate folder to hold its code. The following steps highlight the process to create the slug gem.

A 'Slugable.gemspec' file needs to be in the root path of the gem folder and it should have the following code:  
``` ruby ./slugable.gemspec
Gem::Specification.new do |s|
  s.name        = "sluggit-ppj"
  s.version     = "0.0.0"
  s.date        = "2014-10-20"
  s.summary     = "A slug generator gem"
  s.description = "A cool gem for slugifying models."
  s.author      = "Prasanna Joshi"
  s.email       = "author@myemail.com"
  s.files       = ["lib/slugable_ppj.rb"]
  s.homepage    = "http://www.github.com"
end
```

<div>Some key settings:</div>
- `s.name`: specifies the name of the gem
- `s.files`: specifies where the code for the gem resides
- `s.version`: versioning mechanism for the gem

The './lib/slugable_ppj.rb' could be an exact replica of the module file created earlier.

This is all we need to __create our gem__. Issue  
`gem build slugable.gemspec`  
<div>from the gem root folder path at the shell prompt. If successful in creating the gem, you should see the following output from the command:</div>
```
  ~/sluggable-gem> gem build slugable.gemspec
    Successfully built RubyGem
    Name: sluggit-ppj
    Version: 0.0.0
    File: sluggit-ppj-0.0.0.gem
```
You can see that the 'sluggit-ppj-0.0.0.gem' file has been created in you gem root path.

<div>Once created, we need to follow the steps below to actually <strong>use</strong> it now in our project:</div>
1. add the following lines in the Gemfile of your project to make it available:
`gem 'sluggit-ppj', path: '% local_root_path_of_the_gem %'`
2. run `bundle install` after modifying the Gemfile
3. add `require slugable_ppj` before the features of the gem are called in your code (safest place to add it in is the file 'projec_root_path/config/application.rb' because this file gets loaded immediately after the application starts)

Once you have the gem working like you want to, you can push it to RubyGems.org using the 'gemcutter' command:  
`gem push sluggit-ppj-0.0.0.gem`  
The '.gem' file version should change based on your changes to the `s.version` setting in the '.gemspec' file.

Note: The gem can be disabled (at RubyGems.org) by issuing the 
`gem yank sluggit-ppj -v '0.0.0'`  
command from the gem root path in the shell. As you can see, you can `yank` a particular version of the gem from RubyGems.org.
  
[Back](#gemt)

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






