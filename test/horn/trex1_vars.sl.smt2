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
(rule (=> (= x 1)  (inv-f x y z1 z2 z3)))

; trans rule for inv-f
(rule (=> (and (inv-f x y z1 z2 z3) (and (< x y) (= x! (+ x x)))) (inv-f x! y! z1! z2! z3!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y z1 z2 z3) (not (or (not (<= y x)) (<= 1 x)))) ERROR))
(query ERROR)