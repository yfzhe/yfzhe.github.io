    Title: 译："A closure is poor man's object, an object is poor man's closure."
    Date: 2022-01-08T21:52:38
    Tags: programming, programming paradigm

编程范式的讨论，应该算是程序员社区的日常话题。函数式编程和面向对象，分别是什么，
孰优孰劣，总是争论不休，如同无休无止的宗教战争。而 closure 和 object，可以称作是
fp 和 oop 各自的代表概念。

要翻译的这篇文章，写于 2003 年，是一条邮件列表里的消息。它出自一个
[很长的讨论串](http://people.csail.mit.edu/gregs/ll1-discuss-archive-html/threads.html#03215)，
始作俑者[^1]标题 "What's so cool about Scheme?"，似乎不容易联系到这里。
最后一段留下了一个问题：

> Is Scheme really a 'functional programming language' or is it just a really
> general purpose tool that allows functional programming?

Scheme 真的是一门“函数式编程”语言吗？然后就引发了长长的讨论，讨论什么是函数式编程，
函数式编程必要的特性有哪些，什么是 Scheme / Lisp 的特质。当然，不可避免地，
会提到其他编程范式，当然，主要是面向对象。

然后就到了这篇文章，<http://people.csail.mit.edu/gregs/ll1-discuss-archive-html/msg03277.html>。
它先从倾向闭包的角度，后从倾向对象的角度，来阐发一者无非是低劣版本的另一者。
但是当两种针锋相对的态度出现在同一篇文章中，仿佛太极阴阳，两相融合。因为这种
平等宽容的态度，我很喜欢这个文章。另一个我喜欢的点是在于文章最后编的禅宗公案，
有棒喝，有机锋；给原本朴实的技术讨论增加了不少禅意。

"A closure is poor man's object, an object is poor man's closure." 从文章中提取
出来的这个句子，成为了编程语言社区里的一条名言或是警句；也被用作这篇文章的标题。

<!-- more -->

按理这个句子，特别是作为文章的标题，也应该翻译出来；但是我在 “poor man” 一词
该如何翻译上犯了难。其他地方多是译为“穷人”，但是我更想译为“可怜人”。于是标题译为：

<h1 class="text-center">
闭包是可怜人的对象，对象是可怜人的闭包
</h1>

另外，原文开头是几层的引用回复，这里为了便于阅读理解，也为了排版方便，
把几段引文拆出来，按先后顺序线性排开，同时在每段后面增加了原文的出处的链接。
前面三个部分是被拆出的引文，最后一个部分才是文章的主要部分。

以下是译文：

---

## Anton van Straaten 于 2003-06-03 20:23:57 -0400：

我可以部分同意你的观点；但真的，如果没有闭包，人们会用——也正在用——
种种不优雅的怪异的方法[^2]——就比如，对象 ;o)

<http://people.csail.mit.edu/gregs/ll1-discuss-archive-html/msg03257.html>

## Mike Newhall 于 2003-06-03 20:36:14 -0400：

另外，虽然我不记得原话，Christian Queinnec 在 _LISP In Small Pieces_ 里提出，
尽管很多人认为对象是“可怜人的闭包”，但（在他看来）闭包实际是可怜人的对象。

<http://people.csail.mit.edu/gregs/ll1-discuss-archive-html/msg03258.html>

## Guy Steele 于 2003-06-04 10:54:09 -0400：

闭包是一个对象，它有且仅有一个方法 (method)：“调用 (apply)”。

<http://people.csail.mit.edu/gregs/ll1-discuss-archive-html/msg03269.html>

## Anton van Straaten 于 2003-06-04 13:13:21 -0400：

从一个角度来看，这是对的；也是我对于对象被用来解决缺少闭包的问题的看法。
闭包的简洁可以成为一种财富：类和接口会阻碍行为的简单参数化 (simple
parameterization of behavior)。任何在 Java 或 C++ 里尝试函数式编程的人
都会碰到这一点——能够做到，但是它太冗长乏味了。如果你想做的不过是像
 `(map somefun mylist)` 这样的事情，那能够去定义可执行的“对象”（闭包），
