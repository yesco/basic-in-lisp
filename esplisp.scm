;; make esp-lisp a bit scheme

(define (display x) (princ x))

(define display princ)
(define newline terpri)
(define eq? eq)
(define eqv? eq)
(define equal? equal)
(define pair? cons?)

(define else t)

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

