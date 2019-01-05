;===================================================
; What To Eat Expert System
;
; This expert system is for someone who
; don't know what to eat everyday (just like me).
;
; It will asks serveral questions to the user
; to find out a recommended meal for him/her.
;    
; This system is adapted from auto.clp from the 
; example on the CLIPS website. 

; Tianyi Yang
; tyan227
; 644294325
; tyan227@aucklanduni.ac.nz
;===================================================

;;****************
;;* Welcome Info *
;;****************

(defrule system-banner ""
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "Welcome to WhatToEat System!")
  (printout t crlf crlf)
  (printout t "Don't know what to eat? Let's find one for you.")
  (printout t crlf crlf))

;;****************
;;* Show Result  *
;;****************

(defrule print-eat ""
  (declare (salience 10))
  (eat ?item)
  =>
  (printout t crlf crlf)
  (printout t "Our suggestion is:")
  (printout t crlf crlf)
  (format t " %s%n%n%n" ?item)
  (printout t crlf)
  (printout t "Have a nice meal!")
  )

;;****************
;;* DEFFUNCTIONS *
;;****************

; ask question function
(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

; question with only yes/no answers.
(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no))


; question with 3 possible answers.
; we have two 3-opiton nodes, so we put 1/2/3 here as a common option for both cases.
(deffunction one-two-or-three (?question)
   (bind ?response (ask-question ?question one two three 1 2 3))
   (if (or (eq ?response one) (eq ?response 1))
       then one 
       else (if (or (eq ?response two) (eq ?response 2))
       then two 
       else three)
    )
)


;;;***************
;;;* QUERY RULES *
;;;***************


; Start question
(defrule determine-meal-type ""
   (not (meal-choose ?))
   (not (eat ?))
   =>
   (assert (meal-choose (one-two-or-three "
   What is the type of the meal? 
   For Breakfast/Lunch/Dinner,
   Please type one/two/three or 1/2/3 "))))
;==========


  ; 1.Breakfast   
  (defrule determine-have-time-prepare ""
    (meal-choose one)
    (not (eat ?))
    =>
    (assert (have-time-prepare (yes-or-no-p "Do you have time to prepare it (yes/no)? "))))
  ;==========


  ; 2.Lunch
  (defrule determine-at-uni ""
    (meal-choose two)
    (not (eat ?))   
    =>
    (assert (at-uni (yes-or-no-p "Are you at the university (yes/no)? "))))

    ; 2.1:class in the afternoon   
    (defrule determine-afternoon-class ""
      (meal-choose two)
      (at-uni yes)
      (not (eat ?))
      =>
      (assert (afternoon-class (yes-or-no-p "Do you have class in the afternoon (yes/no)? "))))

    ; 2.2:food type   
    (defrule determine-food-type ""
      (meal-choose two)
      (at-uni no)
      (not (eat ?))
      =>
      (assert (food-type (one-two-or-three "
   Which type of food do you want to have today? 
   For Western/Chinese/Korean food,
   Please type one/two/three or 1/2/3 "))))

      ; 2.2.1: Western food   
      (defrule determine-fast-food ""
        (meal-choose two)
        (at-uni no)
        (food-type one)
        (not (eat ?))
        =>
        (assert (fast-food (yes-or-no-p "Fast food (yes/no)? "))))

      ; 2.2.2: Chinese food   
      (defrule determine-rice ""
        (meal-choose two)
        (at-uni no)
        (food-type two)
        (not (eat ?))
        =>
        (assert (rice (yes-or-no-p "Rice (yes/no)? "))))

      ; 2.2.3: Korean food   
      (defrule determine-light ""
        (meal-choose two)
        (at-uni no)
        (food-type three)
        (not (eat ?))
        =>
        (assert (light (yes-or-no-p "Something light (yes/no)? "))))
  ;==========


  ; 3.Dinner
  (defrule determine-cook-for-dinner ""
    (meal-choose three)
    (not (eat ?))   
    =>
    (assert (cook-for-dinner (yes-or-no-p "Cook for dinner (yes/no)? "))))

    ; 3.1: also prepare breakfast
    (defrule determine-also-prepare-breakfast ""
      (meal-choose three)
      (cook-for-dinner yes)
      (not (eat ?))
      =>
      (assert (also-prepare-breakfast (yes-or-no-p "Also prepare food for the breakfast of the following day (yes/no)? "))))

    ; 3.2: domino voucher
    (defrule determine-have-voucher ""
      (meal-choose three)
      (cook-for-dinner no)
      (not (eat ?))
      =>
      (assert (have-voucher (yes-or-no-p "Have voucher for Domino pizza (yes/no)? "))))




;;;****************
;;;*Result for Eat*
;;;****************

; 1.Breakfast
(defrule have-time-prepare-yes ""
   (have-time-prepare yes)
   (not (eat ?))
   =>
   (assert (eat "Cereal and milk.")))

(defrule have-time-prepare-no ""
   (have-time-prepare no)
   (not (eat ?))
   =>
   (assert (eat "Sandwich with bacon and eggs.")))


; 2.Lunch

  ; 2.1 At university
  (defrule afternoon-class-yes ""
    (afternoon-class yes)
    (not (eat ?))
    =>
    (assert (eat "Have some food in the cafeteria of the university."))) 

  (defrule afternoon-class-no ""
    (afternoon-class no)
    (not (eat ?))
    =>
    (assert (eat "Go home and prepare the lunch.")))

  ; 2.2 Not at university 

    ; 2.2.1: Western food

    (defrule fast-food-yes ""
      (fast-food yes)
      (not (eat ?))
      =>
      (assert (eat "McDonald's")))  

    (defrule fast-food-no ""
      (fast-food no)
      (not (eat ?))
      =>
      (assert (eat "Steak")))   

    ; 2.2.2: Chinese food

    (defrule rice-yes ""
      (rice yes)
      (not (eat ?))
      =>
      (assert (eat "Stir rice")))  

    (defrule rice-no ""
      (rice no)
      (not (eat ?))
      =>
      (assert (eat "Beef Noodle"))) 

    ; 2.2.3: Korean food

    (defrule light-yes ""
      (light yes)
      (not (eat ?))
      =>
      (assert (eat "Bibimbap")))  

    (defrule light-no ""
      (light no)
      (not (eat ?))
      =>
      (assert (eat "Fried chicken"))) 

; 3.Dinner
  
  ; 3.1 also prepare breakfast
  (defrule also-prepare-breakfast-yes ""
      (also-prepare-breakfast yes)
      (not (eat ?))
      =>
      (assert (eat "Sushi")))

  (defrule also-prepare-breakfast-no ""
      (also-prepare-breakfast no)
      (not (eat ?))
      =>
      (assert (eat "Hot pot")))

  ; 3.2 have domino voucher
  (defrule have-voucher-yes ""
      (have-voucher yes)
      (not (eat ?))
      =>
      (assert (eat "Domino pizza home delivery")))

  (defrule have-voucher-no ""
      (have-voucher no)
      (not (eat ?))
      =>
      (assert (eat "Have dinner at a restaurant near home")))


; for debbuging
(defrule no-eats ""
  (declare (salience -10))
  (not (eat ?))
  =>
  (assert (eat "Don't need to eat right now.")))



