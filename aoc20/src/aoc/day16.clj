(ns aoc20.day16)

(defn tickets
  []
  (let [s (->> "aoc/day16.txt"
               clojure.java.io/resource
               slurp
               clojure.string/split-lines
               (map #(clojure.string/split % #","))
               )
        ]
    s))

(defn rules
  []
  {
   :departure-location
   (fn [n] (or (<= 28 n 787) (<= 804 n 964)))
   :departure-station
   (fn [n] (or (<= 41 n 578) (<= 594 n 962)))
   :departure-platform
   (fn [n] (or (<= 50 n 718) (<= 733 n 949)))
   :departure-track
   (fn [n] (or (<= 27 n 846) (<= 862 n 949)))
   :departure-date
   (fn [n] (or (<= 50 n 241) (<= 249 n 957)))
   :departure-time
   (fn [n] (or (<= 44 n 81) (<= 104 n 972)))
   :arrival-location
   (fn [n] (or (<= 45 n 292) (<= 299 n 954)))
   :arrival-station
   (fn [n] (or (<= 46 n 650) (<= 657 n 974)))
   :arrival-platform
   (fn [n] (or (<= 42 n 396) (<= 405 n 953)))
   :arrival-track
   (fn [n] (or (<= 42 n 871) (<= 886 n 973)))
   :class
   (fn [n] (or (<= 31 n 808) (<= 829 n 964)))
   :duration
   (fn [n] (or (<= 39 n 909) (<= 935 n 969)))
   :price
   (fn [n] (or (<= 49 n 350) (<= 364 n 970)))
   :route
   (fn [n] (or (<= 44 n 251) (<= 264 n 959)))
   :row
   (fn [n] (or (<= 50 n 539) (<= 556 n 952)))
   :seat
   (fn [n] (or (<= 45 n 624) (<= 630 n 951)))
   :train
   (fn [n] (or (<= 28 n 283) (<= 290 n 960)))
   :type
   (fn [n] (or (<= 44 n 334) (<= 340 n 951)))
   :wagon
   (fn [n] (or (<= 43 n 699) (<= 716 n 961)))
   :zone
   (fn [n] (or (<= 42 n 668) (<= 688 n 958)))
   })

(defn valid-for-something?
  [n]
  (let [preds (->> (rules)
                  vals)]
    (loop [preds preds]
      (let [pred (first preds)
            preds (rest preds)]
        (cond
          (nil? pred)
          false
          (pred n)
          true
          :else
          (recur preds))))))

(defn part1
  []
  (let [nums (->> (tickets)
                  rest
                  (apply concat)
                  (map #(Integer. %)))]
    (->> nums
         (filter #(not (valid-for-something? %)))
         (reduce + 0))))

(defn ticket-looks-valid?
  [nums]
  (reduce (fn [result n] (and result (valid-for-something? n))) true nums))

(defn slot-match-rules
  [rules n]
  (->> rules
       (map (fn [[k f]] (if (f n) #{k} #{})))
       (apply clojure.set/union)))

(defn match-rules
  [rules nums]
  (->> nums
       (map #(slot-match-rules rules %))))

(defn find-columns
  [candidates]
  (loop [result {} singles [] candidates candidates]
    (cond
      (empty? candidates)
      result
      (empty? singles)
      (let [singles (filter #(= 1 (count (val %))) candidates)]
        (recur result singles candidates))
      :else
      (let [single (first singles)
            sk (key single)
            sv (first (val single))
            result (assoc result sv sk)
            candidates (dissoc candidates sk)
            candidates (into {} (for [[k v] candidates] [k (disj v sv)]))]
        (recur result (rest singles) candidates)))))

(defn part2
  []
  (let [tickets (->> (tickets)
                     (map (fn [ts] (map #(Integer. %) ts))))
        mine (first tickets)
        tickets (->> tickets
                     rest
                     (filter ticket-looks-valid?))
        rules (rules)
        candidates (->> tickets
                        (map #(match-rules rules %))
                        (apply map vector)
                        (map #(apply clojure.set/intersection %))
                        (into {} (map-indexed #(hash-map %1 %2))))
        column-names (find-columns candidates)
        column-indexes (-> column-names
                           (select-keys  [:departure-location :departure-station :departure-platform :departure-track :departure-date :departure-time])
                           vals)
        ]
    (reduce (fn [acc n] (* acc (nth mine n))) 1 column-indexes)))
