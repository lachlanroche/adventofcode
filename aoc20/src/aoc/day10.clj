(ns aoc20.day10
  (:require [clojure.math.combinatorics :as combo]))

(defn input-lines
  []
  (let [s (->> "aoc/day10.txt"
               clojure.java.io/resource
               slurp
               clojure.string/split-lines
               (map #(Long. %))
               sort
               )
        z (+ 3 (reduce max s))
        ]
    (vec (concat [0] s [z]))))

(defn part1
  []
  (->> (input-lines)
       (partition 2 1)
       (group-by #(- (second %) (first %)))
       (map #(count (val %)))
       (apply *)
       ))

