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
# b. Deux variables permettant de stocker les counts
vilain_sb_combo = 0
vilain_bb_combo = 0
# c. Le nombre de combinaison total possible pour 52 cartes (Moins les deux cartes de hero)
total_hands_combo = 1225;
# d. MongoConfiguration and database connection
require 'mongo'
Mongo::Logger.logger.level = ::Logger::FATAL
client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'equity')
# e. Variable pour stocker le nombre de victoire face au deux joueurs
hero_vs_sb_victory_count = 0
hero_vs_bb_victory_count = 0
hero_vs_sb_split_count = 0
hero_vs_bb_split_count = 0
# f. Variables pour stocker le nombre de rencontre théorique, et le nombre de rencontre reel (Rencontre impossible!)
hero_vs_sb_requested_combo = 0
hero_vs_sb_impossible_combo = 0
hero_vs_bb_requested_combo = 0
hero_vs_bb_impossible_combo = 0
# g. Tableaux pour stocker les différentes combinaison possible de couleur pour deux cartes
offsuited_color = ["ch","cd","cs","hc","hd","hs","dc","dh","ds","sc","sh","sd"]
suited_color = ["cc","dd","ss","hh"]
pair_color = ["ch","cd","cs","hd","hs","ds"]
# 2. Définir les variables user :
# - Notre main
# - La range de vilain 1
# - La range de vilain 2
# - Le nombres de joueur à table
# - La taille de l'ante
# - La taille du tapis de hero, vilainSB et vilainBB
hero_hand = "AcAd"
hero_card_1 = "Ac"
hero_card_2 = "Ad"
vilain_range_sb = ['AA','KK','QQ','JJ','TT','99','88','77','66','55','44','33','22','AKo','AKs','AQo','AQs','AJs','AJo','ATo','ATs','A9s','A8s','KQo','KJo']
vilain_range_bb = ['AA','KK','QQ','JJ','TT','99','88','77','66','55','44','33','22','AKo','AKs','AQo','AQs','AJs','AJo','ATo','ATs','A9s','A8s','KQo','KJo']
table_size = 3
ante = 0.12
hero_tapis = 10
vilain_sb_tapis = 14
vilain_bb_tapis = 9
# 3. Vérification du format des variables :
#     - 4 caractères maximum + (regex => WIP)
if hero_hand.length == 4
puts "Info - Hero Hand => " + hero_hand + " : OK!"
else
puts "Error - " + hero_hand + " => wrong format!"
abort
end
#     - Détection du format des ranges des vilains (SB et BB)
vilain_range_sb.each do |hand|
  if hand.length <= 3
    puts "Info - SmallBlind Range => " + hand + " => 'o/s (offsuited/suited)' : OK!"
  elsif hand.length == 4
    puts "Info - SmallBlind Range => " + hand + " => 's/c/d/h (spade/clubs/diamond/heart)' : OK!"
  else
    puts "Error - " + hand + " => wrong format!"
    abort
  end
