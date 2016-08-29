(declare-var x Int)
(declare-var sn Int)
(declare-var x! Int)
(declare-var sn! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (= sn 0) (= x 0))  (inv-f x sn)))

; trans rule for inv-f
(rule (=> (and (inv-f x sn) (and (= x! (+ x 1)) (= sn! (+ sn 1)))) (inv-f x! sn!)))

; prop rule for inv-f
(rule (=> (and (inv-f x sn) (not (or (= sn x) (= sn (- 1))))) ERROR))
(query ERROR)