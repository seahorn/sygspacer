(declare-var x Int)
(declare-var n Int)
(declare-var m Int)
(declare-var z1 Int)
(declare-var z2 Int)
(declare-var z3 Int)
(declare-var x! Int)
(declare-var n! Int)
(declare-var m! Int)
(declare-var z1! Int)
(declare-var z2! Int)
(declare-var z3! Int)
(declare-rel inv-f (Int Int Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= x 0) (= m 0))  (inv-f x n m z1 z2 z3)))

; trans rule for inv-f
(rule (=> (and (inv-f x n m z1 z2 z3) (or (and (and (and (< x n) (= x! (+ x 1))) (= n! n)) (= m! m)) (and (and (and (< x n) (= x! (+ x 1))) (= n! n)) (= m! x)))) (inv-f x! n! m! z1! z2! z3!)))

; prop rule for inv-f
(rule (=> (and (inv-f x n m z1 z2 z3) (not (not (and (and (<= n x) (< 0 n)) (or (<= n m) (< m 0)))))) ERROR))
(query ERROR)