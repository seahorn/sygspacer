(declare-var x Int)
(declare-var y Int)
(declare-var lock Int)
(declare-var v1 Int)
(declare-var v2 Int)
(declare-var v3 Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-var lock! Int)
(declare-var v1! Int)
(declare-var v2! Int)
(declare-var v3! Int)
(declare-rel inv-f (Int Int Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (or (and (= x y) (= lock 1)) (and (= (+ x 1) y) (= lock 0)))  (inv-f x y lock v1 v2 v3)))

; trans rule for inv-f
(rule (=> (and (inv-f x y lock v1 v2 v3) (or (and (and (not (= x y)) (= lock! 1)) (= x! y)) (and (and (and (not (= x y)) (= lock! 0)) (= x! y)) (= y! (+ y 1))))) (inv-f x! y! lock! v1! v2! v3!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y lock v1 v2 v3) (not (not (and (= x y) (not (= lock 1)))))) ERROR))
(query ERROR)