(use sxml)
(define *TOP* string-append)
(define-tag html)
(define-tag head)
(define-tag/ meta)
(define-tag title)
(define-tag body)


(*TOP* "<!DOCTYPE HTML>"
       (html (@ (lang "ja"))
             (head (meta (@ (charset "UTF-8")))
                   (title "Document"))
             (body "Contents")))

(call-with-output-file "test.html"
  (lambda (out)
    (display
     (*TOP* "<!DOCTYPE HTML>"
            (html (@ (lang "ja"))
                  (head (meta (@ (charset "UTF-8")))
                        (title "Document"))
                  (body "Contents")))
     out)))
