---
date: '2016-06-20'
published: true
title: A Model To Fund Open-Source Projects
url: /2016/06/20/a-model-to-fund-open-source-projects
---


Synopsis
--------

Place a bounty on the next release of an open-source project. Until the bounty
is met, those who need/want the newest release must pay an amount in order to
get it. Previous releases remain free. Once the bounty is met, the new release
becomes free.

The Problem of Funding
----------------------

I think open-source is one of the most important cultural and business
innovations produced (so far) by the computing and network revolution. We've
only begun to feel the benefits of this shift and anything we can do to
accelerate it will amplify those benefits.

The biggest hole in the system is funding. We've been trying to use existing
donation models and it just isn't working. If individuals are encouraged to
donate to a tip jar, they tend to put it off (and eventually forget) because
(A) they are just trying it out and don't know yet if it's going to be useful
and (B) it's a hassle to go through the tipping process and they are focused
on trying to solve their problem right now. Once the moment has passed, it
becomes easier and easier to forget.

Business folk don't know what to do with open-source. It doesn't fit into
their world-view. A paid product is familiar territory and they are fine with
buying it. But if it's open-source, that means free, right? Why should we go
through the hassle and paperwork if we can just use it? There are numerous
disincentives to pay for it, and no noticeable benefits. Even if the
programmers prod the purchasing department to do the right thing, it seems
like needless work to the purchasing department. They're not being stingy or
mean---it's just that everything else has higher priority than doing something
that isn't forced upon you. That's just the way old-school business works.

Eventually cultural norms might develop, but in the meantime we need to
provide an adapting structure between the world of open-source and the world
of business.

Release Bounties
----------------

Here's how it works. For projects that create significant releases containing
distinct new features[^It might work in other situations as well but that is
not how I'm initially imagining it], on your next release you set a funding
bounty. Typically this bounty will be based on the amount of effort you put
into the release, but other factors can weigh in as well, such as trying to
hire a new person for the project or paying debts you've incurred in
developing the project thus far. In my opinion it is valuable to be completely
transparent about the needs provided by the bounty, because it helps engage
customers in the process.

I think most projects will set different prices for individual users than for
companies. One thing to keep in mind is that companies can have complex
procurement processes so you need to factor in the time and effort involved
(see later in this article about the benefits of having an external service to
manage these issues). A typical way to charge a company might be based on
number of programmers or employees in the company. Sometimes you'll have to
work out a special contract with that company, but if the result is beneficial
enough it's worth it.

Every time someone pays for the new release, the bounty is reduced by that
amount. Once the bounty is paid off, the release becomes free to everyone.
This way, customers who don't care or can't afford it have the option of
waiting until the release becomes free. Customers that need it right away will
pay for it. The rate at which the bounty is paid off gives feedback to the
developers about how valuable the new feature set is.

You might even provide premiums like stickers, shirts, hats, etc., for
individuals who are extra enthusiastic about the project and want to donate at
a higher level in exchange for those items (much like the reward levels in
services like Kickstarter).

Benefits
--------

The biggest benefit is the ability to create a steady income from your work.
My hope is that it will liberate people from having to work a regular job so
they can devote all their time to working on their open-source projects. I
believe this will dramatically speed up software development in general,
because more people will be able to work on the projects they love.

This mechanism also provides valuable feedback from your customers. Similar to
systems like KickStarter (which doesn't fund you unless your minimum goal is
reached, thus telling you whether there's enough interest in your project),
paying down a bounty gives customers more investment in what features you
produce next.

I think it could also open channels to companies who might be willing to fund
the development of feature-sets that help those companies with their
particular needs. Although such channels are hypothetically available now,
once there's a payment mechanism in place it becomes much easier for a company
to budget, request, and pay for new feature sets.

One very significant benefit is that you don't have to estimate. You create
the feature set first, and then you know how much effort it took to create it
and that tells you what the bounty is. It might also incentivize you to make
smaller, more frequent releases. I think it will certainly encourage you to
discover and add the features that people want to pay for, and thus provides a
valuable form of feedback.

This system might even provide funding for an organization like the PSF. If
the PSF were to create and host the infrastructure for this service, they
could take a percentage for doing so (and I think folks in the Python
open-source community would be enthusiastic in providing another way to fund
the PSF, so the percentage could probably be higher than what Kickstarter, for
example, charges). Under the umbrella of the PSF, payments made to open-source
projects might even qualify as nonprofit donations, which could enable you to
charge more to companies since they then benefit from a tax break. In
addition, the PSF is probably better equipped to handle the procurement
paperwork for companies, and once that process was completed for the PSF,
bounty payments for all projects under the PSF could be made through that
pre-existing account, making it much easier and faster for the company.

Other products might be enabled using this approach. If there's a need for
online training, for example, the current open-source approach doesn't free up
time for the developers to work on it, especially if they have regular jobs.
You might (openly) add something to the current bounty to help support the
development of such materials (perhaps hiring someone to do it), then create a
new bounty on those materials once they've been created (or you might choose
to always charge something for your online training even if it's been funded
through a bounty---people who want it will appreciate its existence either
way).

Summary
-------

A bounty looks a bit like "reverse-Kickstarter" since you are funding
something that has already been created; this means there is much less risk
because you presumably already know the project and trust the developers. One
difference is that it is version-based rather than whole-project-based.

Because all previous versions of the open-source project are free, this allows
individuals and companies to choose whether they want or need the newest version,
or if they are fine waiting for the bounty to be paid by others.

This approach could also enable things like sponsorship for a version. One
company might decide it wants to pay off the entire bounty and the developers
might give that company some kind of public acknowledgement.

Once a pathway for open-source project support has been opened, it invites
further collaboration. Companies might ask for and fund specific features that
they need. It might even promote more training and consulting around the
project.

I am not suggesting that this approach is the solution for all open-source
projects. For example, in the previous post I talked about my experience with
[ReadTheDocs](https://readthedocs.org/). That service doesn't generally
provide quantifiable features on the user end (however, there might be some
features on the developer end that could support release bounties). This
approach will generally be most appropriate for products and libraries that
steadily add features within new releases, which I think covers a large number
of projects.

This approach also doesn't solve the (important) problem of funding the
startup of an open-source project, which is different and closer to
traditional crowdfunding, where you are taking a distinct risk that the
project might never reach fruition. For that we probably need to draw on the
wisdom earned both from venture investing and services like Kickstarter.

I might have been able to think of this approach because of my [Reinventing
Business](http://www.reinventing-business.com/) project. That project has
certainly changed the way I look at possibilities in the world.