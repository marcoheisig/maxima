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


(let ((lunit -1) (mesflg 1))
  (declare (type (f2cl-lib:integer4) lunit mesflg))
  (defun ixsav (ipar ivalue iset)
    (declare (type f2cl-lib:logical iset)
             (type (f2cl-lib:integer4) ivalue ipar))
    (prog ((ixsav 0))
      (declare (type (f2cl-lib:integer4) ixsav))
      (cond
        ((= ipar 1)
         (if (= lunit -1) (setf lunit (iumach)))
         (setf ixsav lunit)
         (if iset (setf lunit ivalue))))
      (cond
        ((= ipar 2)
         (setf ixsav mesflg)
         (if iset (setf mesflg ivalue))))
      (go end_label)
     end_label
      (return (values ixsav nil nil nil)))))

(in-package #:cl-user)
#+#.(cl:if (cl:find-package '#:f2cl) '(and) '(or))
(eval-when (:load-toplevel :compile-toplevel :execute)
  (setf (gethash 'fortran-to-lisp::ixsav fortran-to-lisp::*f2cl-function-info*)
          (fortran-to-lisp::make-f2cl-finfo
           :arg-types '((fortran-to-lisp::integer4) (fortran-to-lisp::integer4)
                        fortran-to-lisp::logical)
           :return-values '(nil nil nil)
           :calls 'nil)))

