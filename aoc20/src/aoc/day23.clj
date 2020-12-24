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

(defn load-deck-map
  []
  (let [cups (concat (input-data) (range 10 1000001))
        c (first cups)]
    (loop [c c
           deck {(last cups) c}
           cups cups]
      (let [d (first cups)
            cups (rest cups)]
        (if (nil? d)
          deck
          (recur d (assoc deck c d) cups))))))

(defn part2
  []
  (loop [i 0
         current (first (input-data))
         deck (load-deck-map)]
    (let [three [(deck current)]
          three (conj three (deck (last three)))
          three (conj three (deck (last three)))
          deck (assoc deck current (deck (last three)))
          dest (loop [b (dec current)]
                 (let [b (if (= 0 b) 1000000 b)]
                   (if (nil? (some #{b} three))
                     b
                     (recur (dec b)))))
          after (deck dest)
          deck (assoc deck
                      dest (first three)
                      (first three) (second three)
                      (second three) (last three)
                      (last three) after)]
      (if (= 10000000 i)
        (* (deck 1) (deck (deck 1)))
        (recur (inc i) (deck current) deck)))))
