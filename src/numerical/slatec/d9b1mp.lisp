;;; Compiled by f2cl version 2.0 beta on 2002/04/25 at 13:18:31
;;; 
;;; Options: ((:prune-labels nil) (:auto-save t) (:relaxed-array-decls t)
;;;           (:coerce-assigns :as-needed) (:array-type ':simple-array)
;;;           (:array-slicing nil) (:declare-common nil)
;;;           (:float-format double-float))

(in-package "SLATEC")


(let ((nbm1 0)
      (nbt12 0)
      (nbm12 0)
      (nbth1 0)
      (xmax 0.0)
      (bm1cs (make-array 37 :element-type 'double-float))
      (bt12cs (make-array 39 :element-type 'double-float))
      (bm12cs (make-array 40 :element-type 'double-float))
      (bth1cs (make-array 44 :element-type 'double-float))
      (pi4 0.7853981633974483)
      (first nil))
  (declare (type f2cl-lib:logical first)
           (type (simple-array double-float (44)) bth1cs)
           (type (simple-array double-float (40)) bm12cs)
           (type (simple-array double-float (39)) bt12cs)
           (type (simple-array double-float (37)) bm1cs)
           (type double-float pi4 xmax)
           (type f2cl-lib:integer4 nbth1 nbm12 nbt12 nbm1))
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (1) ((1 37))) 0.1069845452618063)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (2) ((1 37))) 0.003274915039715965)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (3) ((1 37))) -2.987783266831699e-5)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (4) ((1 37))) 8.331237177991975e-7)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (5) ((1 37))) -4.1126656903020076e-8)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (6) ((1 37))) 2.855344228789215e-9)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (7) ((1 37))) -2.4854083054156242e-10)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (8) ((1 37))) 2.5433933380725826e-11)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (9) ((1 37))) -2.941045772822968e-12)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (10) ((1 37))) 3.7433920254939035e-13)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (11) ((1 37))) -5.149118293821169e-14)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (12) ((1 37))) 7.552535949865143e-15)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (13) ((1 37))) -1.1694097068288464e-15)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (14) ((1 37))) 1.8965624494347916e-16)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (15) ((1 37))) -3.2019553686932867e-17)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (16) ((1 37))) 5.599548399316204e-18)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (17) ((1 37))) -1.0102158947304325e-18)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (18) ((1 37))) 1.873844985727563e-19)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (19) ((1 37))) -3.5635374703285805e-20)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (20) ((1 37))) 6.931283819971238e-21)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (21) ((1 37))) -1.3760594534065002e-21)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (22) ((1 37))) 2.78343078410708e-22)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (23) ((1 37))) -5.727595364320561e-23)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (24) ((1 37))) 1.1973614459188928e-23)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (25) ((1 37))) -2.539928509891872e-24)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (26) ((1 37))) 5.461378289657295e-25)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (27) ((1 37))) -1.1892113417733204e-25)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (28) ((1 37))) 2.6201509773400816e-26)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (29) ((1 37))) -5.836810774255686e-27)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (30) ((1 37))) 1.3137435000805958e-27)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (31) ((1 37))) -2.9858146225103804e-28)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (32) ((1 37))) 6.848390471334604e-29)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (33) ((1 37))) -1.5844015682224769e-29)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (34) ((1 37))) 3.6956410065709383e-30)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (35) ((1 37))) -8.687115921144668e-31)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (36) ((1 37))) 2.0570808461587634e-31)
  (f2cl-lib:fset (f2cl-lib:fref bm1cs (37) ((1 37))) -4.9052257611162253e-32)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (1) ((1 39))) 0.7382386012874298)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (2) ((1 39))) -0.003336111317448391)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (3) ((1 39))) 6.146345488804696e-5)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (4) ((1 39))) -2.4024585161602377e-6)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (5) ((1 39))) 1.4663555577509743e-7)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (6) ((1 39))) -1.1841917305589181e-8)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (7) ((1 39))) 1.1574198963919198e-9)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (8) ((1 39))) -1.3001161129439187e-10)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (9) ((1 39))) 1.6245391141361734e-11)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (10) ((1 39))) -2.2089636821403186e-12)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (11) ((1 39))) 3.218030425855318e-13)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (12) ((1 39))) -4.9653147932768493e-14)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (13) ((1 39))) 8.043890043284782e-15)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (14) ((1 39))) -1.3589121310161292e-15)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (15) ((1 39))) 2.3810504397147214e-16)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (16) ((1 39))) -4.30814663638491e-17)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (17) ((1 39))) 8.0202544032771e-18)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (18) ((1 39))) -1.531631064246231e-18)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (19) ((1 39))) 2.9928606352715575e-19)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (20) ((1 39))) -5.970996465808543e-20)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (21) ((1 39))) 1.2140289669415183e-20)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (22) ((1 39))) -2.511511469661295e-21)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (23) ((1 39))) 5.279056717032873e-22)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (24) ((1 39))) -1.12605092275505e-22)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (25) ((1 39))) 2.4348277359576326e-23)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (26) ((1 39))) -5.33172612369318e-24)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (27) ((1 39))) 1.181361505970712e-24)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (28) ((1 39))) -2.646536828335352e-25)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (29) ((1 39))) 5.990339404136149e-26)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (30) ((1 39))) -1.3690854630829505e-26)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (31) ((1 39))) 3.1576790154380235e-27)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (32) ((1 39))) -7.345791508208437e-28)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (33) ((1 39))) 1.722808148072275e-28)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (34) ((1 39))) -4.071690796128651e-29)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (35) ((1 39))) 9.693474513677961e-30)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (36) ((1 39))) -2.3237636337765707e-30)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (37) ((1 39))) 5.607451067352203e-31)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (38) ((1 39))) -1.3616465391539007e-31)
  (f2cl-lib:fset (f2cl-lib:fref bt12cs (39) ((1 39))) 3.326310923389466e-32)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (1) ((1 40))) 0.0980797915623305)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (2) ((1 40))) 0.0011509611895046854)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (3) ((1 40))) -4.3124821643382055e-6)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (4) ((1 40))) 5.951839610088816e-8)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (5) ((1 40))) -1.7048440198269102e-9)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (6) ((1 40))) 7.79826541361111e-11)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (7) ((1 40))) -4.9589861267664154e-12)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (8) ((1 40))) 4.0384324164211416e-13)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (9) ((1 40))) -3.993046163725175e-14)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (10) ((1 40))) 4.619886183118966e-15)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (11) ((1 40))) -6.089208019095383e-16)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (12) ((1 40))) 8.960930916433878e-17)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (13) ((1 40))) -1.4496294239420232e-17)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (14) ((1 40))) 2.546463158537776e-18)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (15) ((1 40))) -4.809472874647837e-19)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (16) ((1 40))) 9.6876846682926e-20)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (17) ((1 40))) -2.067213372277966e-20)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (18) ((1 40))) 4.6466515591503843e-21)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (19) ((1 40))) -1.0949661288483341e-21)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (20) ((1 40))) 2.693892797288682e-22)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (21) ((1 40))) -6.894992910930374e-23)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (22) ((1 40))) 1.830268262752063e-23)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (23) ((1 40))) -5.025064246351917e-24)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (24) ((1 40))) 1.4235451944548058e-24)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (25) ((1 40))) -4.15219120361645e-25)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (26) ((1 40))) 1.2446092015039792e-25)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (27) ((1 40))) -3.827336370569305e-26)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (28) ((1 40))) 1.2055913578156177e-26)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (29) ((1 40))) -3.884536246376488e-27)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (30) ((1 40))) 1.2786895287204098e-27)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (31) ((1 40))) -4.2951466894479473e-28)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (32) ((1 40))) 1.470689117829071e-28)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (33) ((1 40))) -5.128315665106074e-29)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (34) ((1 40))) 1.8195095854711693e-29)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (35) ((1 40))) -6.563031314841979e-30)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (36) ((1 40))) 2.4048989769199602e-30)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (37) ((1 40))) -8.945966744690612e-31)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (38) ((1 40))) 3.376085160657232e-31)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (39) ((1 40))) -1.2917914546206563e-31)
  (f2cl-lib:fset (f2cl-lib:fref bm12cs (40) ((1 40))) 5.008634462958811e-32)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (1) ((1 44))) 0.7474995720358728)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (2) ((1 44))) -0.0012400777144651713)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (3) ((1 44))) 9.925244240442455e-6)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (4) ((1 44))) -2.0303690737159705e-7)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (5) ((1 44))) 7.535961770569088e-9)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (6) ((1 44))) -4.1661612715343554e-10)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (7) ((1 44))) 3.070161807083489e-11)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (8) ((1 44))) -2.8178499637605214e-12)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (9) ((1 44))) 3.0790696739040296e-13)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (10) ((1 44))) -3.880330026280344e-14)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (11) ((1 44))) 5.509603960863091e-15)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (12) ((1 44))) -8.659006076838378e-16)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (13) ((1 44))) 1.4856049141536748e-16)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (14) ((1 44))) -2.7519529815904087e-17)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (15) ((1 44))) 5.455079609048109e-18)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (16) ((1 44))) -1.1486534501983645e-18)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (17) ((1 44))) 2.55352133779739e-19)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (18) ((1 44))) -5.962149019741345e-20)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (19) ((1 44))) 1.4556622902372718e-20)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (20) ((1 44))) -3.702218542245053e-21)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (21) ((1 44))) 9.776307412534536e-22)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (22) ((1 44))) -2.6726821639668485e-22)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (23) ((1 44))) 7.545330038498327e-23)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (24) ((1 44))) -2.1947899919802744e-23)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (25) ((1 44))) 6.564839462395526e-24)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (26) ((1 44))) -2.0155604298370206e-24)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (27) ((1 44))) 6.341776855677613e-25)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (28) ((1 44))) -2.0419277885337891e-25)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (29) ((1 44))) 6.719146422072056e-26)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (30) ((1 44))) -2.256907911020758e-26)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (31) ((1 44))) 7.729771989298971e-27)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (32) ((1 44))) -2.696744451229464e-27)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (33) ((1 44))) 9.57493445185027e-28)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (34) ((1 44))) -3.456916844889012e-28)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (35) ((1 44))) 1.268123481739844e-28)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (36) ((1 44))) -4.723253663072264e-29)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (37) ((1 44))) 1.7850008478186377e-29)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (38) ((1 44))) -6.840436100451038e-30)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (39) ((1 44))) 2.6566028671720415e-30)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (40) ((1 44))) -1.0450402527914451e-30)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (41) ((1 44))) 4.161829082537714e-31)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (42) ((1 44))) -1.6771639203643715e-31)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (43) ((1 44))) 6.836199777666438e-32)
  (f2cl-lib:fset (f2cl-lib:fref bth1cs (44) ((1 44))) -2.8172247861233646e-32)
  (setq first f2cl-lib:%true%)
  (defun d9b1mp (x ampl theta)
    (declare (type double-float theta ampl x))
    (prog ((z 0.0) (eta 0.0f0))
      (declare (type single-float eta) (type double-float z))
      (cond
       (first (setf eta (* 0.1f0 (f2cl-lib:freal (f2cl-lib:d1mach 3))))
              (setf nbm1
                      (multiple-value-bind
                          (ret-val var-0 var-1 var-2)
                          (initds bm1cs 37 eta)
                        (declare (ignore var-0 var-1))
                        (when var-2 (setf eta var-2))
                        ret-val))
              (setf nbt12
                      (multiple-value-bind
                          (ret-val var-0 var-1 var-2)
                          (initds bt12cs 39 eta)
                        (declare (ignore var-0 var-1))
                        (when var-2 (setf eta var-2))
                        ret-val))
              (setf nbm12
                      (multiple-value-bind
                          (ret-val var-0 var-1 var-2)
                          (initds bm12cs 40 eta)
                        (declare (ignore var-0 var-1))
                        (when var-2 (setf eta var-2))
                        ret-val))
              (setf nbth1
                      (multiple-value-bind
                          (ret-val var-0 var-1 var-2)
                          (initds bth1cs 44 eta)
                        (declare (ignore var-0 var-1))
                        (when var-2 (setf eta var-2))
                        ret-val))
              (setf xmax (/ 1.0 (f2cl-lib:d1mach 4)))))
      (setf first f2cl-lib:%false%)
      (cond
       ((< x 4.0) (xermsg "SLATEC" "D9B1MP" "X must be  >=  4" 1 2)
        (setf ampl 0.0) (setf theta 0.0))
       ((<= x 8.0) (setf z (/ (- (/ 128.0 (* x x)) 5.0) 3.0))
        (setf ampl
                (/
                 (+ 0.75
                    (multiple-value-bind
                        (ret-val var-0 var-1 var-2)
                        (dcsevl z bm1cs nbm1)
                      (declare (ignore var-1))
                      (when var-0 (setf z var-0))
                      (when var-2 (setf nbm1 var-2))
                      ret-val))
                 (f2cl-lib:fsqrt x)))
        (setf theta
                (+ (- x (* 3.0 pi4))
                   (/
                    (multiple-value-bind
                        (ret-val var-0 var-1 var-2)
                        (dcsevl z bt12cs nbt12)
                      (declare (ignore var-1))
                      (when var-0 (setf z var-0))
                      (when var-2 (setf nbt12 var-2))
                      ret-val)
                    x))))
       (t
        (if (> x xmax)
            (xermsg "SLATEC" "D9B1MP" "No precision because X is too big" 2 2))
        (setf z (- (/ 128.0 (* x x)) 1.0))
        (setf ampl
                (/
                 (+ 0.75
                    (multiple-value-bind
                        (ret-val var-0 var-1 var-2)
                        (dcsevl z bm12cs nbm12)
                      (declare (ignore var-1))
                      (when var-0 (setf z var-0))
                      (when var-2 (setf nbm12 var-2))
                      ret-val))
                 (f2cl-lib:fsqrt x)))
        (setf theta
                (+ (- x (* 3.0 pi4))
                   (/
                    (multiple-value-bind
                        (ret-val var-0 var-1 var-2)
                        (dcsevl z bth1cs nbth1)
                      (declare (ignore var-1))
                      (when var-0 (setf z var-0))
                      (when var-2 (setf nbth1 var-2))
                      ret-val)
                    x)))))
      (go end_label)
     end_label
      (return (values nil ampl theta)))))

