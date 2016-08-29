(declare-var x Int)
(declare-var y Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (and (<= 0 x) (and (<= x 2) (<= y 2))) (<= 0 y))  (inv-f x y)))

; trans rule for inv-f
(rule (=> (and (inv-f x y) (and (= x! (+ x 2)) (= y! (+ y 2)))) (inv-f x! y!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y) (not (not (and (= x 4) (= y 0))))) ERROR))
(query ERROR)