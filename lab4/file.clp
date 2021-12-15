;; 0 - h1, 1 - h2
(defglobal 
  ?*Metric* = 1
)

(defglobal 
  ?*Algorithm* = 1
)

(deftemplate Field
  (slot LeftTop(type NUMBER))
  (slot MiddleTop(type NUMBER))
  (slot RightTop(type NUMBER))
  (slot LeftMiddle(type NUMBER))
  (slot TrueMiddle(type NUMBER))
  (slot RightMiddle(type NUMBER))
  (slot LeftBottom(type NUMBER))
  (slot MiddleBottom(type NUMBER))
  (slot RightBottom(type NUMBER))
  (slot Level(type NUMBER));;задает уровень в дереве
  (slot Id(type NUMBER) (default 0))
  (slot State(type NUMBER) (default 0));;0 - не рассматривалось, 1 - рассмотрено 2 - соответствует решению
  (slot From (type NUMBER))
  (slot Exp (type NUMBER));;значение целевой функции
)
 
;глобальная переменная
(defglobal 
  ?*Id* = 0
)

(defglobal 
  ?*TotalStepsCount* = 0
)

(defglobal 
  ?*TotalNodesCount* = 0
)

(deffunction F(?Vertex ?X ?Y) 

	(bind ?a 0)
	(if (= ?Vertex 1) then
	  (bind ?a (+ ?X ?Y))
	)
	(if (= ?Vertex 2) then
	  (bind ?a (+ (abs (- ?X 1)) ?Y))
	)
	(if (= ?Vertex 3) then
	  (bind ?a (+ (abs (- ?X 2)) ?Y))
	)
	(if (= ?Vertex 4) then
	   (bind ?a (+ ?X (abs (- ?Y 1))))      
	)
	(if (= ?Vertex 5) then
	   (bind ?a (+ (abs (- ?X 2)) (abs (- ?Y 1))))
	)
	(if (= ?Vertex 6) then 
	   (bind ?a (+ ?X (abs(- ?Y 2))))    
	)
	(if (= ?Vertex 7) then
	   (bind ?a (+ (abs (- ?X 1)) (abs (- ?Y 2))))
	)
	(if (= ?Vertex 8) then
	   (bind ?a (+ (abs (- ?X 2)) (abs (- ?Y 2))))  
	)
	?a
)
 
;целевая функция: количество шагов до текущего хода+количество цифр, стоящих не на своем месте
(deffunction W(?Level ?LeftTop ?MiddleTop ?RightTop ?RightMiddle ?RightBottom ?MiddleBottom ?LeftBottom ?LeftMiddle ?TrueMiddle)
  
  (if (= ?*Algorithm* 1) then
    (bind ?a ?Level)
  )
   (if (= ?*Algorithm* 0) then
    (bind ?a 0)
  )
  (if (= ?*Metric* 0) then
  	(if (not (= ?LeftTop 1)) then
    		(bind ?a (+ 1 ?a))
  	)
  	(if (not (= ?MiddleTop 2)) then
    		(bind ?a (+ 1 ?a))
  	)
  	(if (not (= ?RightTop 3)) then
    		(bind ?a (+ 1 ?a))
  	)
  	(if (not (= ?RightMiddle 5)) then
    		(bind ?a (+ 1 ?a))
  	)
  	(if (not (= ?RightBottom 8)) then
    		(bind ?a (+ 1 ?a))
  	)
  	(if (not (= ?MiddleBottom 7)) then
    		(bind ?a (+ 1 ?a))
  	)
  	(if (not (= ?LeftBottom 6)) then
    		(bind ?a (+ 1 ?a))
  	)
  	(if (not (= ?LeftMiddle 4)) then
    		(bind ?a (+ 1 ?a))
  	)
  ) 

  (if (= ?*Metric* 1) then
    (bind ?a (+ (F ?LeftTop 0 0 ) ?a))
    (bind ?a (+ (F ?LeftMiddle 0 1) ?a))
    (bind ?a (+ (F ?LeftBottom 0 2) ?a))

    (bind ?a (+ (F ?RightTop 2 0) ?a))
    (bind ?a (+ (F ?RightMiddle 2 1) ?a))
    (bind ?a (+ (F ?RightBottom 2 2) ?a))

    (bind ?a (+ (F ?MiddleTop 1 0) ?a))
    (bind ?a (+ (F ?TrueMiddle 1 1) ?a))
    (bind ?a (+ (F ?MiddleBottom 1 2) ?a))
  )
  ?a
)

