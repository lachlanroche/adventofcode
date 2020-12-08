(ns aoc20.day08)

(defn input-lines
  []
  (let [s (->> "aoc/day08.txt"
               clojure.java.io/resource
               slurp
               clojure.string/split-lines
               (map #(clojure.string/split % #"[\., ]+"))
               (map #(vector (nth % 0) (Integer. (nth % 1)))))
        ]
    s))

(defn part1
  []
  (let [prog (input-lines)]
    (loop [seen #{} pc 0 acc 0]
      (tap> (nth prog pc))
      (let [inst (nth prog pc)
            op (nth inst 0)
            val (nth inst 1)]
        (cond
          (seen pc)
          acc
          (= op "acc")
          (recur (conj seen pc) (inc pc) (+ acc val))
          (= op "nop")
          (recur (conj seen pc) (inc pc) acc)
          (= op "jmp")
          (recur (conj seen pc) (+ pc val) acc))))))

(comment
  (part1)
  )
