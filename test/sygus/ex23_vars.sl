(set-logic LIA)

(synth-inv inv-f ((y Int) (z Int) (c Int)))

(declare-primed-var b Bool)
(declare-primed-var y Int)
(declare-primed-var z Int)
(declare-primed-var c Int)

(define-fun pre-f ((y Int) (z Int) (c Int)) Bool
(and (= c 0) (>= y 0) (>= 127 y) (= z (* 36 y)) (= y! y)))

(define-fun trans-f ((y Int) (z Int) (c Int) (x1 Int)  (y! Int) (z! Int) (c! Int)) Bool
(and (and (< c 36) (= z! (+ z 1))) (= c! (+ c 1))))

(define-fun post-f ((y Int) (z Int) (c Int)) Bool
(not (and (< c 36) (or (< z 0) (>= z 4608)))))

(inv-constraint inv-f pre-f trans-f post-f)

(check-synth)


