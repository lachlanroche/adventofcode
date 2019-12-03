(ns aoc.day01)

(defn fuel-for-mass
  [mass]
  (- (quot mass 3) 2))

(defn fuel-for-module
  ([mass]
  (fuel-for-module mass 0))
  ([mass acc]
    (let [fuel (fuel-for-mass mass)]
      (if (>= 0 fuel)
        acc
        (recur fuel (+ fuel acc))))))

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
  (fuel-for-module 14)
  (fuel-for-module 1969)
  (fuel-for-module 100756)
