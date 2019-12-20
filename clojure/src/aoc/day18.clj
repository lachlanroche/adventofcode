(ns aoc.day18
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.set :as set]
            [astar.core :as astar]
            [clojure.math.combinatorics :as combo]))

(defn coord-neighbors
  [{x 0 y 1}]
  [[x (inc y)] [x (dec y)] [(dec x) y] [(inc x) y]])

(defn manhattan-distance
  [[x1 y1] [x2 y2]]
  (+ (Math/abs (- x1 x2)) (Math/abs (- y2 y1))))

(defn parse-world
  [s]
  (loop [s s x 0 y 0 world {:canvas #{}}]
    (if (empty? s)
      world
      (let [ch (first s)
            k? (Character/isLowerCase ch)
            d? (Character/isUpperCase ch)
            r? (= \@ ch)
            world (if (not r?) world (assoc-in world [:robot (str ch)] [x y]))
            world (if (not k?) world (assoc-in world [:key (str ch)] [x y]))
            world (if (not d?) world (assoc-in world [:door (str ch)] [x y]))
            canvas (:canvas world)
            ]
        (cond
          (= ch \newline)
          (recur (rest s) 0 (inc y) world)
          (= ch \#)
          (recur (rest s) (inc x) y world)
          :else
          (recur (rest s) (inc x) y (assoc world :canvas (conj canvas [x y]))))))))

(defn make-doormap
  [world]
  (->>
   world
   :door
   (map #(hash-map (val %) (key %)))
   (into {})))

(defn make-pairpath
  [ab waypoints field doormap]
  (let [axy (waypoints (first ab))
        bxy (waypoints (second ab))
        graph-fn (fn [xy]
                   (->> (coord-neighbors xy)
                        (filter #(not (nil? (field %))))))
        h (partial manhattan-distance bxy)
        route (astar/route graph-fn manhattan-distance h axy bxy)
        ]
    {ab [(count route) (set (vals (select-keys doormap route)))]}))

(defn make-pathmaps
  [world doormap waypoints]

  (let [wppairs (map set (combo/combinations (keys waypoints) 2))
        pairmap (into {} (map #(make-pairpath % waypoints (:canvas world) doormap) wppairs))
        ]
    {:distmap (into {} (map #(hash-map (key %) (first (val %))) pairmap)) :blockmap (into {} (map #(hash-map (key %) (second (val %))) pairmap))}))


(let [s (->> "aoc/day18.txt"
             io/resource
             slurp)
      world (parse-world s)
      doormap (make-doormap world)
      waypoints (merge {} (:key world) (:robot world))
      {:keys [distmap blockmap]} (make-pathmaps world doormap waypoints)
      blockmap (filter #(not (and (contains? (key %) "@") (not (empty? (val %))))) blockmap)
      keyset (set (keys (:key world)))
      ]
  (def keyset keyset)
  (def blockmap blockmap)
  (def distmap distmap)
  nil
)


;; start from "@" candidates have no blockages
(filter #(and (contains? (key %) "@") (empty? (val %))) blockmap)

;; remove useless "@" transitions
(filter #(not (and (contains? (key %) "@") (not (empty? (val %))))) blockmap)
