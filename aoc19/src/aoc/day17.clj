(ns aoc.day17
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.set :as set]
            [aoc.day09 :as ic]
            [astar.core :as astar]))

(defn coord-neighbors
  [{x 0 y 1}]
  [[x (inc y)] [x (dec y)] [(dec x) y] [(inc x) y]])

(defn parse-scaffold-map
  [s]
  (loop [s s x 0 y 0 world {:canvas #{}}]
    (if (empty? s)
      world
      (let [ch (str (first s))
            robot? (contains? #{"^" "v" "<" ">"} ch)
            world (if (not robot?) world (assoc world :robot [[x y] ch]))
            canvas (:canvas world)
            ]
        (cond
          (= ch "\n")
          (recur (rest s) 0 (inc y) world)
          (= ch ".")
          (recur (rest s) (inc x) y world)
          :else
          (recur (rest s) (inc x) y (assoc world :canvas (conj canvas [x y]))))))))

(defn intersections
  [{:keys [canvas] :as world}]
  (->> canvas
       (map #(hash-map % (coord-neighbors %)))
       (into {})
       (filter #(set/subset? (val %) canvas))
       (map key)))

(defn sum-alignment-parameters
  [world]
  (->> world
      intersections
      (map #(apply * %))
      (reduce + 0)))

(defn part1
  []
  (let [s (-> "aoc/day17.txt"
              io/resource
              slurp)
        prog (ic/program-compile s)
        [mio _] (ic/program [prog [] []] 0 0)
        [_ _ out] mio
        outs (str/join "" (map char out))
        ]
    (->> outs
         parse-scaffold-map
         sum-alignment-parameters)))

(defn robot-turn-direction
  [canvas xy dir]
  (let [[d u l r] (coord-neighbors xy)
        check ({"^" {"L" l "R" r}
                "v" {"L" r "R" l}
                ">" {"L" u "R" d}
                "<" {"L" d "R" u}} dir)
        result (->> check
                    (filter #(canvas (val %)))
                    first)]
    (if (nil? result)
      nil
      (key result))))

(defn walk-forwards
  [canvas xy dir]
  (loop [steps 0 xy xy]
    (let [[d u l r] (coord-neighbors xy)
          step ({"^" u "v" d ">" r "<" l} dir)]
      (if (canvas step)
        (recur (inc steps) step)
        [xy steps]))))

(defn robot-turn
  [dir turn]
  (get-in {"^" {"L" "<" "R" ">"}
           "v" {"L" ">" "R" "<"}
           ">" {"L" "^" "R" "v"}
           "<" {"L" "v" "R" "^"}} [dir turn]))

(defn simple-path
  [{:keys [canvas robot]}]
  (let [[rxy rdir] robot]
    (loop [xy rxy dir rdir path []]
      (let [turn (robot-turn-direction canvas xy dir)
            dir (robot-turn dir turn)]
        (if (nil? dir)
          path
          (let [[xy steps] (walk-forwards canvas xy dir)]
            (recur xy dir (concat path [turn (str steps)]))))))))

(defn sq-replace
  [match replacement sq]
  (let [matching (count match)]
    ((fn replace-in-sequence [[elt & elts :as sq]]
       (lazy-seq
        (cond (empty? sq)
              ()
              (= match (take matching sq))
              (concat replacement (replace-in-sequence (drop matching sq)))
              :default
              (cons elt (replace-in-sequence elts)))))
     sq)))

(defn part2
  []
  (let [s (-> "aoc/day17.txt"
              io/resource
              slurp)
        prog (ic/program-compile s)
        [mio _] (ic/program [prog [] []] 0 0)
        [_ _ out] mio
        outs (str/join "" (map char out))
        world (parse-scaffold-map outs)
        path (simple-path world)
        a ["L" "12" "L" "12" "R" "4"]
        b ["R" "10" "R" "6" "R" "4" "R" "4"]
        c ["R" "6" "L" "12" "L" "12"]
        main (->> path
                  (sq-replace a ["A"])
                  (sq-replace b ["B"])
                  (sq-replace c ["C"]))
        in (concat (interpose "," main)
                   "\n"
                   (interpose "," a)
                   "\n"
                   (interpose "," b)
                   "\n"
                   (interpose "," c)
                   ["\n" "n" "\n"])
        in (map int (str/join "" in))
        prog (assoc prog 0 2)
        [mio _] (ic/program [prog in []] 0 0)
        [_ _ out] mio]
    (if (< 255 (last out))
       (last out)
       (str/join "" (map char out)))))

(comment
(part1)
(part2)
(= 76 (let [s "..#..........\n..#..........\n#######...###\n#.#...#...#.#\n#############\n..#...#...#..\n..#####...^.."]
        (sum-alignment-parameters s)))
)
