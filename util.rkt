#lang racket/base

(require (for-syntax racket/base syntax/parse)
         scribble/core
         scribble/base
         scribble/example)

(provide section*
         racketblock+eval examples0
         make-base-eval
         (rename-out [subscript sub]
                     [superscript sup]))

(define (section* . e)
  (section #:style (style #f (list 'unnumbered))
           e))

(define-syntax (racketblock+eval stx)
  (syntax-parse stx
    [(_ (~or* (~seq #:eval evaluator:expr) (~seq))
        code:expr ...)
     #'(examples (~? (~@ #:eval evaluator))
                 #:no-result
                 code ...)]))

(define-syntax (examples0 stx)
  (syntax-parse stx
    [(_ (~or* (~seq #:eval evaluator:expr) (~seq))
        code:expr ...)
     #'(examples (~? (~@ #:eval evaluator))
                 #:label #f
                 code ...)]))

