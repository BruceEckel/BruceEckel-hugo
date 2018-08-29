---
date: '2015-03-10'
published: true
title: Websockets In Python + Flask On Heroku
url: /2015/03/10/websockets-in-flask-on-heroku
---

Websockets change the shape of Internet development by allowing communication both ways --- not only can the client send messages to the server, but with a websocket the server can at any time push information to the client (not just when the client decides to connect to the server). In effect this brings us back to the convenient world of desktop applications where the program and the user interface have two-way communication.

Websockets have been a long time coming, and in the meantime people have come up with alternatives like long polling. As it stands, you only get websocket support in the most current browser versions.

When I was younger I was willing to slog through the hard path to figure things out. For example, I learned C++ before there were any books about it by poring through the output of **cfront** (the original C++ translator, which emitted rather obscure C). I've also run into walls after I've put in a lot of heavy slogging. I know that a programmer's reach often exceeds their grasp, so the promises made in the documentation don't always hold true. These days I want to start with the easiest route, just to see whether something works at all.

I recently had some nice success after volunteering to [build an app for someone](https://github.com/BruceEckel/Question-Of-The-Day) (my first app designed to run on a phone as well as other platforms), using Python's [Flask web app framework](http://flask.pocoo.org/) hosted on Heroku. Flask seems to me to be exceptionally well-designed and easy to use, so naturally I hoped I could somehow use websockets with Flask.

It took a little poking around (with significant help from [James Ward](http://www.jamesward.com/)), but I got the basic example running successfully on Heroku. All the code and explanation is [here on Github](https://github.com/BruceEckel/hello-flask-websockets). 