;; определяет идентификатор (чтобы можно найти элементы в последовательности)
(deffunction Get_Id()
  (bind ?*Id* (+ ?*Id* 1))
  ?*Id*
)
 
;;выбор метрики
(defrule data-input
  (declare (salience 10000))
	(initial-fact)
=>
	(printout t crlf "Введите метрику (h1 - 0 / h2 - 1): ")
 	(bind ?*Metric* (read))
  (printout t crlf "Жадный или A* (жадный - 0 / A* - 1): ")
 	(bind ?*Algorithm* (read))
)
;;задаем начальное положение
(deffacts start
  (min (W 0 0 4 3 1 8 5 7 6 2))
  (Field (LeftTop 0)        (MiddleTop 4)    (RightTop 3)
         (LeftMiddle 6)     (TrueMiddle 2)   (RightMiddle 1)
         (LeftBottom 7)     (MiddleBottom 5) (RightBottom 8)
         (Level 0)
         (From 0) (Exp (W 0 0 4 3 1 8 5 7 6 2)) (Id (Get_Id))
  ) 
)

;; правило для исключения повторяющихся ситуаций
;; у этого правила самый высокий приоритет;
(defrule move_circle
(declare (salience 1000))
 ?f1 <- (Field (State 1) (LeftTop ?LT1) (MiddleTop ?MT1) (RightTop ?RT1)
 	(LeftMiddle ?LM1) (TrueMiddle ?MM1) (RightMiddle ?RM1)
 	(LeftBottom ?LB1) (MiddleBottom ?MB1) (RightBottom ?RB1))
 ?f0 <- (Field (State 0) (LeftTop ?LT0&:(= ?LT0 ?LT1))
 	(MiddleTop ?MT0&:(= ?MT0 ?MT1)) (RightTop ?RT0&:(= ?RT0 ?RT1))
 	(LeftMiddle ?LM0&:(= ?LM0 ?LM1)) (TrueMiddle ?MM0&:(= ?MM0 ?MM1))
 	(RightMiddle ?RM0&:(= ?RM0 ?RM1)) (LeftBottom ?LB0&:(= ?LB0 ?LB1))
 	(MiddleBottom ?MB0&:(= ?MB0 ?MB1)) (RightBottom ?RB0&:(= ?RB0 ?RB1)))
 =>
 (bind ?*TotalNodesCount* (- ?*TotalNodesCount* 1))
 (retract ?f0)
)

 
;;выбираем узлы из множества Open, и создаем соответствующие пути из него
;;для этого создается 9 правил с одинаковым приоритетом, что дает случайность
(defrule make_new_path_LeftTop
  (declare (salience 100))
  ?fmin <- (min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop 0)    (MiddleTop ?MT) (RightTop ?RT)
     (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle ?RM)
     (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB) (Exp ?E& :(= ?E ?min)))
=> 
  (modify ?f(State 1))
  (bind ?a (W (+ 1 ?L) ?MT 0 ?RT ?RM ?RB ?MB ?LB ?LM ?MM))
  (retract ?fmin)
  (assert (min 100000))
  (assert (Field (LeftTop ?MT) (MiddleTop 0) (RightTop ?RT)
                 (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle ?RM)
                 (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                 (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
         )
  )
  (assert (Field (LeftTop ?LM) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle 0) (TrueMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LM ?MT ?RT ?RM ?RB ?MB ?LB 0 ?MM)) (Id (Get_Id))
         )
   )
  (bind ?*TotalNodesCount* (+ ?*TotalNodesCount* 2))
  (bind ?*TotalStepsCount* (+ ?*TotalStepsCount* 1))
)
 
(defrule make_new_path_MiddleTop
  (declare (salience 100))
  ?fmin<-(min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop ?LT)    (MiddleTop 0) (RightTop ?RT)
     (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle ?RM)
     (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB) (Exp ?E& :(= ?E ?min)))
