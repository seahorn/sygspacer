(declare-var x1 Int)
(declare-var x2 Int)
(declare-var x3 Int)
(declare-var x4 Int)
(declare-var x1! Int)
(declare-var x2! Int)
(declare-var x3! Int)
(declare-var x4! Int)
(declare-rel inv-f (Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (and (= x1 0) (and (= x2 0) (= x3 0))) (= x4 (- 1)))  (inv-f x1 x2 x3 x4)))

; trans rule for inv-f
(rule (=> (and (inv-f x1 x2 x3 x4) (and (<= x1! 0) (and (<= (+ x4! 1) x1!) (and (= x2! x3!) (or (<= 0 x4!) (<= x4! x3!)))))) (inv-f x1! x2! x3! x4!)))

; prop rule for inv-f
(rule (=> (and (inv-f x1 x2 x3 x4) (not (and (<= x1 0) (and (<= (+ x4 1) x1) (and (= x2 x3) (or (<= 0 x4) (<= x4 x3))))))) ERROR))
(query ERROR)