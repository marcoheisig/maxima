;;; Compiled by f2cl version:
;;; ("f2cl1.l,v 1.212 2009/01/08 18:58:49 rtoy Exp $"
;;;  "f2cl2.l,v 1.37 2008/02/22 22:19:33 rtoy Exp $"
;;;  "f2cl3.l,v 1.6 2008/02/22 22:19:33 rtoy Exp $"
;;;  "f2cl4.l,v 1.7 2008/02/22 22:19:34 rtoy Exp $"
;;;  "f2cl5.l,v 1.199 2009/01/07 19:16:59 rtoy Exp $"
;;;  "f2cl6.l,v 1.48 2008/08/24 00:56:27 rtoy Exp $"
;;;  "macros.l,v 1.112 2009/01/08 12:57:19 rtoy Exp $")

;;; Using Lisp CMU Common Lisp Snapshot 2008-12 (19E)
;;; 
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;           (:coerce-assigns :as-needed) (:array-type ':array)
;;;           (:array-slicing t) (:declare-common nil)
;;;           (:float-format single-float))

(in-package :common-lisp-user)


(defun daxpy (n da dx incx dy incy)
  (declare (type (array double-float (*)) dy dx)
           (type (double-float) da)
           (type (f2cl-lib:integer4) incy incx n))
  (f2cl-lib:with-multi-array-data
      ((dx double-float dx-%data% dx-%offset%)
       (dy double-float dy-%data% dy-%offset%))
    (prog ((i 0) (ix 0) (iy 0) (m 0) (mp1 0))
      (declare (type (f2cl-lib:integer4) mp1 m iy ix i))
      (if (<= n 0) (go end_label))
      (if (= da 0.0d0) (go end_label))
      (if (and (= incx 1) (= incy 1)) (go label20))
      (setf ix 1)
      (setf iy 1)
      (if (< incx 0)
          (setf ix
                  (f2cl-lib:int-add
                   (f2cl-lib:int-mul (f2cl-lib:int-sub 1 n) incx)
                   1)))
      (if (< incy 0)
          (setf iy
                  (f2cl-lib:int-add
                   (f2cl-lib:int-mul (f2cl-lib:int-sub 1 n) incy)
                   1)))
      (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                    ((> i n) nil)
        (tagbody
          (setf (f2cl-lib:fref dy-%data% (iy) ((1 1)) dy-%offset%)
                  (+ (f2cl-lib:fref dy-%data% (iy) ((1 1)) dy-%offset%)
                     (* da
                        (f2cl-lib:fref dx-%data% (ix) ((1 1)) dx-%offset%))))
          (setf ix (f2cl-lib:int-add ix incx))
          (setf iy (f2cl-lib:int-add iy incy))
         label10))
      (go end_label)
     label20
      (setf m (mod n 4))
      (if (= m 0) (go label40))
      (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                    ((> i m) nil)
        (tagbody
          (setf (f2cl-lib:fref dy-%data% (i) ((1 1)) dy-%offset%)
                  (+ (f2cl-lib:fref dy-%data% (i) ((1 1)) dy-%offset%)
                     (* da (f2cl-lib:fref dx-%data% (i) ((1 1)) dx-%offset%))))
         label30))
      (if (< n 4) (go end_label))
     label40
      (setf mp1 (f2cl-lib:int-add m 1))
      (f2cl-lib:fdo (i mp1 (f2cl-lib:int-add i 4))
                    ((> i n) nil)
        (tagbody
          (setf (f2cl-lib:fref dy-%data% (i) ((1 1)) dy-%offset%)
                  (+ (f2cl-lib:fref dy-%data% (i) ((1 1)) dy-%offset%)
                     (* da (f2cl-lib:fref dx-%data% (i) ((1 1)) dx-%offset%))))
          (setf (f2cl-lib:fref dy-%data%
                               ((f2cl-lib:int-add i 1))
                               ((1 1))
                               dy-%offset%)
                  (+
                   (f2cl-lib:fref dy-%data%
                                  ((f2cl-lib:int-add i 1))
                                  ((1 1))
                                  dy-%offset%)
                   (* da
                      (f2cl-lib:fref dx-%data%
                                     ((f2cl-lib:int-add i 1))
                                     ((1 1))
                                     dx-%offset%))))
          (setf (f2cl-lib:fref dy-%data%
                               ((f2cl-lib:int-add i 2))
                               ((1 1))
                               dy-%offset%)
                  (+
                   (f2cl-lib:fref dy-%data%
                                  ((f2cl-lib:int-add i 2))
                                  ((1 1))
                                  dy-%offset%)
                   (* da
                      (f2cl-lib:fref dx-%data%
                                     ((f2cl-lib:int-add i 2))
                                     ((1 1))
                                     dx-%offset%))))
          (setf (f2cl-lib:fref dy-%data%
                               ((f2cl-lib:int-add i 3))
                               ((1 1))
                               dy-%offset%)
                  (+
                   (f2cl-lib:fref dy-%data%
                                  ((f2cl-lib:int-add i 3))
                                  ((1 1))
                                  dy-%offset%)
                   (* da
                      (f2cl-lib:fref dx-%data%
                                     ((f2cl-lib:int-add i 3))
                                     ((1 1))
                                     dx-%offset%))))
         label50))
      (go end_label)
     end_label
      (return (values nil nil nil nil nil nil)))))

(in-package #:cl-user)
#+#.(cl:if (cl:find-package '#:f2cl) '(and) '(or))
(eval-when (:load-toplevel :compile-toplevel :execute)
  (setf (gethash 'fortran-to-lisp::daxpy fortran-to-lisp::*f2cl-function-info*)
          (fortran-to-lisp::make-f2cl-finfo
           :arg-types '((fortran-to-lisp::integer4) (double-float)
                        (array double-float (1)) (fortran-to-lisp::integer4)
                        (array double-float (1)) (fortran-to-lisp::integer4))
           :return-values '(nil nil nil nil nil nil)
           :calls 'nil)))

