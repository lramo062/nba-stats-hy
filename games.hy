#!/usr/bin/env hy

(import requests)
(import json)
(import sys)
(import datetime)

(setv DATE-LENGTH 8)
(setv NOW (.now datetime.datetime))
(setv COMMAND (get sys.argv 1))
(cond [(= (len sys.argv) 3) (setv ARG (get sys.argv 2))]
      [(!= (len sys.argv) 3) (setv ARG None)])


(defn get-scores [date]
  ;; makes a GET request for the scores on the given date
  (setv link ( + "http://data.nba.net/data/10s/prod/v1/" date "/scoreboard.json"))
  (setv data (.json (.get requests link)))
  (print-scores data))

(defn print-scores [data]
  ;; prints the scores in a nice human readable format
  (setv games (get data "games"))
  (for [i games]
    (setv home-team (-> i (get "hTeam") (get "triCode")))
    (setv hteam-score (-> i (get "hTeam") (get "score")))
    (.write sys.stdout (+ home-team ": " hteam-score "\t")))
  (print "") ;; new line 
  (for [i games]
    ;; team abriviations
    (setv visiting-team (-> i (get "vTeam") (get "triCode")))    
    ;; team scores
    (setv vteam-score (-> i (get "vTeam") (get "score")))
    ;; print scores
    (.write sys.stdout (+ visiting-team ": " vteam-score "\t")))
  (print "") ;; end the buffer with a new line (shell purposes) 
  (.flush sys.stdout)) ;; flush the buffer 

(if (and (= COMMAND "scores") (!= ARG None))
    (get-scores ARG)
    (do ;; else
      (if (and (= COMMAND "scores") (= (len (str NOW.day)) 1))
          (get-scores (+ (str NOW.year) (str NOW.month) (str 0) (str NOW.day)))
          (get-scores (+ (str NOW.year) (str NOW.month) (str NOW.day)))))) 
