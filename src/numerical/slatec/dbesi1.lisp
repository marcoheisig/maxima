;;; Compiled by f2cl version 2.0 beta on 2002/04/25 at 13:18:45
;;; 
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;           (:coerce-assigns :as-needed) (:array-type ':simple-array)
;;;           (:array-slicing nil) (:declare-common nil)
;;;           (:float-format double-float))

(in-package "SLATEC")


(let ((nti1 0)
      (xmin 0.0)
      (xsml 0.0)
      (xmax 0.0)
      (bi1cs (make-array 17 :element-type 'double-float))
      (first nil))
  (declare (type f2cl-lib:logical first)
           (type (simple-array double-float (17)) bi1cs)
           (type double-float xmax xsml xmin)
           (type f2cl-lib:integer4 nti1))
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (1) ((1 17))) -0.0019717132610998596)
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (2) ((1 17))) 0.4073488766754648)
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (3) ((1 17))) 0.03483899429995946)
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (4) ((1 17))) 0.0015453945563001237)
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (5) ((1 17))) 4.188852109837779e-5)
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (6) ((1 17))) 7.649026764836211e-7)
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (7) ((1 17))) 1.0042493924741178e-8)
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (8) ((1 17))) 9.932207791923812e-11)
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (9) ((1 17))) 7.663801791844763e-13)
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (10) ((1 17))) 4.741418923816739e-15)
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (11) ((1 17))) 2.4041144040745183e-17)
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (12) ((1 17))) 1.0171505007093713e-19)
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (13) ((1 17))) 3.645093565786695e-22)
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (14) ((1 17))) 1.1205749502562039e-24)
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (15) ((1 17))) 2.987544193446809e-27)
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (16) ((1 17))) 6.973231093919469e-30)
  (f2cl-lib:fset (f2cl-lib:fref bi1cs (17) ((1 17))) 1.43679482206208e-32)
  (setq first f2cl-lib:%true%)
  (defun dbesi1 (x)
    (declare (type double-float x))
    (prog ((y 0.0) (dbesi1 0.0))
      (declare (type double-float dbesi1 y))
      (cond
       (first
        (setf nti1
                (initds bi1cs 17
                 (* 0.1f0 (f2cl-lib:freal (f2cl-lib:d1mach 3)))))
        (setf xmin (* 2.0 (f2cl-lib:d1mach 1)))
        (setf xsml (f2cl-lib:fsqrt (* 4.5 (f2cl-lib:d1mach 3))))
        (setf xmax (f2cl-lib:flog (f2cl-lib:d1mach 2)))))
      (setf first f2cl-lib:%false%)
      (setf y (coerce (abs x) 'double-float))
      (if (> y 3.0) (go label20))
      (setf dbesi1 0.0)
      (if (= y 0.0) (go end_label))
      (if (<= y xmin)
          (xermsg "SLATEC" "DBESI1" "ABS(X) SO SMALL I1 UNDERFLOWS" 1 1))
      (if (> y xmin) (setf dbesi1 (* 0.5 x)))
      (if (> y xsml)
          (setf dbesi1
                  (* x
                     (+ 0.875
                        (multiple-value-bind
                            (ret-val var-0 var-1 var-2)
                            (dcsevl (- (/ (* y y) 4.5) 1.0) bi1cs nti1)
                          (declare (ignore var-0 var-1))
                          (when var-2 (setf nti1 var-2))
                          ret-val)))))
      (go end_label)
     label20
      (if (> y xmax)
          (xermsg "SLATEC" "DBESI1" "ABS(X) SO BIG I1 OVERFLOWS" 2 2))
      (setf dbesi1
              (* (exp y)
                 (multiple-value-bind
                     (ret-val var-0)
                     (dbsi1e x)
                   (declare (ignore))
                   (when var-0 (setf x var-0))
                   ret-val)))
      (go end_label)
     end_label
      (return (values dbesi1 x)))))

