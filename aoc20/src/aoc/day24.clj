(ns aoc20.day24)

(defn input-lines
  []
  (let [lines (->> (str "aoc/day24.txt")
                   clojure.java.io/resource
                   slurp
                   clojure.string/split-lines
                   )]
    lines))

(defn path-coord
  [path]
  (if (nil? path)
    nil
    (loop [x 0 y 0 path path]
      (let [p (first path)
            q (second path)]
        (cond
          (empty? path)
          [x y]
          (= p \e)
          (recur (+ x 2) y (rest path))
          (and (= p \n)
               (= q \e))
          (recur (+ x 1) (+ y 1) (rest (rest path)))
          (and (= p \n)
               (= q \w))
          (recur (- x 1) (+ y 1) (rest (rest path)))
          (= p \w)
          (recur (- x 2) y (rest path))
          (and (= p \s)
               (= q \w))
          (recur (- x 1) (- y 1) (rest (rest path)))
          (and (= p \s)
               (= q \e))
          (recur (+ x 1) (- y 1) (rest (rest path))))))))

(defn load-world
  []
  (loop [world #{} lines (input-lines)]
    (let [line (first lines)
          lines (rest lines)
          xy (path-coord line)]
      (cond
        (nil? line)
        world
        (world xy)
        (recur (disj world xy) lines)
        :else
        (recur (conj world xy) lines)))))

(defn part1
  []
  (->> (load-world)
       count))
