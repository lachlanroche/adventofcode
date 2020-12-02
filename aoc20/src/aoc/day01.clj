(ns aoc20.day01)

(defn input-data
  []
  (->> "aoc/day01.txt"
      clojure.java.io/resource
      slurp
      clojure.string/split-lines
      (map #(Integer. %))
      ))

(defn part1
  []
  (let [nums (input-data)]
    (first
     (for [i nums j nums :when (= 2020 (+ i j))]
       (* i j)))))

(defn part2
  []
  (let [nums (input-data)]
    (first
     (for [i nums j nums k nums :when (= 2020 (+ i j k))]
       (* i j k)))))

(comment
  (part1)
  (part2)
)
