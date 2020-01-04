(ns aoc.day24p2
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.set :as set]))

;; IO

(defn parse
  [s]
  (loop [s s x -2 y -2 world #{}]
    (if (empty? s)
      world
      (let [ch (first s)]
        (cond
          (= ch \newline)
          (recur (rest s) -2 (inc y) world)
          (= ch \.)
          (recur (rest s) (inc x) y world)
          :else
          (recur (rest s) (inc x) y (conj world [x y 0])))))))

;; operations

(defn neighbors
  [{x 0 y 1 z 2}]
  (let [cells [[x (inc y) z] [x (dec y) z] [(dec x) y z] [(inc x) y z]]
        plane-fn (fn [acc {ax 0 ay 1 az 2 :as axyz}]
                   (cond
                     (= ay -3)
                     (conj acc [0 -1 (dec z)])
                     (= ay 3)
                     (conj acc [0 1 (dec z)])
                     (= ax -3)
                     (conj acc [-1 0 (dec z)])
                     (= ax 3)
                     (conj acc [1 0 (dec z)])
                     (and (= 0 ax ay))
                     (cond
                       (= x -1)
                       (apply conj acc (map #(vector -2 % (inc z)) (range -2 3)))
                       (= x 1)
                       (apply conj acc (map #(vector 2 % (inc z)) (range -2 3)))

                       (= y -1)
                       (apply conj acc (map #(vector % -2 (inc z)) (range -2 3)))
                       (= y 1)
                       (apply conj acc (map #(vector % 2 (inc z)) (range -2 3))))
                     :else
                     (conj acc axyz)))]
    (reduce plane-fn #{} cells)))

(defn step-bug-cell
  [world result cell]
  (let [adjacent (count (set/intersection world (neighbors cell)))
        bug? (contains? world cell)]
    (if (and bug? (= 1 adjacent))
      (conj result cell)
      result)))

(defn step-empty-cell
  [world result cell]
  (let [adjacent (count (set/intersection world (neighbors cell)))
        clear? (not (contains? world cell))]
    (if (and clear? (or (= 1 adjacent) (= 2 adjacent)))
      (conj result cell)
      result)))

(defn step
  [world]
  (let [result #{}
        result (reduce #(step-bug-cell world %1 %2) result world)
        result (reduce #(step-empty-cell world %1 %2) result (reduce #(apply conj %1 (neighbors %2)) #{} world))]
    result))

(defn part2-impl
  [s n]
  (loop [i 0 world (parse s)]
    (if (= n i)
      world
      (recur (inc i) (step world)))))

(defn part2
  []
  (let [s (-> "aoc/day24.txt"
                  io/resource
                  slurp )]
    (count (part2-impl s 200))))
