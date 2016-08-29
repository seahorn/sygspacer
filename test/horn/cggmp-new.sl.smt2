(declare-var i Int)
(declare-var j Int)
(declare-var i! Int)
(declare-var j! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= i 1) (= j 20))  (inv-f i j)))

; trans rule for inv-f
(rule (=> (and (inv-f i j) (and (and (<= i j) (= i! (+ i 2))) (= j! (- j 1)))) (inv-f i! j!)))

; prop rule for inv-f
(rule (=> (and (inv-f i j) (not (not (and (< j i) (not (= j 13)))))) ERROR))
(query ERROR)