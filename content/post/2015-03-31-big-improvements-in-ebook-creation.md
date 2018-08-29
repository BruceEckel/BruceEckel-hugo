---
date: '2015-03-31'
published: true
title: Big Improvements In Ebook Creation
url: /2015/03/31/big-improvements-in-ebook-creation
---


I just finished the eBook of the [2nd edition of Atomic Scala](http://www.AtomicScala.com). The PDF is, of course, the easiest since it gets created directly from Word (before you tell me I should use something other than Word --- I have done numerous experiments, and Word still provides the most power of anything I've found that allows a single document to produce camera-ready publishable pages, and at the same time generates and maintains a table of contents and index).

Two years ago, for the first edition of the book, the drudgery of figuring out the right way to generate the other eBook formats (mobi for the Kindle and epub for everything else) stretched out for months. It was ultimately interesting and the Python programming was kind of satisfying and fun, but the fiddly-ness of the formats was often maddening.

So even though I had a big Python build script to make everything as automatic as possible, I was gritting my teeth expecting to have to wade into the morass once again.

To convert a book to mobi and epub, you first need very clean HTML as a starting point. More recent versions of Word have included "save as Web Page - filtered" which produces much cleaner HTML than before that option existed. Much of my build script is focused on additional cleaning of Word's filtered HTML, using [Leonard Richardson's wonderful BeautifulSoup4](http://www.crummy.com/software/BeautifulSoup/bs4/doc/) Python library (I know of nothing that comes even close for any other language), and when I couldn't figure out the right Beautiful Soup incantation, a few regular expressions.

Some things had changed, so I had to go through and fix up issues in the Python build script (which uses [Paver](http://paver.github.io/paver/)), but eventually got to the point where I had super-clean HTML and an associated CSS script.

I used [Calibre](http://calibre-ebook.com/) the last time around, and it did a very good job but still required a fair amount of fiddling. The Calibre creator, Kovid Goyal, has been upgrading it a lot over the last couple of years, so I started by throwing in my cleaned HTML, adding a cover and generating an epub just to see what kinds of problems I would have to struggle with.

To my surprise, the result was ... perfect, as far as I could tell. With no adjustments at all the output was flawless on the iPad. Calibre has really upped its quality (it was great before, but this!). I was also a bit spoiled, now, after having imagined days or weeks of effort in my future.

Alas, Calibre's mobi output was no where near good enough. And whatever steps I had taken in the past didn't look like they were going to work, so I was getting emotionally ready to roll up my sleeves and submerge myself in the sewage that is the mobi spec and tools.

As a last ditch, I thought I'd Google for something that might convert epub to mobi, and lo and behold discovered [epub2mobi.com](http://www.epub2mobi.com/). To give perspective, at one point two years ago I had even tried hiring a service to do the conversion, but they couldn't handle things like special formatting and embedded fonts. So I was pretty skeptical, and then surprised and completely amazed when the epub2mobi conversion worked flawlessly! Suddenly, many days of slogging through specs and writing experiments vanished. What a delight! I sent them a thank-you note and some money.

I thought I had a lot more work to do to get the epub and mobi versions for Atomic Scala 2nd edition, but these two programs just made it work like magic.

**Note:** If you start with a Word document and save it as "filtered HTML" Calibre will do quite a good job on it. For a book with just text or relatively simple formatting, it should work fine (I had to process my HTML to get it just right, but most books don't have the formatting etc. requirements I do, and Calibre still did a remarkably good job with the raw HTML despite my issues). If you work with a word processor or other tool that produces really clean HTML directly then you're in even better shape.

**What's even more amazing** is that Calibre can now start with a Microsoft Word **docx** document and directly convert it into ePub --- and really amazing ePub at that. Even including tables, diagrams, etc. I was stunned, after having done it the hard way. This opens up some big possibilities for ebook publishing.

## iOS fix ##

Apple seems to have trouble playing nice in the open-source world. Although iOS iBooks is a wonderful reader, if  you use Calibre to produce ePub from **docx**, you won't get the embedded fonts showing up on iBooks (for some reason, my HTML process for Atomic Scala *did not* produce this problem). After thrashing around for a few days I discovered that you must, after your epub is generated, insert a tiny XML file in this location:

```
META-INF/com.apple.ibooks.display-options.xml
```

Here's the file:

```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<display_options>
  <platform name="*">
    <option name="specified-fonts">true</option>
  </platform>
</display_options>
```

I reported this as a Calibre bug, thinking they'd want to automatically put it in, but Kovid responded by saying that Calibre creates standards-compliant ePub and what Apple did here is non-standard. So you have to put it in yourself, but Calibre makes this pretty easy.

Again, this only seems to be an issue when you are converting from **docx** files, and it's a pretty minor inconvenience compared with everything that Calibre does for you. I am extremely impressed with this program (which is written in Python).