=>
  (modify ?f(State 1))
  (bind ?a (W (+ 1 ?L) 0 ?LT ?RT ?RM ?RB ?MB ?LB ?LM ?MM))
  (retract ?fmin)
  (assert (min 100000))
  (assert (Field (LeftTop 0) (MiddleTop ?LT) (RightTop ?RT)
                 (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle ?RM)
                 (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                 (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
          )
  )
  (assert (Field (LeftTop ?LT) (MiddleTop ?MM) (RightTop ?RT)
                 (LeftMiddle ?LM) (TrueMiddle 0) (RightMiddle ?RM)
                 (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                 (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LT ?MM ?RT ?RM ?RB ?MB ?LB ?LM 0)) (Id (Get_Id))
          )
  )
  (assert (Field (LeftTop ?LT) (MiddleTop ?RT) (RightTop 0)
                 (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle ?RM)
                 (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                 (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LT ?RT 0 ?RM ?RB ?MB ?LB ?LM ?MM)) (Id (Get_Id))
          )
  )
  (bind ?*TotalNodesCount* (+ ?*TotalNodesCount* 3))
  (bind ?*TotalStepsCount* (+ ?*TotalStepsCount* 1))
)
 
(defrule make_new_path_RightTop
  (declare (salience 100))
  ?fmin<-(min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop ?LT)    (MiddleTop ?MT) (RightTop 0)
     (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle ?RM)
     (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB) (Exp ?E& :(= ?E ?min)))
=>
 (modify ?f(State 1))
 (bind ?a (W (+ 1 ?L) ?LT 0 ?MT ?RM ?RB ?MB ?LB ?LM ?MM))
 (retract ?fmin)
 (assert (min 100000))
 (assert (Field (LeftTop ?LT) (MiddleTop 0) (RightTop ?MT)
                (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
         )
 )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RM)
                (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle 0)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LT ?MT ?RM 0 ?RB ?MB ?LB ?LM ?MM)) (Id (Get_Id))
         )
  )
  (bind ?*TotalNodesCount* (+ ?*TotalNodesCount* 2))
  (bind ?*TotalStepsCount* (+ ?*TotalStepsCount* 1))
)
 
(defrule make_new_path_LeftMiddle
  (declare (salience 100))
  ?fmin<-(min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop ?LT)    (MiddleTop ?MT) (RightTop ?RT)
     (LeftMiddle 0) (TrueMiddle ?MM) (RightMiddle ?RM)
     (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB) (Exp ?E& :(= ?E ?min)))
=>
 (modify ?f(State 1))
 (bind ?a (W (+ 1 ?L) 0 ?MT ?RT ?RM ?RB ?MB ?LB ?LT ?MM))
 (retract ?fmin)
 (assert (min 100000))
 (assert (Field (LeftTop 0) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LT) (TrueMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
         )
 )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?MM) (TrueMiddle 0) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LT ?MT ?RT ?RM ?RB ?MB ?LB ?MM 0)) (Id (Get_Id))
         )
  )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LB) (TrueMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom 0) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LT ?MT ?RT ?RM ?RB ?MB 0 ?LB ?MM)) (Id (Get_Id))
         )
  )
  (bind ?*TotalNodesCount* (+ ?*TotalNodesCount* 3))
  (bind ?*TotalStepsCount* (+ ?*TotalStepsCount* 1))
)
 
(defrule make_new_path_TrueMiddle
  (declare (salience 100))
  ?fmin<-(min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop ?LT)    (MiddleTop ?MT) (RightTop ?RT)
     (LeftMiddle ?LM) (TrueMiddle 0) (RightMiddle ?RM)
     (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB) (Exp ?E& :(= ?E ?min)))
=>
 (modify ?f(State 1))
 (bind ?a (W (+ 1 ?L) ?LT 0 ?RT ?RM ?RB ?MB ?LB ?LM ?MT))
 (retract ?fmin)
 (assert (min 100000))
 (assert (Field (LeftTop ?LT) (MiddleTop 0) (RightTop ?RT)
                (LeftMiddle ?LM) (TrueMiddle ?MT) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
         )
 )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (TrueMiddle ?RM) (RightMiddle 0)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LT ?MT ?RT 0 ?RB ?MB ?LB ?LM ?RM)) (Id (Get_Id))
         )
  )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (TrueMiddle ?MB) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom 0) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LT ?MT ?RT ?RM ?RB 0 ?LB ?LM ?MB)) (Id (Get_Id))
         )
  )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle 0) (TrueMiddle ?LM) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ 1 ?L) ?LT ?MT ?RT ?RM ?RB ?MB ?LB 0 ?LM)) (Id (Get_Id))
         )
  )
  (bind ?*TotalNodesCount* (+ ?*TotalNodesCount* 4))
  (bind ?*TotalStepsCount* (+ ?*TotalStepsCount* 1))
)
 
