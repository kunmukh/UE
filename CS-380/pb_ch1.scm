;1.9 1.14 1.18 1.21 1.24 1.36

#lang eopl
;1.9
(define remove
  (lambda (s slist)
    (if (null? slist)
        '()
        (if (eqv? s (car slist) )
            (remove s (cdr slist))
            (cons (car slist)
                  (remove s (cdr slist)))))))
;1.18
(define swapper
  (lambda (u v slst)
    ;(if (null? slst)
    ;    slst
        (cond
          ((null? slst) slst)
          ((eqv? u (car slst)) (cons v (swapper u v (cdr slst))))
          ((eqv? v (car slst)) (cons u (swapper u v (cdr slst))))
          (else (cons (car slst) (swapper u v (cdr slst)))))))

;1.21
(define product
  (lambda (lst1 lst2)
    (if (null? lst1)
        '()
        (if (null? lst2)
        '()
        (append (product1 lst1 (car lst2)) (product lst1 (cdr lst2)))))))

(define product1
  (lambda (lst s)
    (if (null? lst)
        '()
        (cons (list (car lst) s) (product1 (cdr lst) s)))))

;1.24
(define every?
  (lambda (pred lst)
    (if (null? lst)
        #t
        (and (pred (car lst))
             (every? pred (cdr lst))))))


