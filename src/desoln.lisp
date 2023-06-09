;;; -*-  Mode: Lisp; Package: Maxima; Syntax: Common-Lisp; Base: 10 -*- ;;;;

(in-package :maxima)

(defmfun $desolve (eqns vars)
  (let (teqns tvars ovar (lvar ($gensym)) (flag nil) ($dispflag nil))
    (if ($mapatom vars)
	(merror (intl:gettext "desolve(<eqn>,<depvar>): dependent variable <depvar> cannot be a mapatom, found: ~M") vars))
    (unless ($listp vars)
      (setq eqns (list '(mlist) eqns))
      (setq vars (list '(mlist) vars))
      (setq flag t))
    (setq ovar (maref vars 1))
    (unless (= ($length ovar) 1)
      (merror (intl:gettext "desolve: more than one independent variable: ~M") ovar))
    (setq ovar (simplify ($inpart ovar 1)))
    (setq teqns
     (simplify (map1 (lambda (z) (simplify ($laplace z ovar lvar))) eqns)))
    (setq tvars
     (simplify (map1 (lambda (z) (simplify `((%laplace) ,z ,ovar ,lvar))) vars)))
    (setq teqns
	  (let ((errcatch (cons bindlist loclist))
		(ret (errset (simplify ($solve teqns tvars)))))
	    (when (null ret)
	      (errlfun1 errcatch))
	    (cons '(mlist) ret)))
    (when (or (like teqns '((mlist)))
	      (like teqns (list '(mlist) '((mlist)))))
      ;; NOT CLEAR WHAT IS THE PROBLEM. SHOULD BE MORE EXPLICIT.
      (merror (intl:gettext "desolve: can't handle this case.")))
    (setq teqns (simplify ($first teqns)))
    (unless (like flag t)
      (setq teqns (simplify ($first teqns))))
    (setq teqns
     (simplify (map1 (lambda (z) (simplify ($ilt z lvar ovar))) teqns)))
    (if (and flag (= ($length tvars) 1))
	(maref teqns 1)
	teqns)))
