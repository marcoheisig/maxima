;;; Compiled by f2cl version:
;;; ("f2cl1.l,v 1.215 2009/04/07 22:05:21 rtoy Exp $"
;;;  "f2cl2.l,v 1.37 2008/02/22 22:19:33 rtoy Exp $"
;;;  "f2cl3.l,v 1.6 2008/02/22 22:19:33 rtoy Exp $"
;;;  "f2cl4.l,v 1.7 2008/02/22 22:19:34 rtoy Exp $"
;;;  "f2cl5.l,v 1.200 2009/01/19 02:38:17 rtoy Exp $"
;;;  "f2cl6.l,v 1.48 2008/08/24 00:56:27 rtoy Exp $"
;;;  "macros.l,v 1.112 2009/01/08 12:57:19 rtoy Exp $")

;;; Using Lisp CMU Common Lisp 19f (19F)
;;; 
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls nil)
;;;           (:coerce-assigns :as-needed) (:array-type ':array)
;;;           (:array-slicing t) (:declare-common nil)
;;;           (:float-format double-float))

(in-package :minpack)


(let ((factor 100.0) (one 1.0) (zero 0.0))
  (declare (type (double-float) factor one zero))
  (defun hybrj1 (fcn n x fvec fjac ldfjac tol info wa lwa)
    (declare (type (double-float) tol)
             (type (array double-float (*)) wa fjac fvec x)
             (type (f2cl-lib:integer4) lwa info ldfjac n))
    (f2cl-lib:with-multi-array-data
        ((x double-float x-%data% x-%offset%)
         (fvec double-float fvec-%data% fvec-%offset%)
         (fjac double-float fjac-%data% fjac-%offset%)
         (wa double-float wa-%data% wa-%offset%))
      (prog ((xtol 0.0) (j 0) (lr 0) (maxfev 0) (mode 0) (nfev 0) (njev 0)
             (nprint 0))
        (declare (type (f2cl-lib:integer4) nprint njev nfev mode maxfev lr j)
                 (type (double-float) xtol))
        '"     **********"
        '""
        '"     subroutine hybrj1"
        '""
        '"     the purpose of hybrj1 is to find a zero of a system of"
        '"     n nonlinear functions in n variables by a modification"
        '"     of the powell hybrid method. this is done by using the"
        '"     more general nonlinear equation solver hybrj. the user"
        '"     must provide a subroutine which calculates the functions"
        '"     and the jacobian."
        '""
        '"     the subroutine statement is"
        '""
        '"       subroutine hybrj1(fcn,n,x,fvec,fjac,ldfjac,tol,info,wa,lwa)"
        '""
        '"     where"
        '""
        '"       fcn is the name of the user-supplied subroutine which"
        '"         calculates the functions and the jacobian. fcn must"
        '"         be declared in an external statement in the user"
        '"         calling program, and should be written as follows."
        '""
        '"         subroutine fcn(n,x,fvec,fjac,ldfjac,iflag)"
        '"         integer n,ldfjac,iflag"
        '"         double precision x(n),fvec(n),fjac(ldfjac,n)"
        '"         ----------"
        '"         if iflag = 1 calculate the functions at x and"
        '"         return this vector in fvec. do not alter fjac."
        '"         if iflag = 2 calculate the jacobian at x and"
        '"         return this matrix in fjac. do not alter fvec."
        '"         ---------"
        '"         return"
        '"         end"
        '""
        '"         the value of iflag should not be changed by fcn unless"
        '"         the user wants to terminate execution of hybrj1."
        '"         in this case set iflag to a negative integer."
        '""
        '"       n is a positive integer input variable set to the number"
        '"         of functions and variables."
        '""
        '"       x is an array of length n. on input x must contain"
        '"         an initial estimate of the solution vector. on output x"
        '"         contains the final estimate of the solution vector."
        '""
        '"       fvec is an output array of length n which contains"
        '"         the functions evaluated at the output x."
        '""
        '"       fjac is an output n by n array which contains the"
        '"         orthogonal matrix q produced by the qr factorization"
        '"         of the final approximate jacobian."
        '""
        '"       ldfjac is a positive integer input variable not less than n"
        '"         which specifies the leading dimension of the array fjac."
        '""
        '"       tol is a nonnegative input variable. termination occurs"
        '"         when the algorithm estimates that the relative error"
        '"         between x and the solution is at most tol."
        '""
        '"       info is an integer output variable. if the user has"
        '"         terminated execution, info is set to the (negative)"
        '"         value of iflag. see description of fcn. otherwise,"
        '"         info is set as follows."
        '""
        '"         info = 0   improper input parameters."
        '""
        '"         info = 1   algorithm estimates that the relative error"
        '"                    between x and the solution is at most tol."
        '""
        '"         info = 2   number of calls to fcn with iflag = 1 has"
        '"                    reached 100*(n+1)."
        '""
        '"         info = 3   tol is too small. no further improvement in"
        '"                    the approximate solution x is possible."
        '""
        '"         info = 4   iteration is not making good progress."
        '""
        '"       wa is a work array of length lwa."
        '""
        '"       lwa is a positive integer input variable not less than"
        '"         (n*(n+13))/2."
        '""
        '"     subprograms called"
        '""
        '"       user-supplied ...... fcn"
        '""
        '"       minpack-supplied ... hybrj"
        '""
        '"     argonne national laboratory. minpack project. march 1980."
        '"     burton s. garbow, kenneth e. hillstrom, jorge j. more"
        '""
        '"     **********"
        (setf info 0)
        '""
        '"     check the input parameters for errors."
        '""
        (if
         (or (<= n 0)
             (< ldfjac n)
             (< tol zero)
             (< lwa (the f2cl-lib:integer4 (truncate (* n (+ n 13)) 2))))
         (go label20))
        '""
        '"     call hybrj."
        '""
        (setf maxfev (f2cl-lib:int-mul 100 (f2cl-lib:int-add n 1)))
        (setf xtol tol)
        (setf mode 2)
        (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                      ((> j n) nil)
          (tagbody
            (setf (f2cl-lib:fref wa-%data% (j) ((1 lwa)) wa-%offset%) one)
           label10))
        (setf nprint 0)
        (setf lr (the f2cl-lib:integer4 (truncate (* n (+ n 1)) 2)))
        (multiple-value-bind
              (var-0 var-1 var-2 var-3 var-4 var-5 var-6 var-7 var-8 var-9
               var-10 var-11 var-12 var-13 var-14 var-15 var-16 var-17 var-18
               var-19 var-20 var-21)
            (hybrj fcn n x fvec fjac ldfjac xtol maxfev
             (f2cl-lib:array-slice wa double-float (1) ((1 lwa))) mode factor
             nprint info nfev njev
             (f2cl-lib:array-slice wa
                                   double-float
                                   ((+ (f2cl-lib:int-mul 6 n) 1))
                                   ((1 lwa)))
             lr (f2cl-lib:array-slice wa double-float ((+ n 1)) ((1 lwa)))
             (f2cl-lib:array-slice wa
                                   double-float
                                   ((+ (f2cl-lib:int-mul 2 n) 1))
                                   ((1 lwa)))
             (f2cl-lib:array-slice wa
                                   double-float
                                   ((+ (f2cl-lib:int-mul 3 n) 1))
                                   ((1 lwa)))
             (f2cl-lib:array-slice wa
                                   double-float
                                   ((+ (f2cl-lib:int-mul 4 n) 1))
                                   ((1 lwa)))
             (f2cl-lib:array-slice wa
                                   double-float
                                   ((+ (f2cl-lib:int-mul 5 n) 1))
                                   ((1 lwa))))
          (declare (ignore var-0 var-2 var-3 var-4 var-6 var-7 var-8 var-9
                           var-10 var-11 var-15 var-16 var-17 var-18 var-19
                           var-20 var-21))
          (setf n var-1)
          (setf ldfjac var-5)
          (setf info var-12)
          (setf nfev var-13)
          (setf njev var-14))
        (if (= info 5) (setf info 4))
       label20
        (go end_label)
        '""
        '"     last card of subroutine hybrj1."
        '""
       end_label
        (return (values nil n nil nil nil ldfjac nil info nil nil))))))

(in-package #:cl-user)
#+#.(cl:if (cl:find-package '#:f2cl) '(and) '(or))
(eval-when (:load-toplevel :compile-toplevel :execute)
  (setf (gethash 'fortran-to-lisp::hybrj1
                 fortran-to-lisp::*f2cl-function-info*)
          (fortran-to-lisp::make-f2cl-finfo
           :arg-types '(t (fortran-to-lisp::integer4) (array double-float (*))
                        (array double-float (*)) (array double-float (*))
                        (fortran-to-lisp::integer4) (double-float)
                        (fortran-to-lisp::integer4) (array double-float (*))
                        (fortran-to-lisp::integer4))
           :return-values '(nil fortran-to-lisp::n nil nil nil
                            fortran-to-lisp::ldfjac nil fortran-to-lisp::info
                            nil nil)
           :calls '(fortran-to-lisp::hybrj))))

