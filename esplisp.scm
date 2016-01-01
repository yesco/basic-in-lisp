;; make esp-lisp a bit scheme

(define (display x) (princ x))

(setq display princ)
(setq newline terpri)
(setq set! setq)
(setq set-car! setcar)
(setq set-cdr! setcdr)
(setq eq? eq)
(setq eqv? eq)
(setq equal? equal)
(setq pair? cons?)

(setq else t)

(define (cadr x) (car (cdr x)))
(define (cddr x) (cdr (cdr x)))
(define (caar x) (car (car x)))
(define (cdar x) (cdr (car x)))

(define (caadr x) (car (car (cdr x))))
(define (caddr x) (car (cdr (cdr x))))
(define (caaar x) (car (car (car x))))
(define (cadar x) (car (cdr (car x))))

(define (cdadr x) (cdr (car (cdr x))))
(define (cdddr x) (cdr (cdr (cdr x))))
(define (cdaar x) (cdr (car (car x))))
(define (cddar x) (cdr (cdr (car x))))

