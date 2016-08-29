(declare-var x Int)
(declare-var n Int)
(declare-var x! Int)
(declare-var n! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= x n)  (inv-f x n)))

; trans rule for inv-f
(rule (=> (and (inv-f x n) (and (and (< 1 x) (= x! (- x 1))) (= n! n))) (inv-f x! n!)))

; prop rule for inv-f
(rule (=> (and (inv-f x n) (not (not (and (<= x 1) (and (not (= x 1)) (<= 0 n)))))) ERROR))
(query ERROR)