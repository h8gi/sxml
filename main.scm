;(set! format:max-iterations 10000)

(define (print-tag name alst closingp)
  (with-output-to-string 
      (lambda ()
        (display "<")
        (when closingp
          (display "/" ))
        (display (string-downcase (symbol->string name)))
        (for-each
         (lambda (att)
           (printf " ~a=\"~a\"" (string-downcase (symbol->string (car att))) (cdr att)))
         alst)
        (display ">"))))

(define (print-tag/ name alst)
  (with-output-to-string
      (lambda ()
        (display "<")
        (display (string-downcase (symbol->string name)))
        (for-each
         (lambda (att)
           (printf " ~a=\"~a\"" (string-downcase (symbol->string (car att))) (cdr att)))
         alst)
        (display " />"))))

(define-syntax @->pairs
  (syntax-rules ()
    [(_ (pairs ...))
     (@->pairs (pairs ...) ())]
    [(_ () (ps ...))
     (list ps ...)]
    [(_ ((name value) rest ...) (ps ...))
     (@->pairs (rest ...) (ps ... (cons 'name value)))]
    [(_ ((name) rest ...) (ps ...))
     (@->pairs (rest ...) (ps ... (cons 'name "")))]))

(define-syntax tag
  (syntax-rules (@)
    [(_ name (@ pairs ...) body ...)
     (string-append (print-tag 'name (@->pairs (pairs ...)) #f)
                    body ...
                    (print-tag 'name '() #t))]
    [(_ name body ...)
     (tag name (@) body ...)]))

(define-syntax tag/
  (syntax-rules (@)
    [(_ name (@ pairs ...))
     (print-tag/ 'name (@->pairs (pairs ...)))]
    [(_ name)
     (tag/ name (@))]))

(define-syntax define-tag
  (ir-macro-transformer
   (lambda (expr inject compare)
     (let ((name (cadr expr))
           (body (gensym)))
       `(define-syntax ,(inject name)
          (syntax-rules ()
            [(_ ,body ...)
             (tag ,(inject name) ,body ...)]))))))

(define-syntax define-tag/
  (ir-macro-transformer
   (lambda (expr inject compare)
     (let ((name (cadr expr))
           (body (gensym)))
       `(define-syntax ,(inject name)
          (syntax-rules ()
            [(_ ,body ...)
             (tag/ ,(inject name) ,body ...)]))))))
