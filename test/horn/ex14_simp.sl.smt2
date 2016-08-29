(declare-var x Int)
(declare-var y Int)
(declare-var n Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-var n! Int)
(declare-rel inv-f (Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= x 1)  (inv-f x y n)))

; trans rule for inv-f
(rule (=> (and (inv-f x y n) (and (and (<= x n) (= y! (- n x))) (= x! (+ x 1)))) (inv-f x! y! n!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y n) (not (not (and (and (<= x n) (= y (- n x))) (or (<= n y) (< y 0)))))) ERROR))
(query ERROR)