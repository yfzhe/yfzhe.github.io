    Title: Hello World, Again：我是怎么折腾出这个博客的
    Date: 2019-12-22T13:06:27
    Tags: meta

其实这篇文章完全不在我的计划中，本地还有两篇没写完的文章；但是折腾这个博客的过程实在是太费精力了，让这个博客能在因特网上出现之后，我决定写这样一篇文章。（主要是怕不记下来会把这里发生的事情忘了。）

如果你看（当前的）博客首页的话，会发现上下两篇都是「Hello World」。这种尴尬情况的出现是因为这个博客的一部分是在很久以前就准备好的了。当时准备了那一篇[「Hello World」](/posts/2019/05/hello-world.html)，留作第一篇博客，同时也方便写样式测试效果。但是后来把这个博客折腾上线的过程中还是花了不少力气，所以再多记录一点。

<!-- more -->

# 骨架

前一篇文章里也提到了「博客框架」的选择。最开始想弄一个博客的时候，用的是 [Pollen](https://github.com/mbutterick/pollen)；并不是当时不知道现在用的这个 [Frog](https://github.com/greghendershott/frog)，只是 Frog 作为一个真·博客框架，自带的主题实在是太丑陋了。既然还是需要我去做很多东西，那为什么不去用可扩展性强的多得多的 Pollen？

这里简要做一点背景介绍：Frog 和 Pollen 都是用 Racket 做的项目，也是 GitHub 上 star 数比较靠前的项目了。Frog 的定位就是一个博客框架，可以使用 markdown 和 Racket 自带的一个文档语言——[Scribble](https://docs.racket-lang.org/scribble/index.html) 来写文章。有各类博客需要的功能：RSS，站点地图，还有一些小工具，比如 GA，比如 Disqus。一点缺陷就是自带的主题不太好看，基本是每个用户都要自己改造一下的情况。而 Pollen 则是在 Racket 上的一个「图书出版系统」（book-publishing system)，拿来做书（不管是数字的 HTML 还是更纸质的 TeX / PDF）非常合适好用；不过用来做博客就需要不少折腾了。

好，回到正题，为了扩展性和可玩性选择了 Pollen，这才是痛苦的开始。但是用 Pollen 写博客翻了挺多 pollen 的邮件列表里的帖子，也照着这个项目[^1]折腾了挺多。Pollen 通过 xexpr，meta 和 ptree 提供了非常强大的自定义能力。不过这样的自定义能力也就意味着需要做很多的事情，而 Pollen 的资料一直不多，对它们的了解不太深入，如果一直都玩不太顺。折腾一个 RSS 都花费了很长时间，成了压倒我的最后一棵稻草。现在电脑里留着一份当时基于 Pollen 的那个项目，最后的修改时间是 19 年 2 月。看来这一个博客折腾的历史确实也挺久的了。

从 Pollen 换到 Frog 也不意味从头开始。前面说了用 Frog 也要自己重整模板；而之前在 Pollen 上的折腾就直接拿过来用了。Frog 的模板（实际是复用 Racket 自带的 [web-server 里的](https://docs.racket-lang.org/web-server/templates.html)）也还不错，可玩性也还挺大（而且还有 enhance-body，有精力的话可以可以做到和 Pollen 差不多的自定义能力了）。迁移过来之后，花了点时间升级了一下样式（虽然依旧被某网友吐槽很差），再加上前面一条 Hello World，就差不多是博客的骨架部分了。

至于你问我为什么一定要选择 Racket 社区里这些奇奇怪怪的「博客框架」呢？我也不知道该怎么回复，可能当时（现在也是）Racket 玩得比较多，然后就想着在 Racket 这些东西里找一个用着，这样也比较熟悉。

# 利用 CI 自动部署

在本地博客能跑起来之后，按道理是应该认真写篇文章出来的。但是我并没有，不知道在哪看到了用 CI 让博客实现自动部署，然后被迷魂了开始折腾起这个事情。

开始动手做这个博客的时候，Github Actions 还没出来；好像挺多都在用 Travis。不过，有一次发现 Circle CI 的博客写了挺多关于 clojure 的内容，<del>秉持着 Lisp 惺惺相惜的态度，</del>我决定要用 Circle CI 来做这个自动部署。于是，梦魇来了。

自动部署这里最先，也是主要的参考资料是 [lexi-lambda](https://lexi-lambda.github.io) 的一篇文章[^2]。另外 Circle CI 也有一篇说把文档部署到 Github Pages 上的文章[^3]。正常情况下这两篇博客就够了，但是怎么可能是正常情况！如果是正常情况，我显然就不写了。

自动把博客部署到 GitHub Pages 上主要这么几步：先准备好博客框架的环境，然后渲染博客的内容，最后 commit 到对应的 repo 上。

那么第一步，安装博客框架的环境，我这里的情况，就是安装 Racket 和 Frog 了。这里就是主要坑的地方！Racket 世界一般的操作，包括 lexi-lambda 那一篇博客里写的，都是使用 Greg Hendershott 的 [travis-racket](https://github.com/greghendershott/travis-racket) 里的 [install-racket.sh](https://github.com/greghendershott/travis-racket/blob/master/install-racket.sh) 这个脚本安装 Racket。 然而，Circle CI 支持 docker，所以想着用 racket-docker 而不是用一个脚本来处理 racket 环境。

结果 racket-docker 先是没有按时间更新到最新的 Racket 版本，而且它设置了下载包是从 Racket 的 package catalog 里直接现在预编译好的包。结果：首先，没有更新到最新版本，而 package catalog 里只有最新版本的编译后文件；后来，racket-docker 更新到了最新的 7.5 版本，但是在构建博客的时候 frog 会报错导致无法构建博客。原因居然是——Frog 运行的主函数 `main` 每次运行，都会先打印一下当前的版本号。为了兼容低版本，没办法用直接获取 info.rkt 里文件里的版本号；而作者又不愿在不同的地方写多遍版本号。于是决定直接对 info.rkt 文件做一通正则匹配，人工找出版本号。然后，因为 racket-docker 会安装 pre-built 的版本，这里的 info.rkt 也是编译过的，是展开后的格式，所以正则就在这里挂了，嗯，就这么挂了。[^4]

（不过，不得不说，直接从 catalog 上拉下来 pre-built 的包，速度是真快。Frog 本身没有把实现和文档拆开，导致普通安装会去下载不少的依赖，而从 catalog 下载直接一次就可以了。一个小技巧：在这种环境安装 Frog 的时候可以开启 `--no-docs`，即使用 `raco pkg install --auto --no-docs frog` 来安装。这样 Racket 不会去编译安装本地文档，可以节省不少时间。）

于是老实换上 install-racket.sh。所有使用 install-racket.sh 的地方都会有这么一句——"`export PATH="${RACKET_DIR}/bin:${PATH}" # install-racket.sh can't set for us`[bash]"。接下来，问题就出在这个自己来设置一下 `PATH` 上，每次执行完这段之后，接着准备用 `raco pkg install frog` 去安装 frog，ci 报错说找不到 racket。问题竟然是因为 Circle CI 不支持直接动态修改环境变量！！！去官方论坛找到了一篇[相关的帖子](https://discuss.circleci.com/t/how-to-add-a-path-to-path-in-circle-2-0/11554)，按帖子里几个楼里的解决方法依次试一下，才解决了 `PATH` 的问题。

至于构建之后部署的事情，就是添加一下 ssh key，git commit 一下，再 push 到 master 分支。上面的两篇教程里都说得挺好，这里就不多说了。值得一提的一点（或许其实只有我不知道）：Circle CI 官方博客里的那篇说了一个小技巧：在 git message 里加一个 "[skip ci]"（任何位置都行），就可以让 ci 忽略为了部署而做的这次 commit 了，有效解决强迫症患者看到 master 总是失败的痛苦。

最终，经历了 50+ 条失败的 pipeline，终于把这个自动部署的配置文件[^5]弄出来了。真的是太不容易了。

# 最后一点小事：license

之所以说是一点小事，当然是因为这个小博客也不会有什么人转发啥的——估计连浏览量都没有。但是既然要整一个博客，努力弄成大人模样，「版权声明」这种东西即使实际中无用，样子还是要有的嘛。

作为一个（新人）Emacs 用户，开始想的是用 GPL 系列：用咱微小的力量给 free software 做一点微小的贡献。毕竟有这么一句话：

> 一个 Emacs 用户，不是已经信仰了 GNU，就是在信仰 GNU 的路上。 ——我自己说的

不过怎么想，在一个博客上用上 GPL 的 license，还是一件很奇怪的事情。于是就咨询了一位 Emacs 大佬，[@cireu](https://cireu.github.io)；大佬的回复是「CC 不就能搞定了？」原来 Common Creative 有一个 Share-Alike 的选项，也可以做到 GPL 这样的传染性。于是就这么用上了 CC BY-SA，也要感谢一下 cireu 同学。

---

到现在博客就折腾到了这里，也还有些东西没弄，比如评论区，比如流量统计。先这样吧，我去写下一篇文章了。

[^1]: <https://github.com/otherjoel/try-pollen><br />应该是最大（或许就是唯一）的用 Pollen 做博客的例子，功能非常丰富。作者的博客里也很多相关的内容。

[^2]: <https://lexi-lambda.github.io/blog/2015/07/18/automatically-deploying-a-frog-powered-blog-to-github-pages/>

[^3]: <https://circleci.com/blog/deploying-documentation-to-github-pages-with-continuous-integration/>

[^4]: 关于这个我去 frog 的 github 上提了 [issue](https://github.com/greghendershott/frog/issues/253)，后来 Greg Hendershott 也做了一些修复。<br />当年做了非常多 Racket 相关的东西的 Greg，居然因为 Racket2，放下了更新的步伐——甚至前段时间还把有些 repo 存档了（虽然后来又都取消存档），真是让人唏嘘啊。

[^5]: 我的配置文件在 <https://github.com/yfzhe/yfzhe.github.io/blob/source/.circleci/config.yml>，如果也有处于非正常情况下的人需要参考的话。正常情况，还是前面的两篇博客（中的任何一篇）就够了。
