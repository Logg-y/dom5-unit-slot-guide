If you have no interest in modding Dominions 5, this is probably not for you. That is, unless you really like reading about overflowing signed 16 bit integers when the only operations you have are "add" or "set if less than" for some reason.

# BASICS 

There's an older document about 5xx and 6xx spells floating around, but I thought I'd write something as well to highlight the probably not-so-well-known stuff you can do by overflowing ability values and various other little mathematical manipulations.

Each unit in the game has 6 (a few years ago this was 4, it was increased because it was slightly abusable) "slots" on it. Most spell buffs **DO NOT USE THESE SLOTS**. Each slot stores an ability ID, and a corresponding "value", "amount" or "magnitude" of that ability. Their use is therefore generally restricted to things that need to store more data: most spell buffs by comparison are binary in nature: that is to say a unit either has barkskin, or it doesn't. There is no in between, and Illwinter set up their structures to handle the vast majority of buffs and afflictions this way (they can use a single bit per unit to mark whether a unit has a specific effect on them).

In vanilla, the most common effect that enters these slots slots tends to be Horror marks, though the value (severity or "number" or marks) cannot be seen without cheating it reflects how badly a unit is marked and is important in the chances of horror attacks and the like. The number of eyes lost by a unit is another example of this: given the game gives much more severe penalties for losing all your eyes, and not all creatures have only two, so it is therefore necessary to store the number that were damaged somewhere. That somewhere just happens to be effect slots.

Many unit abilities and effects in Dom5 can be added to these, and function as they would if put directly onto a base unit. There are ways to make spells that affect these values: it can be used to make a spell that gives someone a sleep aura, but it is _permanent_, unless going to great lengths to remove it (but more on this later).

If a unit has no free slots, trying to fill the "seventh" slot fails and instead does nothing. So if a unit with all six slots filled and no horror marks becomes completely immune to horror marking. The casting AI does not know this and may happily continue trying horror mark it until turn timer rout kicks in. For modders, making filling slots more available does make these abuse cases much more feasible. Relatively few players are likely aware of this, but it could still be a concern anyway.

