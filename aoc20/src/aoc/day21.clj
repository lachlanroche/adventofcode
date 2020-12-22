(ns aoc20.day21
  (:require [instaparse.core :as insta]))

(defn parse-line
  [line]
  (loop [suffix false ingredient #{} allergen #{} line line]
    (let [l (first line)
          line (rest line)]
      (cond
        (nil? l)
        {:ingredients ingredient :allergens allergen}
        (= l "contains")
        (recur true ingredient allergen line)
        (= true suffix)
        (recur suffix ingredient (conj allergen (keyword l)) line)
        :else
        (recur suffix (conj ingredient l) allergen line)))))

(defn input-file
  []
  (let [s (->> (str "aoc/day21.txt")
               clojure.java.io/resource
               slurp
               clojure.string/split-lines
               (map #(clojure.string/split % #"[ ,\(\)]+"))
               (map parse-line)
        )]
    s))

(defn solve-candidates
  [candidates]
  (loop [result {} singles [] candidates candidates]
    (cond
      (empty? candidates)
      result
      (empty? singles)
      (let [singles (filter #(= 1 (count (val %))) candidates)]
        (recur result singles candidates))
      :else
      (let [single (first singles)
            sk (key single)
            sv (first (val single))
            result (assoc result sv sk)
            candidates (dissoc candidates sk)
            candidates (into {} (for [[k v] candidates] [k (disj v sv)]))]
        (recur result (rest singles) candidates)))))

(defn part1 []
  (let [foods (input-file)
        allergens (->> foods
                       (map :allergens)
                       (apply clojure.set/union))
        candidates (into {}
                         (for [a allergens]
                           [a (reduce (fn [acc {:keys [ingredients allergens]}]
                                        (cond
                                          (not (allergens a))
                                          acc
                                          (nil? acc)
                                          ingredients
                                          :else
                                          (clojure.set/intersection acc ingredients)))
                                      nil
                                      foods)]))
        candidates (->> candidates
                        solve-candidates
                        (map key)
                        set)
        ]
    (->> foods
         (map :ingredients)
         (map #(clojure.set/difference % candidates))
         (map count)
         (reduce + 0)
         )))
