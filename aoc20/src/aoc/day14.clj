(ns aoc20.day14)

(defn input-lines
  []
  (let [s (->> "aoc/day14.txt"
               clojure.java.io/resource
               slurp
               clojure.string/split-lines
               (map #(clojure.string/split % #"[\[\] =]+"))
               )
        ]
    s))

(defn parse-mask
  [s]
  (->> s
       (map-indexed (fn [i c] (if (= c \X) nil [(- 35 i) (- (int c) 48)])))
       (filter #(not (nil? %)))))

(defn apply-mask
  [m v]
  (loop [val v masks m]
    (let [mask (first masks)
          masks (rest masks)
          [p b] mask]
      (cond
        (nil? mask)
        val
        (= 0 b)
        (recur (bit-clear val p) masks)
        :else
        (recur (bit-set val p) masks)))))

(defn part1
  []
  (loop [mem {} mask 0 lines (input-lines)]
    (let [line (first lines)
          lines (rest lines)
          [a b c] line]
      (cond
        (nil? line)
        (reduce + 0 (vals mem))
        (= "mask" a)
        (recur mem (parse-mask b) lines)
        (= "mem" a)
        (let [val (apply-mask mask (Integer. c))
              mem (assoc mem b val)]
        (recur mem mask lines))))))
