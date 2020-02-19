#lang racket/base
(require scribble/core
         scribble/base
         scribble/html-properties
         scribble/example
         (for-syntax racket/base syntax/parse)
         racket/contract)

(provide section* hr
         (contract-out ($ (-> string? ... string?))
                       ($$ (-> string? ... string?)))
         racketblock+eval examples0
         full-url-on-github
         source-code-github-link)

;;; Elements
;; `section` from scribble but do not add a section number before title
(define (section* . e)
  (section #:style (style #f (list 'unnumbered))
           e))

;; implement custom element, see:
;; https://docs.racket-lang.org/scribble/extra-style.html
;; hr
(define (hr)
  (elem #:style
        (style #f
               (list (alt-tag "hr")))))

;; math (KaTeX)
(define ($ . e)
  (apply string-append `("\\(" ,@e "\\)")))

(define ($$ . e)
  (apply string-append `("$$" ,@e "$$")))

;;; Code and interactive
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

;;; Misc
;; some code examples in the github repo
(define *code-path-prefix*
  "https://github.com/yfzhe/yfzhe.github.io/blob/source/")

(define (full-url-on-github path)
  (string-append *code-path-prefix* path))

(define (source-code-github-link file-path)
  (hyperlink (string-append *code-path-prefix* "code/" file-path)
             file-path))
