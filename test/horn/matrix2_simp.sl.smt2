(declare-var m Int)
(declare-var a Int)
(declare-var j Int)
(declare-var k Int)
(declare-var r Int)
(declare-var c Int)
(declare-var m! Int)
(declare-var a! Int)
(declare-var j! Int)
(declare-var k! Int)
(declare-var r! Int)
(declare-var c! Int)
(declare-rel inv-f (Int Int Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (or (<= a m) (= j 0)) (and (< j r) (= k 0)))  (inv-f m a j k r c)))

; trans rule for inv-f
(rule (=> (and (inv-f m a j k r c) (or (and (and (= j! j) (and (= r! r) (= c! c))) (and (< k c) (and (< m a!) (and (= m! a!) (= k! (+ k 1)))))) (and (= j! j) (and (= r! r) (and (= c! c) (and (< k c) (and (< a! m) (= k! (+ k 1))))))))) (inv-f m! a! j! k! r! c!)))

; prop rule for inv-f
(rule (=> (and (inv-f m a j k r c) (not (or (< k c) (or (<= a m) (= j (- 1)))))) ERROR))
(query ERROR)