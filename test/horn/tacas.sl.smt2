(declare-var i Int)
(declare-var j Int)
(declare-var x Int)
(declare-var y Int)
(declare-var i! Int)
(declare-var j! Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-rel inv-f (Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= i x) (= j y))  (inv-f i j x y)))

; trans rule for inv-f
(rule (=> (and (inv-f i j x y) (and (= i! i) (and (= j! j) (and (not (= x 0)) (and (= x! (- x 1)) (= y! (- y 1))))))) (inv-f i! j! x! y!)))

; prop rule for inv-f
(rule (=> (and (inv-f i j x y) (not (or (not (= x 0)) (or (not (= i j)) (= y 0))))) ERROR))
(query ERROR)