(ns aoc.day19
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.set :as set]
            [aoc.day09 :as ic]
            [astar.core :as astar]))

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

(comment
(part1)
)

