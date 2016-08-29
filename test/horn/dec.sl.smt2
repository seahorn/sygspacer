(declare-var x Int)
(declare-var x! Int)
(declare-rel inv-f (Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= x 100)  (inv-f x)))

; trans rule for inv-f
(rule (=> (and (inv-f x) (and (< 0 x) (= x! (- x 1)))) (inv-f x!)))

; prop rule for inv-f
(rule (=> (and (inv-f x) (not (not (and (<= x 0) (not (= x 0)))))) ERROR))
(query ERROR)