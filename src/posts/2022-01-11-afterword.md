    Title: 译后记
    Date: 2022-01-11T21:04:24
    Tags: programming

其实也不算什么译后记。在翻译完[前面一篇文章][article]之后，没更多想说的了。
毕竟译文前面也写了很长一段，能憋出来的都写在里面了。开这一篇文章其实是因为前面
准备这篇译文的时候，把整个讨论串的消息都读了一遍，感觉其中有不少精彩的观点和论述，
摘录出来放到这里。

翻译太难，这里就直接放原文，不翻译了。斜体和粗体均为编者所加。和之前一样，
每段后面附上原文链接。后面的中文部分是我的一些想法。

<!-- more -->

# 关于抽象层次

I'm not suggesting that Scheme relies on fewer lines of code than C,
but rather that it doesn't really matter in either case.  There are
numerous abstraction layers at work here from the hardware (memory,
cache layers, processor, etc.) through the OS and standard user-level
library components up to the individual applications.  _The beauty of
abstraction layers is that when they work right you can ignore everything
below the current layer._

By Russ Ross,
<http://people.csail.mit.edu/gregs/ll1-discuss-archive-html/msg03300.html>

有时候会看到一些人说，你用的这个环境/语言/平台把底层都封装起来了，程序员对
一些基本的事情都不了解，或者是没法做一些我想要的操作，这是个错误。但计算机科学
本身就是一层层抽象叠起来的。可能更重要的事情是先弄清楚你要在哪一个抽象层次上
操作，然后再做事情。

# 关于语言和性能

The fastest language of any of these ought to be hand-coded assembler - why
aren't all the performance-sensitive folk using that?  C and C++ occupy a
very similar role today that assembler once did.  As actual deployed
language and compiler technology has improved, there's less and less reason
to write substantial amounts of code in a language that's designed to mirror
the architecture of a CPU.  The strongest justification you can give today
for C is that it's portable and highly-tuned across multiple architectures,
i.e. the legacy argument.  That one, I'll grant you.

By Anton van Straaten,
<http://people.csail.mit.edu/gregs/ll1-discuss-archive-html/msg03298.html>

不多说了。

# 关于 lazy evaluation

