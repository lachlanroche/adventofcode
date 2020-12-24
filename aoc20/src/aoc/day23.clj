(ns aoc20.day23)

(defn input-data
  []
  [8 7 1 3 6 9 4 5 2])

(defn destination
  [c deck]
  (let [idx (->> deck
                 (map-indexed #(hash-map %2 %1))
                 (apply merge))]
    (loop [c (dec c)]
      (let [c (if (= 0 c) 9 c)
            d (get idx c)]
        (if (not (nil? d))
          d
          (recur (dec c)))))))

(defn part1
  []
  (let [deck (input-data)]
    (loop [i 0 deck deck]
      (let [current (first deck)
            three (take 3 (rest deck))
            deck-tail (drop 4 deck)
            dest-idx (destination current deck-tail)
            ]
        (if (= 100 i)
          (let [pos (destination 2 deck)]
            (concat (drop (inc pos) deck)
                    (take pos deck)))
          (recur (inc i) (concat
                          (take (inc dest-idx) deck-tail)
                          three
                          (drop (inc dest-idx) deck-tail)
                          [current])))))))

