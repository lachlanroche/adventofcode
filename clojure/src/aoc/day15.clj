(ns aoc.day14
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.set :as set]
            [aoc.day09 :as ic]
            [astar.core :as astar]))

;; printing

(defn canvas-bounds
  [canvas]
  (let [[minx maxx miny maxy] (reduce #(let [[x0 x9 y0 y9] %1 [x y] %2] (vector (min x x0) (max x x9) (min y y0) (max y y9))) [0 0 0 0] (keys canvas))]
    {:minx minx :miny miny :maxx maxx :maxy maxy}))

(defn canvas-print
  [canvas]
  (let [{:keys [minx miny maxx maxy]} (canvas-bounds canvas)]
    (loop [x minx y miny s []]
      (let [node (get canvas [x y] {:status 3})
            c (nth ["#" "." "X" " "] (:status node))
            s (conj s c)]
        (cond
          (and (= x maxx) (= y maxy))
          (str/join "" s)
          (= x maxx)
          (recur minx (inc y) (conj s "\n"))
          :else
          (recur (inc x) y s))))))

;; nodes

(defn run-program
  [machine in]
  (let [[mem offset rbase] machine
        [mio reg] (ic/program [mem [in] []] offset rbase)
        [mem _ out] mio
        [offset rbase] reg
        status (first out)
        machine [mem offset rbase]]
    [status machine]))

(defn make-node
  [xy parent status machine]
  {:coord xy :parent parent :status status :machine machine})

;; create world

(defn coord-neighbors
  [{x 0 y 1}]
  [[x (inc y)] [x (dec y)] [(dec x) y] [(inc x) y]])

(defn program-direction
  [{x1 0 y1 1} {x2 0 y2 1}]
  (cond
    (and (= x1 x2) (= (inc y1) y2))
    1
    (and (= x1 x2) (= (dec y1) y2))
    2
    (and (= (dec x1) x2) (= y1 y2))
    3
    :else
    4))

(defn make-world
  [prog]
  (let [node (make-node [0 0] nil 1 [prog 0 0])
        world {:canvas {(:coord node) node}}
        searches-fn (fn [world pxy]
                      (->> (coord-neighbors pxy)
                           (filter #(nil? (get-in world [:canvas %])))
                           (map #(hash-map :coord % :parent pxy))))
        ]
    (loop [world world searches (searches-fn world [0 0])]
      (let [search (first searches)]
        (cond
          (empty? searches)
          world
          (get-in world [:canvas (:coord search)])
          (recur world (rest searches))
          :else
          (let [xy (:coord search)
                parent (get-in world [:canvas (:parent search)])
                pxy (:parent search)
                machine (:machine parent)
                in (program-direction pxy xy)
                [status machine] (run-program machine in)
                node (make-node xy pxy status machine)
                world (if (not= 2 status) world (assoc world :target xy))
                more-searches (if (zero? status) [] (searches-fn world xy))
                ]
            (recur (assoc-in world [:canvas xy] node) (concat (rest searches) more-searches))))))))

(defn flood-field
  [field start]
  (let [searches-fn (fn [pxy]
                      (->> (coord-neighbors pxy)
                           (filter #(= % (field %)))
                           set))
        ]
    (loop [n 0 seen {start 0} searches (searches-fn start)]
      (cond
        (empty? searches)
        (apply max (vals seen))
        :else
        (let [search (first searches)
              time (inc (apply max (vals (select-keys seen (coord-neighbors search)))))
              seen (conj seen {search time})
              more-searches (set/difference (searches-fn search) (set (keys seen)))
              ]
          (recur (inc n) seen (concat (rest searches) more-searches)))))))



#_
(let [s (-> "aoc/day15.txt"
            io/resource
            slurp)
      prog (ic/program-compile s)
      world (make-world prog)]
  (canvas-print (:canvas world)))

(defn manhattan-distance
  [[x1 y1] [x2 y2]]
  (+ (Math/abs (- x1 x2)) (Math/abs (- y2 y1))))

(defn part1
  []
  (let [s (-> "aoc/day15.txt"
              io/resource
              slurp)
        prog (ic/program-compile s)
        world (make-world prog)
        field (->> (:canvas world)
                   vals
                   (filter #(not= 0 (:status %)))
                   (map :coord)
                   set)
        target (:target world)
        h (partial manhattan-distance target)
        graph (fn [xy]
                (->> (coord-neighbors xy)
                     (filter #(not (nil? (field %))))))
        ]
    (count (astar/route graph manhattan-distance h [0 0] target))))

(defn part2
  []
  (let [s (-> "aoc/day15.txt"
              io/resource
              slurp)
        prog (ic/program-compile s)
        world (make-world prog)
        field (->> (:canvas world)
                   vals
                   (filter #(not= 0 (:status %)))
                   (map :coord)
                   set)
        target (:target world)
        ]
    (flood-field field target)))

(comment
(part1)
(part2)
)

#_
(let [field #{[1 1] [1 2] [2 1] [2 3] [3 1] [3 2] [3 3]}
      target [3 2]]
  (flood-field field target))
