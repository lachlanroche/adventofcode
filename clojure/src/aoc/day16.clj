(ns aoc.day16
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.set :as set]))

(defn parse
  [s]
  (->> s
       (map #(- (int %) (int \0)))
       (filter #(<= 0 % 9))))

(defn pattern
  [i n]
  (->> [0 1 0 -1]
       (map #(repeat (inc i) %))
       flatten
       cycle
       (take (inc n))
       (drop 1)))

(defn fft-step
  [in i]
  (let [res (->> in
                 (map * (pattern i (count in)))
                 (reduce + 0))]
    (-> res
        Math/abs
        (rem 10))))

(defn fft-phase
  [in]
  (map #(fft-step in %) (range 0 (count in))))

(defn fft
  [in phases]
  (loop [in in i 0]
    (if (= i phases)
      (take 8 in)
      (recur (fft-phase in) (inc i)))))

(defn part1
  []
  (let [s (-> "aoc/day16.txt"
              io/resource
              slurp)]
    (fft (parse s) 100)))


(defn last-digit
  [x]
  (-> x
      Math/abs
      (mod 10)))

(defn part2-impl
  [end]
  (let [list-sum (reduce + end)]
    (loop [end end out [] r list-sum]
      (if (empty? end)
        (reverse out)
        (let [r1 (- r (first end))]
          (recur (rest end) (cons (last-digit r) out) r1))))))

(defn part2
  []
  (let [s (-> "aoc/day16.txt"
              io/resource
              slurp)
        signal (->> s
                    parse
                    (repeat 10000)
                    flatten)
        offset (->> signal
                    (take 7)
                    (reduce #(+ %2 (* 10 %1)) 0))
        ]
    (loop [i 0 xs (drop offset signal)]
      (if (= i 100)
        (take 8 xs)
        (recur (inc i) (part2-impl xs))))))

(comment
(part1)
(part2)
(fft [1 2 3 4 5 6 7 8] 4)
(fft (parse "") 100)
(= (parse "24176176") (fft (parse "80871224585914546619083218645595") 100))
(= (parse "73745418") (fft (parse "19617804207202209144916044189917") 100))
(= (parse "52432133") (fft (parse "69317163492948606335995924319873") 100))
)
