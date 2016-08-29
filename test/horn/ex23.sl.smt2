(declare-var y Int)
(declare-var z Int)
(declare-var c Int)
(declare-var y! Int)
(declare-var z! Int)
(declare-var c! Int)
(declare-rel inv-f (Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (and (= c 0) (<= 0 y)) (and (<= y 127) (= z (* 36 y))))  (inv-f y z c)))

; trans rule for inv-f
(rule (=> (and (inv-f y z c) (and (and (and (< c 36) (= z! (+ z 1))) (= c! (+ c 1))) (= y! y))) (inv-f y! z! c!)))

; prop rule for inv-f
(rule (=> (and (inv-f y z c) (not (not (and (< c 36) (or (< z 0) (<= 4608 z)))))) ERROR))
(query ERROR)