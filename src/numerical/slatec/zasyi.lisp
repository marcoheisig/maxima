;;; Compiled by f2cl version:
;;; ("f2cl1.l,v 46c1f6a93b0d 2012/05/03 04:40:28 toy $"
;;;  "f2cl2.l,v 96616d88fb7e 2008/02/22 22:19:34 rtoy $"
;;;  "f2cl3.l,v 96616d88fb7e 2008/02/22 22:19:34 rtoy $"
;;;  "f2cl4.l,v 96616d88fb7e 2008/02/22 22:19:34 rtoy $"
;;;  "f2cl5.l,v 46c1f6a93b0d 2012/05/03 04:40:28 toy $"
;;;  "f2cl6.l,v 1d5cbacbb977 2008/08/24 00:56:27 rtoy $"
;;;  "macros.l,v fceac530ef0c 2011/11/26 04:02:26 toy $")

;;; Using Lisp CMU Common Lisp snapshot-2012-04 (20C Unicode)
;;; 
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;           (:coerce-assigns :as-needed) (:array-type ':simple-array)
;;;           (:array-slicing nil) (:declare-common nil)
;;;           (:float-format double-float))

(in-package :slatec)


(let ((pi$ 3.141592653589793)
      (rtpi 0.15915494309189535)
      (zeror 0.0)
      (zeroi 0.0)
      (coner 1.0)
      (conei 0.0))
  (declare (type (double-float) pi$ rtpi zeror zeroi coner conei))
  (defun zasyi (zr zi fnu kode n yr yi nz rl tol elim alim)
    (declare (type (simple-array double-float (*)) yi yr)
             (type (f2cl-lib:integer4) nz n kode)
             (type (double-float) alim elim tol rl fnu zi zr))
    (prog ((i 0) (ib 0) (il 0) (inu 0) (j 0) (jl 0) (k 0) (koded 0) (m 0)
           (nn 0) (aa 0.0) (aez 0.0) (ak 0.0) (ak1i 0.0) (ak1r 0.0) (arg 0.0)
           (arm 0.0) (atol 0.0) (az 0.0) (bb 0.0) (bk 0.0) (cki 0.0) (ckr 0.0)
           (cs1i 0.0) (cs1r 0.0) (cs2i 0.0) (cs2r 0.0) (czi 0.0) (czr 0.0)
           (dfnu 0.0) (dki 0.0) (dkr 0.0) (dnu2 0.0) (ezi 0.0) (ezr 0.0)
           (fdn 0.0) (p1i 0.0) (p1r 0.0) (raz 0.0) (rtr1 0.0) (rzi 0.0)
           (rzr 0.0) (s 0.0) (sgn 0.0) (sqk 0.0) (sti 0.0) (str 0.0) (s2i 0.0)
           (s2r 0.0) (tzi 0.0) (tzr 0.0))
      (declare (type (double-float) tzr tzi s2r s2i str sti sqk sgn s rzr rzi
                                    rtr1 raz p1r p1i fdn ezr ezi dnu2 dkr dki
                                    dfnu czr czi cs2r cs2i cs1r cs1i ckr cki bk
                                    bb az atol arm arg ak1r ak1i ak aez aa)
               (type (f2cl-lib:integer4) nn m koded k jl j inu il ib i))
      (setf nz 0)
      (setf az (coerce (realpart (zabs zr zi)) 'double-float))
      (setf arm (* 1000.0 (f2cl-lib:d1mach 1)))
      (setf rtr1 (f2cl-lib:fsqrt arm))
      (setf il (min (the f2cl-lib:integer4 2) (the f2cl-lib:integer4 n)))
      (setf dfnu (+ fnu (f2cl-lib:int-sub n il)))
      (setf raz (/ 1.0 az))
      (setf str (* zr raz))
      (setf sti (* (- zi) raz))
      (setf ak1r (* rtpi str raz))
      (setf ak1i (* rtpi sti raz))
      (multiple-value-bind (var-0 var-1 var-2 var-3)
          (zsqrt$ ak1r ak1i ak1r ak1i)
        (declare (ignore var-0 var-1))
        (setf ak1r var-2)
        (setf ak1i var-3))
      (setf czr zr)
      (setf czi zi)
      (if (/= kode 2) (go label10))
      (setf czr zeror)
      (setf czi zi)
     label10
      (if (> (abs czr) elim) (go label100))
      (setf dnu2 (+ dfnu dfnu))
      (setf koded 1)
      (if (and (> (abs czr) alim) (> n 2)) (go label20))
      (setf koded 0)
      (multiple-value-bind (var-0 var-1 var-2 var-3)
          (zexp czr czi str sti)
        (declare (ignore var-0 var-1))
        (setf str var-2)
        (setf sti var-3))
      (multiple-value-bind (var-0 var-1 var-2 var-3 var-4 var-5)
          (zmlt ak1r ak1i str sti ak1r ak1i)
        (declare (ignore var-0 var-1 var-2 var-3))
        (setf ak1r var-4)
        (setf ak1i var-5))
     label20
      (setf fdn 0.0)
      (if (> dnu2 rtr1) (setf fdn (* dnu2 dnu2)))
      (setf ezr (* zr 8.0))
      (setf ezi (* zi 8.0))
      (setf aez (* 8.0 az))
      (setf s (/ tol aez))
      (setf jl (f2cl-lib:int (+ rl rl 2)))
      (setf p1r zeror)
      (setf p1i zeroi)
      (if (= zi 0.0) (go label30))
      (setf inu (f2cl-lib:int fnu))
      (setf arg (* (- fnu inu) pi$))
      (setf inu (f2cl-lib:int-sub (f2cl-lib:int-add inu n) il))
      (setf ak (- (sin arg)))
      (setf bk (cos arg))
      (if (< zi 0.0) (setf bk (- bk)))
      (setf p1r ak)
      (setf p1i bk)
      (if (= (mod inu 2) 0) (go label30))
      (setf p1r (- p1r))
      (setf p1i (- p1i))
     label30
      (f2cl-lib:fdo (k 1 (f2cl-lib:int-add k 1))
                    ((> k il) nil)
        (tagbody
          (setf sqk (- fdn 1.0))
          (setf atol (* s (abs sqk)))
          (setf sgn 1.0)
          (setf cs1r coner)
          (setf cs1i conei)
          (setf cs2r coner)
          (setf cs2i conei)
          (setf ckr coner)
          (setf cki conei)
          (setf ak 0.0)
          (setf aa 1.0)
          (setf bb aez)
          (setf dkr ezr)
          (setf dki ezi)
          (f2cl-lib:fdo (j 1 (f2cl-lib:int-add j 1))
                        ((> j jl) nil)
            (tagbody
              (multiple-value-bind (var-0 var-1 var-2 var-3 var-4 var-5)
                  (zdiv ckr cki dkr dki str sti)
                (declare (ignore var-0 var-1 var-2 var-3))
                (setf str var-4)
                (setf sti var-5))
              (setf ckr (* str sqk))
              (setf cki (* sti sqk))
              (setf cs2r (+ cs2r ckr))
              (setf cs2i (+ cs2i cki))
              (setf sgn (- sgn))
              (setf cs1r (+ cs1r (* ckr sgn)))
              (setf cs1i (+ cs1i (* cki sgn)))
              (setf dkr (+ dkr ezr))
              (setf dki (+ dki ezi))
              (setf aa (/ (* aa (abs sqk)) bb))
              (setf bb (+ bb aez))
              (setf ak (+ ak 8.0))
              (setf sqk (- sqk ak))
              (if (<= aa atol) (go label50))
             label40))
          (go label110)
         label50
          (setf s2r cs1r)
          (setf s2i cs1i)
          (if (>= (+ zr zr) elim) (go label60))
          (setf tzr (+ zr zr))
          (setf tzi (+ zi zi))
          (multiple-value-bind (var-0 var-1 var-2 var-3)
              (zexp (- tzr) (- tzi) str sti)
            (declare (ignore var-0 var-1))
            (setf str var-2)
            (setf sti var-3))
          (multiple-value-bind (var-0 var-1 var-2 var-3 var-4 var-5)
              (zmlt str sti p1r p1i str sti)
            (declare (ignore var-0 var-1 var-2 var-3))
            (setf str var-4)
            (setf sti var-5))
          (multiple-value-bind (var-0 var-1 var-2 var-3 var-4 var-5)
              (zmlt str sti cs2r cs2i str sti)
            (declare (ignore var-0 var-1 var-2 var-3))
            (setf str var-4)
            (setf sti var-5))
          (setf s2r (+ s2r str))
          (setf s2i (+ s2i sti))
         label60
          (setf fdn (+ fdn (* 8.0 dfnu) 4.0))
          (setf p1r (- p1r))
          (setf p1i (- p1i))
          (setf m (f2cl-lib:int-add (f2cl-lib:int-sub n il) k))
          (setf (f2cl-lib:fref yr (m) ((1 n))) (- (* s2r ak1r) (* s2i ak1i)))
          (setf (f2cl-lib:fref yi (m) ((1 n))) (+ (* s2r ak1i) (* s2i ak1r)))
         label70))
      (if (<= n 2) (go end_label))
      (setf nn n)
      (setf k (f2cl-lib:int-sub nn 2))
      (setf ak (coerce (the f2cl-lib:integer4 k) 'double-float))
      (setf str (* zr raz))
      (setf sti (* (- zi) raz))
      (setf rzr (* (+ str str) raz))
      (setf rzi (* (+ sti sti) raz))
      (setf ib 3)
      (f2cl-lib:fdo (i ib (f2cl-lib:int-add i 1))
                    ((> i nn) nil)
        (tagbody
          (setf (f2cl-lib:fref yr (k) ((1 n)))
                  (+
                   (* (+ ak fnu)
                      (-
                       (* rzr
                          (f2cl-lib:fref yr ((f2cl-lib:int-add k 1)) ((1 n))))
                       (* rzi
                          (f2cl-lib:fref yi
                                         ((f2cl-lib:int-add k 1))
                                         ((1 n))))))
                   (f2cl-lib:fref yr ((f2cl-lib:int-add k 2)) ((1 n)))))
          (setf (f2cl-lib:fref yi (k) ((1 n)))
                  (+
                   (* (+ ak fnu)
                      (+
                       (* rzr
                          (f2cl-lib:fref yi ((f2cl-lib:int-add k 1)) ((1 n))))
                       (* rzi
                          (f2cl-lib:fref yr
                                         ((f2cl-lib:int-add k 1))
                                         ((1 n))))))
                   (f2cl-lib:fref yi ((f2cl-lib:int-add k 2)) ((1 n)))))
          (setf ak (- ak 1.0))
          (setf k (f2cl-lib:int-sub k 1))
         label80))
      (if (= koded 0) (go end_label))
      (multiple-value-bind (var-0 var-1 var-2 var-3)
          (zexp czr czi ckr cki)
        (declare (ignore var-0 var-1))
        (setf ckr var-2)
        (setf cki var-3))
      (f2cl-lib:fdo (i 1 (f2cl-lib:int-add i 1))
                    ((> i nn) nil)
        (tagbody
          (setf str
                  (- (* (f2cl-lib:fref yr (i) ((1 n))) ckr)
                     (* (f2cl-lib:fref yi (i) ((1 n))) cki)))
          (setf (f2cl-lib:fref yi (i) ((1 n)))
                  (+ (* (f2cl-lib:fref yr (i) ((1 n))) cki)
                     (* (f2cl-lib:fref yi (i) ((1 n))) ckr)))
          (setf (f2cl-lib:fref yr (i) ((1 n))) str)
         label90))
      (go end_label)
     label100
      (setf nz -1)
      (go end_label)
     label110
      (setf nz -2)
      (go end_label)
     end_label
      (return (values nil nil nil nil nil nil nil nz nil nil nil nil)))))

(in-package #:cl-user)
#+#.(cl:if (cl:find-package '#:f2cl) '(and) '(or))
(eval-when (:load-toplevel :compile-toplevel :execute)
  (setf (gethash 'fortran-to-lisp::zasyi fortran-to-lisp::*f2cl-function-info*)
          (fortran-to-lisp::make-f2cl-finfo
           :arg-types '((double-float) (double-float) (double-float)
                        (fortran-to-lisp::integer4) (fortran-to-lisp::integer4)
                        (simple-array double-float (*))
                        (simple-array double-float (*))
                        (fortran-to-lisp::integer4) (double-float)
                        (double-float) (double-float) (double-float))
           :return-values '(nil nil nil nil nil nil nil fortran-to-lisp::nz nil
                            nil nil nil)
           :calls '(fortran-to-lisp::zdiv fortran-to-lisp::zmlt
                    fortran-to-lisp::zexp fortran-to-lisp::zsqrt$
                    fortran-to-lisp::d1mach fortran-to-lisp::zabs))))

