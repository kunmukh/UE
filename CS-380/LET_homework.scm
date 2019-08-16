#lang eopl
;Programer Kunal Mukherjee
;3.6, 3.8, 3.13, 3.16


;scanner
(define scanner-spec-let
  '((white-sp (whitespace) skip)
    (comment ("%" (arbno (not #\newline))) skip)
    (identifier (letter (arbno (or letter digit))) symbol)
    (number (digit (arbno digit)) number)))

(define grammar-let
  '((Program (Exp)
             a-Program)
    (Exp (number)
         const-Exp)
    (Exp ("-" "(" Exp "," Exp ")")
         diff-Exp)
    (Exp ("zero?" "(" Exp ")")
         zero-Exp?)
    (Exp ("equal?" "(" Exp "," Exp ")")
         equal-Exp?)
    (Exp ("greater?" "(" Exp "," Exp ")")
         greater-Exp?)
    (Exp ("less?" "(" Exp "," Exp ")")
         less-Exp?)
    (Exp ("if" Exp "then" Exp "else" Exp)
         if-Exp)
    (Exp (identifier)
         var-Exp)
    (Exp ("let" identifier "=" Exp "in" Exp)
         let-Exp)
    (Exp ("minus" "(" Exp ")")
         minus-Exp)))

(sllgen:make-define-datatypes scanner-spec-let grammar-let)

(define list-the-datatypes
  (lambda ()
    (sllgen:list-define-datatypes scanner-spec-let grammar-let)))

(define just-scan
  (sllgen:make-string-scanner scanner-spec-let grammar-let))

(define scan&parse
  (sllgen:make-string-parser scanner-spec-let grammar-let))

(define run
  (lambda (str)
    (Expval->num (value-of-Program (scan&parse str)))))


 
;Enviroment Expression
(define-datatype environment environment?
  (empty-env)
  (extend-env (var symbol?)
               (val Exp?)
               (saved-env environment?)))

(define apply-env
  (lambda (search-var env)
    (cases environment env
      (empty-env () #f)
      (extend-env (var val saved-env)
                  (if (eqv? search-var var) val
                      (apply-env search-var saved-env))))))                
                   
                   

;LET Langauge

#|(define-datatype Program Program?
  (a-Program (Exp1 Exp?)))

(define-datatype Exp Exp?
  (const-Exp (num number?))
  (diff-Exp (Exp1 Exp?)
            (Exp2 Exp?))
  (zero-Exp? (Exp1 Exp?))
  (if-Exp (Exp1 Exp?)
          (Exp2 Exp?)
          (Exp3 Exp?))
  (var-Exp (var symbol?))
  (let-Exp (var symbol?)
           (Exp1 Exp?)
           (body Exp?))
  (minus-Exp (Exp1 number?)))|#
           



(define init-env
  (lambda ()
    (extend-env 'i (num-val 1)
                (extend-env 'v (num-val 5)
                            (extend-env 'x (num-val 10)
                                        (empty-env))))))

(define-datatype Expval Expval?
  (num-val (num number?))
  (bool-val (bool boolean?)))
  

(define Expval->num
  (lambda (val)
    (cases Expval val
      (num-val (num)
               num)
      (else
       (report-Expval-extractor-error 'num val)))))

(define Expval->bool
  (lambda (val)
    (cases Expval val
      (bool-val (bool)
               bool)
      (else
       (report-Expval-extractor-error 'bool val)))))



(define report-Expval-extractor-error
  (lambda (type val)
    (eopl:error 'Exp-val "Error extracting ~s from ~s" type val)))

(define value-of-Program
  (lambda (pgm)
    (cases Program pgm
      (a-Program (Exp)
                 (value-of Exp init-env)))))

(define value-of
  (lambda (Exp1 env)
    (cases Exp Exp1
      (const-Exp (num)
                 (num-val num))
       (var-Exp (var)
                (apply-env env var))
      (diff-Exp (Exp1 Exp2)
                (let ((val1 (value-of Exp1 env))
                      (val2 (value-of Exp2 env)))
                  (let ((num1 (Expval->num val1))
                        (num2 (Expval->num val2)))
                    (num-val
                     (- num1 num2)))))
      (zero-Exp? (Exp1)
                 (let ((val1 (value-of Exp1 env)))
                   (bool-val
                    (zero? (Expval->num val1)))))
      (equal-Exp? (Exp1 Exp2)
                  (let ((val1 (value-of Exp1 env))
                        (val2 (value-of Exp2 env)))
                    (let ((num1 (Expval->num val1))
                          (num2 (Expval->num val2)))
                      (bool-val (eqv? num1 num2)))))
      (greater-Exp? (Exp1 Exp2)
                    (let ((val1 (value-of Exp1 env))
                          (val2 (value-of Exp2 env)))
                      (let ((num1 (Expval->num val1))
                            (num2 (Expval->num val2)))
                        (bool-val (> num1 num2)))))
      (less-Exp? (Exp1 Exp2)
                 (let ((val1 (value-of Exp1 env))
                       (val2 (value-of Exp2 env)))
                   (let ((num1 (Expval->num val1))
                         (num2 (Expval->num val2)))
                     (bool-val (< num1 num2)))))                      
      (if-Exp (Exp1 Exp2 Exp3)
              (let ((val1 (value-of Exp1 env)))
                (if (Expval->bool val1)
                    (value-of Exp2 env)
                    (value-of Exp3 env))))
      (let-Exp (var Exp1 body)
               (let ((val1 (value-of Exp1 env)))
                 (value-of body (extend-env var (value-of Exp1 env) env))))
      (minus-Exp (Exp1)
                 (let ((val1 (value-of Exp1 env)))
                   (let ((num1 (Expval->num val1)))
                     (num-val (- num1))))))))


      
      


(define report-error
  (lambda ()
    (eopl:error 'Exp "Error")))
                
           
             
    
    


