(ns aoc.day25
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.set :as set]
            [aoc.day09 :as ic]
            [clojure.math.combinatorics :as combo]))

(defn load-program
  []
  (->> "aoc/day25.txt"
       io/resource
       slurp
       ic/program-compile))

(defn stopped?
  [[mem _ _ offset _]]
  (ic/program-stopped? mem offset))

(defn wait-input?
  [[mem _ _ offset _]]
  (ic/program-wait-input? mem offset))

(defn make-world
  []
  {:computer [(load-program) [] [] 0 0] :canvas {} :inventory #{}})

(defn run
  [{:keys [computer canvas inventory] :as world} command]
  (let [input (map int command)
        input (concat input [10])
        input (vec input)
        [mem _ out offset rbase] computer
        [mem _ out offset rbase] (ic/program mem input [] offset rbase)
        world (assoc world :computer [mem [] out offset rbase])
        output (str/join "" (map char out))
        ]
      [world output]))

(defn run-step
  [world command]
  (let [[world output] (run world command)]
    (println output)
    world))

(defn part1
  []
  (reduce run-step (make-world)
          ["west"
           "west"
           "east" "take mug"
           "north" #_ "take easter egg"
           "south"
           "east"
           "south" #_ "escape pod"
           "south" #_ "infinite loop"
           "north"
           "east" #_ "ignore photons"
           "north" #_"take candy cane"
           "south"
           "west"
           "north" #_ "at start"
           "east"
           "north"
           "east" #_"take manifold"
           "west"
           "north" "take hypercube"
           "south"
           "south" "take coin"
           "south"
           "east" #_"take pointer"
           "west"
           "west" "take astrolabe"
           "south" #_"giant electromagnet"
           "north"
           "north"
           "east" "ignore molten lava"
           "north"
           "east" #_ "have correct set of items before entering"
           ])
