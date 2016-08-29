(declare-var c Int)
(declare-var n Int)
(declare-var c! Int)
(declare-var n! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= c 0) (< 0 n))  (inv-f c n)))

; trans rule for inv-f
(rule (=> (and (inv-f c n) (or (and (and (< n c) (= c! (+ c 1))) (= n! n)) (and (and (= c n) (= c! 1)) (= n! n)))) (inv-f c! n!)))

; prop rule for inv-f
(rule (=> (and (inv-f c n) (not (and (or (= c n) (and (<= 0 c) (<= c n))) (or (not (= c n)) (< (- 1) n))))) ERROR))
(query ERROR)