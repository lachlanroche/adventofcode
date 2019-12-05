(ns aoc.day05
  (:require [clojure.string :as string]
            [clojure.java.io :as io]
            [aoc.day02 :as intcode]))

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
    (cpu-poke-assoc mem (get mem a) val))
    (= mode 1)
    (cpu-poke-assoc mem a val))
    ))


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
     (if (= op-halt op-fn)
       [mem nil out offset]
       (let [[mem in out offset] (op-fn (vec (take op-argc (drop (+ 1 offset) mem))) op-mode [mem in out offset])]
         #_(tap> [mem in out])
         (recur [mem in out] offset))))))

(defn program-compile
  [s]
  (let [numbers (string/split s #"[,\n]")
        mem (vec (map #(Integer/parseInt %) numbers))
        ]
    mem))

(defn run-program
 ([s]
  (run-program s [] []))
 ([s in]
  (run-program s in []))
 ([s in out]
  (program [(program-compile s) in out])))

(comment
(program [[3 0 4 0 99] [9] []])
(program [[1002 4 3 4 33] [] []])
(program [[1101 100 -1 4 0] [] []])

(run-program "3,9,8,9,10,9,4,9,99,-1,8" [7])
(run-program "3,9,8,9,10,9,4,9,99,-1,8" [8])
(run-program "3,9,8,9,10,9,4,9,99,-1,8" [9])

(run-program "3,9,7,9,10,9,4,9,99,-1,8" [7])
(run-program "3,9,7,9,10,9,4,9,99,-1,8" [8])
(run-program "3,9,7,9,10,9,4,9,99,-1,8" [9])

(run-program "3,3,1108,-1,8,3,4,3,99" [7])
(run-program "3,3,1108,-1,8,3,4,3,99" [8])
(run-program "3,3,1108,-1,8,3,4,3,99" [9])

(run-program "3,3,1107,-1,8,3,4,3,99" [7])
(run-program "3,3,1107,-1,8,3,4,3,99" [8])
(run-program "3,3,1107,-1,8,3,4,3,99" [9])

(run-program "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9" [0])
(run-program "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9" [1])
(run-program "3,3,1105,-1,9,1101,0,0,12,4,12,99,1" [0])
(run-program "3,3,1105,-1,9,1101,0,0,12,4,12,99,1" [1])

(run-program "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99" [7])
(run-program "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99" [8])
(run-program "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99" [9])
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


(defn part2
  []
  (let [mem (load-program)
        in [5]
        out []
        [mem in out] (program [mem in out])]
    out))

(comment
(part1)
(part2)
)
