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

(defn part2
 []
  (let [nums (input-lines)
        mult [1 1 1 2 4 7 13 24 44 81 149 274 504]]
    (loop [acc (long 1) i 1 run 1]
      (let [n (get nums i)
            p (get nums (dec i))]
        (cond
          (nil? n)
          acc
          (= n (inc p))
          (recur acc (inc i) (inc run))
          :else
          (recur (* acc (nth mult run)) (inc i) 1))))))
