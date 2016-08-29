(declare-var x Int)
(declare-var y Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= x 1)  (inv-f x y)))

; trans rule for inv-f
(rule (=> (and (inv-f x y) (and (and (<= x 10) (= y! (- 10 x))) (= x! (+ x 1)))) (inv-f x! y!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y) (not (not (and (and (<= x 10) (= y (- 10 x))) (or (<= 10 y) (< y 0)))))) ERROR))
(query ERROR)