(declare-var x Int)
(declare-var y Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= x 1)  (inv-f x y)))

; trans rule for inv-f
(rule (=> (and (inv-f x y) (and (< x y) (= x! (+ x x)))) (inv-f x! y!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y) (not (or (not (<= y x)) (<= 1 x)))) ERROR))
(query ERROR)