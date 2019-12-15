#lang racket/base
(require (for-syntax racket/base syntax/parse)
         scribble/core
         scribble/base
         scribble/example)

(provide section*
         racketblock+eval examples0
         make-base-eval
         full-url-on-github
         source-code-github-link
         (rename-out [subscript sub]
                     [superscript sup]))

;;; `section` from scribble but do not add a section number before title
(define (section* . e)
  (section #:style (style #f (list 'unnumbered))
           e))

;;; customized `racketblock` and `examples`
(define-syntax (racketblock+eval stx)
  (syntax-parse stx
    [(_ (~optional (~seq #:eval evaluator:expr))
        code:expr ...)
     #'(examples (~? (~@ #:eval evaluator))
                 #:no-result
                 code ...)]))

(define-syntax (examples0 stx)
  (syntax-parse stx
    [(_ (~optional (~seq #:eval evaluator:expr))
        code:expr ...)
     #'(examples (~? (~@ #:eval evaluator))
                 #:label #f
                 code ...)]))

;;; some code examples in the github repo
(define *code-path-prefix*
  "https://github.com/yfzhe/yfzhe.github.io/blob/source/")

(define (full-url-on-github path)
  (string-append *code-path-prefix* path))

(define (source-code-github-link file-path)
  (hyperlink (string-append *code-path-prefix* "code/" file-path)
             file-path))

