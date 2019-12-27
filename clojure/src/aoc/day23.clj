(ns aoc.day23
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.set :as set]
            [aoc.day09 :as ic]
            [clojure.math.combinatorics :as combo]))

(defn program-run
  [mem in out offset rbase wait?]
  (let [op (ic/cpu-decode (get mem offset))
        op-fn (:fn op)]
    (cond
      (and (= ic/op-input op-fn) (empty? in))
      [mem in out offset rbase true]

      :else
      (let [[mem in out offset rbase] (ic/program mem in out offset rbase)
            op (ic/cpu-decode (get mem offset))
            op-fn (:fn op)]
        [mem in out offset rbase (= op-fn ic/op-input)]))))

(defn network-idle?
  [computers]
  (every? #(and (empty? (second %)) (last %)) computers))

(defn load-program
  []
  (-> "aoc/day23.txt"
      io/resource
      slurp
      ic/program-compile))

(defn make-world
  [n]
  (let [prog (load-program)]
    (vec (map #(vector prog [%] [] 0 0 false) (range n)))))

(defn route-nat-1
  [computers nat b c]
  [nil nil c])

(defn read-packets
  [computer]
  (partition 3 (nth computer 2)))

(defn rm-packets
  [computer]
  (let [out (nth computer 2)
        out (drop (* 3 (quot (count out ) 3)) out)]
    (assoc computer 2 (vec out))))

(defn route-packets
  [computers nat route-nat-fn]
  (let [packets (apply concat (map read-packets computers))
        computers (vec (map rm-packets computers))]
    (loop [packets packets computers computers nat nat]
      (if (empty? packets)
        [computers nat nil]
        (let [[a b c] (first packets)]
          (if (= 255 a)
            (let [[computers nat result] (route-nat-fn computers nat b c)]
              (if (not (nil? result))
                [nil nil result]
                (recur (rest packets) computers nat)))
            (let [comp (get computers a)
                  in (->
                      (get comp 1 [])
                      (conj b)
                      (conj c))
                  comp (assoc comp 1 in)
                  computers (assoc computers a comp)]
              (recur (rest packets) computers nat))))))))

(defn run-loop
  [computers nat route-nat-fn result]
  (cond
    (number? result)
    result
    (every? #(ic/program-stopped? (first %) (nth % 3)) computers)
    nil
    :else
    (let [computers (map #(apply program-run %) computers)
          [computers nat result] (route-packets computers nat route-nat-fn)]
      (if (nil? result)
        (recur computers nat route-nat-fn result)
        result))))

(defn part1
  []
  (run-loop (make-world 50) nil route-nat-1 nil))

(defn part2
  []
  (run-loop (make-world 50) (make-nat-2) route-nat-2 nil))

(part2)
