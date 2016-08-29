(declare-var x Int)
(declare-var sn Int)
(declare-var v1 Int)
(declare-var v2 Int)
(declare-var v3 Int)
(declare-var x! Int)
(declare-var sn! Int)
(declare-var v1! Int)
(declare-var v2! Int)
(declare-var v3! Int)
(declare-rel inv-f (Int Int Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= sn 0) (= x 0))  (inv-f x sn v1 v2 v3)))

; trans rule for inv-f
(rule (=> (and (inv-f x sn v1 v2 v3) (and (= x! (+ x 1)) (= sn! (+ sn 1)))) (inv-f x! sn! v1! v2! v3!)))

; prop rule for inv-f
(rule (=> (and (inv-f x sn v1 v2 v3) (not (or (= sn x) (= sn (- 1))))) ERROR))
(query ERROR)