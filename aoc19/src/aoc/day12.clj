(ns aoc.day12
  (:require [clojure.string :as str]
            [clojure.set :as set]
            [clojure.java.io :as io]
            [clojure.math.combinatorics :as combo]))


(defn make-moon
  [x y z]
  {:position [x y z] :velocity [0 0 0]})

(defn potential
  [moon]
  (reduce #(+ %1 (Math/abs %2)) 0 (:position moon)))

(defn kinetic
  [moon]
  (reduce #(+ %1 (Math/abs %2)) 0 (:velocity moon)))

(defn energy
  [moon]
  (* (kinetic moon) (potential moon)))

(defn velocity-step
  [{:keys [position velocity] :as moon}]
  (assoc moon :position (vec (map + position velocity))))

(defn gravity
  [a b]
  (cond
    (= a b)
    0
    (> a b)
    -1
    :else
    1))

(defn gravity-pair
  [self other]
  (vec (map gravity (:position self) (:position other))))

(defn gravity-step
  [moons self]
  (let [accel (apply map + (map #(gravity-pair self %) moons))
        velocity (vec (map + accel (:velocity self)))]
    (assoc self :velocity velocity)))

(defn physics-step
  [moons]
  (let [result
        (->> moons
             (map (partial gravity-step moons))
             (map velocity-step))]
    (vec result)))

(defn part1-impl
  [n moons]
  (let [moons (nth (iterate physics-step moons) n)]
    (->> moons
         (map energy)
         (reduce + 0))))

(defn part1
  []
  (let [moons [(make-moon -3 15 -11) (make-moon 3 13 -19) (make-moon -13 18 -2) (make-moon 6 0 -1)]]
    (part1-impl 1000 moons)))


(defn gcd
  [a b]
  (if (zero? b)
    a
    (recur b, (mod a b))))

(defn lcm
  [a b]
  (/ (* a b) (gcd a b)))

(defn lcmv [v] (reduce lcm v))

(defn check-cycle
  [moons initial n]
  (and (= (get-in moons [0 :velocity n]) (get-in initial [0 :velocity n]))
       (= (get-in moons [0 :position n]) (get-in initial [0 :position n]))
       (= (get-in moons [1 :velocity n]) (get-in initial [1 :velocity n]))
       (= (get-in moons [1 :position n]) (get-in initial [1 :position n]))
       (= (get-in moons [2 :velocity n]) (get-in initial [2 :velocity n]))
       (= (get-in moons [2 :position n]) (get-in initial [2 :position n]))
       (= (get-in moons [3 :velocity n]) (get-in initial [3 :velocity n]))
       (= (get-in moons [3 :position n]) (get-in initial [3 :position n]))))

(defn part2-impl
  [moons]
  (let [initial moons
        ]
    (loop [i 1 moons moons cycle [nil nil nil]]
      (cond
        (reduce #(and %1 (not (nil? %2))) true cycle)
        (lcmv cycle)
        :else
        (let [moons (physics-step moons)
              [m1 m2 m3 m4] moons
              [cx cy cz] cycle
              cx (cond (not (nil? cx)) cx (check-cycle moons initial 0) i :else nil)
              cy (cond (not (nil? cy)) cy (check-cycle moons initial 1) i :else nil)
              cz (cond (not (nil? cz)) cz (check-cycle moons initial 2) i :else nil)
              ]
          (recur (inc i) moons [cx cy cz]))))))

(defn part2
  []
  (let [moons [(make-moon -3 15 -11) (make-moon 3 13 -19) (make-moon -13 18 -2) (make-moon 6 0 -1)]]
    (part2-impl moons)))

(comment
(part1)
(part2)
(->> [(make-moon -1 0 2) (make-moon 2 -10 -7) (make-moon 4 -8 8) (make-moon 3 5 -1)]
     (part1-impl 10)
     )
(->> [(make-moon -8 -10 0) (make-moon 5 5 10) (make-moon 2 -7 3) (make-moon 9 -8 -3)]
     (part1-impl 100)
     )
(->> [(make-moon -1 0 2) (make-moon 2 -10 -7) (make-moon 4 -8 8) (make-moon 3 5 -1)]
     (part2-impl))
(->> [(make-moon -8 -10 0) (make-moon 5 5 10) (make-moon 2 -7 3) (make-moon 9 -8 -3)]
     (part2-impl)
     )
)
