---
date: '2014-11-19'
title: Using Github Pages for Blogging
url: /2014/11/19/using-github-pages
---


I've wanted to move this programming blog away from [Artima](http://www.artima.com/weblogs/index.jsp?blogger=beckel) for what seems like several years now (Here's an [earlier update on the process](http://www.artima.com/weblogs/viewpost.jsp?thread=361740)). My buddy Bill hasn't found developing the blogging platform to be of much interest anymore, and in particular he realizes there are many better alternatives at this point.

The conversion took a surprising amount of research, partly because I've been away from blogging technology for quite awhile. Initially I hosted my own blogs on my own site, writing the necessary code by hand. Eventually I moved to [Artima](http://www.artima.com/weblogs/index.jsp?blogger=beckel) and relied on that site to provide the blogging framework. I've mostly skipped the need for Wordpress, although [www.AtomicScala.com](http://www.atomicscala.com/) is a Wordpress site. Wordpress and PHP have moved the web , so they deserve credit for that, but for me Wordpress requires too much fiddling --- and that requires a mental shift that I find too disruptive when I'm trying to write a post.

Then there's the issue of the "programming blog," which especially needs to show code listings easily. Although I've been satisfied with Blogger for the [Reinventing Business](http://www.reinventing-business.com/) blog, the fact that Blogger doesn't natively support code listings is a deal-breaker (yes, I know there are tools to format your listings, but that's too much overhead, and fiddly).

There's been a big movement in recent years to static site generators for blogs. These are more efficient (they only get served, not dynamically created) and safer (also because they are not dynamic). Much of the material on the internet *doesn't* need to be dynamically generated, and blogs are a particularly good example.

A static site generator is the collection of software necessary to take your input and produce a set of static web pages, which are then delivered by your server. So far, the Ruby-based [Jekyll](http://jekyllrb.com/) system seems to be the front-runner candidate for "Wordpress for static sites." In particular, [Github](https://github.com/) uses Jekyll for its [Github pages](https://pages.github.com/), where you can freely host your blog.

I've been having occasional encounters with [Ruby](https://www.ruby-lang.org/en/) for many years now and I slowly learn more and more about the language. Perhaps it's just because Python is older and it has so many libraries, but when I'm solving my own problems I choose Python first; the library issue alone seems to make me far more productive. So while I'm not inclined to grab Ruby for many problems, I'm very impressed with what it has accomplished, in particular for Web apps. I recently built a Rails app and the number of problems that Rails solves for you is quite remarkable. I'm not surprised that people are so productive with Rails. Jekyll is another example of a really well-designed Ruby framework.

The input for your blog posts in Jekyll is [Markdown](http://daringfireball.net/projects/markdown/syntax). Not all static site generators use the same syntax, and another factor that pushed me towards Jekyll was the fact that Markdown has good editing tools. I eventually settled on [MarkdownPad](http://markdownpad.com/), a very nice visual editor under Windows. Using a smart editor is a big improvement over editing raw restructured text on Artima. (More details about this decision [here](http://www.artima.com/weblogs/viewpost.jsp?thread=361787)).

Using Github Pages, you create a Github repository for your blog, unpack the Jekyll-variant-of-choice into your repository, add posts in the **_posts** subdirectory of that repository, and when you push to Github, the posts are automatically published. Although it's recommended that you install tools on your local machine, I initially didn't and its worked fine. [Here's an extremely thorough article](http://www.smashingmagazine.com/2014/08/01/build-blog-jekyll-github-pages/) on Jekyll and Github pages.

I further customized my site using the [Lanyon Theme](https://github.com/poole/lanyon#readme) based on [Poole](http://getpoole.com/). This produces the very stylistically-simple effect you see here, with a drawer-sidebar on the left side which I've customized to include my own links as well as a list of blog posts. Code listings required a bit of configuration to get right, as did round quotes and apostrophes. Rather than describe how to do this, I'll just point you to the [Github repository for this site](https://github.com/BruceEckel/BruceEckel.github.io). Because I'm using free Github hosting (no private repositories), the whole site is available for download so you can just look at the sources (and the changes I will do in the future after posting this article) to see what I've done. You can also just unpack my whole project in your Github pages repository and make changes from there. What you see here is exactly what my repository produces.

No search function comes with Jekyll. I tried [Simple Jekyll Search](https://github.com/christian-fei/Simple-Jekyll-Search), but that only seems to search the post titles. So I followed the instructions in [this article](http://truongtx.me/2012/12/28/jekyll-create-simple-search-box/), pasting the code directly into [**sidebar.html**](https://github.com/BruceEckel/BruceEckel.github.io/blob/master/_includes/sidebar.html). Within five minutes I had implemented search. Unfortunately it didn't seem to work. I tried searching for words I knew were in an article. When the page came up, the search appeared to be correctly formed (I successfully tried it by changing the URL to [mindviewinc.com](http://mindviewinc.com/)). But I didn't see results, as if Google wasn't searching Github pages, or at least not my site. Finally, a friend pointed out that I might need to [submit the site for indexing](http://www.google.com/submityourcontent/website-owner/) and that, indeed, solved the problem.

Github has its [own search API](https://developer.github.com/v3/search/), and someone has created a [Liquid tag](http://rubygems.org/gems/jekyll-github-pages-search) that uses this API. This might have some advantages.

## Bumbling Around to Make Disqus Work ##

I also added [Disqus](https://disqus.com/) for discussions, by following [this article](http://joshualande.com/jekyll-github-pages-poole/). This turned out to be a puzzler, because the article said to modify the [**post.html**](https://github.com/BruceEckel/BruceEckel.github.io/blob/master/_layouts/post.html) file, which I did, and I couldn't see the results and started thinking something was broken. Only after thrashing around with it did I realize that **post.html** is only used when you are displaying a single isolated post, but the main page uses [**default.html**](https://github.com/BruceEckel/BruceEckel.github.io/blob/master/_layouts/default.html). This despite the fact that the YAML header in each post specifies **layout:post**, which supposedly says to use **post.html** for display.

But it doesn't stop there --- both **post.html** and **default.html** use **{{ content }}** to include the body of the post, but with **post.html**, that includes a single post while **default.html** includes all the posts on that page (5 per page in my case), with apparently no way to insert anything in between each post, including any Disqus info or even a message that says "go to the single isolated post page in order to read/post comments." This seemed a little bizarre and restrictive. There's a bit of a [rant on the Jekyll Bootstrap site](http://jekyllbootstrap.com/lessons/jekyll-introduction.html#toc_16) explaining that this is because of the Liquid Templating Engine, and saying that it's not worth fighting it. So I was ready to give up. (After all this I have no problem with the Liquid engine; I find the syntax intuitive).

But then I started searching around and discovered that [**index.html**](https://github.com/BruceEckel/BruceEckel.github.io/blob/master/index.html) in the root directory is what creates the list that goes into the **default.html** **{{ content }}** tag. So I put the following:

```html
{% raw %}
<a href="{{ post.url }}#disqus_thread">View or add comments</a>
{% endraw %}
```
directly after the **{{ post.content }}** tag, which allows people to click on the main page and go directly to the comments section on the individual post page.

While trying to figure out these problems, I did eventually install the [local tools described here](https://help.github.com/articles/using-jekyll-with-pages/#using-jekyll) (which was quite simple). This allows you to see the pages locally before pushing them to Github, but more importantly you see any error messages generated by Jekyll; without these debugging is fairly difficult. (However, it turns out that Github will automatically email you some error messages).

## Automating Post Generation with Python ##

One simplification step remained. Jekyll requires you to name your posts in a particular way, and provide header information at the top of the source file for each post. To avoid duplication of effort, I decided to automate this, and naturally (for me) I reached for Python to achieve the automation.

I still have my old Macbook for testing, but other than that I've [moved back to Windows](http://www.artima.com/weblogs/viewpost.jsp?thread=350864), so this Python script takes advantage of that. If you want to use it on a Mac it should work fine with a couple of changes.

One approach I've become fond of is creating a Windows .BAT file for running Python programs, especially after discovering the one-liner you'll see at the top of the following file, which converts any Python program into a batch file, so you can just run it by double-clicking from the Windows explorer. Here's the file [**NewPost.bat**](https://github.com/BruceEckel/BruceEckel.github.io/blob/master/_posts/NewPost.bat):

```python
@setlocal enabledelayedexpansion && python -x "%~f0" %* & exit /b !ERRORLEVEL!
#start python code here (tested on Python 2.7.4)
import os, string, datetime
import easygui # to install: pip install EasyGUI

result = easygui.enterbox(msg="Blog Post Title", title="Name query")
postname = result.lower().strip().replace(" ", "-")
postname = datetime.date.today().strftime("%Y-%m-%d-") + postname + ".md"

slugline = """---
layout: post
published: false
title: %s
---

""" % string.capwords(result)

with open(postname, 'w') as f:
    f.write(slugline)

os.startfile(postname) # Windows only, but there's a Mac equivalent
```

Note that the header initializes **published: false** so the post won't show up on your blog until you're finished with it and you set the flag to **true**.

This program is typically started from the Windows Explorer. To get the name of the post as user input, I decided to try using a popup window dialog. After hunting around for awhile I discovered the [EasyGUI library](http://easygui.sourceforge.net/), which reduces an input dialog box to a single line, although you do have to install the external library. When I found it, the site declared it a non-maintained project, although it did work. If EasyGUI doesn't work for you, you can replace it with Python's **raw_input()**. If you still want a popup window but don't want to install an external package, you can use Python's built-in **TkInter** library. Here's a simple example ([**TkInterInputWindow.bat**](https://github.com/BruceEckel/BruceEckel.github.io/blob/master/_posts/TkInterInputWindow.bat) in the Github repository):

```python
@setlocal enabledelayedexpansion && python -x "%~f0" %* & exit /b !ERRORLEVEL!
#start python code here (tested on Python 2.7.4)
# Using Python's built-in Tkinter to create an input window:
import Tkinter
from tkSimpleDialog import askstring
root = Tkinter.Tk()
root.withdraw()
title = askstring('Blog Post Title', 'Title')
print title
raw_input()
```  
This is certainly not as clear as the one-liner in the **EasyGUI** approach. The **raw_input()** at the end is just to hold the program open so you can see the output of the prior **print** statement.

To summarize, I really like Jekyll on Github pages. Not only does it feel wrong from an architectural standpoint to store blog posts in a database and do lots of dynamic generation for a site that could be simple files statically served, but the heavyweight nature of CMS tends, I believe, to more readily accumulate technical debt. Perhaps more importantly, sites on CMS, like Wordpress, have a certain last-generation feel to them. Perhaps it's because the static site generators seem to predominantly come from the Ruby world, or maybe there's some other reason, but sites like this seem to have a fresher, cleaner feel as well.

Finally, it appeals to the programmer in me to understand how the site works, and to be able to go in and tweak it without having to understand the details of something like Wordpress. The fact that all my blog posts and site customizations are archived in Github is a significant plus.