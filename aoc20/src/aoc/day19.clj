(ns aoc20.day19
  (:require [instaparse.core :as insta]))

(defn input-file
  [fname]
  (let [s (->> (str "aoc/" fname ".txt")
               clojure.java.io/resource
               slurp
               )]
    s))

(defn load-rules
  []
  (insta/parser (input-file "day19r") :start :0))

(defn load-messages
  []
  (->> (input-file "day19m")
       clojure.string/split-lines))

(defn part1
  []
  (->> (load-messages)
       (map (load-rules))
       (filter (complement :index))
       count))

