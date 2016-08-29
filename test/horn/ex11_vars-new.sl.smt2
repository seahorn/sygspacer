(declare-var c Int)
(declare-var n Int)
(declare-var v1 Int)
(declare-var v2 Int)
(declare-var v3 Int)
(declare-var c! Int)
(declare-var n! Int)
(declare-var v1! Int)
(declare-var v2! Int)
(declare-var v3! Int)
(declare-rel inv-f (Int Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= c 0) (< 0 n))  (inv-f c n v1 v2 v3)))

; trans rule for inv-f
(rule (=> (and (inv-f c n v1 v2 v3) (or (and (< n c) (= c! (+ c 1))) (and (= c n) (= c! 1)))) (inv-f c! n! v1! v2! v3!)))

; prop rule for inv-f
(rule (=> (and (inv-f c n v1 v2 v3) (not (not (or (and (not (= c n)) (or (< c 0) (< n c))) (and (= c n) (< (- 1) n)))))) ERROR))
(query ERROR)