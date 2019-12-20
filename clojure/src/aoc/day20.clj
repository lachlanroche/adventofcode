(ns aoc.day20
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.set :as set]
            [aoc.day09 :as ic]
            [clojure.math.combinatorics :as combo]))

(defn coord-neighbors
  [{x 0 y 1}]
  [[x (inc y)] [x (dec y)] [(dec x) y] [(inc x) y]])

(defn manhattan-distance
  [[x1 y1] [x2 y2]]
  (+ (Math/abs (- x1 x2)) (Math/abs (- y2 y1))))

(defn parse-world
  [s]
  (loop [s s x 0 y 0 world {:canvas #{} :portal {}}]
    (if (empty? s)
      world
      (let [ch (first s)
            portal (:portal world)
            canvas (:canvas world)
            ]
        (cond
          (= ch \newline)
          (recur (rest s) 0 (inc y) world)
          (or (= ch \#) (= ch \space))
          (recur (rest s) (inc x) y world)
          (Character/isUpperCase ch)
          (recur (rest s) (inc x) y (assoc world :portal (assoc portal [x y] (str ch))))
          :else
          (recur (rest s) (inc x) y (assoc world :canvas (conj canvas [x y]))))))))


(defn find-portals
  [{:keys [canvas portal]} kv]
   (let [k (key kv)
         v (val kv)
         pt2 (first (select-keys portal (coord-neighbors k)))
         name (str/join "" (sort [v (val pt2)]))
         xy (first (set/intersection canvas (set (concat (coord-neighbors k) (coord-neighbors (key pt2))))))]
     {xy name}
     ))

(defn make-portalmap
  [{:keys [canvas portal] :as world} portals]
  (let [start (key (first (filter #(= "AA" (val %)) portals)))
        dest (key (first (filter #(= "ZZ" (val %)) portals)))
        adjacent (->> (combo/combinations portals 2)
                      (filter #(= (second (first %)) (second (second %))))
                      (map #(hash-map
                             (first (first %)) (first (second %))
                             (first (second %)) (first (first %))))
                      (into {}))]
    {:canvas canvas :start start :dest dest :adjacent adjacent}))

(reduce conj [0] [1 2 3])

(defn bfs-walk
  [canvas neighbors start dest]
  (loop [seen {} queue (conj clojure.lang.PersistentQueue/EMPTY [start nil])]
    (let [[node parent] (peek queue)]
      (if (nil? node)
        seen
        (let [seen (assoc seen node parent)
              more-nodes (filter #(and (contains? canvas %) (not (seen %))) (neighbors node))
              more-nodes (map #(vector % node) more-nodes)
              queue (reduce conj (pop queue) more-nodes)]
        (recur seen queue))))))

(defn bfs-path
  [canvas neighbors start dest]
  (let [parentmap (bfs-walk canvas neighbors start dest)]
    (loop [node dest path (list)]
      (if (= node start)
        path
        (recur (parentmap node) (conj path node))))))

(defn part1
  []
  (let [world (-> "aoc/day20.txt"
                  io/resource
                  slurp
                  parse-world)
        canvas (:canvas world)
        world (->> (:portal world)
                   (map (partial find-portals world))
                   (into {})
                   (make-portalmap world))
        graph-fn (fn [xy]
                   (->> (conj (coord-neighbors xy) (get-in world [ :adjacent xy] [-10 -10]))
                        (filter #(not (nil? (canvas %))))))
        ]
    (count (bfs-path canvas graph-fn (:start world) (:dest world)))
    ))
