(ns aoc20.day15)

(defn input-data
  []
  #_[0 3 6]
  #_[1 3 2]
  [1 0 15 2 10 13])

(->> (input-data)
     (into #{}))

(->> (input-data)
     drop-last
     (map-indexed #(hash-map %2 %1))
     (apply merge))

(defn age-of
  [i n when]
  (let [p (get when n nil)]
    (if (nil? p)
      nil
      (- i p))))

(defn part1
  []
  (let [nums (input-data)]
    (loop [i 0 prev 0 age 0 when {} nums nums]
      (let [num (first nums)
            nums (rest nums)]
        (cond
          (not (nil? num))
          (recur (inc i) num nil (assoc when num i) nums)
          (= 2020 i)
          prev
          (nil? age)
          (recur (inc i) 0 (age-of i 0 when) (assoc when 0 i) nums)
          :else
          (recur (inc i) age (age-of i age when) (assoc when age i) nums))))))
