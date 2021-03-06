(defrule data-input
	(initial-fact)
=>
	(printout t crlf "������� �������� ����� � �/� (����� ����� > 0): ")
 	(bind ?wind (read))
 	(assert (wind ?wind))

	(printout t crlf "������� ������� ������� (1-��/0-���): ")
	(bind ?rainfall (read))
	(assert (rainfall ?rainfall))

	(printout t crlf "������� ������� �������� (1-��/0-���): ")
	(bind ?breakfast (read))
	(assert (breakfast ?breakfast ))

	(printout t crlf "������� ����� ����������� �� ��� � ����� (����� ����� > 0): ")
	(bind ?sleep (read))
	(assert (sleep ?sleep ))

	(printout t crlf "������� �������� �������� (0-������/1-�����������/2-�����): ")
	(bind ?health (read))
	(assert (health ?health )))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule R1
	(wind ?wind)
	(rainfall ?rainfall)
	(test (and (<= ?wind 1) (= ?rainfall 0))) 
=>
	(printout t crlf "������ �������" crlf)
	(assert (weather 1)))

(defrule R2
	(wind ?wind)
	(rainfall ?rainfall)
	(test (and (<= ?wind 5) (> ?wind 1) (= ?rainfall 0))) 
=>
	(printout t crlf "������ ����������" crlf)
	(assert (weather 2)))

(defrule R3
	(wind ?wind)
	(rainfall ?rainfall)
	(test (and (> ?wind 5) (= ?rainfall 0))) 
=>
	(printout t crlf "������ ������" crlf)
	(assert (weather 3)))

(defrule R4
	(wind ?wind)
	(rainfall ?rainfall)
	(test (and (<= ?wind 1) (= ?rainfall 1))) 
=>
	(printout t crlf "������ ����������" crlf)
	(assert (weather 2)))

(defrule R5
	(wind ?wind)
	(rainfall ?rainfall)
	(test (and (> ?wind 1) (= ?rainfall 1))) 
=>
	(printout t crlf "������ ������" crlf)
	(assert (weather 3)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule R6
	(sleep ?sleep)
	(health ?health)
	(test (and (>= ?sleep 8) (= ?health 0))) 
=>
	(printout t crlf "������������ ��������" crlf)
	(assert (feeling 1)))

(defrule R7
	(sleep ?sleep)
	(health ?health)
	(test (and (>= ?sleep 8) (= ?health 1))) 
=>
	(printout t crlf "������������ ����������" crlf)
	(assert (feeling 2)))

(defrule R8
	(sleep ?sleep)
	(health ?health)
	(test (and (>= ?sleep 8) (= ?health 2))) 
=>
	(printout t crlf "������������ ������" crlf)
	(assert (feeling 3)))

(defrule R9
	(sleep ?sleep)
	(health ?health)
	(test (and (< ?sleep 8) (= ?health 1))) 
=>
	(printout t crlf "������������ ������" crlf)
	(assert (feeling 3)))

(defrule R10
	(sleep ?sleep)
	(health ?health)
	(test (and (< ?sleep 8) (= ?health 2))) 
=>
	(printout t crlf "������������ ������" crlf)
	(assert (feeling 3)))

(defrule R11
	(sleep ?sleep)
	(health ?health)
	(test (and (< ?sleep 8) (>= ?sleep 6) (= ?health 0))) 
=>
	(printout t crlf "������������ ����������" crlf)
	(assert (feeling 2)))

(defrule R12
	(sleep ?sleep)
	(health ?health)
	(test (and (< ?sleep 6) (= ?health 0))) 
=>
	(printout t crlf "������������ ������" crlf)
	(assert (feeling 3)))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule R13
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 1) (= ?breakfast 1) (= ?feeling 1))) 
=>
	(printout t crlf "����������� ��������" crlf)
	(assert (mood "good")))

(defrule R14
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 1) (= ?breakfast 1) (= ?feeling 2))) 
=>
	(printout t crlf "����������� ����������" crlf)
	(assert (mood "satisfactorynice")))

(defrule R15
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 1) (= ?breakfast 1) (= ?feeling 3))) 
=>
	(printout t crlf "����������� ������" crlf)
	(assert (mood "bad")))

(defrule R16
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 1) (= ?breakfast 0) (= ?feeling 1))) 
=>
	(printout t crlf "����������� ����������" crlf)
	(assert (mood "satisfactorynice")))

(defrule R17
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 1) (= ?breakfast 0) (= ?feeling 2))) 
=>
	(printout t crlf "����������� ������" crlf)
	(assert (mood "bad")))

(defrule R18
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 1) (= ?breakfast 0) (= ?feeling 3))) 
=>
	(printout t crlf "����������� ����������" crlf)
	(assert (mood "satisfactorynice")))

(defrule R19
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 2) (= ?breakfast 1) (= ?feeling 1))) 
=>
	(printout t crlf "����������� ����������" crlf)
	(assert (mood "satisfactorynice")))

(defrule R20
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 2) (= ?breakfast 1) (= ?feeling 2))) 
=>
	(printout t crlf "����������� ����������" crlf)
	(assert (mood "satisfactorynice")))

(defrule R21
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 2) (= ?breakfast 1) (= ?feeling 3))) 
=>
	(printout t crlf "����������� ������" crlf)
	(assert (mood "bad")))

(defrule R22
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 2) (= ?breakfast 0) (= ?feeling 1))) 
=>
	(printout t crlf "����������� ����������" crlf)
	(assert (mood "satisfactorynice")))

(defrule R23
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 2) (= ?breakfast 0) (= ?feeling 2))) 
=>
	(printout t crlf "����������� ������" crlf)
	(assert (mood "bad")))

(defrule R24
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 2) (= ?breakfast 0) (= ?feeling 3))) 
=>
	(printout t crlf "����������� ������" crlf)
	(assert (mood "bad")))

(defrule R25
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 3) (= ?breakfast 1) (= ?feeling 1))) 
=>
	(printout t crlf "����������� ����������" crlf)
	(assert (mood "satisfactorynice")))

(defrule R26
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 3) (= ?breakfast 1) (= ?feeling 2))) 
=>
	(printout t crlf "����������� ����������" crlf)
	(assert (mood "satisfactorynice")))

(defrule R27
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 3) (= ?breakfast 1) (= ?feeling 3))) 
=>
	(printout t crlf "����������� ������" crlf)
	(assert (mood "bad")))

(defrule R28
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 3) (= ?breakfast 0) (= ?feeling 1))) 
=>
	(printout t crlf "����������� ������" crlf)
	(assert (mood "bad")))

(defrule R29
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 3) (= ?breakfast 0) (= ?feeling 2))) 
=>
	(printout t crlf "����������� ������" crlf)
	(assert (mood "bad")))

(defrule R30
	(weather ?weather)
	(breakfast ?breakfast)
	(feeling ?feeling)
	(test (and (= ?weather 3) (= ?breakfast 0) (= ?feeling 3))) 
=>
	(printout t crlf "����������� ������" crlf)
	(assert (mood "bad")))




