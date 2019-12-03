(ns aoc.day01)

(defn fuel-for-mass
  [mass]
  (- (quot mass 3) 2))


(defn part1
  []
  (->>
   "aoc/day01.txt"
   clojure.java.io/resource
   slurp
   clojure.string/split-lines
   (map #(Integer/parseInt %))
   (reduce #(+ % (fuel-for-mass %2)) 0)))

  (fuel-for-mass 12)
  (fuel-for-mass 14)
  (fuel-for-mass 1969)
  (fuel-for-mass 100756)
  (part1)

