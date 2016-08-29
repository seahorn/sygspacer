(declare-var x Int)
(declare-var y Int)
(declare-var z Int)
(declare-var v1 Int)
(declare-var v2 Int)
(declare-var v3 Int)
(declare-var size Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-var z! Int)
(declare-var v1! Int)
(declare-var v2! Int)
(declare-var v3! Int)
(declare-var size! Int)
(declare-rel inv-f (Int Int Int Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= x 0)  (inv-f x y z v1 v2 v3 size)))

; trans rule for inv-f
(rule (=> (and (inv-f x y z v1 v2 v3 size) (or (and (= x! (+ x 1)) (and (= y! z!) (and (<= z! y) (< x size)))) (and (= x! (+ x 1)) (and (= y! y) (and (< y z!) (< x size)))))) (inv-f x! y! z! v1! v2! v3! size!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y z v1 v2 v3 size) (not (not (and (and (<= size x) (< z y)) (< 0 size))))) ERROR))
(query ERROR)