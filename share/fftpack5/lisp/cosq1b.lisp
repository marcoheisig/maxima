;;; Compiled by f2cl version:
;;; ("f2cl1.l,v 95098eb54f13 2013/04/01 00:45:16 toy $"
;;;  "f2cl2.l,v 95098eb54f13 2013/04/01 00:45:16 toy $"
;;;  "f2cl3.l,v 96616d88fb7e 2008/02/22 22:19:34 rtoy $"
;;;  "f2cl4.l,v 96616d88fb7e 2008/02/22 22:19:34 rtoy $"
;;;  "f2cl5.l,v 95098eb54f13 2013/04/01 00:45:16 toy $"
;;;  "f2cl6.l,v 1d5cbacbb977 2008/08/24 00:56:27 rtoy $"
;;;  "macros.l,v 1409c1352feb 2013/03/24 20:44:50 toy $")

;;; Using Lisp CMU Common Lisp snapshot-2020-04 (21D Unicode)
;;; 
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;           (:coerce-assigns :as-needed) (:array-type ':array)
;;;           (:array-slicing t) (:declare-common nil)
;;;           (:float-format single-float))

(in-package "FFTPACK5")


(defun cosq1b (n inc x lenx wsave lensav work lenwrk ier)
  (declare (type (array double-float (*)) work wsave x)
           (type (f2cl-lib:integer4) ier lenwrk lensav lenx inc n))
  (f2cl-lib:with-multi-array-data
      ((x double-float x-%data% x-%offset%)
       (wsave double-float wsave-%data% wsave-%offset%)
       (work double-float work-%data% work-%offset%))
    (prog ((ier1 0) (x1 0.0d0) (ssqrt2 0.0d0))
      (declare (type (double-float) ssqrt2 x1) (type (f2cl-lib:integer4) ier1))
      (setf ier 0)
      (cond
        ((< lenx
            (f2cl-lib:int-add
             (f2cl-lib:int-mul inc (f2cl-lib:int-add n (f2cl-lib:int-sub 1)))
             1))
         (setf ier 1)
         (xerfft "COSQ1B" 6)
         (go label300))
        ((< lensav
            (f2cl-lib:int-add (f2cl-lib:int-mul 2 n)
                              (f2cl-lib:int
                               (f2cl-lib:f2cl/
                                (f2cl-lib:flog (f2cl-lib:freal n))
                                (f2cl-lib:flog 2.0d0)))
                              4))
         (setf ier 2)
         (xerfft "COSQ1B" 8)
         (go label300))
        ((< lenwrk n)
         (setf ier 3)
         (xerfft "COSQ1B" 10)
         (go label300)))
      (f2cl-lib:arithmetic-if (f2cl-lib:int-sub n 2)
                              (go label300)
                              (go label102)
                              (go label103))
     label102
      (setf ssqrt2 (/ 1.0d0 (f2cl-lib:fsqrt 2.0d0)))
      (setf x1
              (+ (f2cl-lib:fref x-%data% (1 1) ((1 inc) (1 *)) x-%offset%)
                 (f2cl-lib:fref x-%data% (1 2) ((1 inc) (1 *)) x-%offset%)))
      (setf (f2cl-lib:fref x-%data% (1 2) ((1 inc) (1 *)) x-%offset%)
              (* ssqrt2
                 (- (f2cl-lib:fref x-%data% (1 1) ((1 inc) (1 *)) x-%offset%)
                    (f2cl-lib:fref x-%data%
                                   (1 2)
                                   ((1 inc) (1 *))
                                   x-%offset%))))
      (setf (f2cl-lib:fref x-%data% (1 1) ((1 inc) (1 *)) x-%offset%) x1)
      (go end_label)
     label103
      (multiple-value-bind (var-0 var-1 var-2 var-3 var-4 var-5)
          (cosqb1 n inc x wsave work ier1)
        (declare (ignore var-0 var-1 var-2 var-3 var-4))
        (setf ier1 var-5))
      (cond
        ((/= ier1 0)
         (setf ier 20)
         (xerfft "COSQ1B" -5)))
     label300
      (go end_label)
     end_label
      (return (values nil nil nil nil nil nil nil nil ier)))))

(in-package #:cl-user)
#+#.(cl:if (cl:find-package '#:f2cl) '(and) '(or))
(eval-when (:load-toplevel :compile-toplevel :execute)
  (setf (gethash 'fortran-to-lisp::cosq1b
                 fortran-to-lisp::*f2cl-function-info*)
          (fortran-to-lisp::make-f2cl-finfo
           :arg-types '((fortran-to-lisp::integer4) (fortran-to-lisp::integer4)
                        (array double-float (*)) (fortran-to-lisp::integer4)
                        (array double-float (*)) (fortran-to-lisp::integer4)
                        (array double-float (*)) (fortran-to-lisp::integer4)
                        (fortran-to-lisp::integer4))
           :return-values '(nil nil nil nil nil nil nil nil
                            fortran-to-lisp::ier)
           :calls '(fortran-to-lisp::cosqb1 fortran-to-lisp::xerfft))))

