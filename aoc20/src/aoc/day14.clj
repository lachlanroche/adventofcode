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

(defn make-floating-mask
  [bits]
  (loop [fns [identity] bits bits]
    (let [bit (first bits)
          bits (rest bits)]
      (cond
        (nil? bit)
        fns
        :else
        (let [f0 (map #(comp (fn [v] (bit-clear v bit)) %) fns)
              f1 (map #(comp (fn [v] (bit-set v bit)) %) fns)]
          (recur (concat f0 f1) bits))))))

(defn make-fixed-mask
  [bits]
  (loop [f identity bits bits]
    (let [bit (first bits)
          bits (rest bits)]
      (cond
        (nil? bit)
        f
        :else
        (let [f (comp (fn [v] (bit-set v bit)) f)]
          (recur f bits))))))

(defn addr-mask-fns
  [m]
  (let [bit-map (->> m
                     (map-indexed #(vector (- 35 %1) %2))
                     (group-by second))
        fn-1 (->> (get bit-map \1)
                  (map first)
                  make-fixed-mask)
        fn-X (->> (get bit-map \X)
                  (map first)
                  make-floating-mask)
        fn-1X (map #(comp fn-1 %) fn-X)
        ]
    fn-1X))

(defn part2
  []
  (loop [mem {} mask identity lines (input-lines)]
    (let [line (first lines)
          lines (rest lines)
          [a b c] line]
      (cond
        (nil? line)
        (reduce + 0 (vals mem))
        (= "mask" a)
        (recur mem (addr-mask-fns b) lines)
        (= "mem" a)
        (let [val (Integer. c)
              b (Integer. b)
              bs (map #(% b) mask)
              mem (reduce (fn [mem b] (assoc mem b val)) mem bs)
              ]
        (recur mem mask lines))))))
