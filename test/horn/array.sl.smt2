(declare-var x Int)
(declare-var y Int)
(declare-var z Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-var z! Int)
(declare-rel inv-f (Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= x 0)  (inv-f x y z)))

; trans rule for inv-f
(rule (=> (and (inv-f x y z) (or (and (= x! (+ x 1)) (and (= y! z!) (and (<= z! y) (< x 5)))) (and (= x! (+ x 1)) (and (= y! y) (and (< y z!) (< x 5)))))) (inv-f x! y! z!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y z) (not (not (and (<= 5 x) (< z y))))) ERROR))
(query ERROR)