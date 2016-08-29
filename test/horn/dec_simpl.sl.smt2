(declare-var x Int)
(declare-var n Int)
(declare-var x! Int)
(declare-var n! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= x n)  (inv-f x n)))

; trans rule for inv-f
(rule (=> (and (inv-f x n) (and (and (< 0 x) (= x! (- x 1))) (= n! n))) (inv-f x! n!)))

; prop rule for inv-f
(rule (=> (and (inv-f x n) (not (not (and (<= x 0) (and (not (= x 0)) (<= 0 n)))))) ERROR))
(query ERROR)