#lang scribble/manual

Title: 从 Fibonacci 到 define-memo
Date: 2020-03-07T20:44:28
Tags: memoize, racket, macro

@(require (for-label racket/base))
@(require scribble/example
          "../../util.rkt")

故事要从 HackerRank 网站上的 "Functional Programming" 题集里的
@hyperlink["https://www.hackerrank.com/challenges/fibonacci-fp/problem"]{一道题目}
说起。这道题目叫 "Fibonacci"，属于 "Memoize and DP" 分类下。一如题目名字一样
直白，这题就是要求 Fibonacci 数列的第 n 项 @${Fib_n}，其中 @${Fib_0 = 0, Fib_1 =
1}。（其实还是有点点差别，原题因为数字精度范围的问题要求 mod 10e8+7，但是在这里
我们不需要考虑这个问题，下面忽略 mod 10e8+7 这个操作。）

那太简单了啊，直接上来写：

<!-- more -->

@(define evaluator (make-base-eval))

@(racketblock+eval #:eval evaluator
  (define (fib n)
    (cond
      [(= n 0) 0]
      [(= n 1) 1]
      [else (+ (fib (- n 1))
               (fib (- n 2)))])))

写起来很简单，但是我们跑一下试试？

@(examples0 #:eval evaluator
  (time (fib 30)))

才 @code{(fib 30)} 就跑成这样，太慢了。因为对于 @${n > 1} 的情况来说，虽然
@code{(fib (- n 2))} 在 @code{(fib (- n 1))} 的计算中计算过，但是在 @code{(fib
n)} = @code{(+ (fib (- n 1)) (fib (- n 2)))} 里还要再算一次，导致效率很低。不过，
在正常的（支持）函数式编程语言里，我们可以利用尾调用优化，将递归写成尾递归的形式
来提升运行速度。以下是尾递归的版本：

@(racketblock+eval #:eval evaluator
  (define (fib/acc* n acc0 acc1)
    (cond
      [(zero? n) acc0]
      [else (fib/acc* (sub1 n) acc1 (+ acc0 acc1))]))

  (define (fib/acc n)
    (fib/acc* n 0 1)))

同样拿 @code{(fib 30)} 跑一下：

@(examples0 #:eval evaluator
  (time (fib/acc 30)))

可以看到，将 fib 函数写成尾递归版本，运行速度就快了非常多。至于尾递归，不在本文
的范围内，所以就不再往下写了（也许未来会写一篇关于尾调用的文章）。

@; ------------------------------------------------------------
@section*{Memoize}

