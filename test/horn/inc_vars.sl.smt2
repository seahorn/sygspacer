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
(rule (=> (= x 0)  (inv-f x n v1 v2 v3)))

; trans rule for inv-f
(rule (=> (and (inv-f x n v1 v2 v3) (and (= n! n) (and (< x n) (= x! (+ x 1))))) (inv-f x! n! v1! v2! v3!)))

; prop rule for inv-f
(rule (=> (and (inv-f x n v1 v2 v3) (not (or (not (<= n x)) (or (= x n) (< n 0))))) ERROR))
(query ERROR)