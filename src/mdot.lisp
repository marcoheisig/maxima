;;; -*-  Mode: Lisp; Package: Maxima; Syntax: Common-Lisp; Base: 10 -*- ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;     The data in this file contains enhancements.                   ;;;;;
;;;                                                                    ;;;;;
;;;  Copyright (c) 1984,1987 by William Schelter,University of Texas   ;;;;;
;;;     All rights reserved                                            ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (c) Copyright 1982 Massachusetts Institute of Technology 

(in-package :maxima)

;; Non-commutative product and exponentiation simplifier
;; Written:	July 1978 by CWH

;; Flags to control simplification:

(macsyma-module mdot)

(defmvar $dotconstrules t
  "Causes a non-commutative product of a constant and
another term to be simplified to a commutative product.  Turning on this
flag effectively turns on DOT0SIMP, DOT0NSCSIMP, and DOT1SIMP as well.")

(defmvar $dot0simp t
  "Causes a non-commutative product of zero and a scalar term to
be simplified to a commutative product.")

(defmvar $dot0nscsimp t
  "Causes a non-commutative product of zero and a nonscalar term
to be simplified to a commutative product.")

(defmvar $dot1simp t
  "Causes a non-commutative product of one and another term to be
simplified to  a commutative product.")

(defmvar $domxnctimes nil
  "Causes non-commutative products of matrices to be carried out.")

(defmvar $dotident 1 "The value to be returned by X^^0.")

;; The operators "." and "^^" distribute over equations.

(defprop mnctimes (mequal) distribute_over)
(defprop mncexpt (mequal) distribute_over)

(defun simpnct (exp vestigial simp-flag) 
  (declare (ignore vestigial))
  (let ((check exp)
	(first-factor (simpcheck (cadr exp) simp-flag))
	(remainder (if (cdddr exp)
		       (ncmuln (cddr exp) simp-flag)
		       (simpcheck (caddr exp) simp-flag))))
    (cond ((null (cdr exp)) $dotident)
	  ((null (cddr exp)) first-factor)

	  ;;  This does (. sc m) --> (f* sc m)  and  (. (f* sc m1) m2) --> (f* sc (. m1 m2))
	  ;;  and (. m1 (f* sc m2)) --> (f* sc (. m1 m2)) where sc can be a scalar
	  ;;  or constant, and m1 and m2 are non-constant, non-scalar expressions.

	  ((commutative-productp first-factor remainder)
	   (mul2 first-factor remainder))
	  ((product-with-inner-scalarp first-factor)
	   (let ((p-p (partition-product first-factor)))
	     (outer-constant (car p-p) (cdr p-p) remainder)))
	  ((product-with-inner-scalarp remainder)
	   (let ((p-p (partition-product remainder)))
	     (outer-constant (car p-p) first-factor (cdr p-p))))

	  ;;  This code does distribution when flags are set and when called by
	  ;;  $EXPAND.  The way we recognize if we are called by $EXPAND is to look at
	  ;;  the value of $EXPOP, but this is a kludge since $EXPOP has nothing to do
	  ;;  with expanding (. A (f+ B C)) --> (f+ (. A B) (. A C)).  I think that
	  ;;  $EXPAND wants to have two flags:  one which says to convert
	  ;;  exponentiations to repeated products, and another which says to
	  ;;  distribute products over sums.

	  ((and (mplusp first-factor) (or $dotdistrib (not (zerop $expop))))
	   (addn (mapcar #'(lambda (x) (ncmul x remainder))
			 (cdr first-factor))
		 t))
	  ((and (mplusp remainder) (or $dotdistrib (not (zerop $expop))))
	   (addn (mapcar #'(lambda (x) (ncmul first-factor x))
			 (cdr remainder))
		 t))

	  ;;  This code carries out matrix operations when flags are set.

	  ((matrix-matrix-productp first-factor remainder)
	   (timex first-factor remainder))
	  ((or (scalar-matrix-productp first-factor remainder)
	       (scalar-matrix-productp remainder first-factor))
	   (simplifya (outermap1 'mnctimes first-factor remainder) t))

	  ;;  (. (^^ x n) (^^ x m)) --> (^^ x (f+ n m))

	  ((and (simpnct-alike first-factor remainder) $dotexptsimp)
	   (simpnct-merge-factors first-factor remainder))

	  ;;  (. (. x y) z) --> (. x y z)

	  ((and (mnctimesp first-factor) $dotassoc)
	   (ncmuln (append (cdr first-factor)
			   (if (mnctimesp remainder)
			       (cdr remainder)
			       (ncons remainder)))
		   t))

	  ;;  (. (^^ (. x y) m) (^^ (. x y) n) z) --> (. (^^ (. x y) m+n) z)
	  ;;  (. (^^ (. x y) m) x y z) --> (. (^^ (. x y) m+1) z)
	  ;;  (. x y (^^ (. x y) m) z) --> (. (^^ (. x y) m+1) z)
	  ;;  (. x y x y z) --> (. (^^ (. x y) 2) z)

	  ((and (mnctimesp remainder) $dotassoc $dotexptsimp)
	   (setq exp (simpnct-merge-product first-factor (cdr remainder)))
	   (if (and (mnctimesp exp) $dotassoc)
	       (simpnct-antisym-check (cdr exp) check)
	       (eqtest exp check)))

	  ;;  (. x (. y z)) --> (. x y z)

	  ((and (mnctimesp remainder) $dotassoc)
	   (simpnct-antisym-check (cons first-factor (cdr remainder)) check))

	  (t (eqtest (list '(mnctimes) first-factor remainder) check)))))

;;  Predicate functions for simplifying a non-commutative product to a
;;  commutative one.  SIMPNCT-CONSTANTP actually determines if a term is a
;;  constant and is not a nonscalar, i.e. not declared nonscalar and not a
;;  constant list or matrix.  The function CONSTANTP determines if its argument
;;  is a number or a variable declared constant.

(defun commutative-productp (first-factor remainder)
  (or (simpnct-sc-or-const-p first-factor)
      (simpnct-sc-or-const-p remainder)
      (simpnct-onep first-factor)
      (simpnct-onep remainder)
      (zero-productp first-factor remainder)
      (zero-productp remainder first-factor)))

(defun simpnct-sc-or-const-p (term)
  (or (simpnct-constantp term) (simpnct-assumescalarp term)))

(defun simpnct-constantp (term)
  (and $dotconstrules
       (or (mnump term)
	   (and ($constantp term) (not ($nonscalarp term))))))

(defun simpnct-assumescalarp (term)
  (and $dotscrules (scalar-or-constant-p term (eq $assumescalar '$all))))

(defun simpnct-onep (term) (and $dot1simp (onep1 term)))
	
(defun zero-productp (one-term other-term)
  (and (zerop1 one-term)
       $dot0simp
       (or $dot0nscsimp (not ($nonscalarp other-term)))))

;;  This function takes a form and determines if it is a product 
;;  containing a constant or a declared scalar.  Note that in the
;;  next three functions, the word "scalar" is used to refer to a constant
;;  or a declared scalar.  This is a bad way of doing things since we have
;;  to cdr down an expression twice: once to determine if a scalar is there
;;  and once again to pull it out.

(defun product-with-inner-scalarp (product)
  (and (mtimesp product)
       (or $dotconstrules $dotscrules)
       (do ((factor-list (cdr product) (cdr factor-list)))
	   ((null factor-list) nil)
	 (if (simpnct-sc-or-const-p (car factor-list))
	     (return t)))))

;;  This function takes a commutative product and separates it into a scalar
;;  part and a non-scalar part.

(defun partition-product (product)
  (do ((factor-list (cdr product) (cdr factor-list))
       (scalar-list nil)
       (nonscalar-list nil))
      ((null factor-list) (cons (nreverse scalar-list)
				(muln (nreverse nonscalar-list) t)))
    (if (simpnct-sc-or-const-p (car factor-list))
	(push (car factor-list) scalar-list)
	(push (car factor-list) nonscalar-list))))

;;  This function takes a list of constants and scalars, and two nonscalar
;;  expressions and forms a non-commutative product of the nonscalar
;;  expressions, and a commutative product of the constants and scalars and
;;  the non-commutative product.

(defun outer-constant (constant nonscalar1 nonscalar2)
  (muln (nconc constant (ncons (ncmul nonscalar1 nonscalar2))) t))

(defun simpnct-base (term) (if (mncexptp term) (cadr term) term))

(defun simpnct-power (term) (if (mncexptp term) (caddr term) 1))

(defun simpnct-alike (term1 term2)
  (alike1 (simpnct-base term1) (simpnct-base term2)))

(defun simpnct-merge-factors (term1 term2)
  (ncpower (simpnct-base term1)
	   (add2 (simpnct-power term1) (simpnct-power term2))))

(defun matrix-matrix-productp (term1 term2)
  (and (or $doallmxops $domxmxops $domxnctimes)
       (mxorlistp1 term1)
       (mxorlistp1 term2)))

(defun scalar-matrix-productp (term1 term2)
  (and (or $doallmxops $doscmxops)
       (mxorlistp1 term1)
       (scalar-or-constant-p term2 (eq $assumescalar '$all))))


(defun simpncexpt (exp vestigial simp-flag)
  (declare (ignore vestigial))
  (let ((factor (simpcheck (cadr exp) simp-flag))
	(power (simpcheck (caddr exp) simp-flag))
	(check exp))
    (twoargcheck exp)
    (cond ((zerop1 power)
	   (if (zerop1 factor)
	       (if (not errorsw)
		   (merror (intl:gettext "noncommutative exponent: ~M is undefined.")
			   (list '(mncexpt) factor power))
		   (throw 'errorsw t)))
	   (if (mxorlistp1 factor) (identitymx factor) $dotident))
	  ((onep1 power) factor)
	  ((and (simpnct-sc-or-const-p factor)
                (simpnct-sc-or-const-p power)) (power factor power))
	  ((and (zerop1 factor) $dot0simp) factor)
	  ((and (onep1 factor) $dot1simp) factor)
	  ((and (or $doallmxops $domxmxops)
		(mxorlistp1 factor)
		(fixnump power))
	   (let (($scalarmatrixp (or ($listp factor) $scalarmatrixp)))
	     (simplify (powerx factor power))))

	  ;; This does (A+B)^^2 --> A^^2 + A.B + B.A + B^^2
	  ;; and (A.B)^^2 --> A.B.A.B

	  ((and (or (mplusp factor) (not $dotexptsimp))
		(fixnump power)
		(not (> power $expop))
		(plusp power))
	   (ncmul factor (ncpower factor (1- power))))

	  ;; This does the same thing as above for (A+B)^^(-2)
	  ;; and (A.B)^^(-2).  Here the "-" operator does the trick
	  ;; for us.

	  ((and (or (mplusp factor) (not $dotexptsimp))
		(fixnump power)
		(not (> (- power) $expon))
		(< power -1))
	   (let (($expop $expon))
	     (ncpower (ncpower factor (- power)) -1)))
	  
	  ((product-with-inner-scalarp factor)
	   (let ((p-p (partition-product factor)))
	     (mul2 (power (muln (car p-p) t) power)
		   (ncpower (cdr p-p) power))))
	  ((and $dotassoc (mncexptp factor))
	   (ncpower (cadr factor) (mul2 (caddr factor) power)))
	  (t (eqtest (list '(mncexpt) factor power) check)))))


(defun simpnct-invert (exp)
  (cond ((mnctimesp exp)
	 (ncmuln (nreverse (mapcar #'simpnct-invert (cdr exp))) t))
	((and (mncexptp exp) (integerp (caddr exp)))
	 (ncpower (cadr exp) (- (caddr exp))))
	(t (list '(mncexpt simp) exp -1))))

(defun identitymx (x)
  (if (and ($listp (cadr x)) (= (length (cdr x)) (length (cdadr x))))
      (simplifya (cons (car x) (cdr ($ident (length (cdr x))))) t)
      $dotident))

;;  This function incorporates the hairy search which enables such
;;  simplifications as (. a b a b) --> (^^ (. a b) 2).  It assumes
;;  that FIRST-FACTOR is not a dot product and that REMAINDER is.
;;  For the product (. a b c d e), three basic types of comparisons
;;  are done:
;;   
;;  1)  a <---> b		first-factor <---> inner-product
;;      a <---> (. b c)
;;      a <---> (. b c d)
;;      a <---> (. b c d e)	(this case handled in SIMPNCT)
;;   
;;  2) (. a b) <---> c		outer-product <---> (car rest)
;;     (. a b c) <---> d
;;     (. a b c d) <---> e
;;   
;;  3) (. a b) <---> (. c d)	outer-product <---> (firstn rest)
;;   
;;  Note that INNER-PRODUCT and OUTER-PRODUCT share list structure which
;;  is clobbered as new terms are added.

(defun simpnct-merge-product (first-factor remainder)
  (let ((half-product-length (ash (1+ (length remainder)) -1))
	(inner-product (car remainder))
	(outer-product (list '(mnctimes) first-factor (car remainder))))
    (do ((merge-length 2 (1+ merge-length))
	 (rest (cdr remainder) (cdr rest)))
	((null rest) outer-product)
      (cond ((simpnct-alike first-factor inner-product)
	     (return
	       (ncmuln
		(cons (simpnct-merge-factors first-factor inner-product)
		      rest)
		t)))
	    ((simpnct-alike outer-product (car rest))
	     (return
	       (ncmuln
		(cons (simpnct-merge-factors outer-product (car rest))
		      (cdr rest))
		t)))
	    ((and (not (> merge-length half-product-length))
		  (alike1 outer-product
			  (cons '(mnctimes)
				(subseq rest 0 merge-length))))
	     (return
	       (ncmuln (cons (ncpower outer-product 2)
			     (nthcdr merge-length rest))
		       t)))
	    ((= merge-length 2)
	     (setq inner-product
		   (cons '(mnctimes) (cddr outer-product)))))
      (rplacd (last inner-product) (ncons (car rest))))))

(defun simpnct-antisym-check (l check)
  (cond ((and (get 'mnctimes '$antisymmetric) (cddr l))
	 (multiple-value-bind (l antisym-sign) (bbsort1 l)
	   (cond ((equal l 0) 0)
		 ((prog1 (null antisym-sign)
		    (setq l (eqtest (cons '(mnctimes) l) check)))
		  l)
		 (t (neg l)))))
	(t (eqtest (cons '(mnctimes) l) check))))
