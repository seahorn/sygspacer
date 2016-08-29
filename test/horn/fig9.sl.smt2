(declare-var x Int)
(declare-var y Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= x 0) (= y 0))  (inv-f x y)))

; trans rule for inv-f
(rule (=> (and (inv-f x y) (and (= x! x) (and (<= 0 y) (= y! (+ x y))))) (inv-f x! y!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y) (not (<= 0 y))) ERROR))
(query ERROR)