end
vilain_range_bb.each do |hand|
  if hand.length <= 3
    puts "Info - BigBlind Range => " + hand + " => 'o/s (offsuited/suited)' : OK!"
  elsif hand.length == 4
    puts "Info - BigBlind Range => " + hand + " => 's/c/d/h (spade/clubs/diamond/heart)' : OK!"
  else
    puts "Error - " + hand + " => wrong format!"
    abort
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
    abort
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
    abort
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
vilain_range_sb.each do |hand|
  # Si le dernier caractere de la string est une majuscule => C'est forcement une paire.
  if hand[-1, 1] == hand[-1, 1].capitalize
    pair_color.each do |color|
      if hero_card_1 == hand[0,1] + color[1,1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[0,1] + hand[1,1] + color[1, 1]
        hero_vs_sb_impossible_combo += 1
      elsif hero_card_1 == hand[1,1] + color[0, 1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[0,1] + hand[1,1]+ color[1, 1]
        hero_vs_sb_impossible_combo += 1
      elsif hero_card_2 == hand[0,1] + color[-1, 1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[-1, 1] + hand[1,1] + color[0,1]
        hero_vs_sb_impossible_combo += 1
      elsif hero_card_2 == hand[1, 1] + color[0,1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[-1, 1]  + color[0,1] + hand[1,1] + color[1, 1]
        hero_vs_sb_impossible_combo += 1
      end
      client[:equitys].find(:heroHand => hero_hand, :vilainHand => hand[0,1] + color[0,1] + hand[1,1] + color[1, 1]).each do |doc|
        hero_vs_sb_victory_count += doc['heroEquity'].to_i
        hero_vs_sb_split_count += doc['splitEquity'].to_i
        hero_vs_sb_requested_combo += 1
      end
    end
  elsif hand[-1, 1] == "o"
    offsuited_color.each do |color|
      if hero_card_1 == hand[0,1] + color[1,1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[0,1] + hand[1,1] + color[-1, 1]
        hero_vs_sb_impossible_combo += 1
      elsif hero_card_1 == hand[1,1] + color[-1, 1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[0,1] + hand[1,1]+ color[-1, 1]
        hero_vs_sb_impossible_combo += 1
      elsif hero_card_2 == hand[0,1] + color[-1, 1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[-1, 1] + hand[1,1] + color[0,1]
        hero_vs_sb_impossible_combo += 1
      elsif hero_card_2 == hand[1, 1] + color[0,1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[-1, 1]  + color[0,1] + hand[1,1] + color[-1, 1]
        hero_vs_sb_impossible_combo += 1
      end
      client[:equitys].find(:heroHand => hero_hand, :vilainHand => hand[0,1] + color[0,1] + hand[1,1] + color[-1, 1]).each do |doc|
        hero_vs_sb_victory_count += doc['heroEquity'].to_i
        hero_vs_sb_split_count += doc['splitEquity'].to_i
        hero_vs_sb_requested_combo += 1
      end
    end
  elsif hand[-1, 1] == "s"
    suited_color.each do |color|
      if hero_card_1 == hand[0,1] + color[1,1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[0,1] + hand[1,1] + color[-1, 1]
        hero_vs_sb_impossible_combo += 1
      elsif hero_card_1 == hand[1,1] + color[-1, 1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[0,1] + hand[1,1]+ color[-1, 1]
        hero_vs_sb_impossible_combo += 1
      elsif hero_card_2 == hand[0,1] + color[-1, 1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[-1, 1] + hand[1,1] + color[0,1]
        hero_vs_sb_impossible_combo += 1
      elsif hero_card_2 == hand[1, 1] + color[0,1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[-1, 1]  + color[0,1] + hand[1,1] + color[-1, 1]
        hero_vs_sb_impossible_combo += 1
      end
      client[:equitys].find(:heroHand => hero_hand, :vilainHand => hand[0,1] + color[0,1] + hand[1,1] + color[-1, 1]).each do |doc|
        hero_vs_sb_victory_count += doc['heroEquity'].to_i
        hero_vs_sb_split_count += doc['splitEquity'].to_i
        hero_vs_sb_requested_combo += 1
      end
    end
  end
end
vilain_range_bb.each do |hand|
  # Si le dernier caractere de la string est une majuscule => C'est forcement une paire.
  if hand[-1, 1] == hand[-1, 1].capitalize
    pair_color.each do |color|
      if hero_card_1 == hand[0,1] + color[1,1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[0,1] + hand[1,1] + color[1, 1]
        hero_vs_bb_impossible_combo += 1
      elsif hero_card_1 == hand[1,1] + color[0, 1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[0,1] + hand[1,1]+ color[1, 1]
        hero_vs_bb_impossible_combo += 1
      elsif hero_card_2 == hand[0,1] + color[-1, 1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[-1, 1] + hand[1,1] + color[0,1]
        hero_vs_bb_impossible_combo += 1
      elsif hero_card_2 == hand[1, 1] + color[0,1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[-1, 1]  + color[0,1] + hand[1,1] + color[1, 1]
        hero_vs_bb_impossible_combo += 1
      end
      client[:equitys].find(:heroHand => hero_hand, :vilainHand => hand[0,1] + color[0,1] + hand[1,1] + color[1, 1]).each do |doc|
        hero_vs_bb_victory_count += doc['heroEquity'].to_i
        hero_vs_bb_split_count += doc['splitEquity'].to_i
        hero_vs_bb_requested_combo += 1
      end
    end
  elsif hand[-1, 1] == "o"
    offsuited_color.each do |color|
      if hero_card_1 == hand[0,1] + color[1,1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[0,1] + hand[1,1] + color[-1, 1]
        hero_vs_bb_impossible_combo += 1
      elsif hero_card_1 == hand[1,1] + color[-1, 1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[0,1] + hand[1,1]+ color[-1, 1]
        hero_vs_bb_impossible_combo += 1
      elsif hero_card_2 == hand[0,1] + color[-1, 1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[-1, 1] + hand[1,1] + color[0,1]
        hero_vs_bb_impossible_combo += 1
      elsif hero_card_2 == hand[1, 1] + color[0,1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[-1, 1]  + color[0,1] + hand[1,1] + color[-1, 1]
        hero_vs_bb_impossible_combo += 1
      end
      client[:equitys].find(:heroHand => hero_hand, :vilainHand => hand[0,1] + color[0,1] + hand[1,1] + color[-1, 1]).each do |doc|
        hero_vs_bb_victory_count += doc['heroEquity'].to_i
        hero_vs_bb_split_count += doc['splitEquity'].to_i
        hero_vs_bb_requested_combo += 1
      end
    end
  elsif hand[-1, 1] == "s"
    suited_color.each do |color|
      if hero_card_1 == hand[0,1] + color[1,1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[0,1] + hand[1,1] + color[-1, 1]
        hero_vs_bb_impossible_combo += 1
      elsif hero_card_1 == hand[1,1] + color[-1, 1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[0,1] + hand[1,1]+ color[-1, 1]
        hero_vs_bb_impossible_combo += 1
      elsif hero_card_2 == hand[0,1] + color[-1, 1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[0,1] + color[-1, 1] + hand[1,1] + color[0,1]
        hero_vs_bb_impossible_combo += 1
      elsif hero_card_2 == hand[1, 1] + color[0,1]
        puts "Error - Rencontre impossible! " + hero_hand + hand[-1, 1]  + color[0,1] + hand[1,1] + color[-1, 1]
        hero_vs_bb_impossible_combo += 1
      end
      client[:equitys].find(:heroHand => hero_hand, :vilainHand => hand[0,1] + color[0,1] + hand[1,1] + color[-1, 1]).each do |doc|
        hero_vs_bb_victory_count += doc['heroEquity'].to_i
        hero_vs_bb_split_count += doc['splitEquity'].to_i
        hero_vs_bb_requested_combo += 1
      end
    end
  end
end

split_vs_sb = hero_vs_sb_split_count / hero_vs_sb_requested_combo
split_vs_bb = hero_vs_bb_split_count / hero_vs_bb_requested_combo

victory_vs_sb = (hero_vs_sb_victory_count / hero_vs_sb_requested_combo) - split_vs_sb
loose_vs_sb = 100 - victory_vs_sb
victory_vs_bb = (hero_vs_bb_victory_count / hero_vs_bb_requested_combo) - split_vs_bb
loose_vs_bb = 100 - victory_vs_bb

sb_call_i_loose = (vilain_sb_call * loose_vs_sb) / 100
sb_call_i_win = (vilain_sb_call * victory_vs_sb) / 100
bb_call_i_loose = (vilain_bb_call * loose_vs_sb) / 100
bb_call_i_win = (vilain_bb_call * victory_vs_sb) / 100

pot = table_size * ante
pot += 1.5

if hero_tapis > vilain_sb_tapis
  hero_effective_stack = vilain_sb_tapis
else
  hero_effective_stack = hero_tapis
end
if hero_effective_stack > vilain_bb_tapis
  hero_effective_stack = vilain_bb_tapis
end

win_outcome = hero_effective_stack + pot
puts "Info - EV du push de " + hero_hand
everyone_fold_hero_ev = (vilains_total_fold.to_f * pot) / 100
puts "Info - Everyone fold Hero EV => " + everyone_fold_hero_ev.to_s
sb_call_i_win_hero_ev = (sb_call_i_win * win_outcome) / 100
sb_call_i_loose_hero_ev = (sb_call_i_loose * hero_effective_stack) / 100
puts "Info - SB call and hero win EV => " + sb_call_i_win_hero_ev.to_s
puts "Info - SB call and hero loose EV => " + sb_call_i_loose_hero_ev.to_s
bb_call_i_win_hero_ev = (bb_call_i_win * win_outcome) / 100
bb_call_i_loose_hero_ev = (bb_call_i_loose * hero_effective_stack) / 100
puts "Info - BB call and hero win EV => " + bb_call_i_win_hero_ev.to_s
puts "Info - BB call and hero loose EV => " + bb_call_i_loose_hero_ev.to_s
ev_result = (everyone_fold_hero_ev + sb_call_i_win_hero_ev + sb_call_i_loose_hero_ev + bb_call_i_win_hero_ev + bb_call_i_loose_hero_ev) / 5

puts "Info - EV => " + ev_result.to_s
