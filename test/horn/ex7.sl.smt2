(declare-var x Int)
(declare-var y Int)
(declare-var i Int)
(declare-var x! Int)
(declare-var y! Int)
(declare-var i! Int)
(declare-rel inv-f (Int Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (and (and (and (= i 0) (<= 0 x)) (<= 0 y)) (<= y x))  (inv-f x y i)))

; trans rule for inv-f
(rule (=> (and (inv-f x y i) (and (and (< i y) (= i! (+ i 1))) (and (= y! y) (= x! x)))) (inv-f x! y! i!)))

; prop rule for inv-f
(rule (=> (and (inv-f x y i) (not (not (and (< i y) (or (<= x i) (< i 0)))))) ERROR))
(query ERROR)