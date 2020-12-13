(ns aoc20.day13
  (:require [clojure.math.combinatorics :as combo]))

(defn input-data
  []
  (let [s (->> "aoc/day13.txt"
               clojure.java.io/resource
               slurp
               clojure.string/split-lines
               )
        earliest (Integer. (first s))
        buses (->>
               (clojure.string/split (second s) #",")
               (filter #(not= "x" %))
               (map #(Integer. %)))
        buses2 (->>
                (clojure.string/split (second s) #",")
                (map-indexed #(vector %1 %2))
                (filter #(not= "x" (second %)))
                (map #(vector (first %) (Integer. (second %)))))
        ]
    {:earliest earliest :buses buses :buses2 buses2}))

(defn part1
  []
  (let [input (input-data)
        earliest (:earliest input)
        buses (:buses input)]
    (loop [i earliest]
      (let [bus (some #(if (= 0 (mod i %)) % nil) buses)]
        (if (nil? bus)
          (recur (inc i))
          (* bus (- i earliest)))))))

; apparently this is "CRT"
; paste result into wolfram alpha
(defn part2
  []
  (->> (input-data)
       :buses2
       (map #(str "(t + " (first %) ") mod " (second %) " = 0"))
       clojure.string/join))
