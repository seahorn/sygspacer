(declare-var x Int)
(declare-var y Int)
(declare-var i Int)
(declare-var z1 Int)
(declare-var z2 Int)
(declare-var z3 Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-var i! Int)
(declare-var z1! Int)
(declare-var z2! Int)
(declare-var z3! Int)
(declare-rel inv-f (Int Int Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (and (and (= i 0) (<= 0 x)) (<= 0 y)) (<= y x))  (inv-f x y i z1 z2 z3)))

; trans rule for inv-f
(rule (=> (and (inv-f x y i z1 z2 z3) (and (and (< i y) (= i! (+ i 1))) (and (= y! y) (= x! x)))) (inv-f x! y! i! z1! z2! z3!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y i z1 z2 z3) (not (not (and (< i y) (or (<= x i) (< i 0)))))) ERROR))
(query ERROR)