The game itself uses these for a few other things, including (this isn't exhaustive by any means):-
-	The chassis a pretender was originally. This is why if you transform and kill a pretender, they come back as what they were originally, unless they were one of the two "extra" trinity members that don't get this set.
-	The number of eyes a unit has lost.
-	When an immortal unit dies, the turn number it should reform on.
-	When a unit with swarm body turns into a soul vessel, the unit ID it should reform into.
-	Mind Vessel uses this to record the unit ID of the "donor", so that if they are killed it can cancel the spell. This is bugged and makes the spell fail when cast by a unit with a too high ID to fit in the slot.

In some of these cases (like that of the immortals), I do not know what happens if all slots are filled by modded spells and the game's writing attempts fail.

In vanilla, filling four slots in combat is fairly trivial, because the "high power self resist" spells use them. However, elemental resistances are one of the things that are cleared after combat ends.
	
# ADDING THEM WITH SPELLS

Effect numbers 500-699 inclusive deal with adding to these slots.
The spell's DAMAGE attribute is the ability ID to add. Note that not all abilities work when added this way, and not all IDs currently do anything. See  [my list](https://docs.google.com/spreadsheets/d/1G2pZXwdo_c_QxLmIBZhl1E-UNGma__I9yuZTmJiuMhE) that I sort of occasionally/rarely update when people find things wrong with it.

Effect numbers 500-599 are "5xx" effects, and will SET the value to (xx+1) if the value in the recipient's slots was lower than that. So effect 509 damage 309 will give the recipient ability 309 with a value of 10, which happens to be a sleep aura. If you cast this again, nothing will happen. If you take a Shuten-Doji (which has sleep aura 10 already), it becomes 20 as the game happens to add the slot value to the base chassis value. I do not believe this is the case for all abilities (eg: many summoning abilities, start battle spells) but I could be mistaken.

Effect numbers 600-699 are "6xx" effects. These instead just ADD (xx+1) to the value in the recipient's slots, irrespective of what it was before. Effect 609 damage 309 will add 10 sleep aura every cast, and can keep pushing the ability value up and up, until overflows happen beyond 32767 (more on that later).

RITUALS can ONLY use 10500-10599 for the "set if less" versions. 10600-10699 do not function, and to my knowledge there is currently no way to make a ritual that does the uncapped version without somehow triggering an event that spawns a dummy assassin which has 6xx spells in a startbattlespell.

It is possible to make a caster direct a ritual 5xx spell at some other commander. Making a (cure affliction) effect 10131 damage 0 spell with a 105xx nextspell will direct the 105xx onto the commander the player picked when casting the spell. This doesn't seem to work for noncommander units, though it lets players pick them anyway, wasting their gems.

Casting AI will generally refuse to target these outside the few effect IDs used in vanilla. They do however work fine in nextspells, because the casting AI does not read nextspells for scoring purposes. Typically a "harmless" effect is needed to direct these onto the right kind of target (friend/foe) in battles.

A very small subset of these effects are removed from unit slots after battle. These are:
-	Damage reversal
-	Fire/Cold/Shock/Poison Resistances
-	Stun
-	Paralysis
-	Petrification
-	Cursed luck
-	Desiccation
-	Encase in ice
-	Mind collar activation (Phlegra iron bound take damage when they run away, a slot value is set to make this happen only once)
	
# OVERFLOW

Slots can only hold numbers so large. The game only allocates so much space to them, and it does not stop you trying to overfill them, which can lead to some useful results. Specifically, the maximum value that an ability can have in a slot is 32767, and trying to add more of this causes the value to overflow.

In technical terms slot values are signed 16 bit integers, which means they have a minimum value of -32768 and a maximum value of 32767 (and can therefore have 65536 possible values, including zero). Trying to add 1 to a slot of 32767 will make it become the very negative -32768 instead. Note that many abilities do nothing with negative magnitudes and will just disappear off the unit UI: in many cases the game executable simply fetches the value of an ability and checks to see if it is greater than zero before doing anything with it, and will therefore treat a value of zero (same as no ability) the same as any negative value.

However, this means that you can make "subtractive" effects, for instance a spell that reduces the fire resistance of whoever it hits. Because of how overflow works, to subtract X from a slot value you need to add (65536-X) of it instead. As the highest possible increment (effect 699) is +100, this is best done by a high number of effects. For instance, effect 699 nreff 380 will add 100*380 = 38000 to a slot ability value. Note that numbers of effects over 500 may be interpreted by the game as half scaling, and splitting these across multiple chained nextspells is probably the best solution.

To take a practical example, to make a spell subtract 30 fire resist, it'd be necessary to add 65536-30 = 65506 to the slot value...

Effect 699 damage 198 nreff 400 (+40000) followed by...
Effect 677 damage 198 nreff 327 (+78*327 = +25506)

Ideally, in the interests of making the game run faster, the total number of effects a unit is subjected to should be minimised. Adding in bigger increments will be somewhat more efficient!

# REMOVING EFFECTS FROM SLOTS 

Combining both 5xx and 6xx effects should let you zero out the value of a slot, which the game treats as empty and will happily allow another value in.

Because 5xx will set a slot value if it is lower, it will remove any overflowed negative values from the slot value. So, it is possible to "empty" a slot by...

1) effect 599 to 100. This sets any negative values to 100, and any positive values smaller than 100 to 100.
	At this point, the effect value can be in the range 100-32767.
2) effect 699 nreff 328. This adds 32800 to the value, which is guaranteed to overflow it. The result will therefore be in the range of -32636 to 31.
3) effect 599 to 100. Because the value will always be less than 100 after the prior steps, the value should ALWAYS become 100.
Now, overflow 100 again, but add exactly enough to get it to 0 by (which means adding exactly 65436).
4) effect 683 nreff 400. This adds 33600 of the required 65436, leaving 31836 to add. (slot value=-31836 after this)
5) effect 683 nreff 379. This adds 84*379=31836, leaving the value exactly at zero.

There is likely a more efficient way to perform steps 4 and 5 (that needs a smaller total number of effects than 779 additions of 84 used here).

A unit that never had the ability ID in their slots will have it added and cleared back to zero. All these operations will fail against a unit whose slots are full of other ability IDs.

[Here](./slotclear.dm) is an example of this in action. It contains:

1) The d1 combat spell "Remove Bonus HP" which is based on frighten (in practice you'd want a less harmful spell for the AI to aim with, but this was fast for testing). This will remove all bonus HP (effect 305) on everyone on the field by using the above steps
2) Seven s1 rituals named "Slot X" which will add some points of the named abilities.

Casting the slot hp bonus and five other of the rituals should add their effects normally (providing the caster has no slot effects already!), and then trying to use the last ritual will fail.

Exposing them to the combat spell clears the HP bonus effect, which then means that the last ritual will work correctly as it can take the slot where the HP bonus was before.


