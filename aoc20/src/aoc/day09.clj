(ns aoc20.day09
  (:require [clojure.math.combinatorics :as combo]))

(defn input-lines
  []
  (let [s (->> "aoc/day09.txt"
               clojure.java.io/resource
               slurp
               clojure.string/split-lines
               (map #(Long. %)))
        ]
    s))

(defn any-pair-adds-to?
  [nums val]
  (let [totals (->> (combo/combinations nums 2)
                    (map #(+ (nth % 0) (nth % 1)))
                    set)]
    (totals val)))

(defn part1
  []
  (let [nums (input-lines)]
    (loop [i 25]
      (let [n (nth nums i)
            prelude (take 25 (drop (- i 25) nums))]
        (cond
          (nil? n)
          nil
          (any-pair-adds-to? prelude n)
          (recur (inc i))
          :else
          n)))))

