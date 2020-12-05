(ns aoc20.day05)

(defn input-data
  []
  (let [s (->> "aoc/day05.txt"
                  clojure.java.io/resource
                  slurp
                  clojure.string/split-lines)
        ]
    s))

(defn find-seat
  [s]
  (loop [s s row (range 8) col (range 128)]
    (let [c (first s)
          s (rest s)
          keep-r (/ (count row) 2)
          keep-c (/ (count col) 2)]
      (cond
        (nil? c)
        [(first row) (first col)]
        (= \F c)
        (recur s row (take keep-c col))
        (= \B c)
        (recur s row (drop keep-c col))
        (= \L c)
        (recur s (take keep-r row) col)
        (= \R c)
        (recur s (drop keep-r row) col)))))

(defn seat-id
  [[r c]]
  (+ r (* 8 c)))

(defn part1
  []
  (->> (input-data)
       (map find-seat)
       (map seat-id)
       (reduce max)))

(defn part2
  []
  (let [seats (->> (input-data)
                   (map find-seat)
                   (map seat-id)
                   set)
        from (reduce min seats)
        to (reduce max seats)
        available (set (range from (inc to) 1))
        ]
    (first (clojure.set/difference available seats))))

(comment
  (part1)
  (part2)
)
