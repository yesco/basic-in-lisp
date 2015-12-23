;; fix scheme...

(define nil (list))
(define (nth n l)
   (cond
      ((null? l) nil)
      ((< n 0) nil)
      ((= n 0) (car l))
      (else (nth (- n 1) (cdr l)))))
(define (atom? x) (not (or (pair? x) (null? x))))

;; example basic program

(define bprog
   '((10 let n = 0)
     (20 print "hello")
     (30 print n)
     (40 let n = n + 1)
     (50 goto 20)))

;; basic supporting function

(define (goto ln p)
   (if (eq? ln (car (car p))) 
      p
      (goto ln (cdr p))))

(define (getvar var vars)
   (let ((bind (assoc var vars)))
      (if bind (cdr bind)
         0)))

(define (expr x vars)
   (cond
      ((symbol? x) (getvar x vars))
      ((atom? x) x)
      (else (let ((n (getvar 'n vars)))
               (+ n 1) ) )))

(define (setvar var val vars)
   (let ((bind (assoc var vars)))
      (cond
         (bind (set-cdr! bind val) vars)
         (else (cons (cons var val) vars)))))
   
;; basic run function
;;   p - list of statements to run
;;   stack - of list of statements before gosub, that can be continued on return
;;   vars - variable bindings

(define (brun p stack vars)
   (cond
      ((not (null? p)) (brun-hlp p stack vars))
      ((null? stack) (basic-vars vars))
      (else (brun-hlp (car stack) (cdr stack) vars)) ) )

(define (brun-hlp p stack vars)
           (let* ((curr (car p))
                  (lno (car curr))
                  (stat (cadr curr))
                  (args (cddr curr))
                  (a (nth 0 args)))
              ;; use case?
              (cond
                 ((eq? stat 'return)  (brun (car stack)    (cdr stack)          vars))
                 ((eq? stat 'goto)    (brun (goto a bprog) stack                vars))
                 ((eq? stat 'gosub)   (brun (goto a bprog) (cons (cdr p) stack) vars))
                 ((eq? stat 'let)     (brun (cdr p)        stack                (setvar a (expr (cddr args) vars) vars)))
                 ((eq? stat 'run)     (brun bprog          nil                  nil))
                 (else (cond
                          ((eq? stat 'print) (display (expr a vars)) (newline))
                          ((eq? stat 'list) (map (lambda (l) (display l) (newline)) bprog))
                          (else (error "BASIC: can't understand: " curr)) )
                    (brun (cdr p) stack vars) ) ) ) )
;; guile
(use-modules (ice-9 readline))
(activate-readline)
;; (readline "prompt>") => string

;; TODO: define destructive insert that is tail safe?
(define (binsert ln prog)
   (let ((n (car ln))
         (curn (caar prog)))
      (cond
         ((null? prog) nil)
         ((< n curn) (cons ln prog))
         ((= n curn) (cons ln (cdr prog)))
         (else (cons (car prog) (binsert ln (cdr prog)))))))


(define (basic-vars vars)
   (display "Ready!\n")
   (let ((ln (read)))
      (cond
         ((atom? ln) (brun (list (list 0 ln)) nil vars))
         ((integer? (car ln)) (set! bprog (binsert ln bprog)) (basic-vars vars)))))

(define (basic)
   (basic-vars nil))

(use-modules (ice-9 debug))
(trace brun)

(basic)
