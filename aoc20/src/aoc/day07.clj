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

(comment
  (part1)
)
