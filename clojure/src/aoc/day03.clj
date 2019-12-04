(ns aoc.day02)

(defn op-right
  [[x y] n]
  (map #(vector (+ x %) y) (range 1 (+ 1 n))))

(defn op-left
  [[x y] n]
  (map #(vector (- x %) y) (range 1 (+ 1 n))))

(defn op-up
  [[x y] n]
  (map #(vector x (+ y %)) (range 1 (+ 1 n))))

(defn op-down
  [[x y] n]
  (map #(vector x (- y %)) (range 1 (+ 1 n))))

(defn op-noop
  [xy _]
  [])

(def op-map {"R" op-right
             "L" op-left
             "U" op-up
             "D" op-down})

(defn eval-op
  [xy op]
  (let [op-code (str (first op))
        op-fn (get op-map op-code op-noop)
        n (Integer/parseInt (apply str (rest op)))]
    (op-fn xy n)))

(defn wire-op
  [[xy points] op]
  (let [new (eval-op xy op)
        xy (if (empty? new) xy (last new))
        points (apply conj points new)]
    [xy points]))

(defn wire-points
  [ops]
  (let [[_ points] (reduce wire-op [[0 0] []] ops)]
    points))

(defn abs
  [n]
  (if (< 0 n) n (- n)))

(defn manhattan
  ([xy]
   (manhattan [0 0] xy))
  ([[x1 y1] [x2 y2]]
   (+ (abs (- x1 x2))
      (abs (- y1 y2)))))

(defn wire-cross-distance
  [w1 w2]
  (->> (clojure.set/intersection (set (wire-points w1)) (set (wire-points w2)))
       (map manhattan)
       (apply min)))

(defn part1
  []
  (->> "aoc/day03.txt"
      clojure.java.io/resource
      slurp
      clojure.string/split-lines
      (map #(clojure.string/split % #","))
      (apply wire-cross-distance)))

(defn wire-delay-cost-map
  [points]
  (->> points
       (map-indexed #(vector %2 (+ 1 %1)))
       (into {})))

(defn wire-least-delay-intersection
  [s1 s2]
  (let [w1 (wire-points s1)
        w2 (wire-points s2)
        joins (clojure.set/intersection (set w1) (set w2))
        cost1 (-> w1 wire-delay-cost-map (select-keys (seq joins)))
        cost2 (-> w2 wire-delay-cost-map (select-keys (seq joins)))
        cheapest (apply min-key #(+ (get cost1 %) (get cost2 %)) (seq joins))
        ]
    (+ (get cost1 cheapest) (get cost2 cheapest))))

(defn part2
  []
  (->> "aoc/day03.txt"
      clojure.java.io/resource
      slurp
      clojure.string/split-lines
      (map #(clojure.string/split % #","))
      (apply wire-least-delay-intersection)))

(comment
(op-right [0 0] 2)
(op-left [0 0] 2)
(op-up [0 0] 2)
(op-down [0 0] 2)
(op-noop [0 0] 2)
(eval-op [0 0] "R2")
(wire-points ["R2" "R2"])
(wire-cross-distance
 ["R75" "D30" "R83" "U83" "L12" "D49" "R71" "U7" "L72"]
 ["U62" "R66" "U55" "R34" "D71" "R55" "D58" "R83"])
(wire-cross-distance
 ["R98" "U47" "R26" "D63" "R33" "U87" "L62" "D20" "R33" "U53" "R51"]
 ["U98" "R91" "D20" "R16" "D67" "R40" "U7" "R15" "U6" "R7"])
(wire-least-delay-intersection
 ["R8","U5","L5","D3"]
 ["U7","R6","D4","L4"])
(wire-least-delay-intersection
 ["R75" "D30" "R83" "U83" "L12" "D49" "R71" "U7" "L72"]
 ["U62" "R66" "U55" "R34" "D71" "R55" "D58" "R83"])
(wire-least-delay-intersection
 ["R98" "U47" "R26" "D63" "R33" "U87" "L62" "D20" "R33" "U53" "R51"]
 ["U98" "R91" "D20" "R16" "D67" "R40" "U7" "R15" "U6" "R7"])
)
