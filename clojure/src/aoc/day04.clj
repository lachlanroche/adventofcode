(ns aoc.day04)

(defn password?
  [s]
  (and
   (= 6 (count s))
   (some #(= (first %) (second %)) (partition 2 1 s))
   (= s (apply str (sort s)))))

(defn part1
  []
  (->> (range 231832 767347)
       (map str)
       (filter password?)
       count))

(part1)

