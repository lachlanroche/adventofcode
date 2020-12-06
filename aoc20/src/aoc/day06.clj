(ns aoc20.day06)

(defn input-lines
  []
  (let [s (->> "aoc/day06.txt"
               clojure.java.io/resource
               slurp
               clojure.string/split-lines)
        ]
    s))

(defn input-data
  []
  (loop [pp [] p #{} ss (input-lines)]
    (let [s (first ss)
          ss (rest ss)]
      (cond
        (nil? s)
        (conj pp p)
        (= "" s)
        (recur (conj pp p) [] ss)
        :else
        (recur pp (conj p (set s)) ss)))))

(defn part1
  []
  (->> (input-data)
       (map #(apply clojure.set/union %))
       (map count)
       (reduce +)))

(defn part2
  []
  (->> (input-data)
       (map #(clojure.set/intersection %))
       (map count)
       (map #(if (nil? %) 0 %))
       (reduce +)))

(comment
  (part1)
  (part2)
)
