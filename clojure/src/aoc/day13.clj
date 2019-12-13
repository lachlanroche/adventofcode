(ns aoc.day13
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.edn :as edn]
            [aoc.day09 :as ic]
            [clojure.math.combinatorics :as combo]))

(defn make-arcade
  []
  {:canvas {} :blank 0 :score 0 :ball [-0 0] :paddle [0 0] :started false})

(defn arcade-draw
  [{:keys [canvas ball paddle started] :as arcade} [x y c]]
  (if (and (= y 0) (= x -1))
    (assoc arcade :score c)
    (let [canvas (assoc canvas [x y] c)
          ball (if (= c 4) [x y] ball)
          paddle (if (= c 3) [x y] paddle)
          started (if (= c 2) true started)]
      (assoc arcade :canvas canvas :ball ball :paddle paddle :started started))))

(defn arcade-move-joystick
  [{:keys [ball paddle]}]
  (let [[bx _] ball
        [px _] paddle]
    (cond
      (= bx px)
      0
      (< bx px)
      -1
      :else
      1)))

(defn arcade-count-blocks
  [{:keys [canvas]}]
  (count (filter #(= 2 %) (vals canvas))))

(defn arcade-program
  ([prog]
   (arcade-program (make-arcade) prog [] [] 0 0))
  ([prog coins]
   (arcade-program (make-arcade) (assoc prog 0 coins) [] [] 0 0))
  ([arcade mem in out offset rbase]
   (cond
     (<= 3 (count out))
     (let [arcade (arcade-draw arcade (vec (take 3 out)))
           out (vec (drop 3 out))]
       (recur arcade mem in out offset rbase))
     (and (ic/program-wait-input? mem offset) (empty? in))
     (let [stick (arcade-move-joystick arcade)]
       (recur arcade mem [stick] out offset rbase))
     (ic/program-stopped? mem offset)
     (do
       #_(tap> [in out offset rbase robot mem])
       arcade)
     (and (:started arcade) (= 0 (arcade-count-blocks arcade)))
     arcade
     :else
     (let [[mio reg] (ic/program [mem in out] offset rbase)
           [mem in out] mio
           [offset rbase] reg]
       (recur arcade mem in out offset rbase))
     )))

(defn arcade-bounds
  [{:keys [canvas]}]
  (let [[minx maxx miny maxy] (reduce #(let [[x0 x9 y0 y9] %1 [x y] %2] (vector (min x x0) (max x x9) (min y y0) (max y y9))) [0 0 0 0] (keys canvas))]
    {:minx minx :miny miny :maxx maxx :maxy maxy}))

(defn arcade-print
  [{:keys [canvas blank] :as arcade}]
  (let [{:keys [minx miny maxx maxy]} (arcade-bounds arcade)]
    (loop [x minx y miny s []]
      (let [c (get canvas [x y] 0)
            c (get [" " "|" "#" "=" "o"] c)
            s (conj s c)]
        (cond
          (and (= x maxx) (= y maxy))
          (str/join "" s)
          (= x maxx)
          (recur minx (+ y 1) (conj s "\n"))
          :else
          (recur (+ x 1) y s))))))

(defn part1
  []
  (let [s (-> "aoc/day13.txt"
              io/resource
              slurp)
        prog (ic/program-compile s)
        arcade (arcade-program prog)]
    (println (arcade-print arcade))
    (arcade-count-blocks arcade)))

(defn part2
  []
  (let [s (-> "aoc/day13.txt"
              io/resource
              slurp)
        prog (ic/program-compile s)
        arcade (arcade-program prog 2)]
    (println (arcade-print arcade))
    (:score arcade)))

(comment
(part1)
(part2)
)
