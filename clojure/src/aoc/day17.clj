(ns aoc.day17
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.set :as set]
            [aoc.day09 :as ic]
            [astar.core :as astar]))

(defn coord-neighbors
  [{x 0 y 1}]
  [[x (inc y)] [x (dec y)] [(dec x) y] [(inc x) y]])

(defn parse-scaffold-map
  [s]
  (loop [s s x 0 y 0 world {:canvas #{}}]
    (if (empty? s)
      world
      (let [ch (str (first s))
            robot? (contains? #{"^" "v" "<" ">"} ch)
            world (if (not robot?) world (assoc world :robot [[x y] ch]))
            canvas (:canvas world)
            ]
        (cond
          (= ch "\n")
          (recur (rest s) 0 (inc y) world)
          (= ch ".")
          (recur (rest s) (inc x) y world)
          :else
          (recur (rest s) (inc x) y (assoc world :canvas (conj canvas [x y]))))))))

(defn intersections
  [{:keys [canvas] :as world}]
  (->> canvas
       (map #(hash-map % (coord-neighbors %)))
       (into {})
       (filter #(set/subset? (val %) canvas))
       (map key)))

(defn sum-alignment-parameters
  [world]
  (->> world
      intersections
      (map #(apply * %))
      (reduce + 0)))

(defn part1
  []
  (let [s (-> "aoc/day17.txt"
              io/resource
              slurp)
        prog (ic/program-compile s)
        [mio _] (ic/program [prog [] []] 0 0)
        [_ _ out] mio
        outs (str/join "" (map char out))
        ]
    (->> outs
         parse-scaffold-map
         sum-alignment-parameters)))

(comment
(part1)
(= 76 (let [s "..#..........\n..#..........\n#######...###\n#.#...#...#.#\n#############\n..#...#...#..\n..#####...^.."]
        (sum-alignment-parameters s)))
)

