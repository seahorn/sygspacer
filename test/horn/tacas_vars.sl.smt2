(declare-var i Int)
(declare-var j Int)
(declare-var x Int)
(declare-var y Int)
(declare-var z1 Int)
(declare-var z2 Int)
(declare-var z3 Int)
(declare-var i! Int)
(declare-var j! Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-var z1! Int)
(declare-var z2! Int)
(declare-var z3! Int)
(declare-rel inv-f (Int Int Int Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= i x) (= j y))  (inv-f i j x y z1 z2 z3)))

; trans rule for inv-f
(rule (=> (and (inv-f i j x y z1 z2 z3) (and (= i! i) (and (= j! j) (and (not (= x 0)) (and (= x! (- x 1)) (= y! (- y 1))))))) (inv-f i! j! x! y! z1! z2! z3!)))

; prop rule for inv-f
(rule (=> (and (inv-f i j x y z1 z2 z3) (not (or (not (= x 0)) (or (not (= i j)) (= y 0))))) ERROR))
(query ERROR)