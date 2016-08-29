(declare-var x Int)
(declare-var y Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= x 1)  (inv-f x y)))

; trans rule for inv-f
(rule (=> (and (inv-f x y) (and (and (<= x 100) (= y! (- 100 x))) (= x! (+ x 1)))) (inv-f x! y!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y) (not (not (and (and (<= x 100) (= y (- 100 x))) (or (<= 100 y) (< y 0)))))) ERROR))
(query ERROR)