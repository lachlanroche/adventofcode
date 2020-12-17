(ns aoc20.day17
  (:require [clojure.math.combinatorics :as combo]))

(defn input-data
  []
  (let [s (->> "aoc/day17.txt"
               clojure.java.io/resource
               slurp)]
    (loop [s s x 0 y 0 canvas #{} size [0 0 0]]
      (if (empty? s)
        {:canvas canvas :size size}
        (let [ch (first s)
              seat? (= \# ch)
              [max-x max-y _] size
              canvas (if (not seat?) canvas (conj canvas [x y 0]))]
          (cond
            (= ch \newline)
            (recur (rest s) 0 (inc y) canvas size)
            :else
            (let [size [(max max-x x) (max max-y y) 0]]
              (recur (rest s) (inc x) y canvas size))))))))

(defn neighbors
  [[x y z]]
  (->> (for [dx [-1 0 1] dy [-1 0 1] dz [-1 0 1]]
         (if (= 0 dx dy dz)
           nil
           [(+ x dx) (+ y dy) (+ z dz)]))
       (filter #(not (nil? %)))
       set))

(defn remain-active
  [canvas]
  (loop [result #{} points canvas]
    (let [point (first points)
          points (rest points)]
      (cond
        (nil? point)
        result
        (<= 2 (count (clojure.set/intersection canvas (neighbors point))) 3)
        (recur (conj result point) points)
        :else
        (recur result points)))))


(defn become-active
  [canvas inactive]
  (loop [result #{} points inactive]
    (let [point (first points)
          points (rest points)]
      (cond
        (nil? point)
        result
        (= 3 (count (clojure.set/intersection canvas (neighbors point))))
        (recur (conj result point) points)
        :else
        (recur result points)))))

(defn part1
  []
  (let [world (input-data)
        canvas (:canvas world)]
    (loop [i 0 canvas canvas]
      (cond
        (= 6 i)
        (count canvas)
        :else
        (let [near-actives (->> canvas
                                (map neighbors)
                                (reduce #(apply conj %1 %2 ) #{}))
              inactive (clojure.set/difference near-actives canvas)
              canvas (clojure.set/union (remain-active canvas) (become-active canvas inactive))]
          (recur (inc i) canvas))))))
