(declare-var x Int)
(declare-var y Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= x 1) (= y 0))  (inv-f x y)))

; trans rule for inv-f
(rule (=> (and (inv-f x y) (and (and (< y 1000) (= x! (+ x y))) (= y! (+ y 1)))) (inv-f x! y!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y) (not (not (and (<= 1000 y) (< x y))))) ERROR))
(query ERROR)