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
(rule (=> (= x (- 15000))  (inv-f x y z1 z2 z3)))

; trans rule for inv-f
(rule (=> (and (inv-f x y z1 z2 z3) (and (and (< x 0) (= x! (+ x y))) (= y! (+ y 1)))) (inv-f x! y! z1! z2! z3!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y z1 z2 z3) (not (not (and (<= 0 x) (<= y 0))))) ERROR))
(query ERROR)