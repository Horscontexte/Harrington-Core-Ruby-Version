# 1. Variable de traitement
# a. Trois tableaux permettant d'identifier si le combo est suited/offsuited ou pair
suited = ['AKs','AQs','AJs','ATs','A9s','A8s','A7s','A6s','A5s','A4s','A3s','A2s','KQs','KJs','KTs','K9s','K8s','K7s','K6s','K5s','K4s','K3s','K2s','QJs',
'QTs','Q9s','Q8s','Q7s','Q6s','Q5s','Q4s','Q3s','Q2s','JTs','J9s','J8s','J7s','J6s','J5s','J4s','J3s','J2s','T9s','T8s','T7s','T6s','T5s','T4s','T3s',
'T2s','98s','97s','96s','95s','94s','93s','92s','87s','86s','85s','84s','83s','82s','76s','75s','74s','73s','72s','65s','64s','63s','62s','54s','53s',
'52s','43s','42s','32s']
offsuited = ['AKo','AQo','AJo','ATo','A9o','A8o','A7o','A6o','A5o','A4o','A3o','A2o','KQo','KJo','KTo','K9o','K8o','K7o','K6o','K5o','K4o','K3o','K2o','QJo',
'QTo','Q9o','Q8o','Q7o','Q6o','Q5o','Q4o','Q3o','Q2o','JTo','J9o','J8o','J7o','J6o','J5o','J4o','J3o','J2o','T9o','T8o','T7o','T6o','T5o','T4o','T3o',
'T2o','98o','97o','96o','95o','94o','93o','92o','87o','86o','85o','84o','83o','82o','76o','75o','74o','73o','72o','65o','64o','63o','62o','54o','53o',
'52o','43o','42o','32o']
pair = ['AA','KK','QQ','JJ','TT','99','88','77','66','55','44','33','22']
# b. Deux variables permettant de stocker les counts dans un scope global
vilain_sb_combo = 0
vilain_bb_combo = 0
# c. Le nombre de combinaison total possible pour 52 cartes (Moins les deux cartes de hero)
total_hands_combo = 1225;
# 2. Définir les variables user :
# - Notre main
# - La range de vilain 1
# - La range de vilain 2
# - Le nombres de joueur à table
# - La taille de l'ante
# - La taille du tapis de hero, vilainSB et vilainBB
hero_hand = "AcAd"
vilain_range_sb = ['AA','KK','QQ','JJ','TT','99','88','77','ATs','AKo','AKs','AQo','AQs','AJs']
vilain_range_bb = ['AA','KK','QQ','JJ','TT','99','88','77','66','55','AKo','AKs','AQo','AQs','AJs','AJo','ATo','ATs','A9s','A8s']
table_size = 3
ante = 1.12
hero_tapis = 10
vilain_sb_tapis = 14
vilain_bb_tapis = 9
# 3. Vérification du format des variables :
#     - 4 caractères maximum + (regex => WIP)
if hero_hand.length == 4
puts "Info - Hero Hand => " + hero_hand + " : OK!"
else
puts "Error - " + hero_hand + " : wrong format!"
end
#     - Détection du format des ranges des vilains (SB et BB)
vilain_range_sb.each do |hand|
  if hand.length <= 3
    puts "Info - SmallBlind Range => " + hand + " => 'o/s (offsuited/suited)' : OK!"
  elsif hand.length == 4
    puts "Info - SmallBlind Range => " + hand + " => 's/c/d/h (spade/clubs/diamond/heart)' : OK!"
  else
    puts "Error - " + hand + " => wrong format!"
  end
end
vilain_range_bb.each do |hand|
  if hand.length <= 3
    puts "Info - BigBlind Range => " + hand + " => 'o/s (offsuited/suited)' : OK!"
  elsif hand.length == 4
    puts "Info - BigBlind Range => " + hand + " => 's/c/d/h (spade/clubs/diamond/heart)' : OK!"
  else
    puts "Error - " + hand + " => wrong format!"
  end
end
# 4. Nous allons compter le nombre de combo contenu dans chaque range :
#        - Paire => 6 Combo
#        - Dépareillées => 12 Combo
#        - Assorties => 4 Combo
vilain_range_sb.each do |hand|
  if suited.include? hand
    vilain_sb_combo += 4
  elsif offsuited.include? hand
    vilain_sb_combo += 12
  elsif pair.include? hand
    vilain_sb_combo += 6
  else
    puts "Error - " + hand + " is not suited/offsuited or pair"
  end
end
# Print a log with vilainSB count
puts "Info - VilainSB count => " + vilain_sb_combo.to_s
vilain_range_bb.each do |hand|
  if suited.include? hand
    vilain_bb_combo += 4
  elsif offsuited.include? hand
    vilain_bb_combo += 12
  elsif pair.include? hand
    vilain_bb_combo += 6
  else
    puts "Error - " + hand + " is not suited/offsuited or pair"
  end
end
# Print a log with vilainBB count
puts "Info - VilainBB count => " + vilain_bb_combo.to_s
# 5. Calculer la probabilité pour chaque range d'obtenir un call
vilain_sb_call = vilain_sb_combo.to_f / total_hands_combo.to_f
vilain_sb_call = vilain_sb_call.to_f * 100
puts "Info - VilainSB calling => " + vilain_sb_call.to_s + "%"
vilain_bb_call = vilain_bb_combo.to_f / total_hands_combo.to_f
vilain_bb_call = vilain_bb_call.to_f * 100
puts "Info - VilainBB calling => " + vilain_bb_call.to_s + "%"
# 6. Calculer la probabilité d'obtenir un fold apres un shove de Hero
vilain_sb_fold = 100 - vilain_sb_call.to_f
vilain_bb_fold = 100 - vilain_bb_call.to_f
vilains_total_fold = (vilain_sb_fold.to_f + vilain_bb_fold.to_f) / 2
vilains_total_fold.to_f ** 2
vilains_total_call = 100 - vilains_total_fold.to_f
puts "Info - Probabilité d'obtenir un fold par SB et BB => " + vilains_total_fold.to_s
puts "Info - Probabilité d'obtenir un call par SB ou BB => " + vilains_total_call.to_s
# 7. Calculer l'equity de chaque rencontre (Hero vs vilain combo)
