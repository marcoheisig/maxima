
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

(macsyma-module nalgfa)

(declare-top (special vlist *nosplitf *algvar *denom *num *ans))

(load-macsyma-macros rzmac ratmac)

(defun new-alg ()
  (newsym ($gensym "alg")))


(defun psqfrp (p var)
  (zerop (pdegree (pgcd p (pderivative p var)) var)))

(defun pgsubst (val var p) ;;generalized psubst substitutes any
  (cond ((pcoefp p) p) ;;expression for any var in p
	((eq var (car p))
	 (cond ((pzerop val)
		(ptterm (cdr p) 0))
	       ((do ((ld (cadr p) (car a))
		     (a (cdddr p) (cddr a))
		     (ans (caddr p)
			  (pplus
			   (ptimes ans (pexpt val (- ld (car a))))
			   (cadr a))))
		    ((null a) (ptimes ans (pexpt val ld)))))))
	((pointergp var (car p)) p)
	((do ((a (cdddr p) (cddr a))
	      (ans (ptimes (list (car p) (cadr p) 1)
			   (pgsubst val var (caddr p)))
		   (pplus ans
			  (ptimes (list (car p) (car a) 1)
				  (pgsubst val var (cadr a))))))
	     ((null a) ans)))))

(defun pvsubst (nvar ovar p)
  (cond ((or (pcoefp p) (pointergp ovar (car p))) p)
	((eq ovar (car p))
	 (cons nvar (cdr p)))
	(t (pgsubst (make-poly nvar) ovar p))))

