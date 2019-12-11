(ns aoc.day11
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.edn :as edn]
            [aoc.day09 :as ic]
            [clojure.math.combinatorics :as combo]))

(defn move-forward
  [{:keys [facing position] :as robot}]
  (let [m {:up [1 dec] :down [1 inc] :right [0 inc] :left [0 dec]}
        [index op] (get m facing)
        position (assoc position index (op (get position index)))]
    (assoc robot :position position)))

(defn turn
  [{:keys [facing] :as robot} facing-map]
  (assoc robot :facing (get facing-map facing)))

(defn turn-left
  [robot]
  (turn robot {:up :left :left :down :down :right :right :up}))

(defn turn-right
  [robot]
  (turn robot {:up :right :right :down :down :left :left :up}))

(defn paint
  [{:keys [position canvas] :as robot} color]
  (assoc robot :canvas (assoc canvas position color)))

(defn read-camera
  [{:keys [position canvas blank blank-origin]}]
  (if (= position [0 0])
    (get canvas position blank-origin)
    (get canvas position blank)))

(defn robot-action-paint
  [robot color]
  #_(tap> ["paint" color (:position robot)])
  (paint robot color))

(defn robot-action-move
  [robot direction]
  (let [turn-fn (get [turn-left turn-right] direction)
        robot (turn-fn robot)
        robot (move-forward robot)]
    #_(tap> ["move" direction (:position robot)])
    robot))

(defn robot-action
  [robot val]
  (let [action-fn (:action robot)
        robot (action-fn robot val)
        action (if (= action-fn robot-action-paint) robot-action-move robot-action-paint)]
    (assoc robot :action action)))

(defn make-robot
  [base-color origin-color]
  {:position [0 0] :facing :up :canvas {} :blank base-color :blank-origin origin-color :action robot-action-paint})

(defn robot-program
  ([prog origin-color]
   (robot-program (make-robot 0 origin-color) prog [] [] 0 0))
  ([robot mem in out offset rbase]
   (cond
     (not (empty? out))
     (let [robot (robot-action robot (first out))
           out (vec (rest out))]
       (recur robot mem in out offset rbase))
     (and (ic/program-wait-input? mem offset) (empty? in))
     (let [pixel (read-camera robot)]
       (recur robot mem [pixel] out offset rbase))
     (ic/program-stopped? mem offset)
     (do
       (tap> [in out offset rbase robot mem])
       robot)
     :else
     (let [[mio reg] (ic/program [mem in out] offset rbase)
           [mem in out] mio
           [offset rbase] reg]
       (recur robot mem in out offset rbase))
     )))

(defn robot-bounds
  [{:keys [canvas]}]
  (let [[minx maxx miny maxy] (reduce #(let [[x0 x9 y0 y9] %1 [x y] %2] (vector (min x x0) (max x x9) (min y y0) (max y y9))) [0 0 0 0] (keys canvas))]
    {:minx minx :miny miny :maxx maxx :maxy maxy}))

(defn robot-print
  [{:keys [canvas blank] :as robot}]
  (let [{:keys [minx miny maxx maxy]} (robot-bounds robot)]
    (loop [x minx y miny s []]
      (let [c (get canvas [x y] 2)
            c (get ["_" "#" " "] c)
            s (conj s c)]
        (cond
          (and (= x maxx) (= y maxy))
          (str/join "" s)
          (= x maxx)
          (recur minx (+ y 1) (conj s "\n"))
          :else
          (recur (+ x 1) y s))))))

#_
(let [robot (make-robot 0)
      robot (reduce #(robot-action %1 %2) robot [1 0 0 0 1 0 1 0 0 1 1 0 1 0])]
  (println (robot-print robot))
  [robot (count (:canvas robot)) (robot-bounds robot) (robot-print robot)])


(defn part1
  []
  (let [s (-> "aoc/day11.txt"
              io/resource
              slurp)
        prog (ic/program-compile s)
        robot (robot-program prog 0)]
    (println (robot-print robot))
    (count (:canvas robot))))

(defn part2
  []
  (let [s (-> "aoc/day11.txt"
              io/resource
              slurp)
        prog (ic/program-compile s)
        robot (robot-program prog 1)]
    (robot-print robot)))

(comment
(part1)
(part2)
)
