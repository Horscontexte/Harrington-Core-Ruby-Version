# Harrington-Core-Ruby-Version
Rework for Harrington Core Project - Base on S.H.A.L

## What is this script ?

Based on Dan Harrigton work in "Harrington on Hold 'em: Expert Strategy for No Limit Tournaments: The Endgame", i make a script to solve preflop shove
in a 3 way poker action. The calculation method is based on "structured hand analysis". 

In order to make it work, you must use the Harrigton-tool repo to create data and fill a mongoDB with tones of equity poker result. 

https://github.com/Horscontexte/Harrington-Tools

## Variables

- Our hands (Two cards)
  - Example : "AcAd"
- Small Blind and big blind calling range
  - Example :  ['AA','KK','QQ','JJ','TT','99','88','77','66','55','44','33','22','AKo','AKs','AQo','AQs','AJs','AJo','ATo','ATs','A9s','A8s','KQo','KJo']
- Table size
- Ante size
- Our, small blind and big bling stack

## Result

When we execute the script, we get "Info - EV => the number of expected blind with our shove against two opponent"

If the result is positive, pushing our hand is EV+

If the result is negative, pushing our hand is EV-, and of course, we shouldnt do that :)