好像用上尾递归版本的 @code{fib/acc} 之后，这道题目应该也就解决了。但显然故事不能
就在这里结束。回头看文章的开头就给出的一点提示：「这道题位于 `Memoized and DP'
分类下」，我们可以考虑一下用 memoize 的方法来解决这题。

Memoize，有的翻译成「记忆化」。对于一个函数 @${f(x)}，memoize 就是记住之前对
@${x_1, x_2, \ldots} 的计算结果 @${f(x_1), f(x_2), \ldots}，如果下一次碰到已经
「记忆」过的参数，可以直接返回计算结果而跳过计算过程，来减少计算量，提升运行效率。
那么显然要求被 memoized 函数是纯函数了。

这个「记忆」，这里准备用哈希表来实现：把参数 @${x_i} 作为 key，计算结果
@${f(x_i)} 作为 value 储存起来。下面是 memoize 版本的 @code{fib}：

@(racketblock+eval #:eval evaluator
  (define fib/memo
    (let ([memo (make-hash '((0 . 0) (1 . 1)))])          (code:comment #,"0")
      (lambda (n)
        (hash-ref memo n                                  (code:comment #,"1")
                  (lambda ()                              (code:comment #,"2")
                    (let ([res (+ (fib/memo (- n 1))
                                  (fib/memo (- n 2)))])   (code:comment #,"3")
                      (hash-set! memo n res)              (code:comment #,"4")
                      res))))))                           (code:comment #,"5"))

在 0 处创建了一个哈希表 @code{memo} 用来记录计算过的结果，而且这里偷巧地把
@${fib} 的初始状态直接写到 @code{memo} 里。在 1 这里，就是先尝试从 @code{memo}
里取出 @${fib_n}；如果 @code{memo} 里找不到 @${fib_n}，那么就在 2 处计算出
@${fib_n} 的值并存到 @code{memo} 里去（这里用了一下 @racket[hash-ref] 的小特点：
如果没有在 hash 里没有需要的 key，可选的第三个参数会被执行，它的结果作为
@code{hash-ref} 的结果被返回）。后面的 3, 4, 5 处就很直白了——求出 @${fib_n} 的值，
把它塞到 @code{memo} 里，再返回前面计算的结果。

来看一下运行效率：

@(examples0 #:eval evaluator
  (time (fib/memo 30)))

还行。再跟尾递归的版本比较一下：

@(examples0 #:eval evaluator
  (time (for ([i (in-range 1000)]) (fib/acc i)))
  (time (for ([i (in-range 1000)]) (fib/memo i))))

在多次反复计算的情况下，memoized 版本的优势就出来了。

恰好 HackerRank 上的那题每个测试点有 @${T} 个输入 @${n_1, n_2, \ldots, n_T}，也
就是说在一个测试点也需要反复计算，正好对应到上面 memoize 的优势了。不过我也没写
尾递归形式的版本，没比较实际的情况；从上面的例子看，memoize 有优势应该是确定的。

@; ------------------------------------------------------------
@section*{@code{define-memo}}

@(evaluator '(require (for-syntax racket/base)))

通过上面的 @code{fib/memo} 我们已经看到了实现 memoize 的一个模式：先创建一个闭包，
初始化一个 hashmap，这个闭包返回一个函数——这个函数接受到参数之后会先去前面的
hashmap 里找一下有没有保存过的结果，如果有直接返回，如果没有再进行计算，同时还有
把这次计算的结果存储到 hashmap 里。那么我们可以抽象出来一个宏 @code{define/memo}
来表达 memoize 一个函数的过程，让函数本体的定义重回自然：

@(racketblock
  (define-syntax (define/memo stx)
    (syntax-case stx ()
      [(_ (id arg ...) body ...)
       #'(define id
           (let ([memo (make-hash)])
             (lambda (arg ...)
               (hash-ref memo (list arg ...)
                         (lambda ()
                           (let ([res (begin body ...)])
                             (hash-set! memo (list arg ...) res)
                             res))))))])))

主要的一点变化是，这里考虑了多参函数的情况（既然是抽象出一种模式出来），所以
@code{memo} 的 key 是一整个 @code{(list arg ...)} 而不是单一参数。

这时候，前面的 @code{fib/memo} 就可以这样定义：

@(racketblock
  (define/memo (fib/memo n)
    (cond
      [(= n 0) 0]
      [(= n 1) 1]
      [else (+ (fib/memo (- n 1))
               (fib/memo (- n 2)))])))

和文章最开始定义 @code{fib} 一模一样。

就像 @code{(define (id arg ...) body ...)} 可以 desugar 到 @code{(define id
(lambda (arg ...) body ...))} 一样，我们这里也可以让 @code{define/memo} 基于一个
memoized 版本的 @racket[lambda]——@code{lambda/memo}：（@code{lambda/memo} 主体和
上面的 @code{define/memo} 差不多，这里就不写了。）

@(racketblock
  (define-syntax (lambda/memo stx)
    (syntax-case stx ()
      [(_ (arg ...) body)
       #,(elem ".... ")]))

  (define-syntax-rule (define/memo (id arg ...) body ...)
    (define id (lambda/memo (arg ...) body ...))))

@; ------------------------------------------------------------
@section*{再一个奇怪的需求}

我们通过将之前计算的结果保存在一个哈希表里来实现 memoize。而这时候来了一个奇怪的
需求：我想把这个哈希表取出来看看。这时候怎么办？

这里就可以引入 Racket 的一个特性 @racket[prop:procedure]，实现了这个 property 的
struct 都可以在函数调用位置直接当作函数来使用。利用这个功能，我们可以把闭包中函
数和记录计算结果的哈希表放一个 struct 里面，然后把 memoize 的函数作为
@code{prop:procedure} 对应的函数，再针对这个 struct 来提供一个获取哈希表的方法来
实现「查看保存了的之前的计算结果」。

先定义 struct：

@(racketblock+eval #:eval evaluator
  (struct proc/memo (proc memo)
    #:property prop:procedure
    (struct-field-index proc)))

再定义宏 @code{lambda/memo*}，注意这里最后将存储计算结果的 @code{memo} 和
memoize 了的函数 @code{proc} 一起放到刚才定义的 proc/memo 这个 struct 里就好了：

@(racketblock+eval #:eval evaluator
  (define-syntax (lambda/memo* stx)
    (syntax-case stx ()
     [(_ (arg ...) body ...)
      #'(let* ([memo (make-hash)]
               [proc
                (lambda (arg ...)
                  (hash-ref memo (list arg ...)
                            (lambda ()
                              (let ([res (begin body ...)])
                                 (hash-set! memo (list arg ...) res)
                                 res))))])
          (proc/memo proc memo))])))

最后定义出 @code{define/memo*}：

@(racketblock+eval #:eval evaluator
  (define-syntax-rule (define/memo* (proc-id arg ...) body ...)
    (define proc-id
      (lambda/memo* (arg ...) body ...))))

同样地，测试一下：

@(evaluator
  '(begin
     (collect-garbage)
     (collect-garbage)
     (collect-garbage)))

@(examples0 #:eval evaluator
  (eval:no-prompt
   (define/memo* (fib/memo* n)
     (cond
       [(= n 0) 0]
       [(= n 1) 1]
       [else (+ (fib/memo* (- n 1)) (fib/memo* (- n 2)))])))

  (time (for ([i (in-range 1000)]) (fib/memo* i))))

这样，通过 @code{define/memo*}（以及 @code{lambda/memo*}）定义的「函数」实际是一
个 @code{proc/memo} 的实例。它可以当作普通函数来使用，不同的是，我们可以通过
@code{proc/memo-memo} 来获取之前已经计算过的结果啦。这个 api 可能有点难看，我们
给它换一个名字：

@(examples0 #:eval evaluator
  (eval:no-prompt
   (define get-memoized proc/memo-memo))

  (code:comment "让我们来看一下都保存了多少条的结果：（虽然它肯定是 1000）")
  (hash-count (get-memoized fib/memo*)))

@(close-eval evaluator)

@hr[]

到这里，我的 @code{define/memo} 写完了。从上面看，它还够正常使用。比较尴尬的是我
们在 @code{lambda/memo} 那里对函数参数的处理，虽然支持了多参但是不支持 Racket 里
其他的形式——optional arguments 和 keyword arguments，而且直接用 @code{(list arg
...)} 也有点蠢。@hyperlink["https://docs.racket-lang.org/memoize/"]{memoize} 是
一个做得挺好的 memoize 的包，它里面对多参是用 @racket[eq-hash-code] 求一下 hash
值作为 key，这样对内存的压力会小一点。

文章对应的代码在 @source-code-github-link{define-memo.rkt}。
