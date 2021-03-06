(declare-var x Int)
(declare-var y Int)
(declare-var z1 Int)
(declare-var z2 Int)
(declare-var z3 Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-var z1! Int)
(declare-var z2! Int)
(declare-var z3! Int)
(declare-rel inv-f (Int Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= x 0) (= y 0))  (inv-f x y z1 z2 z3)))

; trans rule for inv-f
(rule (=> (and (inv-f x y z1 z2 z3) (and (= x! x) (and (<= 0 y) (= y! (+ x y))))) (inv-f x! y! z1! z2! z3!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y z1 z2 z3) (not (<= 0 y))) ERROR))
(query ERROR)