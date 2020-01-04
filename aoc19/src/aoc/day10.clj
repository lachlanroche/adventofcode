(ns aoc.day10
  (:require [clojure.string :as str]
            [clojure.set :as set]
            [clojure.java.io :as io]
            [clojure.math.combinatorics :as combo]))

(defn parse-field
 [s]
 (let [lines (str/split s #"[\n]")
       maxx (dec (count (first lines)))
       maxy (dec (count lines))]
   (loop [x 0
          y 0
          field {}]
     (let [line (get lines y)
           point (get line x)
           field (assoc field [x y] point)]
       (cond
         (and (= maxx x) (= maxy y))
         field
         (= maxx x)
         (recur 0 (inc y) field)
         :else
         (recur (inc x) y field))))))

(defn locations-of
  [ch m]
  (->> m
       (filter #(= ch (val %)))
       (map first)
       set))

(defn polar-adjust
  [[x y]]
  (let [[x y] [(- x) y]]
    (cond
      (and (> 0 x) (> 0 y))
      [y (- x)]
      (and (> 0 x) (< 0 y))
      [y (- x)]
      (and (< 0 x) (> 0 y))
      [y (- x)]
      :else
      [y (- x)])))

(defn polar-coord
  [[x y]]
  (let [x (double x)
        y (double y)
        [x y] (polar-adjust [x y])
        dist (Math/sqrt (+ (* x x) (* y y)))
        angle (Math/acos (/ (* -1 x) dist))
        angle (if (<= 0 y) angle (+ (* -1 angle) (Math/PI) (Math/PI)))]
  {:dist dist :angle (float angle)}))

(defn asteroid-visibility
  [{:keys [asteroids] :as field} bpoint]
  (let [[bx by] bpoint
        asteroids (disj asteroids bpoint)
        normalise (fn [[ax ay]] [(- ax bx) (- ay by)])
        asteroids (map #(merge {:asteroid % :normal (normalise %)} (polar-coord (normalise %))) asteroids)
        asteroids (sort-by (juxt :angle :dist) asteroids)
        ]
    asteroids))

(defn part1-impl
  [s]
  (let [field (parse-field s)
        asteroids (locations-of \# field)
        field {:asteroids asteroids}
        ]
    (->> asteroids
         (map #(hash-map :asteroid % :count (count (group-by :angle (asteroid-visibility field %)))))
         (sort-by :count)
         last)))

(defn part1
  []
  (let [s (-> "aoc/day10.txt"
              io/resource
              slurp)]
    (part1-impl s)))

(defn zap-rocks
  [angle-map]
  (loop [n 200 c (count angle-map) angle-map angle-map]
    (cond
      (<= n c)
      (-> angle-map
          (nth (- n 1))
          first
          :asteroid)
      :else
      (let [n (- c n)
            angle-map (->> angle-map
                           (map #(drop 1 %))
                           (filter #(not (empty? %))))
            c (count angle-map)]
        (recur n c angle-map)))))

(defn part2-impl
  [s]
  (let [field (parse-field s)
        asteroids (locations-of \# field)
        field {:asteroids asteroids}
        base (:asteroid (part1-impl s))
        angle-map (->> base
                       (asteroid-visibility field)
                       (sort-by :angle)
                       (partition-by :angle))
        ]
    (zap-rocks angle-map)))

(defn part2
  []
  (let [s (-> "aoc/day10.txt"
              io/resource
              slurp)]
    (part2-impl s)))

(comment
(part2)
(part2-impl ".#..##.###...#######\n##.############..##.\n.#.######.########.#\n.###.#######.####.#.\n#####.##.#.##.###.##\n..#####..#.#########\n####################\n#.####....###.#.#.##\n##.#################\n#####.##.###..####..\n..######..##.#######\n####.##.####...##..#\n.#####..#.######.###\n##...#.##########...\n#.##########.#######\n.####.#.###.###.#.##\n....##.##.###..#####\n.#.#.###########.###\n#.#.#.#####.####.###\n###.##.####.##.#..##")
(part1)
(part1-impl ".#..#\n.....\n#####\n....#\n...##")
(part1-impl "......#.#.\n#..#.#....\n..#######.\n.#.#.###..\n.#..#.....\n..#....#.#\n#..#....#.\n.##.#..###\n##...#..#.\n.#....####")
(part1-impl "#.#...#.#.\n.###....#.\n.#....#...\n##.#.#.#.#\n....#.#.#.\n.##..###.#\n..#...##..\n..##....##\n......#...\n.####.###.")
(part1-impl ".#..#..###\n####.###.#\n....###.#.\n..###.##.#\n##.##.#.#.\n....###..#\n..#.#..#.#\n#..#.#.###\n.##...##.#\n.....#.#..")
(part1-impl ".#..##.###...#######\n##.############..##.\n.#.######.########.#\n.###.#######.####.#.\n#####.##.#.##.###.##\n..#####..#.#########\n####################\n#.####....###.#.#.##\n##.#################\n#####.##.###..####..\n..######..##.#######\n####.##.####...##..#\n.#####..#.######.###\n##...#.##########...\n#.##########.#######\n.####.#.###.###.#.##\n....##.##.###..#####\n.#.#.###########.###\n#.#.#.#####.####.###\n###.##.####.##.#..##")
)
