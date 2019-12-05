(ns aoc.day05
  (:require [clojure.string :as string]
            [clojure.java.io :as io]
            [aoc.day02 :as intcode]))

(defn cpu-peek
  [mem mode a]
  ;(tap> ["peek" mode a])
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
  ;(tap> ["poke" mode a val]) (tap> mem)
  (cpu-poke-assoc mem a val))

(defn cpu-input
  [in]
  [(first in) (vec (rest in))])

(defn cpu-output
  [out a]
  (conj out a))

(defn op-add
  [[a b z] [ma mb mz] [mem in out]]
  (let [a (cpu-peek mem ma a)
        b (cpu-peek mem mb b)
        result (+ a b)
        mem (cpu-poke mem mz z result)]
    [mem in out]))

(defn op-mul
  [[a b z] [ma mb mz] [mem in out]]
  (let [a (cpu-peek mem ma a)
        b (cpu-peek mem mb b)
        result (* a b)
        mem (cpu-poke mem mz z result)]
    [mem in out]))

(defn op-input
  [[z] [mz] [mem in out]]
  (let [[result in] (cpu-input in)
        mem (cpu-poke mem mz z result)]
    [mem in out]))

(defn op-output
  [[z] [mz] [mem in out]]
  (let [result (cpu-peek mem mz z)
        out (cpu-output out result)]
    [mem in out]))

(defn op-halt
  [_ _ _]
  nil)

(def op-map
  {1 {:fn op-add :argc 3}
   2 {:fn op-mul :argc 3}
   3 {:fn op-input :argc 1}
   4 {:fn op-output :argc 1}
   99 {:fn op-halt :argc 0}
   })

(defn cpu-decode
  [raw-opcode]
  ;(tap> ["decode" raw-opcode])
  (let [opcode (rem raw-opcode 100)
        ma (rem (quot raw-opcode 100) 10)
        mb (rem (quot raw-opcode 1000) 10)
        mc (rem (quot raw-opcode 10000) 10)
        op (get op-map opcode (get op-map 99))
        op-fn (:fn op)
        op-argc (:argc op)
        op-sz (+ 1 (:argc op))
        ]
    {:raw opcode
     :mode [ma mb mc]
     :size op-sz
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
         op-size (:size op)
         op-mode (:mode op)]
     ;(tap> op)
     ;(tap> offset)
     ;(tap> (vec (take op-argc (drop (+ 1 offset) mem))))
     (if (= op-halt op-fn)
       [mem nil out]
       (let [[mem in out] (op-fn (vec (take op-argc (drop (+ 1 offset) mem))) op-mode [mem in out])]
         ;(tap> [mem in out])
         (recur [mem in out] (+ op-size offset)))))))

(comment
(program [[3 0 4 0 99] [9] []])
(program [[1002 4 3 4 33] [] []])
(program [[1101 100 -1 4 0] [] []])
)

(defn load-program
  []
  (let [numbers (-> "aoc/day05.txt"
                    io/resource
                    slurp
                    (string/split #"[,\n]"))
        mem (vec (map #(Integer/parseInt %) numbers))
        ]
    mem))

(defn part1
  []
  (let [mem (load-program)
        in [1]
        out []
        [mem in out] (program [mem in out])]
    out))

;(part1)
