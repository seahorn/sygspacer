(declare-var top.usr.inc@0 Bool)
(declare-var top.usr.rst_c1@0 Bool)
(declare-var top.usr.rst@0 Bool)
(declare-var top.usr.o1@0 Bool)
(declare-var top.usr.o2@0 Bool)
(declare-var top.usr.ok@0 Bool)
(declare-var top.res.init_flag@0 Bool)
(declare-var top.impl.usr.c1@0 Int)
(declare-var top.impl.usr.c2@0 Int)
(declare-var top.usr.inc@1 Bool)
(declare-var top.usr.rst_c1@1 Bool)
(declare-var top.usr.rst@1 Bool)
(declare-var top.usr.o1@1 Bool)
(declare-var top.usr.o2@1 Bool)
(declare-var top.usr.ok@1 Bool)
(declare-var top.res.init_flag@1 Bool)
(declare-var top.impl.usr.c1@1 Int)
(declare-var top.impl.usr.c2@1 Int)
(declare-rel str_invariant (Bool Bool Bool Bool Bool Bool Bool Int Int))
(declare-rel ERROR () )

; init rule for str_invariant
(rule (=> (and (= top.impl.usr.c2@0 (ite top.usr.rst@0 0 (ite (and top.usr.inc@0 (< 0 6)) (+ 0 1) 0))) (= top.impl.usr.c1@0 (ite (or top.usr.rst_c1@0 top.usr.rst@0) 0 (ite (and top.usr.inc@0 (< 0 10)) (+ 0 1) 0))) (= top.usr.o2@0 (= top.impl.usr.c2@0 6)) (= top.usr.o1@0 (= top.impl.usr.c1@0 10)) (= top.usr.ok@0 (=> top.usr.o1@0 top.usr.o2@0)) top.res.init_flag@0)  (str_invariant top.usr.inc@0 top.usr.rst_c1@0 top.usr.rst@0 top.usr.o1@0 top.usr.o2@0 top.usr.ok@0 top.res.init_flag@0 top.impl.usr.c1@0 top.impl.usr.c2@0)))

; trans rule for str_invariant
(rule (=> (and (str_invariant top.usr.inc@0 top.usr.rst_c1@0 top.usr.rst@0 top.usr.o1@0 top.usr.o2@0 top.usr.ok@0 top.res.init_flag@0 top.impl.usr.c1@0 top.impl.usr.c2@0) (and (= top.impl.usr.c2@1 (ite top.usr.rst@1 0 (ite (and top.usr.inc@1 (< top.impl.usr.c2@0 6)) (+ top.impl.usr.c2@0 1) top.impl.usr.c2@0))) (= top.impl.usr.c1@1 (ite (or top.usr.rst_c1@1 top.usr.rst@1) 0 (ite (and top.usr.inc@1 (< top.impl.usr.c1@0 10)) (+ top.impl.usr.c1@0 1) top.impl.usr.c1@0))) (= top.usr.o2@1 (= top.impl.usr.c2@1 6)) (= top.usr.o1@1 (= top.impl.usr.c1@1 10)) (= top.usr.ok@1 (=> top.usr.o1@1 top.usr.o2@1)) (not top.res.init_flag@1))) (str_invariant top.usr.inc@1 top.usr.rst_c1@1 top.usr.rst@1 top.usr.o1@1 top.usr.o2@1 top.usr.ok@1 top.res.init_flag@1 top.impl.usr.c1@1 top.impl.usr.c2@1)))

; prop rule for str_invariant
(rule (=> (and (str_invariant top.usr.inc@0 top.usr.rst_c1@0 top.usr.rst@0 top.usr.o1@0 top.usr.o2@0 top.usr.ok@0 top.res.init_flag@0 top.impl.usr.c1@0 top.impl.usr.c2@0) (not top.usr.ok@0)) ERROR))
(query ERROR)