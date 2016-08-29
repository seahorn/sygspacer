(declare-var i Int)
(declare-var n Int)
(declare-var sn Int)
(declare-var v1 Int)
(declare-var v2 Int)
(declare-var v3 Int)
(declare-var i! Int)
(declare-var n! Int)
(declare-var sn! Int)
(declare-var v1! Int)
(declare-var v2! Int)
(declare-var v3! Int)
(declare-rel inv-f (Int Int Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= sn 0) (= i 1))  (inv-f i n sn v1 v2 v3)))

; trans rule for inv-f
(rule (=> (and (inv-f i n sn v1 v2 v3) (and (= n! n) (and (= i! (+ i 1)) (and (<= i n) (= sn! (+ sn 1)))))) (inv-f i! n! sn! v1! v2! v3!)))

; prop rule for inv-f
(rule (=> (and (inv-f i n sn v1 v2 v3) (not (or (<= i n) (or (= sn n) (= sn 0))))) ERROR))
(query ERROR)