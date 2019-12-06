(ns aoc.day06
  (:require [clojure.string :as string]
            [clojure.java.io :as io]))




(defn orbit-insert
  "b orbits a"
  [m a b]
  (let [m (if (get m a) m (assoc m a nil))]
    (assoc m b a)))

(defn orbit-count
  ([m z]
   (orbit-count m z 0))
  ([m z result]
   (if-let [y (get m z)]
    (recur m y (+ 1 result))
    result)))

(defn orbit-total-count
  [s]
  (let [m (->> s
               string/split-lines
               (map #(string/split % #"\)"))
               (reduce #(orbit-insert %1 (first %2) (second %2)) {})
               (into {}))
        ]
    (reduce + (map #(orbit-count m %) (keys m)))))

(orbit-total-count "COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L")


(defn part1
  []
  (-> "aoc/day06.txt"
      io/resource
      slurp
      orbit-total-count))


(comment
(add-orbit {} "COM" "B")
(orbit-count (add-orbit {} "COM" "B") "B")
(orbit-count (add-orbit {} "COM" "B") "COM")
(part1)
)
