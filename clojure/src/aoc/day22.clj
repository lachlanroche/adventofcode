(ns aoc.day22
  (:require [clojure.string :as str]
            [clojure.java.io :as io]))

;; shuffle
;; {:type :n :size}

(defn combine-shuffle
  [a b]
  (let [size (:size a)
        types (map :type [a b])]
    (cond
      (= [:deal :deal] types)
      nil

      (= [:cut :cut] types)
      (list {:type :cut :size size :n (rem (+ size (:n a) (:n b)) size)})

      (= [:increment :increment] types)
      (list {:type :increment :size size :n (rem (* (:n a) (:n b)) size)})

      (= [:deal :cut] types)
      (list {:type :cut :size size :n (- size (:n b))}
            {:type :deal :size size})

      (= [:cut :increment] types)
      (list {:type :increment :size size :n (:n b)}
            {:type :cut :size size :n (rem (* (:n a) (:n b)) size)})

      (= [:deal :increment] types)
      (list {:type :increment :size size :n (:n b)}
            {:type :cut :size size :n (+ size 1 (- (:n b)))}
            {:type :deal :size size})

      :else
      (list a b))))

(defn combine-shuffle-list
  [xs]
  (let [[ax bx cx dx & xs] xs
        [ta tb tc td] (map :type [ax bx cx dx])]
    (cond
      (nil? ax)
      nil

      (nil? bx)
      (list ax)

      (nil? cx)
      (if (or (= [:increment :cut] [ta tb])
              (= [:cut :deal] [ta tb])
              (= [:increment :deal] [ta tb]))
        (list ax bx)
        (combine-shuffle ax bx))

      (nil? dx)
      (cond
        (= [:increment :cut :deal] [ta tb tc])
        (list ax bx cx)

        (and (not= [:increment :cut] [ta tb])
             (not= [:cut :deal] [ta tb])
             (not= [:increment :deal] [ta tb]))
        (recur (concat (combine-shuffle ax bx) (list cx)))

        :else
        (recur (concat (list ax) (combine-shuffle bx cx))))

      :else
      (cond
        (and (not= [:increment :cut] [ta tb])
             (not= [:cut :deal] [ta tb])
             (not= [:increment :deal] [ta tb]))
        (recur (concat (combine-shuffle ax bx) (list cx dx) xs))

        (and (not= [:increment :cut] [tb tc])
             (not= [:cut :deal] [tb tc])
             (not= [:increment :deal] [tb tc]))
        (recur (concat (list ax) (combine-shuffle bx cx) (list dx) xs))

        :else
        (recur (concat (list ax bx) (combine-shuffle cx dx) xs))
        ))))

(defn parse-line
  [s size]
  (let [ss (str/split s #" ")]
    (cond
      (str/starts-with? s "deal into")
      {:type :deal :size size}
      (str/starts-with? s "cut")
      {:type :cut :size size :n (Long/parseLong (last ss))}
      (str/starts-with? s "deal with")
      {:type :increment :size size :n (Long/parseLong (last ss))}
      :else
      nil)))

(defn parse-input
  [s size]
  (->> (str/split-lines s)
       (reduce #(if-let [shuffle (parse-line %2 size)] (conj %1 shuffle) %1) [])))

(defn perform
  [deck {:keys [type size n]}]
  (tap> ["perform" type size n])
  (cond
    (= type :deal)
    (reverse deck)

    (= type :cut)
    (let [n (rem (+ size n) size)]
      (concat (drop n deck) (take n deck)))

    (= type :increment)
    (loop [i 0 pos 0 result (transient (vec deck))]
      (if (= i size)
        (persistent! result)
        (do
          (assoc! result pos (nth deck i))
          (recur (inc i) (rem (+ n pos) size) result))))
    ))

(comment
(perform (range 10) {:type :deal :size 10})
(perform (range 10) {:type :cut :size 10 :n 3})
(perform (range 10) {:type :cut :size 10 :n -4})
(perform (range 10) {:type :increment :size 10 :n 3})
(-> (range 10)
    (perform {:type :increment :size 10 :n 7})
    (perform {:type :increment :size 10 :n 9})
    )
)

(defn part1
  []
  (let [s (->> "aoc/day22.txt"
               io/resource
               slurp)
        size 10007
        shuffles (parse-input s size)
        shuffles (combine-shuffle-list shuffles)
        deck (loop [deck (range size) shuffles shuffles]
                (if (empty? shuffles)
                  deck
                  (recur (perform deck (first shuffles)) (rest shuffles))))
        _deck (reduce #(perform %1 %2) (range size) shuffles)]
    (.indexOf deck 2019)
    ))

