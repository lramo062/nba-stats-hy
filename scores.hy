#!/usr/bin/env hy

(import requests)
(import json)
(import sys)
(import datetime)

(setv DATE-LENGTH 8)
(setv NOW (.now datetime.datetime))
(setv current-date (+ (str NOW.year) (str NOW.month)
                      (cond [(= (len (str NOW.day)) 1) (+ "0" (str NOW.day))]
                            [(= (len (str NOW.day)) 2) (str NOW.day)])))

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
  (print (.format "{:<10}" "HOME") "AWAY")
  (for [i games]
    (setv home-team (-> i (get "hTeam") (get "triCode")))
    (setv hteam-score (-> i (get "hTeam") (get "score")))
    (setv visiting-team (-> i (get "vTeam") (get "triCode")))    
    (setv vteam-score (-> i (get "vTeam") (get "score")))
    (print (.format "{0:<10}" (str (+ home-team ": " (str hteam-score))))
           (+ visiting-team ": " (str vteam-score)))))

(if (and (= COMMAND "scores") (!= ARG None))
    (get-scores ARG)
    (get-scores current-date))
