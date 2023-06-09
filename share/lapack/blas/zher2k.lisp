;;; Compiled by f2cl version:
;;; ("f2cl1.l,v 2edcbd958861 2012/05/30 03:34:52 toy $"
;;;  "f2cl2.l,v 96616d88fb7e 2008/02/22 22:19:34 rtoy $"
;;;  "f2cl3.l,v 96616d88fb7e 2008/02/22 22:19:34 rtoy $"
;;;  "f2cl4.l,v 96616d88fb7e 2008/02/22 22:19:34 rtoy $"
;;;  "f2cl5.l,v 3fe93de3be82 2012/05/06 02:17:14 toy $"
;;;  "f2cl6.l,v 1d5cbacbb977 2008/08/24 00:56:27 rtoy $"
;;;  "macros.l,v 3fe93de3be82 2012/05/06 02:17:14 toy $")

;;; Using Lisp CMU Common Lisp 20d (20D Unicode)
;;; 
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;           (:coerce-assigns :as-needed) (:array-type ':array)
;;;           (:array-slicing t) (:declare-common nil)
;;;           (:float-format double-float))

(in-package :blas)


(let* ((one 1.0) (zero (f2cl-lib:cmplx 0.0 0.0)))
  (declare (type (double-float 1.0 1.0) one)
           (type (f2cl-lib:complex16) zero)
           (ignorable one zero))
  (defun zher2k (uplo trans n k alpha a lda b ldb$ beta c ldc)
    (declare (type (double-float) beta)
             (type (array f2cl-lib:complex16 (*)) c b a)
             (type (f2cl-lib:complex16) alpha)
             (type (f2cl-lib:integer4) ldc ldb$ lda k n)
             (type (simple-string *) trans uplo))
    (f2cl-lib:with-multi-array-data
        ((uplo character uplo-%data% uplo-%offset%)
         (trans character trans-%data% trans-%offset%)
         (a f2cl-lib:complex16 a-%data% a-%offset%)
         (b f2cl-lib:complex16 b-%data% b-%offset%)
         (c f2cl-lib:complex16 c-%data% c-%offset%))
      (prog ((temp1 #C(0.0 0.0)) (temp2 #C(0.0 0.0)) (i 0) (info 0) (j 0) (l 0)
             (nrowa 0) (upper nil))
        (declare (type (f2cl-lib:complex16) temp1 temp2)
                 (type (f2cl-lib:integer4) i info j l nrowa)
                 (type f2cl-lib:logical upper))
        (cond
          ((lsame trans "N")
           (setf nrowa n))
          (t
           (setf nrowa k)))
        (setf upper (lsame uplo "U"))
        (setf info 0)
        (cond
          ((and (not upper) (not (lsame uplo "L")))
           (setf info 1))
          ((and (not (lsame trans "N")) (not (lsame trans "C")))
           (setf info 2))
          ((< n 0)
           (setf info 3))
          ((< k 0)
           (setf info 4))
          ((< lda (max (the f2cl-lib:integer4 1) (the f2cl-lib:integer4 nrowa)))
           (setf info 7))
          ((< ldb$
              (max (the f2cl-lib:integer4 1) (the f2cl-lib:integer4 nrowa)))
           (setf info 9))
          ((< ldc (max (the f2cl-lib:integer4 1) (the f2cl-lib:integer4 n)))
           (setf info 12)))
        (cond
          ((/= info 0)
           (xerbla "ZHER2K" info)
           (go end_label)))
        (if (or (= n 0) (and (or (= alpha zero) (= k 0)) (= beta one)))
            (go end_label))
        (cond
          ((= alpha zero)
           (cond
             (upper
              (cond
                ((= beta (f2cl-lib:dble zero))
                 (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                               ((> j n) nil)
                   (tagbody
                     (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                   ((> i j) nil)
                       (tagbody
                         (setf (f2cl-lib:fref c-%data%
                                              (i j)
                                              ((1 ldc) (1 *))
                                              c-%offset%)
                                 zero)
                        label10))
                    label20)))
                (t
                 (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                               ((> j n) nil)
                   (tagbody
                     (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                   ((> i
                                       (f2cl-lib:int-add j
                                                         (f2cl-lib:int-sub 1)))
                                    nil)
                       (tagbody
                         (setf (f2cl-lib:fref c-%data%
                                              (i j)
                                              ((1 ldc) (1 *))
                                              c-%offset%)
                                 (* beta
                                    (f2cl-lib:fref c-%data%
                                                   (i j)
                                                   ((1 ldc) (1 *))
                                                   c-%offset%)))
                        label30))
                     (setf (f2cl-lib:fref c-%data%
                                          (j j)
                                          ((1 ldc) (1 *))
                                          c-%offset%)
                             (coerce
                              (* beta
                                 (f2cl-lib:dble
                                  (f2cl-lib:fref c-%data%
                                                 (j j)
                                                 ((1 ldc) (1 *))
                                                 c-%offset%)))
                              'f2cl-lib:complex16))
                    label40)))))
             (t
              (cond
                ((= beta (f2cl-lib:dble zero))
                 (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                               ((> j n) nil)
                   (tagbody
                     (f2cl-lib:fdo (i j (f2cl-lib:int-add i 1))
                                   ((> i n) nil)
                       (tagbody
                         (setf (f2cl-lib:fref c-%data%
                                              (i j)
                                              ((1 ldc) (1 *))
                                              c-%offset%)
                                 zero)
                        label50))
                    label60)))
                (t
                 (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                               ((> j n) nil)
                   (tagbody
                     (setf (f2cl-lib:fref c-%data%
                                          (j j)
                                          ((1 ldc) (1 *))
                                          c-%offset%)
                             (coerce
                              (* beta
                                 (f2cl-lib:dble
                                  (f2cl-lib:fref c-%data%
                                                 (j j)
                                                 ((1 ldc) (1 *))
                                                 c-%offset%)))
                              'f2cl-lib:complex16))
                     (f2cl-lib:fdo (i (f2cl-lib:int-add j 1)
                                    (f2cl-lib:int-add i 1))
                                   ((> i n) nil)
                       (tagbody
                         (setf (f2cl-lib:fref c-%data%
                                              (i j)
                                              ((1 ldc) (1 *))
                                              c-%offset%)
                                 (* beta
                                    (f2cl-lib:fref c-%data%
                                                   (i j)
                                                   ((1 ldc) (1 *))
                                                   c-%offset%)))
                        label70))
                    label80))))))
           (go end_label)))
        (cond
          ((lsame trans "N")
           (cond
             (upper
              (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                            ((> j n) nil)
                (tagbody
                  (cond
                    ((= beta (f2cl-lib:dble zero))
                     (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                   ((> i j) nil)
                       (tagbody
                         (setf (f2cl-lib:fref c-%data%
                                              (i j)
                                              ((1 ldc) (1 *))
                                              c-%offset%)
                                 zero)
                        label90)))
                    ((/= beta one)
                     (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                   ((> i
                                       (f2cl-lib:int-add j
                                                         (f2cl-lib:int-sub 1)))
                                    nil)
                       (tagbody
                         (setf (f2cl-lib:fref c-%data%
                                              (i j)
                                              ((1 ldc) (1 *))
                                              c-%offset%)
                                 (* beta
                                    (f2cl-lib:fref c-%data%
                                                   (i j)
                                                   ((1 ldc) (1 *))
                                                   c-%offset%)))
                        label100))
                     (setf (f2cl-lib:fref c-%data%
                                          (j j)
                                          ((1 ldc) (1 *))
                                          c-%offset%)
                             (coerce
                              (* beta
                                 (f2cl-lib:dble
                                  (f2cl-lib:fref c-%data%
                                                 (j j)
                                                 ((1 ldc) (1 *))
                                                 c-%offset%)))
                              'f2cl-lib:complex16)))
                    (t
                     (setf (f2cl-lib:fref c-%data%
                                          (j j)
                                          ((1 ldc) (1 *))
                                          c-%offset%)
                             (coerce
                              (f2cl-lib:dble
                               (f2cl-lib:fref c-%data%
                                              (j j)
                                              ((1 ldc) (1 *))
                                              c-%offset%))
                              'f2cl-lib:complex16))))
                  (f2cl-lib:fdo (l 1 (f2cl-lib:int-add l 1))
                                ((> l k) nil)
                    (tagbody
                      (cond
                        ((or (/= (f2cl-lib:fref a (j l) ((1 lda) (1 *))) zero)
                             (/= (f2cl-lib:fref b (j l) ((1 ldb$) (1 *))) zero))
                         (setf temp1
                                 (* alpha
                                    (f2cl-lib:dconjg
                                     (f2cl-lib:fref b-%data%
                                                    (j l)
                                                    ((1 ldb$) (1 *))
                                                    b-%offset%))))
                         (setf temp2
                                 (coerce
                                  (f2cl-lib:dconjg
                                   (* alpha
                                      (f2cl-lib:fref a-%data%
                                                     (j l)
                                                     ((1 lda) (1 *))
                                                     a-%offset%)))
                                  'f2cl-lib:complex16))
                         (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                       ((> i
                                           (f2cl-lib:int-add j
                                                             (f2cl-lib:int-sub
                                                              1)))
                                        nil)
                           (tagbody
                             (setf (f2cl-lib:fref c-%data%
                                                  (i j)
                                                  ((1 ldc) (1 *))
                                                  c-%offset%)
                                     (+
                                      (f2cl-lib:fref c-%data%
                                                     (i j)
                                                     ((1 ldc) (1 *))
                                                     c-%offset%)
                                      (*
                                       (f2cl-lib:fref a-%data%
                                                      (i l)
                                                      ((1 lda) (1 *))
                                                      a-%offset%)
                                       temp1)
                                      (*
                                       (f2cl-lib:fref b-%data%
                                                      (i l)
                                                      ((1 ldb$) (1 *))
                                                      b-%offset%)
                                       temp2)))
                            label110))
                         (setf (f2cl-lib:fref c-%data%
                                              (j j)
                                              ((1 ldc) (1 *))
                                              c-%offset%)
                                 (coerce
                                  (+
                                   (f2cl-lib:dble
                                    (f2cl-lib:fref c-%data%
                                                   (j j)
                                                   ((1 ldc) (1 *))
                                                   c-%offset%))
                                   (f2cl-lib:dble
                                    (+
                                     (*
                                      (f2cl-lib:fref a-%data%
                                                     (j l)
                                                     ((1 lda) (1 *))
                                                     a-%offset%)
                                      temp1)
                                     (*
                                      (f2cl-lib:fref b-%data%
                                                     (j l)
                                                     ((1 ldb$) (1 *))
                                                     b-%offset%)
                                      temp2))))
                                  'f2cl-lib:complex16))))
                     label120))
                 label130)))
             (t
              (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                            ((> j n) nil)
                (tagbody
                  (cond
                    ((= beta (f2cl-lib:dble zero))
                     (f2cl-lib:fdo (i j (f2cl-lib:int-add i 1))
                                   ((> i n) nil)
                       (tagbody
                         (setf (f2cl-lib:fref c-%data%
                                              (i j)
                                              ((1 ldc) (1 *))
                                              c-%offset%)
                                 zero)
                        label140)))
                    ((/= beta one)
                     (f2cl-lib:fdo (i (f2cl-lib:int-add j 1)
                                    (f2cl-lib:int-add i 1))
                                   ((> i n) nil)
                       (tagbody
                         (setf (f2cl-lib:fref c-%data%
                                              (i j)
                                              ((1 ldc) (1 *))
                                              c-%offset%)
                                 (* beta
                                    (f2cl-lib:fref c-%data%
                                                   (i j)
                                                   ((1 ldc) (1 *))
                                                   c-%offset%)))
                        label150))
                     (setf (f2cl-lib:fref c-%data%
                                          (j j)
                                          ((1 ldc) (1 *))
                                          c-%offset%)
                             (coerce
                              (* beta
                                 (f2cl-lib:dble
                                  (f2cl-lib:fref c-%data%
                                                 (j j)
                                                 ((1 ldc) (1 *))
                                                 c-%offset%)))
                              'f2cl-lib:complex16)))
                    (t
                     (setf (f2cl-lib:fref c-%data%
                                          (j j)
                                          ((1 ldc) (1 *))
                                          c-%offset%)
                             (coerce
                              (f2cl-lib:dble
                               (f2cl-lib:fref c-%data%
                                              (j j)
                                              ((1 ldc) (1 *))
                                              c-%offset%))
                              'f2cl-lib:complex16))))
                  (f2cl-lib:fdo (l 1 (f2cl-lib:int-add l 1))
                                ((> l k) nil)
                    (tagbody
                      (cond
                        ((or (/= (f2cl-lib:fref a (j l) ((1 lda) (1 *))) zero)
                             (/= (f2cl-lib:fref b (j l) ((1 ldb$) (1 *))) zero))
                         (setf temp1
                                 (* alpha
                                    (f2cl-lib:dconjg
                                     (f2cl-lib:fref b-%data%
                                                    (j l)
                                                    ((1 ldb$) (1 *))
                                                    b-%offset%))))
                         (setf temp2
                                 (coerce
                                  (f2cl-lib:dconjg
                                   (* alpha
                                      (f2cl-lib:fref a-%data%
                                                     (j l)
                                                     ((1 lda) (1 *))
                                                     a-%offset%)))
                                  'f2cl-lib:complex16))
                         (f2cl-lib:fdo (i (f2cl-lib:int-add j 1)
                                        (f2cl-lib:int-add i 1))
                                       ((> i n) nil)
                           (tagbody
                             (setf (f2cl-lib:fref c-%data%
                                                  (i j)
                                                  ((1 ldc) (1 *))
                                                  c-%offset%)
                                     (+
                                      (f2cl-lib:fref c-%data%
                                                     (i j)
                                                     ((1 ldc) (1 *))
                                                     c-%offset%)
                                      (*
                                       (f2cl-lib:fref a-%data%
                                                      (i l)
                                                      ((1 lda) (1 *))
                                                      a-%offset%)
                                       temp1)
                                      (*
                                       (f2cl-lib:fref b-%data%
                                                      (i l)
                                                      ((1 ldb$) (1 *))
                                                      b-%offset%)
                                       temp2)))
                            label160))
                         (setf (f2cl-lib:fref c-%data%
                                              (j j)
                                              ((1 ldc) (1 *))
                                              c-%offset%)
                                 (coerce
                                  (+
                                   (f2cl-lib:dble
                                    (f2cl-lib:fref c-%data%
                                                   (j j)
                                                   ((1 ldc) (1 *))
                                                   c-%offset%))
                                   (f2cl-lib:dble
                                    (+
                                     (*
                                      (f2cl-lib:fref a-%data%
                                                     (j l)
                                                     ((1 lda) (1 *))
                                                     a-%offset%)
                                      temp1)
                                     (*
                                      (f2cl-lib:fref b-%data%
                                                     (j l)
                                                     ((1 ldb$) (1 *))
                                                     b-%offset%)
                                      temp2))))
                                  'f2cl-lib:complex16))))
                     label170))
                 label180)))))
          (t
           (cond
             (upper
              (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                            ((> j n) nil)
                (tagbody
                  (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                                ((> i j) nil)
                    (tagbody
                      (setf temp1 zero)
                      (setf temp2 zero)
                      (f2cl-lib:fdo (l 1 (f2cl-lib:int-add l 1))
                                    ((> l k) nil)
                        (tagbody
                          (setf temp1
                                  (+ temp1
                                     (*
                                      (f2cl-lib:dconjg
                                       (f2cl-lib:fref a-%data%
                                                      (l i)
                                                      ((1 lda) (1 *))
                                                      a-%offset%))
                                      (f2cl-lib:fref b-%data%
                                                     (l j)
                                                     ((1 ldb$) (1 *))
                                                     b-%offset%))))
                          (setf temp2
                                  (+ temp2
                                     (*
                                      (f2cl-lib:dconjg
                                       (f2cl-lib:fref b-%data%
                                                      (l i)
                                                      ((1 ldb$) (1 *))
                                                      b-%offset%))
                                      (f2cl-lib:fref a-%data%
                                                     (l j)
                                                     ((1 lda) (1 *))
                                                     a-%offset%))))
                         label190))
                      (cond
                        ((= i j)
                         (cond
                           ((= beta (f2cl-lib:dble zero))
                            (setf (f2cl-lib:fref c-%data%
                                                 (j j)
                                                 ((1 ldc) (1 *))
                                                 c-%offset%)
                                    (coerce
                                     (f2cl-lib:dble
                                      (+ (* alpha temp1)
                                         (* (f2cl-lib:dconjg alpha) temp2)))
                                     'f2cl-lib:complex16)))
                           (t
                            (setf (f2cl-lib:fref c-%data%
                                                 (j j)
                                                 ((1 ldc) (1 *))
                                                 c-%offset%)
                                    (coerce
                                     (+
                                      (* beta
                                         (f2cl-lib:dble
                                          (f2cl-lib:fref c-%data%
                                                         (j j)
                                                         ((1 ldc) (1 *))
                                                         c-%offset%)))
                                      (f2cl-lib:dble
                                       (+ (* alpha temp1)
                                          (* (f2cl-lib:dconjg alpha) temp2))))
                                     'f2cl-lib:complex16)))))
                        (t
                         (cond
                           ((= beta (f2cl-lib:dble zero))
                            (setf (f2cl-lib:fref c-%data%
                                                 (i j)
                                                 ((1 ldc) (1 *))
                                                 c-%offset%)
                                    (+ (* alpha temp1)
                                       (* (f2cl-lib:dconjg alpha) temp2))))
                           (t
                            (setf (f2cl-lib:fref c-%data%
                                                 (i j)
                                                 ((1 ldc) (1 *))
                                                 c-%offset%)
                                    (+
                                     (* beta
                                        (f2cl-lib:fref c-%data%
                                                       (i j)
                                                       ((1 ldc) (1 *))
                                                       c-%offset%))
                                     (* alpha temp1)
                                     (* (f2cl-lib:dconjg alpha) temp2)))))))
                     label200))
                 label210)))
             (t
              (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                            ((> j n) nil)
                (tagbody
                  (f2cl-lib:fdo (i j (f2cl-lib:int-add i 1))
                                ((> i n) nil)
                    (tagbody
                      (setf temp1 zero)
                      (setf temp2 zero)
                      (f2cl-lib:fdo (l 1 (f2cl-lib:int-add l 1))
                                    ((> l k) nil)
                        (tagbody
                          (setf temp1
                                  (+ temp1
                                     (*
                                      (f2cl-lib:dconjg
                                       (f2cl-lib:fref a-%data%
                                                      (l i)
                                                      ((1 lda) (1 *))
                                                      a-%offset%))
                                      (f2cl-lib:fref b-%data%
                                                     (l j)
                                                     ((1 ldb$) (1 *))
                                                     b-%offset%))))
                          (setf temp2
                                  (+ temp2
                                     (*
                                      (f2cl-lib:dconjg
                                       (f2cl-lib:fref b-%data%
                                                      (l i)
                                                      ((1 ldb$) (1 *))
                                                      b-%offset%))
                                      (f2cl-lib:fref a-%data%
                                                     (l j)
                                                     ((1 lda) (1 *))
                                                     a-%offset%))))
                         label220))
                      (cond
                        ((= i j)
                         (cond
                           ((= beta (f2cl-lib:dble zero))
                            (setf (f2cl-lib:fref c-%data%
                                                 (j j)
                                                 ((1 ldc) (1 *))
                                                 c-%offset%)
                                    (coerce
                                     (f2cl-lib:dble
                                      (+ (* alpha temp1)
                                         (* (f2cl-lib:dconjg alpha) temp2)))
                                     'f2cl-lib:complex16)))
                           (t
                            (setf (f2cl-lib:fref c-%data%
                                                 (j j)
                                                 ((1 ldc) (1 *))
                                                 c-%offset%)
                                    (coerce
                                     (+
                                      (* beta
                                         (f2cl-lib:dble
                                          (f2cl-lib:fref c-%data%
                                                         (j j)
                                                         ((1 ldc) (1 *))
                                                         c-%offset%)))
                                      (f2cl-lib:dble
                                       (+ (* alpha temp1)
                                          (* (f2cl-lib:dconjg alpha) temp2))))
                                     'f2cl-lib:complex16)))))
                        (t
                         (cond
                           ((= beta (f2cl-lib:dble zero))
                            (setf (f2cl-lib:fref c-%data%
                                                 (i j)
                                                 ((1 ldc) (1 *))
                                                 c-%offset%)
                                    (+ (* alpha temp1)
                                       (* (f2cl-lib:dconjg alpha) temp2))))
                           (t
                            (setf (f2cl-lib:fref c-%data%
                                                 (i j)
                                                 ((1 ldc) (1 *))
                                                 c-%offset%)
                                    (+
                                     (* beta
                                        (f2cl-lib:fref c-%data%
                                                       (i j)
                                                       ((1 ldc) (1 *))
                                                       c-%offset%))
                                     (* alpha temp1)
                                     (* (f2cl-lib:dconjg alpha) temp2)))))))
                     label230))
                 label240))))))
        (go end_label)
       end_label
        (return (values nil nil nil nil nil nil nil nil nil nil nil nil))))))

(in-package #:cl-user)
#+#.(cl:if (cl:find-package '#:f2cl) '(and) '(or))
(eval-when (:load-toplevel :compile-toplevel :execute)
  (setf (gethash 'fortran-to-lisp::zher2k
                 fortran-to-lisp::*f2cl-function-info*)
          (fortran-to-lisp::make-f2cl-finfo
           :arg-types '((simple-string) (simple-string)
                        (fortran-to-lisp::integer4) (fortran-to-lisp::integer4)
                        (fortran-to-lisp::complex16)
                        (array fortran-to-lisp::complex16 (*))
                        (fortran-to-lisp::integer4)
                        (array fortran-to-lisp::complex16 (*))
                        (fortran-to-lisp::integer4) (double-float)
                        (array fortran-to-lisp::complex16 (*))
                        (fortran-to-lisp::integer4))
           :return-values '(nil nil nil nil nil nil nil nil nil nil nil nil)
           :calls '(fortran-to-lisp::xerbla fortran-to-lisp::lsame))))

