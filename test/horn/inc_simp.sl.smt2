(declare-var x Int)
(declare-var n Int)
(declare-var x! Int)
(declare-var n! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= x 0)  (inv-f x n)))

; trans rule for inv-f
(rule (=> (and (inv-f x n) (and (= n! n) (and (< x n) (= x! (+ x 1))))) (inv-f x! n!)))

; prop rule for inv-f
(rule (=> (and (inv-f x n) (not (or (not (<= n x)) (or (= x n) (< n 0))))) ERROR))
(query ERROR)