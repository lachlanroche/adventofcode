(ns aoc.day19
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.set :as set]
            [aoc.day09 :as ic]))

(defn load-program
  []
  (-> "aoc/day19.txt"
      io/resource
      slurp
      ic/program-compile))

(defn affected?
  [prog {x 0 y 1}]
  (let [[mio _] (ic/program [prog [x y] []] 0 0)
        [_ _ out] mio]
    (= 1 (first out))))

(defn part1
  []
  (let [prog (load-program)]
    (loop [total 0 x 0 y 0]
      (let [total (if (affected? prog [x y]) (inc total) total)]
        (cond
          (and (= y 49) (= x 49))
          total
          (and (= x 49))
          (recur total 0 (inc y))
          :else
          (recur total (inc x) y))))))

(defn santa-catchable?
  [prog x y]
  (reduce #(and %1 (affected? prog %2)) true [[x y] [x (+ 99 y)] [(+ 99 x) y] [(+ 99 x) (+ 99 y)]]))

(defn part2
  []
  (let [prog (load-program)
        affected? (partial affected? prog)
        catchable? (partial santa-catchable? prog)]
    (loop [x 5 y 6]
      (let [ax x
            ay (- y 99)
            success? (if (and (pos? ax) (pos? ay)) (catchable? ax ay) false)]
        (cond
          success?
          (+ ay (* 10000 ax))
          (affected? [x (inc y)])
          (recur x (inc y))
          :else
          (recur (inc x) y))))))

(comment
(part1)
(part2)
)
