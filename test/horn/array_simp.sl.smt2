(declare-var x Int)
(declare-var y Int)
(declare-var z Int)
(declare-var size Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-var z! Int)
(declare-var size! Int)
(declare-rel inv-f (Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= x 0)  (inv-f x y z size)))

; trans rule for inv-f
(rule (=> (and (inv-f x y z size) (or (and (= x! (+ x 1)) (and (= y! z!) (and (<= z! y) (< x size)))) (and (= x! (+ x 1)) (and (= y! y) (and (< y z!) (< x size)))))) (inv-f x! y! z! size!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y z size) (not (not (and (and (<= size x) (< z y)) (< 0 size))))) ERROR))
(query ERROR)