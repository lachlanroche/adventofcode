(ns aoc20.day20)

(defn input-file
  []
  (let [s (->> (str "aoc/day20.txt")
               clojure.java.io/resource
               slurp
               clojure.string/split-lines
               )]
    s))

(defn load-raw-tiles
  []
  (let [lines (->> (str "aoc/day20.txt")
               clojure.java.io/resource
               slurp
               clojure.string/split-lines
               )]
    (loop [result {} tile {} lines lines]
      (let [line (first lines)
            lines (rest lines)]
        (cond
          (nil? line)
          (assoc result (:id tile) tile)
          (= "" line)
          (recur (assoc result (:id tile) tile) {} lines)
          (= \T (first line))
          (let [id (-> line
                       (clojure.string/replace #"[^0-9]" "")
                       (Integer. ))]
            (recur result {:id id :lines []} lines))
          :else
          (let [str (:lines tile)
                tile (assoc tile :lines (conj str line))]
          (recur result tile lines)))))))

(defn edge->num
  [s]
  (loop [n 0 b 1 s s]
    (cond
      (= s "")
      n
      (= \# (first s))
      (recur (+ b n) (* b 2) (.substring s 1))
      :else
      (recur n (* b 2) (.substring s 1)))))

(defn edge->id
  [s]
  (min (edge->num s) (edge->num (clojure.string/reverse s))))

(defn str->edges
  [{:keys [lines id] :as tile}]
  (let [edge [(first lines)
              (apply str (map last lines))
              (last lines)
              (apply str (map first lines))]
        edge (map edge->id edge)]
    {:id id :edge edge}))

(defn variations
  [[a b c d]]
  [[a b c d]
   [b c d a]
   [c d a b]
   [d a b c]
   [d c b a]
   [c b a d]
   [b a d c]
   [a d c b]])

(defn load-world
  []
  (let [world (load-raw-tiles)]
      (into {} (for [[k v] world] [k (str->edges v)]))))

(defn neighbors
  [canvas [x y]]
  (->> #{[(inc x) y] [(dec x) y] [x (inc y)] [x (dec y)]}
       (filter (fn [[x y]] (and (<= 0 x 11) (<= 0 y 11))))
       (filter #(nil? (get canvas %)))))

(defn part1
  []
  (let [tiles (load-world)
        singles (->> tiles
                     (map #(:edge (val %)))
                     flatten
                     sort
                     frequencies
                     (filter #(= 1 (val %)))
                     (map key)
                     set)]
    (->> tiles
         (map (fn [[k {:keys [id edge]}]]
                (if (= 2 (count (filter singles edge)))
                  id
                  1)))
         (reduce * 1))))
