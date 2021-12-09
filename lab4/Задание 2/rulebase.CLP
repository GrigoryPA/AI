(deftemplate Node))
    (slot LeftTop(type NUMBER)) ;; 9 слотов для положения фишек
    (slot MiddleTop(type NUMBER))
    (slot RightTop(type NUMBER))
    (slot LeftMiddle(type NUMBER))
    (slot MiddleMiddle(type NUMBER))
    (slot RightMiddle(type NUMBER))
    (slot LeftBottom (type NUMBER))
    (slot MiddleBottom(type NUMBER))
    (slot RightBottom(type NUMBER))
    (slot Depth(type NUMBER)) ;; глубина вершины в дереве
    (slot Id(type NUMBER) (default 0)) ;; уникальный идентификатор вершины
    (slot Status(type NUMBER) (default 0)) ;; статус вершины:
    0 – не раскрыта,
    1 – раскрыта
    2 – соответствует решению
    (slot From (type NUMBER)) ;; ссылка на родителя
    (slot Exp (type NUMBER)) ;; значение целевой функции для данной вершины
)

(defglobal
    ?*Id* = О ;; объявляем и инициализируем глобальную переменную
)
(deffunction Get_Id() ;; функция получения следующего Id
    (bind ?*Id* (+ ?*Id* 1)) ;; инкрементируем Id
        ?*Id*
)

(deffunction W(?Depth ?LeftTop ?MiddleTop ?RightTop
?RightMiddle ?RightBottom ?MiddleBottom
?LeftBottom ?LeftMiddle)
    (bind ?a ?Depth) ;; f(n) := g(n)
    (if (not (= ?LeftTop 1)) then (bind ?a (+ 1 ?a))) ;; подсчет f(n)
    (if (not (= ?MiddleTop 2)) then (bind ?a (+ 1 ?a))) ;; в части h(n)
    (if (not (= ?RightTop 3)) then (bind ?a (+ 1 ?a))) ;; по всем (8-ми!)
    (if (not (= ?RightMiddle 4)) then (bind ?a (+ 1 ?a))) ;; ячейкам
    (if (not (= ?RightBottom 5)) then (bind ?a (+ 1 ?a)))
    (if (not (= ?MiddleBottom 6)) then (bind ?a (+ 1 ?a)))
    (if (not (= ?Left Bottom 7)) then (bind ?a (+ 1 ?a)))
    (if (not (= ?LeftMiddle 8)) then (bind ?a (+ 1 ?a)))
    ?a ;; возвращаемое значение
)

(deffacts start ;; факты соответствующие исходному состоянию
    (Node(LeftTop 2)    (MiddleTop 8)    (RightTop 3)
         (LeftMiddle 1) (MiddleMiddle 6) (RightMiddle 4)
         (LeftBottom 7) (MiddleBottom 0) (RightBottom 5)
    (Depth 0)
    (From 0)
    (Exp (W 0 2 8 3 4 5 0 7 1))
    (Id (Get_Id))
    )
    (min (W 0 2 8 3 4 5 0 7 1)) ;; фиксируется текущее значение min f(n)
)

(defrule move_circle
    (declare (salience 1000)) ;; максимальный приоритет!!!
    (Node(Exp ?Х)) ;; первый факт
        ?f<-(Node (Exp ?Y&~?X)(Status 0))   ;; второй факт
                                            ;;с неравным значением ЦФ
    (test(< ?X ?У)) ;;большим, чем у первого состояния
    = >
    (retract ?f) ;; удаление вершины с большей ЦФ
    (printout t "delete rule" crlf)
)

(defrule goal_test ;;проверка целевого состояния
    (declare (salience 500))
        ?f<-(Node (LeftTop 1)    (MiddleTop 2)    (RightTop 3);; состояние
                  (LeftMiddle 8) (MiddleMiddle 0) (RightMiddle 4) ;; целевое
                  (LeftBottom 7) (MiddleBottom 6) (RightBottom 5)
    (Status ~2) ;; текущий статус вершины «не целевое»
    (From ?Id))
    = >
    (modify ?f(Status 2));;текущая вершина помечается как «целевая»
)

(defrule select_answer  ;; изменение статуса промежуточных вершин
                        ;; - бэктрекинг
    (declare (salience 500))
    (;; вершина со статусом 2, ссылается на
        Node(Status 2) (From ?Id)) ;; родителя
    ?f<-(Node(Id ?Id) (Status ~2))
    = >
    (modify ?f(Status 2))
)

(deffunction ManhDist(?vertex ?x ?y)
    (if (=vertex 1) then
        x + y
    )
    (if (=vertex 2) then
        abs(x - 1) + y
    )
    (if (=vertex 3) then
        abs(x - 2) + y
    )
    (if (=vertex 4) then
        x + abs(y - 1)
    )
    (if (=vertex 5) then
        abs(x - 2) + abs(y - 1)
    )
    (if (=vertex 6) then
        x + abs(y - 2)
    )
    (if (=vertex 7) then
        abs(x - 1) + abs(y - 2)
    )
    (if (=vertex 8) then
        abs(x - 2) + abs(x - 2)
    )
)