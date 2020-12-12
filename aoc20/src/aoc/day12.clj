(ns aoc20.day12)

(defn input-lines
  []
  (let [s (->> "aoc/day12.txt"
               clojure.java.io/resource
               slurp
               clojure.string/split-lines
               )
        ]
    s))

(defn abs [n]
  (if (neg? n)
    (- 0 n)
    n))

(defn turn
  [f dir]
  (let [t (first dir)
        n (->> (rest dir)
               (clojure.string/join "")
               Integer.)
        n (/ n 90)
        dir (if (= \L t) "NWSENWSE" "NESWNESW")
        dir (drop-while #(not= % f) dir)
        ]
    (nth dir n)))

(defn move
  ([xy dir]
   (move xy (first dir) (rest dir)))

  ([[x y] t dir]
   (let [n (Integer. (clojure.string/join "" dir))]
    (cond
      (= \N t)
      [x (+ y n)]
      (= \S t)
      [x (- y n)]
      (= \E t)
      [(+ x n) y]
      (= \W t)
      [(- x n) y]
      ))))

(defn part1
  []
  (loop [f \E xy [0 0] lines (input-lines)]
    (let [line (first lines)
          lines (rest lines)]
      (tap> [xy f line])
      (cond
        (nil? line)
        (let [[x y] xy]
          (+ (abs x) (abs y)))
        (#{\N \S \E \W} (first line))
        (recur f (move xy line) lines)
        (#{\F} (first line))
        (recur f (move xy f (rest line)) lines)
        (#{\L \R} (first line))
        (recur (turn f line) xy lines)
        :else
        (recur f xy lines)))))
