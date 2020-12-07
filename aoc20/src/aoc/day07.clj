(ns aoc20.day07)

(defn input-lines
  []
  (let [s (->> "aoc/day07.txt"
               clojure.java.io/resource
               slurp
               clojure.string/split-lines
               (map #(clojure.string/split % #"[\., ]+")))
        ]
    s))

(defn parse-bag
  [ss]
  (let [name (str (nth ss 0) " " (nth ss 1))]
    (if (= "no" (nth ss 4))
      (hash-map name {})
      (hash-map name
                (->> ss
                     (drop 4)
                     (partition 4)
                     (map #(hash-map (str (nth % 1) " " (nth % 2)) (Integer. (nth % 0))))
                     (apply merge))))))

(defn parents-of
  [n tree]
  (->> tree
       (filter #((apply hash-set (keys (val %))) n))
       (map key)
       ))

(defn ancestors-of
  [n tree]
  (loop [seen #{} ancestors #{} queue [n]]
    (let [q (first queue)
          queue (rest queue)]
      (if (nil? q)
        ancestors
        (let [parents (into #{} (parents-of q tree))
              seen (clojure.set/union seen #{q})
              ancestors (clojure.set/union parents ancestors)
              queue (concat queue (vec (clojure.set/difference parents seen)))]
          (recur seen ancestors queue))))))

(defn part1
  []
  (let [tree (->> (input-lines)
                  (map parse-bag)
                  (apply merge))
        ]
    (->> tree
         (ancestors-of "shiny gold")
         count)))

(defn children-of
  [n tree]
  (->> (get tree n)))

(defn weight-of
  [n tree]
  (let [children (children-of n tree)]
    (if (empty? children)
      1
      (loop [cweight 0 children children]
        (let [child (first children)
              children (rest children)]
          (cond
            (nil? child)
            (+ 1 cweight)
            :else
            (let [cn (key child)
                  cw (val child)]
              (recur (+ cweight (* cw (weight-of cn tree))) children))))))))

(defn part2
  []
  (let [tree (->> (input-lines)
                  (map parse-bag)
                  (apply merge))]
    (->> tree
         (weight-of "shiny gold")
         (+ -1))))

(comment
  (part1)
  (part2)
)