在必要的时候将它们内联 (inline)，这会非常有用。

但从另一个角度看，闭包的这个调用“方法”可以用作底层 (low-level) 的方法分派
(method dispatch) 机制，所以闭包可以被用来，且已经被用来实现高效的、具有多个
方法的对象系统。Oleg Kiselyov 有一篇关于这个主题的短文：
<http://okmij.org/ftp/Scheme/oop-in-fp.txt>

在被这样使用后，闭包可以说是比对象更强大，因为它可以实现很多新的功能，而不仅仅
作为一个单一的语言所提供的方法分派机制。将闭包视为用以实现对象的构成单元，那么
显而易见，对象是可怜人的闭包。

但是 Smalltalk[^3] 用户可能会说，等等，如果你要费尽心思去在你的语言里实现闭包这样的
东西，既然这闭包已经和对象非常相似了，为什么不一路走下去，实现“真正”的，支持任意
数量的方法的，对象呢？那这时闭包不过是一种特殊情况下的对象。如果你的语言里只有
这些受限的闭包，而你却又不得不在此之上实现一个对象系统，那显然闭包是可怜人的对象。

这两种对立观点间的冲突我无意解决，我认为这个关于闭包和对象的问题应该成为一个公案。
我会去拿到禅法认证[^4]，并将 Norman Adams（被认为是“对象是可怜人的闭包”的提出者）
和 Christian Queinnec（“闭包是可怜人的对象”）结合成一个大禅师，称为 Qc Na。
我还会不太谦虚地把自己以一个学生的身份放到这则故事里，正如我在这条消息的最后一段
里提过的：
<http://www.ai.mit.edu/~gregs/ll1-discuss-archive-html/msg01488.html>...[^5]
我认为我确实是在思考这两种看似对立的角度中获得了一些启迪。下面是这则公案：

<div class="text-center">
* * *
</div>

德高望重的 Qc Na 大师正和弟子 Anton 散步。想和师父讨论问题，Anton 打开了话茬，
“师父，我听说对象是个很好的东西，这是真的吗？”Qc Na 大师眼含怜悯看着学生，回答，
“傻孩子，对象不过是可怜人的闭包罢了。”

收到训斥，Anton 从师父身边离开回到自己的小屋，决心研究闭包。他仔细阅读整个
“Lambda: The Ultimate...”[^6] 系列的论文和其他相关的论文；又实现了一个小的 Scheme
解释器，其中包含一个基于闭包的对象系统。他收获颇丰，期待向师父展示自己的进展。

再一次和 Qc Na 大师散步时，Anton 试图让老师惊讶：“师父，我已经仔细学习了这个
问题，现在我理解什么叫对象不过是可怜人的闭包了。”听罢，Qc Na 大师对 Anton
当头一棒，“你何时才能学会？闭包是可怜人的对象。”当是时，Anton 开悟。

:)

[^1]: 指这个讨论串的第一条消息。
[^2]: 原文为 "use all sorts of hacks anyway"，这个 "hack" 实在难译。
[^3]: 一个经典的程序语言，最早的面向对象语言之一。强调消息传递（而不是方法调用）。
      Alan Key 领衔设计。参见 Wikipedia：<https://en.wikipedia.org/wiki/Smalltalk>。
[^4]: 原文为 "I'll take some koanic license"。
[^5]: 原文如此，这个链接现已失效，一个现在可访问的链接为
      <http://people.csail.mit.edu/gregs/ll1-discuss-archive-html/msg01488.html>
[^6]: 由 Guy L. Steele 和 Gerald Jay Sussman 完成的一系列论文（前者也在本文中出现），
      提出了 Scheme 和整个函数式编程领域中诸多重要概念和技术。"Lambda the ultimate"
      本身也成为函数式编程社区里的一个标语。
