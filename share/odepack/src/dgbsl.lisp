;;; Compiled by f2cl version:
;;; ("f2cl1.l,v 95098eb54f13 2013/04/01 00:45:16 toy $"
;;;  "f2cl2.l,v 95098eb54f13 2013/04/01 00:45:16 toy $"
;;;  "f2cl3.l,v 96616d88fb7e 2008/02/22 22:19:34 rtoy $"
;;;  "f2cl4.l,v 96616d88fb7e 2008/02/22 22:19:34 rtoy $"
;;;  "f2cl5.l,v 95098eb54f13 2013/04/01 00:45:16 toy $"
;;;  "f2cl6.l,v 1d5cbacbb977 2008/08/24 00:56:27 rtoy $"
;;;  "macros.l,v 1409c1352feb 2013/03/24 20:44:50 toy $")

;;; Using Lisp CMU Common Lisp snapshot-2017-01 (21B Unicode)
;;; 
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;           (:coerce-assigns :as-needed) (:array-type ':array)
;;;           (:array-slicing t) (:declare-common nil)
;;;           (:float-format double-float))

(in-package "ODEPACK")


(defun dgbsl (abd lda n ml mu ipvt b job)
  (declare (type (array f2cl-lib:integer4 (*)) ipvt)
           (type (f2cl-lib:integer4) job mu ml n lda)
           (type (array double-float (*)) b abd))
  (f2cl-lib:with-multi-array-data
      ((abd double-float abd-%data% abd-%offset%)
       (b double-float b-%data% b-%offset%)
       (ipvt f2cl-lib:integer4 ipvt-%data% ipvt-%offset%))
    (prog ((k 0) (kb 0) (l 0) (la 0) (lb 0) (lm 0) (m 0) (nm1 0) (t$ 0.0))
      (declare (type (double-float) t$)
               (type (f2cl-lib:integer4) nm1 m lm lb la l kb k))
      (setf m (f2cl-lib:int-add mu ml 1))
      (setf nm1 (f2cl-lib:int-sub n 1))
      (if (/= job 0) (go label50))
      (if (= ml 0) (go label30))
      (if (< nm1 1) (go label30))
      (f2cl-lib:fdo (k 1 (f2cl-lib:int-add k 1))
                    ((> k nm1) nil)
        (tagbody
          (setf lm
                  (min (the f2cl-lib:integer4 ml)
                       (the f2cl-lib:integer4 (f2cl-lib:int-sub n k))))
          (setf l (f2cl-lib:fref ipvt-%data% (k) ((1 *)) ipvt-%offset%))
          (setf t$ (f2cl-lib:fref b-%data% (l) ((1 *)) b-%offset%))
          (if (= l k) (go label10))
          (setf (f2cl-lib:fref b-%data% (l) ((1 *)) b-%offset%)
                  (f2cl-lib:fref b-%data% (k) ((1 *)) b-%offset%))
          (setf (f2cl-lib:fref b-%data% (k) ((1 *)) b-%offset%) t$)
         label10
          (daxpy lm t$
           (f2cl-lib:array-slice abd-%data%
                                 double-float
                                 ((+ m 1) k)
                                 ((1 lda) (1 *))
                                 abd-%offset%)
           1
           (f2cl-lib:array-slice b-%data%
                                 double-float
                                 ((+ k 1))
                                 ((1 *))
                                 b-%offset%)
           1)
         label20))
     label30
      (f2cl-lib:fdo (kb 1 (f2cl-lib:int-add kb 1))
                    ((> kb n) nil)
        (tagbody
          (setf k (f2cl-lib:int-sub (f2cl-lib:int-add n 1) kb))
          (setf (f2cl-lib:fref b-%data% (k) ((1 *)) b-%offset%)
                  (/ (f2cl-lib:fref b-%data% (k) ((1 *)) b-%offset%)
                     (f2cl-lib:fref abd-%data%
                                    (m k)
                                    ((1 lda) (1 *))
                                    abd-%offset%)))
          (setf lm
                  (f2cl-lib:int-sub
                   (min (the f2cl-lib:integer4 k) (the f2cl-lib:integer4 m))
                   1))
          (setf la (f2cl-lib:int-sub m lm))
          (setf lb (f2cl-lib:int-sub k lm))
          (setf t$ (- (f2cl-lib:fref b-%data% (k) ((1 *)) b-%offset%)))
          (daxpy lm t$
           (f2cl-lib:array-slice abd-%data%
                                 double-float
                                 (la k)
                                 ((1 lda) (1 *))
                                 abd-%offset%)
           1
           (f2cl-lib:array-slice b-%data% double-float (lb) ((1 *)) b-%offset%)
           1)
         label40))
      (go label100)
     label50
      (f2cl-lib:fdo (k 1 (f2cl-lib:int-add k 1))
                    ((> k n) nil)
        (tagbody
          (setf lm
                  (f2cl-lib:int-sub
                   (min (the f2cl-lib:integer4 k) (the f2cl-lib:integer4 m))
                   1))
          (setf la (f2cl-lib:int-sub m lm))
          (setf lb (f2cl-lib:int-sub k lm))
          (setf t$
                  (ddot lm
                   (f2cl-lib:array-slice abd-%data%
                                         double-float
                                         (la k)
                                         ((1 lda) (1 *))
                                         abd-%offset%)
                   1
                   (f2cl-lib:array-slice b-%data%
                                         double-float
                                         (lb)
                                         ((1 *))
                                         b-%offset%)
                   1))
          (setf (f2cl-lib:fref b-%data% (k) ((1 *)) b-%offset%)
                  (/ (- (f2cl-lib:fref b-%data% (k) ((1 *)) b-%offset%) t$)
                     (f2cl-lib:fref abd-%data%
                                    (m k)
                                    ((1 lda) (1 *))
                                    abd-%offset%)))
         label60))
      (if (= ml 0) (go label90))
      (if (< nm1 1) (go label90))
      (f2cl-lib:fdo (kb 1 (f2cl-lib:int-add kb 1))
                    ((> kb nm1) nil)
        (tagbody
          (setf k (f2cl-lib:int-sub n kb))
          (setf lm
                  (min (the f2cl-lib:integer4 ml)
                       (the f2cl-lib:integer4 (f2cl-lib:int-sub n k))))
          (setf (f2cl-lib:fref b-%data% (k) ((1 *)) b-%offset%)
                  (+ (f2cl-lib:fref b-%data% (k) ((1 *)) b-%offset%)
                     (ddot lm
                      (f2cl-lib:array-slice abd-%data%
                                            double-float
                                            ((+ m 1) k)
                                            ((1 lda) (1 *))
                                            abd-%offset%)
                      1
                      (f2cl-lib:array-slice b-%data%
                                            double-float
                                            ((+ k 1))
                                            ((1 *))
                                            b-%offset%)
                      1)))
          (setf l (f2cl-lib:fref ipvt-%data% (k) ((1 *)) ipvt-%offset%))
          (if (= l k) (go label70))
          (setf t$ (f2cl-lib:fref b-%data% (l) ((1 *)) b-%offset%))
          (setf (f2cl-lib:fref b-%data% (l) ((1 *)) b-%offset%)
                  (f2cl-lib:fref b-%data% (k) ((1 *)) b-%offset%))
          (setf (f2cl-lib:fref b-%data% (k) ((1 *)) b-%offset%) t$)
         label70
         label80))
     label90
     label100
      (go end_label)
     end_label
      (return (values nil nil nil nil nil nil nil nil)))))

(in-package #:cl-user)
#+#.(cl:if (cl:find-package '#:f2cl) '(and) '(or))
(eval-when (:load-toplevel :compile-toplevel :execute)
  (setf (gethash 'fortran-to-lisp::dgbsl fortran-to-lisp::*f2cl-function-info*)
          (fortran-to-lisp::make-f2cl-finfo
           :arg-types '((array double-float (*)) (fortran-to-lisp::integer4)
                        (fortran-to-lisp::integer4) (fortran-to-lisp::integer4)
                        (fortran-to-lisp::integer4)
                        (array fortran-to-lisp::integer4 (*))
                        (array double-float (*)) (fortran-to-lisp::integer4))
           :return-values '(nil nil nil nil nil nil nil nil)
           :calls '(fortran-to-lisp::ddot fortran-to-lisp::daxpy))))

