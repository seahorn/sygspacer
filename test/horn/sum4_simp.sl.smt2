(declare-var i Int)
(declare-var sn Int)
(declare-var size Int)
(declare-var i! Int)
(declare-var sn! Int)
(declare-var size! Int)
(declare-rel inv-f (Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= sn 0) (= i 1))  (inv-f i sn size)))

; trans rule for inv-f
(rule (=> (and (inv-f i sn size) (and (= size! size) (and (= i! (+ i 1)) (and (<= i size) (= sn! (+ sn 1)))))) (inv-f i! sn! size!)))

; prop rule for inv-f
(rule (=> (and (inv-f i sn size) (not (or (<= i size) (or (= sn size) (= sn 0))))) ERROR))
(query ERROR)