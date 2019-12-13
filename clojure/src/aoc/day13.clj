(ns aoc.day13
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.edn :as edn]
            [aoc.day09 :as ic]
            [clojure.math.combinatorics :as combo]))

(defn make-arcade
  []
  {:canvas {} :blank 0 :score 0})

(defn arcade-draw
  [{:keys [canvas score] :as arcade} [x y c]]
  (if (and (= y 0) (= x -1))
    (assoc arcade :score c)
    (assoc arcade :canvas (assoc canvas [x y] c))))

(defn arcade-program
  ([prog]
   (arcade-program (make-arcade) prog [] [] 0 0))
  ([prog coins]
   (arcade-program (make-arcade) (assoc prog 0 coins) [] [] 0 0))
  ([arcade mem in out offset rbase]
   (cond
     (<= 3 (count out))
     (let [arcade (arcade-draw arcade (vec (take 3 out)))
           out (vec (drop 3 out))]
       (recur arcade mem in out offset rbase))
     ;(and (ic/program-wait-input? mem offset) (empty? in))
     ;(let [pixel (read-camera robot)]
     ;  (recur robot mem [pixel] out offset rbase))
     (ic/program-stopped? mem offset)
     (do
       #_(tap> [in out offset rbase robot mem])
       arcade)
     :else
     (let [[mio reg] (ic/program [mem in out] offset rbase)
           [mem in out] mio
           [offset rbase] reg]
       (recur arcade mem in out offset rbase))
     )))

(defn arcade-bounds
  [{:keys [canvas]}]
  (let [[minx maxx miny maxy] (reduce #(let [[x0 x9 y0 y9] %1 [x y] %2] (vector (min x x0) (max x x9) (min y y0) (max y y9))) [0 0 0 0] (keys canvas))]
    {:minx minx :miny miny :maxx maxx :maxy maxy}))

(defn arcade-print
  [{:keys [canvas blank] :as arcade}]
  (let [{:keys [minx miny maxx maxy]} (arcade-bounds arcade)]
    (loop [x minx y miny s []]
      (let [c (get canvas [x y] 0)
            c (get [" " "|" "#" "=" "o"] c)
            s (conj s c)]
        (cond
          (and (= x maxx) (= y maxy))
          (str/join "" s)
          (= x maxx)
          (recur minx (+ y 1) (conj s "\n"))
          :else
          (recur (+ x 1) y s))))))

(defn part1
  []
  (let [s (-> "aoc/day13.txt"
              io/resource
              slurp)
        prog (ic/program-compile s)
        arcade (arcade-program prog)]
    (println (arcade-print arcade))
    (count (filter #(= 2 %) (vals (:canvas arcade))))))

(comment
(part1)
(part2)
)