(defun ordervar (var l)
  (let ((mvar (lmainvar l)))
    (cond ((null mvar) l)
	  ((null (pointergp mvar var)) (cons var l))
	  ((let ((newvar (gensym)))
	     (setq genvar (append genvar (list newvar)))
	     (setf (symbol-plist newvar) (symbol-plist var))
	     (setf (symbol-value newvar) (1+ (symbol-value mvar)))
	     (cons newvar (mapcar #'(lambda (p) (pvsubst newvar var p)) l)))))))

(defun lmainvar (l) ;;main var of list of poly's
  (do ((l l (cdr l))
       (v))
      ((null l) v)
    (cond ((pcoefp (car l)))
	  ((null v) (setq v (caar l)))
	  ((pointergp (caar l) v)
	   (setq v (caar l))))))

(defun presult (p1 p2 var) ;;change call in algsys?
  (let ((genvar genvar))
    (setq var (ordervar var (list p1 p2))
	  p1 (cadr var)
	  p2 (caddr var)
	  var (car var))
    (cond ((zerop (pdegree p1 var))
	   (cond ((zerop (pdegree p2 var)) 1)
		 ((pexpt p1 (cadr p2)))))
	  ((zerop (pdegree p2 var))
	   (pexpt p2 (cadr p1)))
	  ((resultant p1 p2)))))

(defun pcoefvec (p)
  (cond ((pcoefp p) (list p))
	((do ((l)
	      (i (cadr p) (1- i))
	      (p (cdr p)))
	     ((signp l i) (nreverse l))
	   (push (cond ((and p (= (car p) i))
			(prog1 (cadr p) (setq p (cddr p))))
		       ( 0 ))
		 l)))))

(defun algtrace1 (bvec tvec)
  (do ((i (- (length tvec) (length bvec)) (1- i)))
      ((zerop i) (algtrace* bvec tvec))
    (setq bvec (cons 0 bvec))))

(defun algtrace* (bvec tvec)
  (do ((b bvec (cdr b))
       (tr (car (last bvec))
	   (pplus tr (car (last b)))))
      ((null (cdr b)) tr)
    (or (pzerop (car b))
	(do ((l (cdr b) (cdr l))
	     (tv tvec (cdr tv)))
	    ((null l))
	  (rplaca l (pdifference (car l) (ptimes (car b) (car tv))))))))

(defun algtrace (f p)
  (let* ((r (cadr (pdivide (car f) p))))
    (if (or (constantp (car r))                  ; r constant 
	    (not (eq (caar r) (car p))))          ; r constant in main var of p
	(ratreduce (pctimes (cadr p) (car r)) (cdr r)) ; r*deg(p)
	(ratreduce (algtrace1 (pcoefvec (car r)) (cdr (pcoefvec p)))
		    (cdr r)))))


(defmfun $algtrace (f p var)
  (let ((varlist (list var))
	(genvar nil))
    (rdis* (algtrace (rform f) (car (rform p))))))


(defun good-form (l) ;;bad -> good
  (do ((l l (cddr l))
       (ans))
      ((null l) (nreverse ans))
    (push (cons (cadr l) (car l)) ans)))

(defun bad-form (l) ;;good -> bad
  (mapcar #'(lambda (q) (list (cdr q) (car q))) l))

(defmfun $algfac (a1 &optional (a2 nil a2?) (a3 nil a3?))
  (if a3?
      ($pfactoralg a1 a2 a3)
      (let ((varlist))
	(cond (a2?
	       (newvar a2)
	       (if (alike1 a2 (car varlist))
		   ($pfactoralg a1 nil a2)
		   ($pfactoralg a1 a2 (car (last varlist)))))
	      (t
	       (newvar a1)
		 (setq varlist (mapcan #'(lambda (q) (if (algpget q) (list q) nil)) varlist))
		 (cond ((= (length varlist) 1)
			($pfactoralg a1 nil (car varlist)))
		       ((> (length varlist) 1)
                        ;; MEANING OF NEXT MESSAGE IS UNCLEAR
			(merror (intl:gettext "algfac: too many algebraics.")))
		       (t
                        ;; MEANING OF NEXT MESSAGE IS UNCLEAR
			(merror (intl:gettext "algfac: no algebraics.")))))))))

(defmfun $pfactoralg (f p alg)
  (let ((varlist (list alg))
	(genvar) (vlist) (tellratlist) ($ratfac)
	($gcd '$algebraic)
	($algebraic) ($ratalgdenom t)
	(*denom 1) (*num 1) (*ans))
    (cond ((and (null p) (radfunp alg t)) (newvar (cadr alg)))
	  (t (newvar p)))
    (newvar1 f)
    (cond ((null vlist) (merror (intl:gettext "pfactoralg: attempt to factor a constant."))))
    (setq varlist (nconc varlist (sortgreat vlist)))
    (cond (p (setq p (cadr (ratrep* p)))
	     (push (cons alg (mapcar #'pdis (cdr p)))
		   tellratlist))
	  (t (setq p (algpget alg))
	     (setq p (pdifference
		      (pexpt (cadr (ratrep* alg)) (car p))
		      (cadr p)))))
    (setq $algebraic t)
    (setq f (cadr (ratrep* f)))
    (setq f (pfactoralg1 f p 0))
    (cons '(mtimes)
	  (cons (rdis (ratreduce *num *denom))
		(mapcar 'pdis f)))))

(defun nalgfac (p mp)
  (let ((*num 1) (*denom 1) (*ans) (algfac*) ($nalgfac)
	($algebraic t) ($gcd '$algebraic))
    (setq p (pfactoralg1 p mp 0))
    (setq adn* (* adn* *denom))
    (cond ((equal *num 1) p)
	  (t (cons *num p)))))

(setq *nosplitf t)

(defun pfactoralg1 (f p ind)
  (cond ((pcoefp f) (setq *num (ptimeschk f *num)) *ans)
	((= (cadr f) 1) (setq f (pshift f (car p) ind))
	 (push (algnormal f) *ans)
	 (setq f (rquotient f (car *ans))
	       *denom (ptimeschk (cdr f) *denom)
	       *num (ptimeschk (car f) *num))
	 *ans)
	((equal (cdr f) (cdr p))
	 (push (pdifference (make-poly (car f)) (make-poly (car p))) *ans)
	 (setq f (rquotient f (car *ans))
	       *denom (ptimeschk (cdr f) *denom))
	 (pfactoralg1 (car f) p ind))
	((zerop (pdegree f (car p)))
	 (mapc #'(lambda (q) 
		   (if (pcoefp q) nil
		     (pfactoralg1 (pshift q (car p) -1) p (1+ ind))))
	       (let (($algebraic nil)
		     ($gcd (car *gcdl*)))
		 (pfactor1 f)))
	 *ans)
	(t (do ((l (let (($algebraic nil)
			 ($gcd (car *gcdl*)))
		     (pfactor (algnorm f p)))
		   (cddr l))
		(polys)
		(temp)
		(alg (car p)))
	       ((null l)
		(setq *num (ptimeschk f *num))
		(mapc #'(lambda (q) (pfactoralg1
				     (pshift q alg -1) p (1+ ind)))
		      polys)
		*ans)
	       (cond ((pcoefp (car l)) nil)
		     (t (setq temp (cond ((null (cddr l)) f)
					 (t (pgcd f (car l)))))
			(cond ((pcoefp temp) nil)
			      ((= (cadr temp) 1)
			       (setq temp (algnormal temp))
			       (push (pshift temp alg ind) *ans))
			      ((= (cadr l) 1)
			       (setq temp (algnormal temp))
			       (push (pshift temp alg ind) *ans)
			       (or *nosplitf
				   (setq *nosplitf
					 (list (car l) temp ind))))
			      (t (push temp polys)))
			(setq f (rquotient f temp)
			      *denom (ptimeschk (cdr f) *denom)
			      f (car f)))) ))))

(defun pshift (f alg c)
  (if (= c 0) f
      (pgsubst (pplus (make-poly (car f)) (pctimes c (make-poly alg)))
	       (car f) f)))



(defmfun $splitfield (p var)
  (let ((varlist)
	(genvar)
	(genpairs)
	(*algvar)
	($gcd '$algebraic))
    (newsym var)
    (setq *algvar (caar (new-alg)))
    (setq p (psplit-field (cadr (ratf p))))
    (cons
     '(mlist)
     (cons (pdis* (car p))
	   (mapcar 'rdis* (cdr p))))))

(defun psplit-field (p)			;modresult?
  (let ((l (mapcar #'(lambda (q) (psplit-field1 (cdr q)))
		   (good-form (pfactor p)))) ;don't normalize lcfs?
	($algebraic t))
    (if (null (cdr l)) (car l)
	(do ((l l (cdr l))
	     (prim) (zeroes) (temp))
	    ((null l) (cons (or prim '|$splits in q|) zeroes))
	  (cond ((eq (caar l) 'linear)
		 (setq zeroes (cons (cdar l) zeroes)))
		((null prim)
		 (setq prim (caar l)
		       zeroes (nconc (cdar l) zeroes)))
		((setq temp
		       (primelmt (cons (car p) (cdr prim))
				 (cons (car p) (cdaar l))
				 *algvar)
		       zeroes
		       (nconc
			(mapcar
			 #'(lambda (q)
			     (ratgsubst (cadddr temp) (caaar l) q))
			 (cdar l))
			(mapcar
			 #'(lambda (q)
			     (ratgsubst (caddr temp) (car prim) q))
			 zeroes))
		       prim (car temp))))))))

(defun plsolve (p)
  (ratreduce (ptterm (cdr p) 0)
	     (pminus (ptterm (cdr p) 1))))


(defun psplit-field1 (p)
  ;;returns minimal poly and list of roots
  ;;p must be square free
  (*bind* ((minpoly (cons *algvar (cdr p)))
	   (zeroes) ($algebraic t)
	   ($ratalgdenom t))
	  (if (equal (cadr p) 1) (return (cons 'linear (plsolve p))))
	  (do ((polys (list p) )
	       (nminpoly)
	       (*nosplitf nil nil)
	       (alpha (cons (make-poly (car minpoly)) 1)))
	      ((null polys)
	       (cons minpoly zeroes))
	    (push alpha zeroes)
	    (putprop (car minpoly) (cdr minpoly) 'tellrat)
	    (rplaca polys
		    (car
		     (rquotient (pctimes (cdr alpha) (car polys))
				(pdifference
				 (pctimes (cdr alpha) (pget (caar polys)))
				 (car alpha)))))
	    (setq polys
		  (mapcan
		   #'(lambda (q)
		       (cond ((equal (cadr q) 1) ;;linear factor
			      (push (plsolve q) zeroes)
			      nil) ;;flush linear factor
			     ((list q))))
		   (mapcan #'(lambda (q)
			       (let ((*ans) (*num 1) (*denom 1))
				 (nreverse (pfactoralg1 q minpoly 0))))
			   polys)))
	    (when *nosplitf
	      (setq nminpoly (car *nosplitf)
		    *nosplitf (cdr *nosplitf))
	      (putprop *algvar (cdr nminpoly) 'tellrat)
	      (let ((beta
		     (plsolve (pgcd (cons (caar *nosplitf) (cdr minpoly))
				    (exchangevar (car *nosplitf) *algvar)))))
		(setq alpha (ratplus (cons (make-poly *algvar) 1)
				     (rattimes (cons (- (cadr *nosplitf)) 1)
					       beta t)))
		(setq zeroes
		      (mapcar
		       #'(lambda (q) (ratgsubst beta (car minpoly) q))
		       zeroes))
		(setq polys
		      (mapcar
		       #'(lambda (q) (car (rgsubst beta (car minpoly) q)))
		       polys))
		(setq minpoly
		      (cons *algvar (cdr nminpoly))))))))

(defun exchangevar (poly var)
  (let ((newvar (gensym))
	(ovar (car poly)))
    (setf (symbol-value newvar) (1+ (eval ovar)))
    (pvsubst ovar newvar
	     (pvsubst var ovar
		      (pvsubst newvar var poly)))))

(defun rgsubst (val var p) ;;generalized psubst substitutes any
  (cond ((pcoefp p)
	 (cons p 1)) ;;expression for any var in p
	((eq var (car p))
	 (cond ((pzerop val)
		(cons (ptterm (cdr p) 0) 1))
	       ((do ((ld (cadr p) (car a))
		     (a (cdddr p) (cddr a))
		     (ans (cons (caddr p) 1)
			  (ratplus
			   (rattimes ans
				     (ratexpt val
					      (- ld (car a)))
				     t)
			   (cons (cadr a) 1))))
		    ((null a) (rattimes ans (ratexpt val ld) t))))))
	((pointergp var (car p)) (cons p 1))
	(t (let ((newsym (gensym)))
	     (setf (symbol-value newsym) (1+ (symbol-value (car p))))
	     (rgsubst val newsym (pvsubst newsym var p))))))

(defun ratgsubst (val var rat)
  (ratquotient (rgsubst val var (car rat))
	       (rgsubst val var (cdr rat))))

(defun algnorm (f p)
  (presult f p (car p)))

(defmfun $algnorm (r p var)
  (let ((varlist (list var))
	(genvar))
    (setq r (ratf r)
	  p (cadr (ratf p)))
    (rdis* (cons (algnorm (cadr r) p)
		 (algnorm (cddr r) p)))))

(defun sqfrnorm (f p fvar) ;;f must be sqfr, p is minpoly, fvar # pvar
  (*bind* ((pvar (car p)))
	  (setq f (cdr (ordervar pvar (list f p))) ;;new main var will be car of p
		p (cadr f) f (car f))  ;make mainvar of f = mainvar(p)
	  (do ((i 0 (1+ i))
	       (dif (pdifference (make-poly fvar) (make-poly (car p))))
	       (f f (pgsubst dif fvar f))
	       (res))
	      ((and (eq (car f) (car p))
		    (setq res (primpart (algnorm f p)))
		    (psqfrp res fvar))
	       (list res
		     (*bind* (($algebraic t))		;;;modified f
			     (putprop pvar (cdr p) 'tellrat)
			     (pvsubst pvar (car p) f))
		     (car p)
		     p
		     i)))))

(defun primelmt (a b gvar &aux ($algebraic nil))
  ;;a is a poly with coeff's in k(b)
  ;;gvar is new variable
  (let ((norm (sqfrnorm (cons gvar (cdr a)) b gvar))
	(alpha) (beta) ($ratalgdenom t))
    (rplaca norm (primpart (car norm)))
    (putprop gvar (cdar norm) 'tellrat)
    (setq $algebraic t
	  beta (subresgcd (cadddr norm)
		     (pvsubst (caddr norm)
			      (car b)
			      (cadr norm))))
    (setq beta (plsolve beta)
	  alpha (ratplus (cons (make-poly gvar) 1)
			 (rattimes (cons (- (cadddr (cdr norm))) 1)
				   beta t)))
    (list (car norm) ;;minimal poly
	  (pplus (make-poly (car a)) ;;new prim elm in old guys
		 (list (car b) 1  (car (last norm))))
	  alpha beta)))	;;in terms of gamma

(defun $primelmt (f_b p_a c)
  ;;p_a(a) is an irreducible polynomial in K defining an extension
  ;;K[a] of degree n_a. Then f_b(b) is a polynomial in K[a] of degree
  ;;n_f , which defines a new extension K[a,b]. The output is a
  ;;polynomial of degree n_a*n_b, and the expression of its variable
  ;;in terms of a root a of p_a and a root b of f_b.
  ;;One assumes that p_a only depends on one variable a and f_b of two
  ;;different variables b and a. So this works only for algebraic
  ;;numbers, not algebraic curves.



  (let* ((vla (newvar p_a))  ; ensure varlist = ($a $b)
	 (vlf (newvar f_b))
	 (varlist (cons (car vla) (remove (car vla) vlf)))
	 (genvar)  ; start with a clean space of vars
	 (genpairs)
	 (p (cadr (ratf p_a)))          ;p_a in rat form
	 (f (cadr (ratf f_b)))          ;f_b in rat form mainvar b
	 (algvar (caar (newsym c)))  ;new primitive element
	 (prim  (primelmt f p algvar)))
    (list '(mlist) (pdis (car prim)) (pdis (cadr prim)))))
	  ;(rdis (caddr prim)) (rdis (cadddr prim))))) ;debug alpha beta



;; discriminant of a basis

(defmfun $bdiscr (&rest args)
  (let ((varlist) (genvar))
    (xcons (bdiscr (mapcar #'rform (butlast args))
		   (car (rform (car (last args)))))
	   (list 'mrat 'simp varlist genvar))))

(defun bdiscr (l minp)
  (det (mapcar #'(lambda (q1)
		   (mapcar #'(lambda (q2)
			       (algtrace (cons (ptimes (car q1) 
						 (car q2)) 1)
					 minp)) l)) l)))
