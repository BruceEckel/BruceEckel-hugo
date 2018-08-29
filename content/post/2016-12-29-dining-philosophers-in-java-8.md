---
date: '2016-12-29'
published: true
title: Dining Philosophers in Java 8
url: /2016/12/29/dining-philosophers-in-java-8
---


Because tasks can become blocked, it's possible for one task to get stuck
waiting for another task, which in turn waits for another task, and so on, until
the chain leads back to a task waiting on the first one. You get a continuous
loop of tasks waiting on each other, and no one can move. This is called
*deadlock*.^[You can also have *livelock* when two tasks are able to change
their state (they don't block) but they never make any useful progress.]

If you try running a program and it deadlocks right away, you can immediately
track down the bug. The real problem is when your program seems to be working
fine but has the hidden potential to deadlock. Here, you might not get any
indication that deadlocking is possible, so the flaw is latent in your program
until it unexpectedly happens---typically to a customer (in a way almost
certainly difficult to reproduce). Thus, preventing deadlock through careful
program design is a critical part of developing concurrent systems.

The *Dining Philosophers* problem, invented by Edsger Dijkstra, is the classic
demonstration of deadlock. The basic description specifies five philosophers
(the example shown here allows any number). These philosophers spend part of
their time thinking and part of their time eating. While they are thinking, they
don't need any shared resources, but they eat using a limited number of
utensils. In the original problem description, the utensils are forks, and two
forks are required to get spaghetti from a bowl in the middle of the table.
A more convincing version uses chopsticks; clearly, each philosopher requires
two chopsticks to eat.

A difficulty is introduced: As philosophers, they have very little money, so
they can only afford five chopsticks (more generally, the same number of
chopsticks as philosophers). These are spaced around the table between them.
When a philosopher wants to eat, that philosopher must pick up the chopstick to
the left and the one to the right. If the philosopher on either side is using a
desired chopstick, our philosopher must wait until the necessary chopsticks
become available.

A `StickHolder` class manages a single `Chopstick` by keeping it in a
`BlockingQueue` of size one. A `BlockingQueue` is a collection, designed to be
safely used in concurrent programs, that blocks (waits) if you call `take()`
and the queue is empty. Once a new element is placed in the queue, the block
is released and that value is returned:

```java
// concurrent/StickHolder.java
import java.util.concurrent.*;

public class StickHolder {
  private static class Chopstick {}
  private Chopstick stick = new Chopstick();
  private BlockingQueue<Chopstick> holder =
    new ArrayBlockingQueue<>(1);
  public StickHolder() { putDown(); }
  public void pickUp() {
    try {
      holder.take(); // Blocks if unavailable
    } catch(InterruptedException e) {
      throw new RuntimeException(e);
    }
  }
  public void putDown() {
    try {
      holder.put(stick);
    } catch(InterruptedException e) {
      throw new RuntimeException(e);
    }
  }
}
```

For simplicity, the `Chopstick` is never actually produced by the
`StickHolder`, but kept `private` within the class. If you call `pickUp()` and
the stick is unavailable, `pickUp()` blocks until the stick is returned by
another `Philosopher` calling `putDown()`. Note that all the thread safety in
this class is achieved through the use of the `BlockingQueue`.

Each `Philosopher` is a task that attempts to `pickUp()` the chopstick to both
its right and left so it can eat, then releases those chopsticks with
`putDown()`:

```java
// concurrent/Philosopher.java

public class Philosopher implements Runnable {
  private final int seat;
  private final StickHolder left, right;
  public Philosopher(int seat,
    StickHolder left, StickHolder right) {
    this.seat = seat;
    this.left = left;
    this.right = right;
  }
  @Override
  public String toString() {
    return "P" + seat;
  }
  @Override
  public void run() {
    while(true) {
      // System.out.println("Thinking");   // [1]
      right.pickUp();
      left.pickUp();
      System.out.println(this + " eating");
      right.putDown();
      left.putDown();
    }
  }
}
```

No two `Philosopher`s can successfully `take()` the same chopstick at the same
time. In addition, if a chopstick has already been taken by one `Philosopher`,
the next `Philosopher` that tries to take that same chopstick will block,
waiting for it to be released.

The result is a seemingly-innocent program that deadlocks. I've used arrays
here instead of collections only because the resulting syntax is cleaner:

```java
// concurrent/DiningPhilosophers.java
// Deadlock can be hidden in a program
import java.util.*;
import java.util.concurrent.*;
import static java.util.concurrent.TimeUnit.*;

public class DiningPhilosophers {
  private StickHolder[] sticks;
  private Philosopher[] philosophers;
  public DiningPhilosophers(int n) {
    sticks = new StickHolder[n];
    Arrays.setAll(sticks, i -> new StickHolder());
    philosophers = new Philosopher[n];
    Arrays.setAll(philosophers, i ->
      new Philosopher(i,
        sticks[i], sticks[(i + 1) % n]));    // [1]
    // Fix by reversing stick order:
    // philosophers[1] =                     // [2]
    //   new Philosopher(0, sticks[0], sticks[1]);
    Arrays.stream(philosophers)
      .forEach(CompletableFuture::runAsync); // [3]
  }
  public static void main(String[] args) {
    // Returns right away:
    new DiningPhilosophers(5);               // [4]
    // Keeps main() from exiting:
    ScheduledExecutorService sched =
      Executors.newScheduledThreadPool(1);
    sched.schedule( () -> {
      System.out.println("Shutdown");
      sched.shutdown();
    }, 3, SECONDS);
  }
}
```

Test this program by hand. When you stop seeing output, that means the program
is deadlocked.

In the `DiningPhilosophers` constructor, each `Philosopher` is given a
reference to a left and right `StickHolder`. Every `Philosopher` except
the last one is initialized by situating that `Philosopher` between the next
pair of chopsticks. The last `Philosopher` is given the zeroth
chopstick for its right chopstick, so the round table is completed. That's
because the last `Philosopher` is sitting right next to the first one, and they
both share that zeroth chopstick. **[1]** shows the right-hand stick selected
with a modulus of `n`, wrapping the last `Philosopher` around to be next to the
first one.

Now all `Philosopher`s can try to eat, each waiting on the `Philosopher` next
to them to put down its chopstick.

To start each `Philosopher` running at **[3]**, I call `runAsync()` which means
that the `DiningPhilosophers` constructor returns right away at **[4]**.
Without anything to keep `main()` from completing, the program simply exits and
doesn't do much. To prevent this, I create a `ScheduledExecutorService` which
holds `main()` open until it is `shutdown()`. Then I schedule a task which
shuts down the `Executor` after three seconds, at which point all tasks
automatically terminate as the program exits.

In the configuration as given, the `Philosopher`s spend virtually no time
thinking. Thus they all compete for chopsticks while trying to eat, and
deadlock tends to happen quickly. You can change this:

1.  Add more `Philosopher`s by increasing the value at **[4]**.

2.  Uncomment line **[1]** in `Philosopher.java`.

Either one will make deadlock much less likely, which shows the danger of
writing a concurrent program and believing it's safe because it seems to "run
OK on my machine." You can easily convince yourself the program is deadlock
free, even though it isn't. This example is interesting precisely because it
demonstrates that a program can appear to run correctly while still prone to
deadlock.

To repair the problem, we observe that deadlock occurs when four conditions are
simultaneously met:

1.  Mutual exclusion. At least one resource used by the tasks must not be
    shareable. Here, a chopstick can be used by only one `Philosopher`
    at a time.

2.  At least one task must hold a resource and wait to acquire a
    resource currently held by another task. That is, for deadlock to occur, a
    `Philosopher` must be hold one chopstick and wait for a second one.

3.  A resource cannot be preemptively taken away from a task. Tasks only
    release resources as a normal event. Our `Philosopher`s are polite and they
    don't grab chopsticks from other `Philosopher`s.

4.  A circular wait can happen, whereby a task waits on a resource held by
    another task, which in turn is waiting on a resource held by another task,
    and so on, until one of the tasks is waiting on a resource held by the first
    task, thus gridlocking everything. In `DiningPhilosophers.java`,
    the circular wait happens because each `Philosopher` tries to get the right
    chopstick first, then the left.

Because *all* these conditions must be met to cause deadlock, you must only
prevent one of them to prohibit deadlock. In this program, an easy way to
prevent deadlock is to break the fourth condition. This condition happens
because each `Philosopher` tries to pick up its chopsticks in a particular
sequence: first right, then left. Because of that, it's possible for each
`Philosopher` to hold its right chopstick while waiting for the left, causing
the circular wait condition. However, if the one of the `Philosopher`s is
initialized to try to instead get the left chopstick first, that `Philosopher`
never prevents the `Philosopher` on the immediate right from picking up a
chopstick, precluding the circular wait.

In `DiningPhilosophers.java`, uncomment the line at **[1]** and the one
following it. This replaces the original `philosophers[1]` with a `Philosopher`
that has its chopsticks reversed. By ensuring that the second `Philosopher`
picks up and puts down the left chopstick before the right, we remove the
potential for deadlock.

This is only one solution to the problem. You can also solve it by preventing
one of the other conditions (see advanced threading books for more details).

There is no language support to help prevent deadlock; it's up to you to avoid
it by careful design. These are not comforting words to the person who's trying
to debug a deadlocking program. And of course the easiest and best way to avoid
concurrency problems is *never share resources*---unfortunately that's not
always possible.