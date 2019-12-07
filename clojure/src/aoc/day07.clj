(ns aoc.day07
  (:require [clojure.string :as string]
            [clojure.java.io :as io]
            [aoc.day05 :as ic]
            [clojure.math.combinatorics :as combo]))

(defn run-program-phase
  [prog phase in]
  (let [in (concat [phase] in)
        out (ic/program [prog in []])]
    out))

(defn run-program-phase-list
  [prog phases in]
  (let [phase (first phases)
        phases (rest phases)
        [_ _ out _] (ic/run-program-phase prog phase in)
        ]
    (if (empty? phases)
      out
      (recur prog phases out))))

(defn run-programm-all-phases
  [prog phases]
  (->> (combo/permutations phases)
       (map #(vector (run-program-phase-list prog % [0]) %))
       ))

(defn part1-run
  [s]
  (let [p (ic/program-compile s)
        outmap (run-programm-all-phases p [0 1 2 3 4])
        outmap (sort #(> (ffirst %1) (ffirst %2)) outmap)
        ]
    (first outmap)))

(defn part1
  []
  (let [s (-> "aoc/day07.txt"
              io/resource
              slurp)
        ]
    (part1-run s)))

(comment
(part1-run "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0")
(part1-run "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0")
(part1-run "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0")
(part1)
)
