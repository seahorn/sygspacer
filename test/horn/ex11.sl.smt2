(declare-var c Int)
(declare-var c! Int)
(declare-rel inv-f (Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= c 0)  (inv-f c)))

; trans rule for inv-f
(rule (=> (and (inv-f c) (or (and (not (= c 4)) (= c! (+ c 1))) (and (= c 4) (= c! 1)))) (inv-f c!)))

; prop rule for inv-f
(rule (=> (and (inv-f c) (not (not (and (not (= c 4)) (or (< c 0) (< 4 c)))))) ERROR))
(query ERROR)