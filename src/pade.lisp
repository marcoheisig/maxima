;;; -*-  Mode: Lisp; Package: Maxima; Syntax: Common-Lisp; Base: 10 -*- ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;     The data in this file contains enhancements.                   ;;;;;
;;;                                                                    ;;;;;
;;;  Copyright (c) 1984,1987 by William Schelter,University of Texas   ;;;;;
;;;     All rights reserved                                            ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;     (c) Copyright 1980 Massachusetts Institute of Technology         ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(in-package :maxima)

(macsyma-module pade)

(declare-top (special tlist))

(load-macsyma-macros rzmac mhayat ratmac)

(defmacro red (p) `(cdr ,p))

(defmacro p0? (p) `(null ,p))

(defmacro e0? (expon) `(zerop (car ,expon)))

(defmacro epos? (expon) `(signp g (car ,expon)))

(defmacro eneg? (expon) `(signp l (car ,expon)))

(defmacro num (r) `(car ,r))

(defmacro denom (r) `(cdr ,r))

(defmacro eneg (exp) `(cons (- (car ,exp)) (cdr ,exp)))

(defmacro pade-lexp (poly) `(cond ((p0? ,poly) (ezero))
			     (t (le ,poly))))

(defun eshift (poly expon)
  (mapcar #'(lambda (tm) (term (e+ (e tm) expon)
			       (c tm)))
	  poly))

(defmacro psmake (p tpf)
  `(make-ps (gvar-o ,tpf) (poly-data ,tpf) (reverse ,p)))

(defmfun $pade (taylor-form n-bound d-bound)
  (cond ((not (and ($ratp taylor-form) (member 'trunc (car taylor-form) :test #'eq)))
	 (merror (intl:gettext "pade: first argument must be a Taylor series; found: ~M") taylor-form)))
  (destructuring-let (((nil nil varlist genvar tlist) (car taylor-form)))
    (if (psp (cdr taylor-form))		     
	(cons '(mlist)
	      (pade (cdr taylor-form)
		    (cons (car (tay-order n-bound))
			  (car (tay-order d-bound)))
		    (orig-trunc (car (mrat-tlist taylor-form)))))
      (list '(mlist) (srdis (cdr taylor-form))))))
	     
(defun pade (tpf bounds trunc)
  (let ((ord (le (terms tpf))) (poly (terms tpf)))
    (setq trunc (e+ trunc (egcd trunc (psexpon-gcd poly))))
    (unless (e0? ord)
      (setq poly (eshift poly (eneg ord)))
      (setq trunc (e- trunc ord))
      (cond ((epos? ord) (rplaca bounds
				 (e- (car bounds) ord)))
	    (t (rplacd bounds (e+ (cdr bounds) ord)))))
    (let ((r1 (cons (list (term trunc (rcone))) nil))
	  (r2 (pade-monize (reverse poly) (list (term (ezero) (rcone))))))
      (do ((ans (cond ((or (e> (le (last poly)) (num bounds))
			   (eneg? (denom bounds))) nil)
		      (t (list r2)))
		(cond ((or (e> (le (num r2)) (num bounds))
			   (e> (le (denom r2)) (denom bounds)))
		       ans)
		      ((epos? (le (last (num r2))))
		       ans)		;not a true approximate
		      (t (cons r2 ans)))))
	  ((or (e0? (pade-lexp (num r2)))
	       (e>= (pade-lexp (denom r2)) (denom bounds)))
	   (mapcar #'(lambda (r) ($ratsimp
				  (m// (srdis (psmake (eshift (num r) ord) tpf))
				       (srdis (psmake (denom r) tpf)))))
		   ans))
	(setq r1 (pade1 r1 r2))
	(rotatef r1 r2)))))

(defun pade1 (r1 r2)
  (do ((quoterm) (lcoef (lc (num r2))) (expon (le (num r2)))
       (p2 (red (num r2))) (q2 (denom r2)) (p1 (num r1)) (q1 (denom r1)))
      ((or (p0? p1) (e> expon (le p1)))
       (pade-monize p1 q1))
    (setq quoterm (term (e- (le p1) expon)
			(rcminus (rcquo (lc p1) lcoef))))
    (setq p1 (upoly+ (red p1)
		     (term* quoterm p2)))
    (setq q1 (upoly+ q1 (term* quoterm q2)))))

(defun term* (term p)
  (let ((p1 nil) (coef (c term)) (expon (e term)) coef1)
    (mapc #'(lambda (term1)
	      (setq coef1 (rctimes coef (c term1)))
	      (if (not (rczerop coef1))
		  (push (term (e+ expon (e term1))
			      coef1)
			p1)))
	  p)
    (nreverse p1)))

(defun pade-monize (num den)		;monicize numerator
  (let ((mult (term (ezero) (rcinv (lc num)))))
    (cons (term* mult num) (term* mult den))))
	     
(defun upoly+ (p1 p2)
  (do ((p) (c))
      (nil)
    (cond ((p0? p1) (return (nreconc p p2)))
	  ((p0? p2) (return (nreconc p p1)))
	  ((e> (le p2) (le p1)) (push (pop p2) p))
	  ((e> (le p1) (le p2)) (push (pop p1) p))
	  (t
	   (setq c (rcplus (lc p1) (lc p2)))
	   (if (not (rczerop c))
	       (push (term  (le p1) c) p))
	   (setq p1 (red p1) p2 (red p2))))))

#-nil
(declare-top(unspecial tlist))
