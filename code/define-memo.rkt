#lang racket

;;; define/memo and lambda/memo:
;;; a naive implement of memoizing
(define-syntax (lambda/memo stx)
  (syntax-case stx ()
    [(_ (arg ...) body ...)
     #'(let ([memo (make-hash)])
         (lambda (arg ...)
           (hash-ref memo (list arg ...)
                     (lambda ()
                       (let ([res (begin body ...)])
                         (hash-set! memo (list arg ...) res)
                         res)))))]))

(define-syntax-rule (define/memo (proc arg ...) body ...)
  (define proc (lambda/memo (arg ...) body ...)))

;;; lambda/memo*:
;;; a weird update of lambda/memo,
;;; exposing an api to get the memoized data.
(struct proc/memo (proc memo)
  #:property prop:procedure
  (struct-field-index proc))

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
         (proc/memo proc memo))]))

(define-syntax-rule (define/memo* (proc-id arg ...) body ...)
  (define proc-id (lambda/memo* (arg ...) body ...)))

(define get-memoized proc/memo-memo)

(module+ test
  (define/memo* (fib* n)
    (cond
      [(= n 0) 0]
      [(= n 1) 1]
      [else (+ (fib* (- n 1)) (fib* (- n 2)))]))

  (time (fib* 100))
  (hash-count (get-memoized fib*)))
