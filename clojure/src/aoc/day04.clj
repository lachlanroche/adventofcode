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

(part1)

