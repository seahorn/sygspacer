(declare-var x Int)
(declare-var n Int)
(declare-var m Int)
(declare-var x! Int)
(declare-var n! Int)
(declare-var m! Int)
(declare-rel inv-f (Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= x 0) (= m 0))  (inv-f x n m)))

; trans rule for inv-f
(rule (=> (and (inv-f x n m) (or (and (and (and (< x n) (= x! (+ x 1))) (= n! n)) (= m! m)) (and (and (and (< x n) (= x! (+ x 1))) (= n! n)) (= m! x)))) (inv-f x! n! m!)))

; prop rule for inv-f
(rule (=> (and (inv-f x n m) (not (not (and (and (<= n x) (< 0 n)) (or (<= n m) (< m 0)))))) ERROR))
(query ERROR)