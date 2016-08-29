(declare-var x Int)
(declare-var y Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= x (- 50))  (inv-f x y)))

; trans rule for inv-f
(rule (=> (and (inv-f x y) (and (and (< x 0) (= x! (+ x y))) (= y! (+ y 1)))) (inv-f x! y!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y) (not (not (and (<= 0 x) (<= y 0))))) ERROR))
(query ERROR)