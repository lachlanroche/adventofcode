(ns aoc.day07
  (:require [clojure.string :as str]
            [clojure.java.io :as io]
            [clojure.math.combinatorics :as combo]))

(defn cpu-peek
  [mem mode a]
  #_(tap> ["peek" mode a])
  (cond
    (= mode 0)
    (get mem a)
    (= mode 1)
    a
    ))

(defn cpu-poke-assoc
  [mem a v]
  (if (< a (count mem))
    (assoc mem a v)
    (let [mem (apply conj mem (repeat (- a (count mem)) 0))]
      (assoc mem a v))))

(defn cpu-poke
  [mem mode a val]
  #_(tap> ["poke" mode a val])
  #_(tap> mem)
  (cond
    (= mode 0)
    (cpu-poke-assoc mem (get mem a) val)
    (= mode 1)
    (cpu-poke-assoc mem a val)))

(defn cpu-input
  [in]
  [(first in) (vec (rest in))])

(defn cpu-output
  [out a]
  (conj out a))

(defn op-add
  [[a b z] [ma mb mz] [mem in out ip]]
  (let [a (cpu-peek mem ma a)
        b (cpu-peek mem mb b)
        result (+ a b)
        mem (cpu-poke mem 1 z result)]
    [mem in out (+ 4 ip)]))

(defn op-mul
  [[a b z] [ma mb mz] [mem in out ip]]
  (let [a (cpu-peek mem ma a)
        b (cpu-peek mem mb b)
        result (* a b)
        mem (cpu-poke mem 1 z result)]
    [mem in out (+ 4 ip)]))

(defn op-input
  [[z] [mz] [mem in out ip]]
  (let [[result in] (cpu-input in)
        mem (cpu-poke mem 1 z result)]
    [mem in out (+ 2 ip)]))

(defn op-output
  [[z] [mz] [mem in out ip]]
  (let [result (cpu-peek mem mz z)
        out (cpu-output out result)]
    [mem in out (+ 2 ip)]))

(defn op-jump-if-true
  [[a b] [ma mb] [mem in out ip]]
  (let [a (cpu-peek mem ma a)
        b (cpu-peek mem mb b)]
    (if (not= 0 a)
      [mem in out b]
      [mem in out (+ 3 ip)])))

(defn op-jump-if-false
  [[a b] [ma mb] [mem in out ip]]
  #_(tap> ["jif" [a b] [ma mb] ip])
  (let [a (cpu-peek mem ma a)
        b (cpu-peek mem mb b)]
    (if (= 0 a)
      [mem in out b]
      [mem in out (+ 3 ip)])))

(defn op-less-than
  [[a b z] [ma mb mz] [mem in out ip]]
  (let [a (cpu-peek mem ma a)
        b (cpu-peek mem mb b)
        result (if (< a b) 1 0)
        mem (cpu-poke mem 1 z result)]
  [mem in out (+ 4 ip)]))

(defn op-equals
  [[a b z] [ma mb mz] [mem in out ip]]
  (let [a (cpu-peek mem ma a)
        b (cpu-peek mem mb b)
        result (if (= a b) 1 0)
        mem (cpu-poke mem 1 z result)]
  [mem in out (+ 4 ip)]))

(defn op-halt
  [_ _ _]
  nil)

(def op-map
  {1 {:fn op-add :argc 3}
   2 {:fn op-mul :argc 3}
   3 {:fn op-input :argc 1}
   4 {:fn op-output :argc 1}
   5 {:fn op-jump-if-true :argc 2}
   6 {:fn op-jump-if-false :argc 2}
   7 {:fn op-less-than :argc 3}
   8 {:fn op-equals :argc 3}
   99 {:fn op-halt :argc 0}
   })

(defn cpu-decode
  [raw-opcode]
  #_(tap> ["decode" raw-opcode])
  (let [opcode (rem raw-opcode 100)
        ma (rem (quot raw-opcode 100) 10)
        mb (rem (quot raw-opcode 1000) 10)
        mc (rem (quot raw-opcode 10000) 10)
        op (get op-map opcode (get op-map 99))
        op-fn (:fn op)
        op-argc (:argc op)
        ]
    {:raw opcode
     :mode [ma mb mc]
     :argc op-argc
     :fn op-fn
     }))

(defn program
  ([mio]
   (program mio 0))
  ([[mem in out] offset]
   (let [op (cpu-decode (get mem offset))
         op-fn (:fn op)
         op-argc (:argc op)
         op-mode (:mode op)]
     #_(tap> op)
     #_(tap> offset)
     #_(tap> (vec (take op-argc (drop (+ 1 offset) mem))))
     (cond
       (= op-halt op-fn)
       [[mem in out] offset]
       (and (= op-input op-fn) (empty? in))
       [[mem in out] offset]
       :else
       (let [[mem in out offset] (op-fn (vec (take op-argc (drop (+ 1 offset) mem))) op-mode [mem in out offset])]
         #_(tap> [mem in out])
         (recur [mem in out] offset))))))

(defn program-stopped?
  [[mem in out] offset]
   (let [op (cpu-decode (get mem offset))
         op-fn (:fn op)]
     (= op-halt op-fn)))

(defn program-running?
  [mio offset]
  (not (program-stopped mio offset)))

(defn program-compile
  [s]
  (let [numbers (str/split s #"[,\n]")
        mem (vec (map #(Integer/parseInt %) numbers))
        ]
    mem))

(defn run-program-phase
  [prog phase in]
  (let [in (concat [phase] in)
        out (program [prog in []])]
    out))

(defn run-program-phase-list
  [prog phases in]
  (let [phase (first phases)
        phases (rest phases)
        [_ _ out _] (run-program-phase prog phase in)
        ]
    (if (empty? phases)
      out
      (recur prog phases out))))

(defn run-program-all-phases
  [prog phases]
  (->> (combo/permutations phases)
       (map #(vector (run-program-phase-list prog % [0]) %))
       ))

(defn part1-run
  [s]
  (let [p (program-compile s)
        outmap (run-program-all-phases p [0 1 2 3 4])
        outmap (sort #(> (ffirst %1) (ffirst %2)) outmap)
        ]
    (first outmap)))

(defn part1
  []
  (let [s (-> "aoc/day07.txt"
              io/resource
              slurp)
        ]
    (part1-run s)))

(comment
(part1-run "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0")
(part1-run "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0")
(part1-run "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0")
(part1)
)
