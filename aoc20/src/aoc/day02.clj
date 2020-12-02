(ns aoc20.day02)

(defn input-data
  []
  (->> "aoc/day02.txt"
      clojure.java.io/resource
      slurp
      clojure.string/split-lines
      (map #(clojure.string/replace % #"[\-:]" " "))
      (map #(clojure.string/split % #" +"))
      (map #(hash-map :min (Integer. (get % 0)) :max (Integer. (get % 1)) :letter (first (get % 2)) :word (get % 3)))
      ))

(defn match-p1?
  [{:keys [min max letter word]}]
  (let [n (count (filter #(= letter %) word))]
    (and (>= n min) (<= n max))))

(defn part1
  []
  (count (filter match-p1? (input-data))))

(comment
  (part1)
)
