(declare-var x1 Int)
(declare-var x2 Int)
(declare-var x3 Int)
(declare-var x1! Int)
(declare-var x2! Int)
(declare-var x3! Int)
(declare-rel inv-f (Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= x1 0) (and (= x2 0) (= x3 0)))  (inv-f x1 x2 x3)))

; trans rule for inv-f
(rule (=> (and (inv-f x1 x2 x3) (and (<= x1! x2!) (or (<= 0 x2!) (<= (- x2! x3!) 2)))) (inv-f x1! x2! x3!)))

; prop rule for inv-f
(rule (=> (and (inv-f x1 x2 x3) (not (and (<= x1 x2) (or (<= 0 x2) (<= (- x2 x3) 2))))) ERROR))
(query ERROR)