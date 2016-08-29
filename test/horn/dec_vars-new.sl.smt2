(declare-var x Int)
(declare-var n Int)
(declare-var v1 Int)
(declare-var v2 Int)
(declare-var v3 Int)
(declare-var x! Int)
(declare-var n! Int)
(declare-var v1! Int)
(declare-var v2! Int)
(declare-var v3! Int)
(declare-rel inv-f (Int Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= x n)  (inv-f x n v1 v2 v3)))

; trans rule for inv-f
(rule (=> (and (inv-f x n v1 v2 v3) (and (and (< 1 x) (= x! (- x 1))) (= n! n))) (inv-f x! n! v1! v2! v3!)))

; prop rule for inv-f
(rule (=> (and (inv-f x n v1 v2 v3) (not (not (and (<= x 1) (and (not (= x 1)) (<= 0 n)))))) ERROR))
(query ERROR)