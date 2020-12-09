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

(defn sublist-adds-to
  [nums start length target]
  (loop [acc 0 i 0]
    (let [n (get nums (+ start i))]
      (cond
        (> acc target)
        false
        (and (= i length) (= acc target))
        true
        (nil? n)
        false
        :else
        (recur (+ acc n) (inc i))))))

(defn part2
  []
  (let [target (part1)
        nums (vec (input-lines))]
    (filter #(not (nil? %))
            (for [i (range (count nums)) length (range 2 (count nums))]
              (when (sublist-adds-to nums i length target)
                (let [nn (take length (drop i nums))]
                  (+ (apply min nn) (apply max nn))))))))

(comment
  (part1)
  (part2)
  )
