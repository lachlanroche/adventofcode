(ns aoc20.day22)

(defn input-file
  []
  (let [lines (->> (str "aoc/day22.txt")
                   clojure.java.io/resource
                   slurp
                   clojure.string/split-lines
                   (map #(clojure.string/split % #"[ :]"))
                   )]
    (loop [decks [] deck [] lines lines]
      (let [line (first lines)
            lines (rest lines)]
        (cond
          (nil? line)
          (conj decks deck)
          (= "Player" (first line))
          (recur decks [] lines)
          (= "" (first line))
          (recur (conj decks deck) [] lines)
          :else
          (recur decks (conj deck (Integer. (first line))) lines))))
    ))

(defn play-step
  [aa bb]
  (let [a (first aa)
        aa (rest aa)
        b (first bb)
        bb (rest bb)]
  (if (> a b)
    [(concat aa [a b]) bb]
    [aa (concat bb [b a])])))

(defn score
  [aa]
  (->> aa
       reverse
       (map-indexed #(* (inc %1) %2))
       (reduce +)))

(defn play-all
  [[aa bb]]
  (loop [aa aa bb bb]
    (cond
      (= 0 (count aa))
      (score bb)
      (= 0 (count bb))
      (score aa)
      :else
      (let [[aa bb] (play-step aa bb)]
        (recur aa bb)))))

(defn part1
  []
  (play-all (input-file)))

(defn play-game
  [aa bb]
  (loop [seen #{} aa aa bb bb]
    (let [hash (clojure.string/join "," (concat aa [0] bb))
          fresh? (nil? (seen hash))
          seen (conj seen hash)
          a (first aa)
          aa (rest aa)
          b (first bb)
          bb (rest bb)
          ]
      (cond
        (nil? b)
        ["a" (concat [a] aa)]
        (nil? a)
        ["b" (concat [b] bb)]
        (not fresh?)
        ["a" (concat [a] aa)]
        (and (<= a (count aa))
             (<= b (count bb)))
        (let [[winner _] (play-game (take a aa) (take b bb))]
          (if (= "a" winner)
            (recur seen (concat aa [a b]) bb)
            (recur seen aa (concat bb [b a]))))
        :else
        (if (> a b)
          (recur seen (concat aa [a b]) bb)
          (recur seen aa (concat bb [b a])))))))

(defn part2
  []
  (let [[aa bb] (input-file)]
    (->> (play-game aa bb)
         second
         score)))
