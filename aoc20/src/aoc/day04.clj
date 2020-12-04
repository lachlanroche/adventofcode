(ns aoc20.day04)

(defn input-lines
  []
  (->> "aoc/day04.txt"
      clojure.java.io/resource
      slurp
      clojure.string/split-lines
      ))

(defn parse-p
  [line]
  (let [ss (clojure.string/split line #" +")]
    (loop [p {} ss ss]
      (let [s (first ss)
            ss (rest ss)]
      (cond
        (nil? s)
        p
        (= "" s)
        (recur p ss)
        :else
        (let [[k v] (clojure.string/split s #":")]
          (recur (assoc p (keyword k) v) ss)))))))

(defn input-data
  []
  (loop [pp [] p {} lines (input-lines)]
    (let [line (first lines)
          lines (rest lines)]
      (cond
        (nil? line)
        (if (= {} p)
          p
          (conj pp p))
        (= "" line)
        (recur (conj pp p) {} lines)
        :true
        (recur pp (merge p (parse-p line)) lines)
        ))))

(defn valid-p1?
  [{:keys [byr iyr eyr hgt hcl ecl pid cid] :as pp}]
  (and
   (not (nil? byr))
   (not (nil? iyr))
   (not (nil? eyr))
   (not (nil? hgt))
   (not (nil? hcl))
   (not (nil? ecl))
   (not (nil? pid))))

(defn part1
  []
  (->> (input-data)
       (filter valid-p1?)
       count))

(comment
  (part1)
)
