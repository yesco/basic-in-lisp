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
     (40 let n = n + 1 * 2)
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
      ((number? x) x)
      ((not (pair? x)) (throw "Not understood expression: " x))
      ((= 1 (length x)) (expr (car x) vars))
      ((and (symbol? (car x)) (pair? (cadr x)))
       (let ((args (cadr x)))
	 (case (car x)
	   ((round) (round (expr (car args) vars))))))
      (else (let ((a (expr (car x) vars))
		  (op (cadr x))
		  (b (cddr x)))
	      (case op
		((+) (+ a (expr b vars)))
		((-) (- a (expr b vars)))
		((/) (expr (cons (/ a (expr (car b) vars)) (cdr b)) vars))
		((*) (expr (cons (* a (expr (car b) vars)) (cdr b)) vars))
		)))))
	      
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
	      ;; (display "-------------------") (display curr) (display " ") (display vars) (newline)
              (cond
                 ((eq? stat 'return)  (brun (car stack)    (cdr stack)          vars))
                 ((eq? stat 'goto)    (brun (goto a bprog) stack                vars))
                 ((eq? stat 'gosub)   (brun (goto a bprog) (cons (cdr p) stack) vars))
                 ((eq? stat 'let)     (brun (cdr p)        stack                (setvar a (expr (cddr args) vars) vars)))
                 ((eq? stat 'run)     (brun bprog          nil                  nil))
                 (else (cond
                          ((eq? stat 'print) (display (expr a vars)) (newline))
                          ((eq? stat 'list) (map (lambda (l) (display l) (newline)) bprog))
			  ;; catch all for everything not matched - reset all but keep vars state for debugging
                          (else (display "BASIC: can't understand: ") (display curr)
				(set! p (quote ((0 print "error"))))
				(set! stack (list)))) 
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
   (display "\nReady!\n")
   (let ((ln (read)))
      (cond
         ((atom? ln) (brun (list (list 0 ln)) nil vars))
         ((not (integer? (car ln))) (brun (list (cons 0 ln)) nil vars))
         ((integer? (car ln)) (set! bprog (binsert ln bprog)) (basic-vars vars)))))

(define (basic)
  (basic-vars nil))

(use-modules (ice-9 debug))
;;(trace brun)
(trace expr)

(basic)
