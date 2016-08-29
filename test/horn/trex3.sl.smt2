(declare-var x1 Int)
(declare-var x2 Int)
(declare-var x3 Int)
(declare-var d1 Int)
(declare-var d2 Int)
(declare-var d3 Int)
(declare-var x1! Int)
(declare-var x2! Int)
(declare-var x3! Int)
(declare-var d1! Int)
(declare-var d2! Int)
(declare-var d3! Int)
(declare-rel inv-f (Int Int Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= d1 1) (and (= d2 1) (= d3 1)))  (inv-f x1 x2 x3 d1 d2 d3)))

; trans rule for inv-f
(rule (=> (and (inv-f x1 x2 x3 d1 d2 d3) (or (and (and (= x2! x2) (and (= x3! x3) (and (= d1! d1) (and (= d2! d2) (= d3! d3))))) (and (< 0 x1) (and (< 0 x2) (and (< 0 x3) (= x1! (+ x1 (- 0 d1))))))) (or (and (and (= x1! x1) (and (= x3! x3) (and (= d1! d1) (and (= d2! d2) (= d3! d3))))) (and (< 0 x1) (and (< 0 x2) (and (< 0 x3) (= x2! (+ x2 (- 0 d2))))))) (and (and (= x1! x1) (and (= x2! x2) (and (= d1! d1) (and (= d2! d2) (= d3! d3))))) (and (< 0 x1) (and (< 0 x2) (and (< 0 x3) (= x3! (+ x3 (- 0 d3)))))))))) (inv-f x1! x2! x3! d1! d2! d3!)))

; prop rule for inv-f
(rule (=> (and (inv-f x1 x2 x3 d1 d2 d3) (not (or (< x1 0) (or (< x2 0) (or (< x3 0) (or (= x1 0) (or (= x2 0) (= x3 0)))))))) ERROR))
(query ERROR)