(declare-var x Int)
(declare-var y Int)
(declare-var n Int)
(declare-var v1 Int)
(declare-var v2 Int)
(declare-var v3 Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-var n! Int)
(declare-var v1! Int)
(declare-var v2! Int)
(declare-var v3! Int)
(declare-rel inv-f (Int Int Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= x 1)  (inv-f x y n v1 v2 v3)))

; trans rule for inv-f
(rule (=> (and (inv-f x y n v1 v2 v3) (and (and (<= x n) (= y! (- n x))) (= x! (+ x 1)))) (inv-f x! y! n! v1! v2! v3!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y n v1 v2 v3) (not (not (and (and (<= x n) (= y (- n x))) (or (<= n y) (< y 0)))))) ERROR))
(query ERROR)