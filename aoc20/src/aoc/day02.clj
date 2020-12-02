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

(defn match-p2?
  [{:keys [min max letter word]}]
  (let [a? (= letter (get word (dec min)))
        b? (= letter (get word (dec max)))]
    (and
     (or a? b?)
     (not (and a? b?)))))

(defn part1
  []
  (count (filter match-p1? (input-data))))

(defn part2
  []
  (count (filter match-p2? (input-data))))

(comment
  (part1)
  (part2)
)
