(declare-var m Int)
(declare-var a Int)
(declare-var j Int)
(declare-var k Int)
(declare-var m! Int)
(declare-var a! Int)
(declare-var j! Int)
(declare-var k! Int)
(declare-rel inv-f (Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (or (<= a m) (= j 0)) (and (< j 1) (= k 0)))  (inv-f m a j k)))

; trans rule for inv-f
(rule (=> (and (inv-f m a j k) (or (and (= j! j) (and (< k 1) (and (< m a!) (and (= m! a!) (= k! (+ k 1)))))) (and (= j! j) (and (< k 1) (and (< a! m) (= k! (+ k 1))))))) (inv-f m! a! j! k!)))

; prop rule for inv-f
(rule (=> (and (inv-f m a j k) (not (or (< k 1) (or (< a m) (= j (- 1)))))) ERROR))
(query ERROR)