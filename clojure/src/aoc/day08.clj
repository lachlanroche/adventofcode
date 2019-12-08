(ns aoc.day07
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.math.combinatorics :as combo]))

(defn image-color-count
  [{:keys [pixels w h]} c]
  (let [layers (partition (* w h) pixels)
    ]
    (->> layers
         (map (fn [layer] (count (filter #(= c %) layer)))))))

(defn image-checksum
  [{:keys [pixels w h] :as image}]
  (image-color-count image \0))

(defn part1-impl
  [s w h]
  (let [image {:pixels s :w w :h h}
        zeros (image-color-count image \0)
        ones (image-color-count image \1)
        twos (image-color-count image \2)
        counts (map vector zeros ones twos)
        counts (sort #(< (first %1) (first %2)) counts)
        least-0 (first counts)
        ]
    (tap> counts)
    (tap> least-0)
    (* (second least-0) (nth least-0 2))))

(defn part1
  []
  (let [s (-> "aoc/day08.txt"
              io/resource
              slurp)
        ]
    (part1-impl s 25 6)))

(comment
(part1)
)

(defn pixel-color
  [colors]
  (->> colors
       (filter #(not= \2 %))
       first))

(defn image-parse
  [s w h]
  (let [layers (partition (* w h) s)
        layerv (apply map vector layers)
        pixels (map pixel-color layerv)
        ]
    {:pixels pixels :w w :h h}))

(defn image-string
  [{:keys [pixels w h]}]
  (let [m {\0 " " \1 "*" \2 " "}]
    (->> pixels
         (map #(get m %))
         (partition w)
         (map #(apply str %))
         (str/join "\n")
         )))

(defn part2
  []
  (let [s (-> "aoc/day08.txt"
              io/resource
              slurp)
        img (image-parse s 25 6)
        ]
    (image-string img)))

(comment
(part2)
)
