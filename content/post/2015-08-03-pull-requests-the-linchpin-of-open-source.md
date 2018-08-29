---
date: '2015-08-03'
published: true
title: 'Pull Requests: The Linchpin of Open Source'
url: /2015/08/03/pull-requests-the-linchpin-of-open-source
---


When Linus Torvalds started creating Linux, he managed the code base himself.
People would email him patches and he would either include them or not.

To maintain the code base -- to have checkpoints and be able to back up to an
earlier known point -- he used a *Distributed Version Control System* (DVCS)
which, as the name implies, is for managing versions.

So there were these two seemingly-separate things: incorporating patches and
managing versions.

Linus originally used a proprietary DVCS called BitKeeper, but at some point
became dissatisfied with that and created the open-source Git system instead.
But even then he continued to take patch requests via email, incorporate them in
and create new versions using Git.

Later, Github formed to provide repositories for Git projects (and BitBucket did
the same thing, but started out using Mercurial, which was written in Python.
More recently BitBucket has changed to predominantly support Git, although it
still also supports Mercurial).

Github’s innovation was in incorporating the mechanism of the patch request into
the DVCS process, rather than relying on email patches and hand-processing. Now
you can review a patch, and if you accept it you incorporate it into your
project with the push of a button.

For some reason, they chose to use the term “pull request” rather than “patch
request.” For years this confused me and I just ignored it, thinking “well, if
you want to pull something, pull it -- don’t bother asking me about it!” (This
confusion is one big reason for the failure of the [Python Patterns
book](<https://bitbucket.org/BruceEckel/python-3-patterns-idioms>)).

At OSCON in the speaker room I overhead someone declaring that the pull request
is the cornerstone of the open-source process. Along with my studies of
[emerging organizational structures](<http://www.reinventing-business.com/>),
this created an epiphany for me.

The project owner is the one with commit privileges (he or she can also grant
others commit privileges and they can work out some internal way of making
decisions, but let’s keep it simple for now). Anytime someone submits a
pull/patch request, the committer can incorporate it or deny it, depending on
whether it fits the committer’s vision/standards/requirements. It’s a yes/no
decision, and at that point the committer re-asserts their leadership on the
project.

Taken in isolation, this system produces a single autocratic ruler, and relies
on that ruler’s benevolence. If the ruler decides to behave badly you end up
with the scenario we’re all familiar with: “my way or the highway,” and this is
what makes so many companies unpleasant to work for -- even if they start out as
nice places to work, the door is always open for them to become unpleasant,
dictatorial environments, so simple Brownian motion means they’ll probably end
up there.

Open source leaves a second door open, however. If your pull requests keep
getting ignored *and* you feel strongly enough about a project, you can turn
your fork into a new project and take it in another direction. If your
leadership is better than the original, people will begin to prefer your
version. Effectively, it creates a marketplace of genetic variations around a
single project, rather than arbitrarily forcing that project to have a single
implementation, even when something around that project is broken.

The pull request allows an individual to express their vision, and to make it
clear to contributors whether they’re on the same page as the project owner. It
prevents the leaden morass that is consensus (unless a group of committers
choose to practice it). The fork allows genetic variation within an open-source
project, so the marketplace can choose the best-suited version.

Here’s a very nice [overview of the
process](<https://guides.github.com/introduction/flow/>).

(*James Ward explained most of this to me*)