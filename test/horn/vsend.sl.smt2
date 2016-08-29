(declare-var c Int)
(declare-var i Int)
(declare-var c! Int)
(declare-var i! Int)
(declare-rel inv-f (Int Int))
(declare-rel ERROR () )

; init rule for inv-f
(rule (=> (= i 0)  (inv-f c i)))

; trans rule for inv-f
(rule (=> (and (inv-f c i) (and (< 48 c) (and (< c 57) (= i! (+ (+ i i) (- c 48)))))) (inv-f c! i!)))

; prop rule for inv-f
(rule (=> (and (inv-f c i) (not (or (< 57 c) (or (< c 48) (<= 0 i))))) ERROR))
(query ERROR)