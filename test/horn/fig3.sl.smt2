(declare-var x Int)
(declare-var y Int)
(declare-var lock Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-var lock! Int)
(declare-rel inv-f (Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (or (and (= x y) (= lock 1)) (and (= (+ x 1) y) (= lock 0)))  (inv-f x y lock)))

; trans rule for inv-f
(rule (=> (and (inv-f x y lock) (or (and (and (not (= x y)) (= lock! 1)) (= x! y)) (and (and (and (not (= x y)) (= lock! 0)) (= x! y)) (= y! (+ y 1))))) (inv-f x! y! lock!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y lock) (not (not (and (= x y) (not (= lock 1)))))) ERROR))
(query ERROR)