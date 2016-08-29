(declare-var x1 Int)
(declare-var x2 Int)
(declare-var x3 Int)
(declare-var x4 Int)
(declare-var x5 Int)
(declare-var x1! Int)
(declare-var x2! Int)
(declare-var x3! Int)
(declare-var x4! Int)
(declare-var x5! Int)
(declare-rel inv-f (Int Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (and (and (= x1 0) (and (= x2 0) (= x3 0))) (= x4 0)) (= x5 0))  (inv-f x1 x2 x3 x4 x5)))

; trans rule for inv-f
(rule (=> (and (inv-f x1 x2 x3 x4 x5) (and (<= 0 x1!) (and (<= x1! (+ x4! 1)) (and (= x2! x3!) (and (= 0 x5!) (or (<= x2! (- 1)) (<= x4! (+ x2! 2)))))))) (inv-f x1! x2! x3! x4! x5!)))

; prop rule for inv-f
(rule (=> (and (inv-f x1 x2 x3 x4 x5) (not (and (<= 0 x1) (and (<= x1 (+ x4 1)) (and (= x2 x3) (and (= 0 x5) (or (<= x2 (- 1)) (<= x4 (+ x2 2))))))))) ERROR))
(query ERROR)