(declare-var x Int)
(declare-var n Int)
(declare-var x! Int)
(declare-var n! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= x 0) (<= 0 n))  (inv-f x n)))

; trans rule for inv-f
(rule (=> (and (inv-f x n) (and (= n! n) (and (< x n) (= x! (+ x 1))))) (inv-f x! n!)))

; prop rule for inv-f
(rule (=> (and (inv-f x n) (not (or (not (<= n x)) (= x n)))) ERROR))
(query ERROR)