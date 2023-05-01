-- If you found your way here, you probably have your own testing or working .dm
-- This one has mod headers or mod info in it, so copy and paste it into whatever
-- - it won't work on its own.

#newspell
#name "Remove Bonus HP pt5"
#effect 683
#damage 305
#aoe 666
#nreff 379
-- add 84*779 = 65436. Here we are at exactly 100, add the two together = 65536.
-- So we this should take it back to zero again?
#school -1
#researchlevel 0
#pathlevel 0 1
#spec 0
#fatiguecost 0
#end


#newspell
#name "Remove Bonus HP pt4"
#effect 683
#damage 305
#aoe 666
#nreff 400
-- add 84*779 = 65436. Here we are at exactly 100, add the two together = 65536.
-- So we this should take it back to zero again?
-- except we can't use nreff > 500 because it turns into half scaling
-- so split into 379+400
#school -1
#researchlevel 0
#pathlevel 0 1
#spec 0
#fatiguecost 0
#nextspell "Remove Bonus HP pt5"
#end

#newspell
#name "Remove Bonus HP pt3"
-- set to 100
#effect 599
#damage 305
#aoe 666
#nreff 1
#school -1
#researchlevel 0
#pathlevel 0 1
#spec 0
#fatiguecost 0
#nextspell "Remove Bonus HP pt4"
#end

#newspell
#name "Remove Bonus HP pt2"
#effect 699
#damage 305
#aoe 666
#nreff 328
-- add 32800, this should overflow any value
#school -1
#researchlevel 0
#pathlevel 0 1
#spec 0
#fatiguecost 0
#nextspell "Remove Bonus HP pt3"
#end

#newspell
#name "Remove Bonus HP pt1"
#effect 599 -- set to 100 if lower
#damage 305
#aoe 666
#nreff 1
#school -1
#researchlevel 0
#pathlevel 0 1
#spec 0
#fatiguecost 0
#nextspell "Remove Bonus HP pt2"
#end

#newspell
#copyspell "Frighten"
#name "Remove Bonus HP"
#fatiguecost 0
#aoe 666
#prec 100
#range 100
#nextspell "Remove Bonus HP pt1"
#researchlevel 0
#end

#newspell
#name "Slot bonus hp"
#effect 10569
#nreff 1
#damage 305
#path 0 4
#school 0
#researchlevel 0
#pathlevel 0 1
#fatiguecost 100
#end

#newspell
#name "Slot sleep aura"
#effect 10509
#nreff 1
#damage 306
#path 0 4
#school 0
#researchlevel 0
#pathlevel 0 1
#fatiguecost 100
#end

#newspell
#name "Slot disbelieve"
#effect 10509
#nreff 1
#damage 295
#path 0 4
#school 0
#researchlevel 0
#pathlevel 0 1
#fatiguecost 100
#end

#newspell
#name "Slot healer"
#effect 10502
#nreff 1
#damage 354
#path 0 4
#school 0
#researchlevel 0
#pathlevel 0 1
#fatiguecost 100
#end

#newspell
#name "Slot inspirational"
#effect 10502
#nreff 1
#damage 368
#path 0 4
#school 0
#researchlevel 0
#pathlevel 0 1
#fatiguecost 100
#end

#newspell
#name "Slot reforming"
#effect 10589
#nreff 1
#damage 337
#path 0 4
#school 0
#researchlevel 0
#pathlevel 0 1
#fatiguecost 100
#end

#newspell
#name "Slot mindslime"
#effect 10509
#nreff 1
#damage 402
#path 0 4
#school 0
#researchlevel 0
#pathlevel 0 1
#fatiguecost 100
#end
