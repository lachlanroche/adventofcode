(ns aoc.day04)

(defn password?
  [repeat-fn s]
  (and
   (= 6 (count s))
   (repeat-fn s)
   (= s (apply str (sort s)))))

(defn has-repeat?
  [s]
   (some #(= (first %) (second %)) (partition 2 1 s)))

(defn part1
  []
  (->> (range 231832 767347)
       (map str)
       (filter (partial password? has-repeat?))
       count))

(defn has-double?
  [s]
  (->> s
       (partition-by identity)
       (map #(hash-map (first %) (count %)))
       (into {})
       (some #(= 2 (val %)))
     ))

(defn part2
  []
  (->> (range 231832 767347)
       (map str)
       (filter (partial password? has-double?))
       count))

(comment
(part1)
(part2)
)
