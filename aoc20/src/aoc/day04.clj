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

(defn parse-int
  [s]
  (if (nil? s)
    nil
    (try
      (Integer. s)
      (catch Exception _ nil)
    )))

(defn parse-inch
  [s]
  (cond
    (nil? s)
    nil
    (not (clojure.string/ends-with? s "in"))
    nil
    :else
    (parse-int (clojure.string/join "" (drop-last 2 s)))))

(defn parse-cm
  [s]
  (cond
    (nil? s)
    nil
    (not (clojure.string/ends-with? s "cm"))
    nil
    :else
    (parse-int (clojure.string/join "" (drop-last 2 s)))))

(defn valid-hcl?
  [hcl]
  (and
   (string? hcl)
   (= 7 (count hcl))
   (= \# (first hcl))
   (= 6 (count (filter #{\0 \1 \2 \3 \4 \5 \6 \7 \8 \9 \a \b \c \d \e \f} (rest hcl))))))

(defn valid-p2?
  [{:keys [byr iyr eyr hgt hcl ecl pid cid] :as pp}]

  (let [byr_ (parse-int byr)
        iyr_ (parse-int iyr)
        eyr_ (parse-int eyr)
        hgt_in (parse-inch hgt)
        hgt_cm (parse-cm hgt)
        pid_ (parse-int pid)
        cid_ (parse-int cid)]
    (and (and (number? byr_)
              (>= 2002 byr_ 1920))
         (and (number? iyr_)
              (>= 2020 iyr_ 2010))
         (and (number? eyr_)
              (>= 2030 eyr_ 2020))
         (or
          (and (number? hgt_cm) (>= 193 hgt_cm 150))
          (and (number? hgt_in) (>= 76 hgt_in 59)))
         (valid-hcl? hcl)
         (#{"amb" "blu" "brn" "gry" "grn" "hzl" "oth"} ecl)
         (number? pid_)
         (= 9 (count pid))
         )))

(defn part1
  []
  (->> (input-data)
       (filter valid-p1?)
       count))

(defn part2
  []
  (->> (input-data)
       (filter valid-p2?)
       count))

(comment
  (part1)
  (part2)
)