As for whether Haskell fans consider laziness crucial to a functional
language, you might be surprised to find that not all of them do. In
particular, _Simon Peyton Jones doesn't seem to find laziness essential_
(see <http://www.research.microsoft.com/~simonpj/papers/haskell-retrospective/index.htm>).
What he thinks IS essential, as I've said, is being "purely
functional," and he argues that the biggest benefit of sticking to
laziness was that it forced them to stick to their pure functional
guns, even when the going was very tough.

By Matt Hellige,
<http://people.csail.mit.edu/gregs/ll1-discuss-archive-html/msg03232.html>

对于很多 Haskell 人来说，lazy evaluation 都是他们心中函数式编程必要特性的集合中
必须的一个。再考虑到 Haskell 在函数式编程社区里 cult 般的地位，你会看到不少不用
Haskell 的人也认为 lazy evalution 是 fp 所必要的特性（去知乎上就能看到很多）。
但这里告诉我们，Haskell 的创造者（之一）也认为 laziness 并不是函数式编程所必须的。

# 关于 side effects

\> isn't functional programming just programming without side effects

You can classify functional languages as pure/impure, lazy/eager. You tend
to find that the lazy languages (Haskell, Clean, Miranda) are pure, and
impure languages (Lisp, Scheme, ML) are eager. _There's no reason you can't
have a pure eager language, but I can't think of one (anybody?)._ Impure lazy
languages aren't really feasible, because the laziness means that you can't
predict when side-effects will occur, which is not useful if you use
side-effects to perform I/O.

By "Bayley, Alistair",
<http://people.csail.mit.edu/gregs/ll1-discuss-archive-html/msg03219.html>

十几年前（也快二十年了），pure eager language 还是理论上存在但现实中没有的东西。
但随着 algebraic effect 如火如荼的发展，现在能举出好几个这样的语言了。

## 关于 first-class functions

\> Functional programming is a style, typified by the use of first-class
functions, and higher-order functions (functions that take functions as
arguments and apply them, and functions that return functions).

There's another reason that higher-order functions tend to go
hand-in-hand with functional languages, and it's a paradigmatic one.
Since functional languages are generally founded on the idea that
"everything is a function," we'd like them to be able to realize this
model. _The locus classicus for this idea is, of course, lambda
calculus, in which one may model any traditional computing construct
using only functions, from the Church numerals on up._ Naturally, all
these functions are higher-order and anonymous. So the natural
translation of lambda-calculus ideas to a practical language BEGINS
with higher-order anonymous functions, rather than ending there. It
is, in fact, the introduction of non-lambda binding constructs and
non-functional primitive data that is, in some sense, a perversion...

_This is not so different from the object-oriented idea that everything
is be an object, or the older "von Neumann idea" that everything is a
mutable cell._ It's just that in order for everything to be a function,
some of those functions need to be higher-order.

By Matt Hellige,
<http://people.csail.mit.edu/gregs/ll1-discuss-archive-html/msg03236.html>

我自己从来没能回到 lambda calculus 这个本源来考虑 first-class functions 的问题。
是的，在 lambda calculus 里，所有的值都是用函数来表示的，true 和 false 是这样，
自然数也是借由 Church encoding 通过 lambda 表示出来。上面的这个视角很有意思。

# 关于用 Scheme 来实现语言

Describing it as "a book about how to implement a Scheme in Scheme" rather
misses the point.  One point being missed is the importance (or lack
thereof) of typical language syntaxes.  _Think of Scheme for this purpose as
a simple and consistent way of representing abstract syntax trees for any
language._  That's why it has little obvious "syntax" other than parentheses,
and how you can do things like express XML natively in Scheme (see e.g.
SXML).

When you see a snippet of code in EOPL that's written in one of the book's
own languages, don't think of it as Scheme - think of it as the essential
semantic core of a language which could have any of a variety of surface
syntaxes.  The EOPL languages already have some syntax, provided by macros,
but this also can be thought of as a kind of core/internal syntax.  _You
could take any of the EOPL languages and use a lexer and parser generator to
quite easily create a more traditional syntactic surface, which maps to the
exact code in the EOPL book._  What you'd end up with would look as much like
any traditional language as you want it to (although your semantic core
would be better designed).  So for the purposes of EOPL, C/C++ and a
language's surface syntax are both distractions.

What I'm describing might sound impractical to the uninitiated - maybe you
wouldn't want to implement a "real" language on top of a Scheme-like core.
The only problem with this assumption is it's completely wrong: there are
any number of real languages that do exactly this.  _Every functional
language that can be compiled to a bytecode, including Haskell and various
ML varieties, compiles to a bytecode that bears a strong resemblance to
Scheme._

Why is that?  It's because _Scheme is an expression of some core mathematical
ideas about computation: **a relatively minimal set of features that provides
a complete computational framework**._  If you're implementing a functional
language, when you get down to its core, below the syntax and the derived
semantic features, you're likely to end up with something that looks a heck
of a lot like a Scheme core.

By Anton van Straaten,
<http://people.csail.mit.edu/gregs/ll1-discuss-archive-html/msg03292.html>

用 S-expression 来做 AST，以尽量少的功能同时尽量少的限制来提供丰富的表达能力，
这是 Scheme 的两个财富。上面加粗的句子，在 rnrs 里也可以找到同样的精神：

> Programming languages should be designed not by piling feature
> on top of feature, but by removing the weaknesses and restrictions
> that make additional features appear necessary.

# One more thing...

前面说不知道怎么翻译 "poor man"，[@Zhu Aisi][citreu] 说可以这么翻译：

<div class="text-center">
闭包是消费降级的对象，对象是消费降级的闭包
</div>

可以说是一个颇具时代精神的译法了，特意记在这里。


[article]: https://yfzhe.github.io/posts/2022/01/a-closure-is-poor-man-s-object-and-vice-versa/
[citreu]: https://citreu.gitlab.io
