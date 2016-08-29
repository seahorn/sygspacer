(declare-var i Int)
(declare-var n Int)
(declare-var sn Int)
(declare-var i! Int)
(declare-var n! Int)
(declare-var sn! Int)
(declare-rel inv-f (Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= sn 0) (= i 1))  (inv-f i n sn)))

; trans rule for inv-f
(rule (=> (and (inv-f i n sn) (and (= n! n) (and (= i! (+ i 1)) (and (<= i n) (= sn! (+ sn 1)))))) (inv-f i! n! sn!)))

; prop rule for inv-f
(rule (=> (and (inv-f i n sn) (not (or (<= i n) (or (= sn n) (= sn 0))))) ERROR))
(query ERROR)