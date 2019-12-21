(ns aoc.day21
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.set :as set]
            [aoc.day09 :as ic]))

(defn load-program
  []
  (-> "aoc/day21.txt"
      io/resource
      slurp
      ic/program-compile))

(defn springdroid-run
  [prog in]
  (let [[mio reg] (ic/program [prog in []] 0 0)
        [mem _ out] mio
        [offset rbase] reg
        [mio reg] (ic/program [mem in out] offset rbase)
        [mem _ out] mio]
    (if (< 255 (last out))
      (last out)
      (str/join "" (map char out)))))

(defn springdroid-runsc
  [code]
  (springdroid-run (load-program) (map int (str/join "\n" (concat code [""])))))

(defn part1
  []
  (springdroid-runsc ["NOT A J" "NOT B T" "OR T J" "NOT C T" "OR T J" "AND D J" "WALK"]))

(defn part2
  []
  (springdroid-runsc
   ["NOT A J" "NOT B T" "AND D T" "OR T J" "NOT C T" "OR T J" "NOT A T" "OR T J" "AND H J" "OR E J" "AND D J" "RUN"]))
