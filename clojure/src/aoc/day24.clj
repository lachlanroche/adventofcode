(ns aoc.day24
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.set :as set]))

;; 5x5 game of life - edges do not wrap
;; using long as bitset

;; IO

(defn print
  [^long world]
  (loop [i 0 s []]
    (let [s (conj s (if (bit-test world i) \# \.))]
      (cond
        (= 24 i)
        (str/join "" (conj s \newline))
        (= 4 (rem i 5))
        (recur (inc i) (conj s \newline))
        :else
        (recur (inc i) s)))))

(defn parse
  [s]
  (loop [i 0 s s world 0]
    (let [c (first s)
          s (rest s)]
      (cond
        (empty? s)
        world
        (= \newline c)
        (recur i s world)
        :else
        (recur (inc i) s (if (= \# c) (bit-set world i) world))))))

;; operations

(defn neighbors
  [^long i]
  (let [result []
        result (if (zero? (rem i 5)) result (conj result (dec i)))
        result (if (= 4 (rem i 5)) result (conj result (inc i)))
        result (if (<= i 4) result (conj result (- i 5)))
        result (if (>= i 20) result (conj result (+ i 5)))]
    result))

(defn step-cell
  [^long world ^long result ^long i]
  (let [adjacent (reduce #(if (bit-test world %2) (inc %1) %1) 0 (neighbors i))
        bug? (bit-test world i)]
    #_(tap> [i (bit-test world i) adjacent])
    (cond
      (and bug? (not= 1 adjacent))
      (bit-clear result i)
      (and (not bug?) (or (= 1 adjacent) (= 2 adjacent)))
      (bit-set result i)
      :else
      result)))

(defn step
  [^long world]
  (reduce #(step-cell world %1 %2) world (range 25)))

(defn part1
  []
  (let [world (-> "aoc/day24.txt"
                  io/resource
                  slurp
                  parse)]
    (loop [world world seen #{}]
      (let [world (step world)]
        (if (seen world)
          world
          (recur world (conj seen world)))))))

