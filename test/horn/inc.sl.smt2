(declare-var x Int)
(declare-var x! Int)
(declare-rel inv-f (Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= x 0)  (inv-f x)))

; trans rule for inv-f
(rule (=> (and (inv-f x) (and (< x 100) (= x! (+ x 1)))) (inv-f x!)))

; prop rule for inv-f
(rule (=> (and (inv-f x) (not (or (not (<= 100 x)) (= x 100)))) ERROR))
(query ERROR)