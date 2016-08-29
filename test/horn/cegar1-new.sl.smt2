(declare-var x Int)
(declare-var y Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (and (<= 0 x) (and (<= x 10) (<= y 10))) (<= 0 y))  (inv-f x y)))

; trans rule for inv-f
(rule (=> (and (inv-f x y) (and (= x! (+ x 10)) (= y! (+ y 10)))) (inv-f x! y!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y) (not (not (and (= x 20) (= y 0))))) ERROR))
(query ERROR)