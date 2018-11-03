#!/usr/bin/env hy

(import requests)
(import json)
(import sys)

(defn get-player-data [command]
  (setv link "http://stats.nba.com/js/data/widgets/home_season.json")
  (setv response (.json (.get requests link)))
  (setv player-data (-> response (get "items") (get 0) (get "items")))
  (setv team-data (-> response (get "items") (get 1) (get "items")))
  (cond
    [(= command "player") (print-player-data player-data)]
    [(= command "team") (print-team-data team-data)]))
    
(defn print-player-data [data]
  (print "Season Player Leaders:")
  (for [x data]
    (setv title (get x "title"))
    (setv cat (get x "name"))
    (print title ":" )
    (for [y (get x "playerstats")]
      (print "\t" (get y "TEAM_ABBREVIATION") " " (get y "PLAYER_NAME") " " (get y cat)))))

(defn print-team-data [data]
  (print "Season Team Leaders:")
  (for [x data]
    (setv title (get x "title"))
    (setv cat (get x "name"))
    (print title ":" )
    (for [y (get x "teamstats")]
      (print "\t" (get y "TEAM_ABBREVIATION") " " (get y "TEAM_NAME") " " (get y cat)))))

(get-player-data "player")
(get-player-data "team")
