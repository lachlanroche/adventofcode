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

(defn part2
  []
  (let [rules (-> (input-file "day19r")
                  (clojure.string/replace #"8: 42" "8: 42 | 42 8")
                  (clojure.string/replace #"11: 42 31" "11: 42 31 | 42 11 31")
                  load-rules)]
  (->> (load-messages)
       (map rules)
       (filter (complement :index))
       count)))