(defrule make_new_path_RightMiddle
  (declare (salience 100))
  ?fmin<-(min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop ?LT)    (MiddleTop ?MT) (RightTop ?RT)
     (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle 0)
     (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB) (Exp ?E& :(= ?E ?min)))
=>
 (modify ?f(State 1))
 (bind ?a (W (+ ?L 1) ?LT ?MT 0 ?RT ?RB ?MB ?LB ?LM ?MM))
 (retract ?fmin)
 (assert (min 100000))
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop 0)
                (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle ?RT)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
         )
 )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (TrueMiddle 0) (RightMiddle ?MM)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ ?L 1) ?LT ?MT ?RT ?MM ?RB ?MB ?LB ?LM 0)) (Id (Get_Id))
         )
  )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle ?RB)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom 0)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ ?L 1) ?LT ?MT ?RT ?RB 0 ?MB ?LB ?LM ?MM)) (Id (Get_Id))
         )
  )
  (bind ?*TotalNodesCount* (+ ?*TotalNodesCount* 3))
  (bind ?*TotalStepsCount* (+ ?*TotalStepsCount* 1))
)
 
(defrule make_new_path_LeftBottom
  (declare (salience 100))
  ?fmin<-(min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop ?LT)    (MiddleTop ?MT) (RightTop ?RT)
     (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle ?RM)
     (LeftBottom 0) (MiddleBottom ?MB) (RightBottom ?RB) (Exp ?E& :(= ?E ?min)))
=>
 (modify ?f(State 1))
 (bind ?a (W (+ ?L 1) ?LT ?MT ?RT ?RM ?RB ?MB ?LM 0 ?MM))
 (retract ?fmin)
 (assert (min 100000))
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle 0) (TrueMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom ?LM) (MiddleBottom ?MB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
         )
 )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom ?MB) (MiddleBottom 0) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ ?L 1) ?LT ?MT ?RT ?RM ?RB 0 ?MB ?LM ?MM)) (Id (Get_Id))
         )
  )
  (bind ?*TotalNodesCount* (+ ?*TotalNodesCount* 2))
  (bind ?*TotalStepsCount* (+ ?*TotalStepsCount* 1))
)
 
(defrule make_new_path_MiddleBottom
  (declare (salience 100))
  ?fmin<-(min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop ?LT)    (MiddleTop ?MT) (RightTop ?RT)
     (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle ?RM)
     (LeftBottom ?LB) (MiddleBottom 0) (RightBottom ?RB) (Exp ?E& :(= ?E ?min)))
=>
 (modify ?f(State 1))
 (bind ?a (W (+ ?L 1) ?LT ?MT ?RT ?RM ?RB ?LB 0 ?LM ?MM))
 (retract ?fmin)
 (assert (min 100000))
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom 0) (MiddleBottom ?LB) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
         )
 )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (TrueMiddle 0) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom ?MM) (RightBottom ?RB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ ?L 1) ?LT ?MT ?RT ?RM ?RB ?MM ?LB ?LM 0)) (Id (Get_Id))
         )
  )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom ?RB) (RightBottom 0)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ ?L 1) ?LT ?MT ?RT ?RM 0 ?RB ?LB ?LM ?MM)) (Id (Get_Id))
         )
  )
  (bind ?*TotalNodesCount* (+ ?*TotalNodesCount* 3))
  (bind ?*TotalStepsCount* (+ ?*TotalStepsCount* 1))
)
 
