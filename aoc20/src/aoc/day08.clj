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

(defn run-p2
  [prog target]
  (loop [seen #{} pc 0 acc 0]
    (let [inst (get prog pc)
          op (nth inst 0)
          val (nth inst 1)]
      (cond
        (seen pc)
        nil
        (= target pc)
        acc
        (nil? inst)
        nil
        (= op "acc")
        (recur (conj seen pc) (inc pc) (+ acc val))
        (= op "nop")
        (recur (conj seen pc) (inc pc) acc)
        (= op "jmp")
        (recur (conj seen pc) (+ pc val) acc)))))

(defn run-with-subst-p2
  [prog i]
  (let [op (first (nth prog i))
        val (second (nth prog i))
        po (if (= "jmp" op) "nop" "jmp")
        prog (vec (assoc prog i [po val]))]
    (run-p2 prog (count prog))))

(defn part2
  []
  (let [prog (vec (input-lines))]
    (loop [i 0]
      (let [op (first (nth prog i))]
        (if (= op "acc")
          (recur (inc i))
          (let [acc (run-with-subst-p2 prog i)]
            (if (nil? acc)
              (recur (inc i))
              acc)))))))

(comment
  (part1)
  (part2)
  )
