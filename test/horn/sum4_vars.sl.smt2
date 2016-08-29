(declare-var i Int)
(declare-var sn Int)
(declare-var size Int)
(declare-var v1 Int)
(declare-var v2 Int)
(declare-var v3 Int)
(declare-var i! Int)
(declare-var sn! Int)
(declare-var size! Int)
(declare-var v1! Int)
(declare-var v2! Int)
(declare-var v3! Int)
(declare-rel inv-f (Int Int Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= sn 0) (= i 1))  (inv-f i sn size v1 v2 v3)))

; trans rule for inv-f
(rule (=> (and (inv-f i sn size v1 v2 v3) (and (= size! size) (and (= i! (+ i 1)) (and (<= i size) (= sn! (+ sn 1)))))) (inv-f i! sn! size! v1! v2! v3!)))

; prop rule for inv-f
(rule (=> (and (inv-f i sn size v1 v2 v3) (not (or (<= i size) (or (= sn size) (= sn 0))))) ERROR))
(query ERROR)