(defrule make_new_path_RightBottom
  (declare (salience 100))
  ?fmin<-(min ?min)
  ?f<-(Field (State 0) (Level ?L) (Id ?Id)
         (LeftTop ?LT)    (MiddleTop ?MT) (RightTop ?RT)
     (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle ?RM)
     (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom 0) (Exp ?E& :(= ?E ?min)))
=>
 (modify ?f(State 1))
 (bind ?a (W (+ ?L 1) ?LT ?MT ?RT 0 ?RM ?MB ?LB ?LM ?MM))
 (retract ?fmin)
 (assert (min 100000))
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle 0)
                (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RM)
                (Level (+ ?L 1)) (From ?Id) (Exp ?a) (Id (Get_Id))
         )
 )
 (assert (Field (LeftTop ?LT) (MiddleTop ?MT) (RightTop ?RT)
                (LeftMiddle ?LM) (TrueMiddle ?MM) (RightMiddle ?RM)
                (LeftBottom ?LB) (MiddleBottom 0) (RightBottom ?MB)
                (Level (+ ?L 1)) (From ?Id) (Exp (W (+ ?L 1) ?LT ?MT ?RT ?RM ?MB 0 ?LB ?LM ?MM)) (Id (Get_Id))
         )
  )
  (bind ?*TotalNodesCount* (+ ?*TotalNodesCount* 2))
  (bind ?*TotalStepsCount* (+ ?*TotalStepsCount* 1))
)
 
(defrule find_min
  (declare (salience 150))
;;приоритет ниже чем у правила исключающего циклы и выше чем у правил порождения новых ходов
  ?fmin<-(min ?min)
  (Field (Exp ?E& :(< ?E ?min)) (State 0))
=>
 (retract ?fmin)
 (assert (min ?E))
)
 
(defrule errors;;на случай, если в программе допущены ошибки с перестановками
  (declare (salience 1000))
  (Field 
         (LeftTop ?LT)    (MiddleTop ?MT)    (RightTop ?RT)
         (LeftMiddle ?LM) (TrueMiddle ?MM)   (RightMiddle ?RM)
         (LeftBottom ?LB) (MiddleBottom ?MB) (RightBottom ?RB))
  (test (or (= ?LT ?MT) (= ?LT ?RT) (= ?LT ?LM) (= ?LT ?MM) (= ?LT ?RM) (= ?LT ?LB) (= ?LT ?MB) (= ?LT ?RB) (= ?MT ?RT) (= ?MT ?LM) (= ?MT ?MM) (= ?MT ?RM) (= ?MT ?LB) (= ?MT ?MB) (= ?MT ?RB) (= ?RT ?LM) (= ?RT ?MM) (= ?RT ?RM) (= ?RT ?LB) (= ?RT ?MB) (= ?RT ?RB) (= ?LM ?MM) (= ?LM ?RM) (= ?LM ?LB) (= ?LM ?MB) (= ?LM ?RB) (= ?MM ?RM) (= ?MM ?LB) (= ?MM ?MB) (= ?MM ?RB) (= ?RM ?LB) (= ?RM ?MB) (= ?RM ?RB) (= ?LB ?MB) (= ?LB ?RB) (= ?MB ?RB)))
=>
 (printout t "error" crlf)
 (halt)
)
 
;;если нашли решение, то выделяем его
(defrule start_select_answer
  (declare (salience 500))
  ?f<-(Field (LeftTop 1)    (MiddleTop 2) (RightTop 3)
     (LeftMiddle 4) (TrueMiddle 0) (RightMiddle 5)
     (LeftBottom 6) (MiddleBottom 7) (RightBottom 8) (State ~2) (From ?Id))
=>
  (modify ?f(State 2))
  (assert (Id ?Id))
)
 
(defrule select_answer
  (declare (salience 500))
  ?fId<-(Id ?Id)
  ?f<-(Field (Id ?Id) (State ~2) (From ?NewId))
=>
  (modify ?f(State 2))
  (retract ?fId)
  (assert (Id ?NewId))
)
 
;;удаляем остальные
(defrule delete_not_answer
  (declare (salience 400))
  (Field (State 2))
  ?f<-(Field (State ~2))
=>
  (retract ?f)
)
 
;;делаем остановку если решений нет
(defrule Stop_1
  (declare (salience 200))
  (not (Field(State 0|2)))
=>
  (halt)
  (printout t "no solutions" crlf)
)
 
;;делаем остановку если решение есть
(defrule Stop_2
  (declare (salience 200))
  (Field(State 2))
=>
  (halt)
  (printout t "found solution" crlf)
  (printout t "Steps = " ?*TotalStepsCount* crlf)
  (printout t "Nodes = " ?*TotalNodesCount* crlf)
)