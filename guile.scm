;; guile

;; fix scheme...

(define nil (list))
(define (atom? x) (not (or (pair? x) (null? x))))

;; readline and debug

(use-modules (ice-9 readline))
(activate-readline)
(use-modules (ice-9 debug))

;;(trace brun)
;;(trace expr)
