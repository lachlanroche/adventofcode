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
       (group-by (fn [[a b]] (- b a)))
       (map #(count (val %)))
       (apply *)
       ))

(defn tribonacci-seq
  []
   (->> (iterate (fn [[a b c]] [b c (+ a b c)]) [1 2 4])
        (map first)
        (take 15)
        (concat (list 1 1))
        vec))
        ))

(defn part2
 []
  (let [nums (input-lines)
        mult (tribonacci-seq)]
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
