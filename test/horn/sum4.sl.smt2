(declare-var i Int)
(declare-var sn Int)
(declare-var i! Int)
(declare-var sn! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= sn 0) (= i 1))  (inv-f i sn)))

; trans rule for inv-f
(rule (=> (and (inv-f i sn) (and (= i! (+ i 1)) (and (<= i 8) (= sn! (+ sn 1))))) (inv-f i! sn!)))

; prop rule for inv-f
(rule (=> (and (inv-f i sn) (not (or (<= i 8) (or (= sn 8) (= sn 0))))) ERROR))
(query ERROR)