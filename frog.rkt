#lang frog/config

;; Called early when Frog launches. Use this to set parameters defined
;; in frog/params.
(define/contract (init)
  (-> any)
  (current-scheme/host "https://yfzhe.github.io")
  (current-title "看看就好的博客")
  (current-author "yfzhe")
  (current-permalink "/posts/{year}/{month}/{filename}/index.html")
  (current-feed-full? #t)
  (current-max-feed-items 50)
  (current-source-dir "src")
  (current-output-dir "out"))

;; Called once per post and non-post page, on the contents.
(define/contract (enhance-body xs)
  (-> (listof xexpr/c) (listof xexpr/c))
  ;; Here we pass the xexprs through a series of functions.
  (~> xs
      (syntax-highlight #:line-numbers? #f
                        #:css-class "code-source")
      ;(auto-embed-tweets #:parents? #t)
      (add-racket-doc-links #:code? #t #:prose? #f)))

;; Called from `raco frog --clean`.
(define/contract (clean)
  (-> any)
  (void))
