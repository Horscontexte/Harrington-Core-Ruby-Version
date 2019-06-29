# 1. Définir les variables :
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

# 2. Vérification du format des variables :
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
