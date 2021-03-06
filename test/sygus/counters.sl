(set-logic LIA)

(synth-inv str_invariant(
  (top.usr.inc@0 Bool)
  (top.usr.rst_c1@0 Bool)
  (top.usr.rst@0 Bool)
  (top.usr.o1@0 Bool)
  (top.usr.o2@0 Bool)
  (top.usr.ok@0 Bool)
  (top.res.init_flag@0 Bool)
  (top.impl.usr.c1@0 Int)
  (top.impl.usr.c2@0 Int) 
))

(declare-primed-var top.usr.inc@0 Bool)
(declare-primed-var top.usr.rst_c1@0 Bool)
(declare-primed-var top.usr.rst@0 Bool)
(declare-primed-var top.usr.o1@0 Bool)
(declare-primed-var top.usr.o2@0 Bool)
(declare-primed-var top.usr.ok@0 Bool)
(declare-primed-var top.res.init_flag@0 Bool)
(declare-primed-var top.impl.usr.c1@0 Int)
(declare-primed-var top.impl.usr.c2@0 Int)

(define-fun
  init (
    (top.usr.inc@0 Bool)
    (top.usr.rst_c1@0 Bool)
    (top.usr.rst@0 Bool)
    (top.usr.o1@0 Bool)
    (top.usr.o2@0 Bool)
    (top.usr.ok@0 Bool)
    (top.res.init_flag@0 Bool)
    (top.impl.usr.c1@0 Int)
    (top.impl.usr.c2@0 Int)
  ) Bool
  
  (let
   ((X1 0))
   (let
    ((X2 0))
    (and
     (=
      top.impl.usr.c2@0
      (ite top.usr.rst@0 0 (ite (and top.usr.inc@0 (< X1 6)) (+ X1 1) X1)))
     (=
      top.impl.usr.c1@0
      (ite
       (or top.usr.rst_c1@0 top.usr.rst@0)
       0
       (ite (and top.usr.inc@0 (< X2 10)) (+ X2 1) X2)))
     (= top.usr.o2@0 (= top.impl.usr.c2@0 6))
     (= top.usr.o1@0 (= top.impl.usr.c1@0 10))
     (= top.usr.ok@0 (=> top.usr.o1@0 top.usr.o2@0))
     top.res.init_flag@0)))
)

(define-fun
  trans (
    
    ;; Current state.
    (top.usr.inc@0 Bool)
    (top.usr.rst_c1@0 Bool)
    (top.usr.rst@0 Bool)
    (top.usr.o1@0 Bool)
    (top.usr.o2@0 Bool)
    (top.usr.ok@0 Bool)
    (top.res.init_flag@0 Bool)
    (top.impl.usr.c1@0 Int)
    (top.impl.usr.c2@0 Int)
    
    ;; Next state.
    (top.usr.inc@1 Bool)
    (top.usr.rst_c1@1 Bool)
    (top.usr.rst@1 Bool)
    (top.usr.o1@1 Bool)
    (top.usr.o2@1 Bool)
    (top.usr.ok@1 Bool)
    (top.res.init_flag@1 Bool)
    (top.impl.usr.c1@1 Int)
    (top.impl.usr.c2@1 Int)
  
  ) Bool
  
  (let
   ((X1 top.impl.usr.c2@0))
   (let
    ((X2 top.impl.usr.c1@0))
    (and
     (=
      top.impl.usr.c2@1
      (ite top.usr.rst@1 0 (ite (and top.usr.inc@1 (< X1 6)) (+ X1 1) X1)))
     (=
      top.impl.usr.c1@1
      (ite
       (or top.usr.rst_c1@1 top.usr.rst@1)
       0
       (ite (and top.usr.inc@1 (< X2 10)) (+ X2 1) X2)))
     (= top.usr.o2@1 (= top.impl.usr.c2@1 6))
     (= top.usr.o1@1 (= top.impl.usr.c1@1 10))
     (= top.usr.ok@1 (=> top.usr.o1@1 top.usr.o2@1))
     (not top.res.init_flag@1))))
)

(define-fun
  prop (
    (top.usr.inc@0 Bool)
    (top.usr.rst_c1@0 Bool)
    (top.usr.rst@0 Bool)
    (top.usr.o1@0 Bool)
    (top.usr.o2@0 Bool)
    (top.usr.ok@0 Bool)
    (top.res.init_flag@0 Bool)
    (top.impl.usr.c1@0 Int)
    (top.impl.usr.c2@0 Int)
  ) Bool
  
  top.usr.ok@0
)

(inv-constraint str_invariant init trans prop)

(check-synth)
