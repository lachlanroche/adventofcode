(ns aoc20.day03)

(defn input-data
  []
  (let [s (->> "aoc/day03.txt"
                  clojure.java.io/resource
                  slurp)
        ]
    (loop [s s x 0 y 0 canvas #{} size [0 0]]
      (if (empty? s)
        {:canvas canvas :size size}
        (let [ch (first s)
              tree? (= \# ch)
              [max-x max-y] size
              canvas (if (not tree?) canvas (conj canvas [x y]))]
          (cond
            (= ch \newline)
            (recur (rest s) 0 (inc y) canvas size)
            :else
            (let [size [(max max-x x) (max max-y y)]]
              (recur (rest s) (inc x) y canvas size))))))))

(defn tree?
  [canvas [x y]]
  (not (nil? (get canvas [x y]))))

(defn ski
  [dx dy]
  (let [{:keys [canvas size]} (input-data)
        [max-x max-y] size]
    (loop [x 0 y 0 t 0]
      (let [x_ (mod (+ dx x) (inc max-x))
            y_ (+ dy y)]
        (cond
          (> y max-y)
          t
          (tree? canvas [x y])
          (recur x_ y_ (inc t))
          :true
          (recur x_ y_ t))))))

(defn part1
  []
  (ski 3 1))

(defn part2
  []
  (* (ski 1 1)
     (ski 3 1)
     (ski 5 1)
     (ski 7 1)
     (ski 1 2)))

(comment
  (part1)
  (part2)
)
