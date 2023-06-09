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

(macsyma-module homog)

(load-macsyma-macros ratmac)

(declare-top (special *hvar *hmat))

(defun addvardeg (n l lt)
  (mapc #'(lambda (x) (push (cons n x) lt)) l) lt)

(defun ptermvec (p)
  (ltermvec p (sort (listovars p) #'pointergp) nil))

(defun nzeros (n l)
  (dotimes (i n l)
    (push 0 l)))

(defun ltermvec (p vl coef?)
  (cond ((null vl) (list (if coef? p nil)))
	((pcoefp p) (list (nzeros (length vl) (if coef? p nil))))
	((pointergp (car vl) (car p))
	 (addvardeg 0 (ltermvec p (cdr vl) coef?) nil))
	(t (do ((p (cdr p) (cddr p))
		(lt nil (addvardeg (car p) (ltermvec (cadr p) (cdr vl)
						     coef?)
				   lt)))
	       ((null p) lt)))))

;car(lv) = list of dependent equations
;caddr (lv) = correspondence between new columns and old ones.

(defun hlinsolve (mat)
  (let ((n (1- (length mat))) (m (length (car mat))) arr ndepvar
	(mat (mapcar #'(lambda (x) (mapcar #'- (car mat) x)) (cdr mat))))
    (setq arr (make-array (list (1+ (max m n)) (+ 2 m))))
    (do ((ml mat (cdr ml))		;solving for m vars
	 (i 1 (1+ i)))
	((null ml))
      (do ((l (car ml) (cdr l))
	   (j 1 (1+ j)))
	  ((null l) (setf (aref arr i j) 0))
	(setf (aref arr i j) (car l))))
    (setq mat (tfgeli1 arr n (1+ m)))
    (and (cadr mat) (merror "HLINSOLVE: inconsistent equations.")) ;shouldn't happen
					; # indep equations = n - (car mat)
					; # dependent vars = # indep equations
					; # indep vars = m - # dependent vars
    (setq ndepvar (- n (length (car mat))))
    (do ((i (1+ n) (1+ i))) ((> i m))
      (do ((j (1+ ndepvar) (1+ j))) ((> j m))
	(setf (aref arr i j) 0)))
    (do ((i (1+ ndepvar) (1+ i))
	 (det (abs (aref arr 1 1))))
	((> i m))
      (setf (aref arr i i) det))
    (cond ((signp g (aref arr 1 1))
	   (do ((i 1 (1+ i))) ((> i ndepvar))
	     (do ((j (1+ ndepvar) (1+ j))) ((> j m))
	       (setf (aref arr i j) (- (aref arr i j)))))))
    (do ((l (caddr mat) (cdr l))	;invert var permutation
	 (i 1 (1+ i)))
	((null l))
      (setf (aref arr 0 (car l)) i))
    (do ((varord (caddr mat) (cdr varord))
	 (i 1 (1+ i)))
	((> i ndepvar)
	 (do ((varord varord (cdr varord))
	      (i i (1+ i)))
	     ((> i m)
	      (do ((ans)
		   (i m (1- i)))
		  ((< i 1) ans)
		(push (aref arr i 0) ans)))
	   (do ((vecl)
		(j m (1- j)))
	       ((< j 1)
		(setf (aref arr (car varord) 0) vecl))
	     (push (aref arr (aref arr 0 j) i) vecl))))
      (do ((gcd 0)
	   (j i (1+ j)))
	  ((or (= gcd 1) (> j m))
	   (setf (aref arr (car varord) 0)
		 (abs (truncate (aref arr i i) gcd))))
	(setq gcd (gcd gcd (aref arr i j)))))))
; returns (mixed list of <reduced exp> and <basis vector for null space>)
; <reduced expon> corresponds to dependent var
; <basis vector> corresponds to independent var

(defun hreduce (p &optional (vl (setq *hvar (sort (listovars p) 'pointergp)))
		      (hl (setq *hmat (hlinsolve (ltermvec p *hvar nil)))))
       (cond ((pcoefp p) p)
	     ((pointergp (car vl) (car p))
	      (hreduce p (cdr vl) (cdr hl)))
	     ((numberp (car hl))
	      (cons (car p)
		    (do ((p (cdr p) (cddr p))
			 (red (car hl))
			 (ans))
			((null p) (nreverse ans))
			(push (truncate (car p) red) ans)
			(push (hreduce (cadr p) (cdr vl) (cdr hl)) ans))))
	     (t (do ((p (cdddr p) (cddr p))
		     (sum (hreduce (caddr p) (cdr vl) (cdr hl))
			  (pplus sum (hreduce (cadr p) (cdr vl) (cdr hl)))))
		    ((null p) sum)))))

(defun hexpand (p &optional (hl *hmat) (vl *hvar))
  (if (every #'onep hl)
      p
      (progn
	(do ((hl hl (cdr hl))
	     (i 1 (1+ i))
	     (pl (ltermvec p vl t)))
	    ((null hl) (setq p pl))
	  (if (and (numberp (car hl)) (not (onep (car hl))))
	      (do ((pl pl (cdr pl))) ((null pl))
		(do ((term (car pl) (cdr term))
		     (j (1- i) (1- j)))
		    ((= j 0) (rplaca term (* (car term) (car hl))))))))
	(do ((hl hl (cdr hl))
	     (i 1 (1+ i))
	     (wtlist)
	     (newwt))
	    ((null hl) (hsimp p vl))
	  (unless (numberp (car hl))
	    (setq wtlist (mapcar #'(lambda (x) (hdot (car hl) x)) p))
	    (setq newwt (nth (1- i) (car hl)))
	    (do ((maxwt (apply #'max wtlist))
		 (pl p (cdr pl))
		 (wtlist wtlist (cdr wtlist)))
		((null pl))
	      (do ((term (car pl) (cdr term))
		   (j (1- i) (1- j)))
		  ((= j 0) (rplaca term (truncate (- maxwt (car wtlist)) newwt))))))))))

(defun hdot (ht pt)
       (do ((ht (cdr ht) (cdr ht))
	    (pt (cdr pt) (cdr pt))
	    (sum (* (car ht) (car pt)) (+ sum (* (car ht) (car pt)))))
	   ((null ht) sum)))

(defun hsimp (pl vl)
       (do ((pl (cdr pl) (cdr pl))
	    (p (hsimp1 (car pl) vl) (pplus p (hsimp1 (car pl) vl))))
	   ((null pl) p)))

(defun hsimp1 (tl vl)
       (cond ((null vl) tl)
	     ((> (car tl) 0)
	      (list (car vl) (car tl) (hsimp1 (cdr tl) (cdr vl))))
	     (t (hsimp1 (cdr tl) (cdr vl)))))
