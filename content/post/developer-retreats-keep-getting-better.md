---
date: '2019-08-30'
published: true
title: Developer Retreats Keep Getting Better
url: /2019/08/30/developer-retreats-keep-getting-better
author: "Bruce Eckel"
---

The recent developer retreat took place August 20-26th. We arranged it because
my friend Luciano Ramalho
([Thoughtworker](https://www.thoughtworks.com/profiles/luciano-ramalho) and
author of the best-selling [Fluent Python](http://shop.oreilly.com/product/0636920032519.do))
was doing a multi-stop trip to the US (from his native Brazil) and had a gap in
his schedule, so he wanted to come to Crested Butte and have a retreat. This
seems to have become a pattern: someone I know would like to come here, and we
end up organizing a retreat around their trip.

In the past we've had retreats around specific subjects, but I've found that
this created pressure to "move forward" and "be productive" which seems to make
the event more like work and less like a retreat, depleting important amounts
of fun and relaxation. So with each successive retreat I've tried to remove
anything that allows us to fall into our normal mindset of urgency.

Initially, I stated that the only "rule" was the
["law of two feet"](https://www.wintertechforum.com/open-spaces/#the-law-of-two-feet)
which we use during the [Winter Tech Forum](https://www.wintertechforum.com/),
but as the retreat progressed I realized that this is based on the idea of
multiple sessions happening at the same time, and thus "two feet" is confusing
during a developer retreat. So I revised it to the much simpler maxim of "Do whatever
you want." This seemed to be an important clarification. For example, during several
afternoons Luciano comfortably announced that he was going to take a nap (an example
that I followed, having just returned from a rather exhausting workshop myself).

With such a lax structure (indeed, as lax as I've been able to make it), our
cultural training tells us that less would be accomplished, but it seems like
we got a lot done, and there were numerous other learning experiences that
happened along the way. For me, a particularly valuable multi-day conversation
was on coroutines in Python (which also enhanced my research into coroutines
for Kotlin). Both Luciano and Jim Baker were very helpful here, and even though
I've been studying and writing about concurrency on and off for decades, my
understanding took a nice jump forward.

We use Slack as a communication platform during a retreat. This includes basics
like answering questions about travel and lodging, but also things as simple
as announcing that you are heading to a coffee shop or to breakfast in case
other people want to join you. And of course, sharing technical information
about projects.

The main location for the retreat is the training room for
[Evolve Coworking](https://www.evolvework.co/). I'm still planning to put up
a Chromecast-enabled monitor in that room, as well as painting part of the
wall with whiteboard paint.

Luciano wanted to create a foundation for experimenting with the "Distributed
Consensus Problem" (an introduction can be found
[here](https://blog.acolyer.org/2019/03/08/a-generalised-solution-to-distributed-consensus/)),
using the [RAFT algorithm](https://raft.github.io/)---that link includes a simulation
to make it easier to understand. To do this, he ordered and assembled a group
of Raspberry Pi computers, each connected to a Unicorn Hat display:

{{< figure src="/images/Claudia.jpg" title="Claudia: The RAFT Simulation Platform" >}}

Steve Tarver introduced us to Ansible and created the configuration for
Claudia. This was new to several of us, so it was very useful to have Steve
there as an expert.

{{< figure src="/images/SteveAndJim.jpg" title="Steve Tarver and Jim Baker with Claudia" >}}

Here's the [Github repo](https://github.com/standupdev/claudia) for the project.

Not everyone worked on Claudia; Josh and Cody were spending time on a project they've
been working on for our customer, and I was recovering from a previous week-long workshop
so I mostly just observed and participated in discussions.

{{< figure src="/images/CodyJoshLucianoBruce.jpg"
title="Cody Bontecou, Joshua Fry, Luciano Ramalho and Me having breakfast at McGill's in Crested Butte" >}}

Our friend Bill Frasure had his 30th birthday on the Blue Mesa Reservoir so we
joined him on a rented pontoon boat, and our friend Joe brought his kayaks:

{{< figure src="/images/CodyJoeBlueMesa.jpg" title="Cody and Joe Webber Unloading Kayaks at the Blue Mesa" >}}

This was such a pleasant experience that I've decided pontoon boating should
be included as a possibility for future Summer events.

{{< figure src="/images/LucianoBlueMesa.jpg" title="Joe and Luciano at the Blue Mesa" >}}


