(ns aoc20.day13
  (:require [clojure.math.combinatorics :as combo]))

(defn input-data
  []
  (let [s (->> "aoc/day18.txt"
               clojure.java.io/resource
               slurp
               clojure.string/split-lines
               (map #(clojure.string/split % #" "))
               )]
    s))

(defn evil
  [str]
  (loop [acc [0] ops [+] str str]
    (let [s (first str)
          str (rest str)]
      (tap> [s acc ops])
      (cond
        (nil? s)
        (first acc)
        (= "+" s)
        (recur acc (concat [+] ops) str)
        (= "*" s)
        (recur acc (concat [*] ops) str)
        (= "(" s)
        (recur (concat [0] acc) (concat [+] ops) str)
        (= ")" s)
        (let [val0 (first acc)
              val1 (second acc)
              acc (rest acc)
              op (first ops)
              ops (rest ops)
              val (op val0 val1)
              acc (assoc (vec acc) 0 val)]
          (recur acc ops str))
        (number? (read-string s))
        (let [op (first ops)
              ops (rest ops)
              val (first acc)
              val (op val (read-string s))
              acc (assoc (vec acc) 0 val)]
          (recur acc ops str))))))

(defn part1
       []
  (->> (input-data)
       (map evil)
       (reduce + 0)))

