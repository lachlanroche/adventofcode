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
  [str]
  (insta/parser str :start :0))

(defn load-messages
  []
  (->> (input-file "day19m")
       clojure.string/split-lines))

(defn part1
  []
  (let [rules (-> (input-file "day19r")
                  load-rules)]
  (->> (load-messages)
       (map rules)
       (filter (complement :index))
       count)))

