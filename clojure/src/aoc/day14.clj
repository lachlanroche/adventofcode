(ns aoc.day14
  (:require [clojure.string :as str]
            [clojure.set :as set]
            [clojure.java.io :as io]
            [clojure.math.combinatorics :as combo]))

(defn parse-chemical
  [[s t]]
  [t (Integer/parseInt s)])

(defn parse-reaction
  [s]
  (let [ss (str/split s #"[, ]+")
        ss (filter #(not= % "=>") ss)
        n (- (count ss) 2)
        reaction (->> (take n ss)
                 (partition 2)
                 (map parse-chemical)
                 (into {}))
        [out qty] (parse-chemical (drop n ss))
        ]
    {out {:require (vec (keys reaction)) :output out :quantity qty :reaction reaction}}))

(defn parse-reactions
  [s]
  (->> s
       str/split-lines
       (map parse-reaction)
       (into {})))

(defn consume
  [stock el qty]
  (let [have (get stock el 0)
        have (- have qty)
        ]
    (assoc stock el have)))

(defmulti produce
  (fn [world el qty] (if (= el "ORE") "ORE" nil)))

(defmethod produce "ORE"
  [{:keys [stock] :as world} typ qty]
  (assoc world :stock (consume stock typ qty)))

(defmethod produce nil
  [{:keys [stock rules] :as world} typ qty]
  (let [rule (get rules typ)
        requires (:require rule)
        reaction (:reaction rule)
        rule_qty (:quantity rule)
        multiple (quot qty rule_qty)
        multiple (if (zero? (mod qty rule_qty)) multiple (inc multiple))
        ]
    (loop [stock stock require requires]
      (cond
        (and (empty? require) (nil? (some neg? (select-keys requires stock))))
        (let [el_n (get stock typ 0)
              el_n (+ el_n (* rule_qty multiple))]
          (assoc world :stock (assoc stock typ el_n)))
        (not (empty? require))
        (let [el (first require)
              el_n (* multiple (get reaction el 0))
              stock (consume stock el el_n)
              el_n (get stock el 0)
              ]
          (cond
            (= "ORE" el)
            (recur stock (rest require))
            (not (neg? el_n))
            (recur stock (rest require))
            :else
            (let [w (assoc world :stock stock)
                  w (produce w el (- el_n))]
              (recur (:stock w) (rest require)))))))))

(defn ore-to-produce
  [world typ qty]
  (let [result (produce world typ qty)]
    (- (get-in result [:stock "ORE"] 0))))

(defn part1-impl
  [s]
  (let [world {:stock {} :rules (parse-reactions s)}]
    (ore-to-produce world "FUEL" 1)))

(defn part1
  []
  (let [s (-> "aoc/day14.txt"
              io/resource
              slurp)]
    (part1-impl s)))

(defn part2-impl
  [s]
  (let [world {:stock {} :rules (parse-reactions s)}
        target 1000000000000]
    (loop [lower 0 upper 1000000000]
      (cond
        (= lower upper)
        lower
        (= (inc lower) upper)
        (if (> target (ore-to-produce world "FUEL" upper))
          upper
          lower)
        :else
        (let [window (- upper lower)
              middle (+ lower (quot (- upper lower) 2))
              result (ore-to-produce world "FUEL" middle)]
          (tap> [lower middle upper result])
          (cond
            (> result target)
            (recur lower middle)
            (= target result)
            middle
            :else
            (recur middle upper)))))))

(defn part2
  []
  (let [s (-> "aoc/day14.txt"
              io/resource
              slurp)]
    (part2-impl s)))

(part1)
(= 31 (part1-impl 1 "10 ORE => 10 A\n1 ORE => 1 B\n7 A, 1 B => 1 C\n7 A, 1 C => 1 D\n7 A, 1 D => 1 E\n7 A, 1 E => 1 FUEL"))
(= 165 (part1-impl 1 "9 ORE => 2 A\n8 ORE => 3 B\n7 ORE => 5 C\n3 A, 4 B => 1 AB\n5 B, 7 C => 1 BC\n4 C, 1 A => 1 CA\n2 AB, 3 BC, 4 CA => 1 FUEL"))
(= 13312 (part1-impl 1 "157 ORE => 5 NZVS\n165 ORE => 6 DCFZ\n44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL\n12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ\n179 ORE => 7 PSHF\n177 ORE => 5 HKGWZ\n7 DCFZ, 7 PSHF => 2 XJWVT\n165 ORE => 2 GPVTF\n3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT"))
(= 180697 (part1-impl 1 "2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG\n17 NVRVD, 3 JNWZP => 8 VPVL\n53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL\n22 VJHF, 37 MNCFX => 5 FWMGM\n139 ORE => 4 NVRVD\n144 ORE => 7 JNWZP\n5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC\n5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV\n145 ORE => 6 MNCFX\n1 NVRVD => 8 CXFTF\n1 VJHF, 6 MNCFX => 4 RFSQX\n176 ORE => 6 VJHF"))
(= 2210736 (part1-impl 1 "171 ORE => 8 CNZTR\n7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL\n114 ORE => 4 BHXH\n14 VRPVC => 6 BMBT\n6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL\n6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT\n15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW\n13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW\n5 BMBT => 4 WPTQ\n189 ORE => 9 KTJDG\n1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP\n12 VRPVC, 27 CNZTR => 2 XDBXC\n15 KTJDG, 12 BHXH => 5 XCVML\n3 BHXH, 2 VRPVC => 7 MZWV\n121 ORE => 7 VRPVC\n7 XCVML => 6 RJRHP\n5 BHXH, 4 VRPVC => 5 LTCX"))

(part2)
(= 82892753 (part2-impl "157 ORE => 5 NZVS\n165 ORE => 6 DCFZ\n44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL\n12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ\n179 ORE => 7 PSHF\n177 ORE => 5 HKGWZ\n7 DCFZ, 7 PSHF => 2 XJWVT\n165 ORE => 2 GPVTF\n3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT"))
(= 5586022 (part2-impl "2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG\n17 NVRVD, 3 JNWZP => 8 VPVL\n53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL\n22 VJHF, 37 MNCFX => 5 FWMGM\n139 ORE => 4 NVRVD\n144 ORE => 7 JNWZP\n5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC\n5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV\n145 ORE => 6 MNCFX\n1 NVRVD => 8 CXFTF\n1 VJHF, 6 MNCFX => 4 RFSQX\n176 ORE => 6 VJHF"))
(= 460664 (part2-impl "171 ORE => 8 CNZTR\n7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL\n114 ORE => 4 BHXH\n14 VRPVC => 6 BMBT\n6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL\n6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT\n15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW\n13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW\n5 BMBT => 4 WPTQ\n189 ORE => 9 KTJDG\n1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP\n12 VRPVC, 27 CNZTR => 2 XDBXC\n15 KTJDG, 12 BHXH => 5 XCVML\n3 BHXH, 2 VRPVC => 7 MZWV\n121 ORE => 7 VRPVC\n7 XCVML => 6 RJRHP\n5 BHXH, 4 VRPVC => 5 LTCX"))
)
