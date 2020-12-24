(ns aoc20.day18
  (:require [instaparse.core :as insta]))

(defn input-data
  []
  (let [s (->> "aoc/day18.txt"
               clojure.java.io/resource
               slurp
               clojure.string/split-lines
               )]
    s))

(def arithmetic
  (insta/parser
    "expr = add-mul
     <add-mul> = term | add | mul
     add = add-mul <'+'> term
     mul = add-mul <'*'> term
     <term> = number | <'('> add-mul <')'>
     number = #'[0-9]+'"
    :auto-whitespace :standard))

(def parse-tree->sexp
  {
   :expr identity
   :add +
   :mul *
   :number read-string
   })

(defn part1
  []
  (reduce
   (fn [acc expr]
     (+ acc
        (->> (arithmetic expr)
             (insta/transform parse-tree->sexp))))
   0
   (input-data)))

(def arithmetic2
  (insta/parser
    "expr = add-expr | mul-expr
     <add-expr> = term | add
     add = add-expr <'+'> term
     <mul-expr> = add-expr | mul
     mul = mul-expr <'*'> add-expr
     <term> = number | <'('> mul-expr <')'>
     number = #'[0-9]+'"
    :auto-whitespace :standard))

(defn part2
  []
  (reduce
   (fn [acc expr]
     (+ acc
        (->> (arithmetic2 expr)
             (insta/transform parse-tree->sexp))))
   0
   (input-data)))
