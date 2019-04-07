
function Roll-Initiative{
	<#
.SYNOPSIS
	This function “rolls” one d20 for Initiative.

.DESCRIPTION
	Author: Orval Roller (@cysecgunz on the Twitterz)
	License: Open Gaming License v1.0 / GNU General Public License (GPL 3.0)
	Required Dependencies: None
	Optional Dependencies: None    

.EXAMPLE
	Roll-Initiative
    	You rolled a Natural 20!
#>
	$Initiative = get-random -minimum 1 -maximum 21
    	if($Initiative -eq 20){
        	Write-Host "You rolled a Natural 20!" -foregroundcolor green
    	}
    	else
    	{
         	Write-Host "Your rolled a $Initiative for initiative!" -ForegroundColor green   
    	}
}

function Roll-AbilityCheck{
	<#
.SYNOPSIS
	This function “rolls” a d20 for an ability check (Strength,Dexterity,Constitution,Intelligence,Wisdom,or Charisma) and adds the character's
	ability modifier.

.DESCRIPTION
	Author: Orval Roller (@cysecgunz on the Twitterz)
	License: Open Gaming License v1.0 / GNU General Public License (GPL 3.0)
	Required Dependencies: None
	Optional Dependencies: None

.PARAMETER Ability
	Abilities are STR (Strength), DEX (Dexterity), CON (Constitution), INT (Intelligence), WIS (Wisdom), and CHA (Charisma).

.PARAMETER Modifier
	Ability modifiers are an integer ranging from -5 (minus five) to +10 (plus ten).    

.EXAMPLE
	Roll-AbilityCheck -Ability STR -Modifier 3
    	You rolled 16 on your strength check!
#>
[cmdletbinding()]    
	param(

    	[Parameter(Mandatory=$TRUE, ValueFromPipeline=$TRUE)]
    	[ValidateSet('STR','DEX','CON','INT','WIS','CHA')]
    	[string]
    	$ability,
    	[Parameter(Mandatory=$TRUE, ValueFromPipeline=$TRUE)]
    	[ValidateRange(-5,10)]
    	[int]
    	$modifier
     	)

	$abilityTable = @{
    	"STR" = "strength"
    	"DEX" = "dexterity"
    	"CON" = "constitution"
    	"INT" = "intelligence"
    	"WIS" = "wisdom"
    	"CHA" = "charisma"
	}
    
	[string]$abilityFullname = $abilityTable.item("$ability")

	[int]$abilityRoll = get-random -minimum 1 -maximum 21
    
	[int]$abilityCheck = $abilityRoll + $modifier

	Write-Host "You rolled $abilityCheck on your $abilityFullname check!" -foregroundcolor green

}

function Roll-ForDamage{

<#
.SYNOPSIS
	This function “rolls” one or more dice depending on the chosen attack weapon.

.DESCRIPTION
	Author: Orval Roller (@cysecgunz on the Twitterz)
	License: Open Gaming License v1.0 / GNU General Public License (GPL 3.0)
	Required Dependencies: None
	Optional Dependencies: None

.PARAMETER Weapon
	All available weapons are referenced in “weapons.csv.” Selecting the weapon will request the dice number and type from “weapons.csv.”    

.EXAMPLE
	Roll-Damage -Weapon Mace
    	Your mace did 4 bludgeoning damage!
#>

[cmdletbinding()]
    
	param(
   	 
    	[Parameter(Mandatory=$TRUE, ValueFromPipeline=$TRUE)]   	 
    	[ValidateSet('club','dagger','greatclub','handaxe','javelin','light-hammer','mace','quarterstaff','quaterstaff-versatile',`
                	'sickle','spear','light-crossbow','dart','shortbow','sling','battleaxe','battleaxe-versatile','flail','glaive',`
                	'greataxe','greatsword','halberd','lance','longsword','longsword-versatile','maul','morningstar','pike','rapier',`
                	'scimitar','shortsword','trident','war-pick','warhammer','warhammer-versatile','whip','blowgun','hand-crossbow',`
                	'heavy-crossbow','longbow')]
                	<#
                    	ValidateSet is a list of values that can be entered for Roll-Damage weapon parameter,
                    	this also provides tab-complete functionality to the cmdlet, as it will only display
                    	the weapons available for the cmdlet.
                	#>
    	[string]
    	$weapon,
        [Parameter(Mandatory=$TRUE, ValueFromPipeline=$TRUE)]
        [ValidateRange(-5,10)]
        [int]
        $modifier,
        [Parameter(Mandatory=$TRUE, ValueFromPipeline=$TRUE)]
        [ValidateRange(0,10)]
        [int]
        $proficiency
    	)

	[int]$Global:damage = $null #This line sets the Global variable damage to "null."

	<#
	This takes the list of weapons in CSV format and converts them (similar to pointing Import-CSV to a file). This approach
	was taken so the function is not reliant upon a CSV file.
	#>
    
	$weaponList = @"
        	weaponName,diceNumber,diceType,damageType
        	club,1,4,bludgeoning
        	dagger,1,4,piercing
        	greatclub,1,8,bludgeoning
        	handaxe,1,6,slashing
        	javelin,1,6,piercing
        	light-hammer,1,4,bludgeoning
        	mace,1,6,bludgeoning
        	quarterstaff,1,6,bludgeoning
        	quarterstaff-versatile,1,8,bludgeoning
        	sickle,1,4,slashing
        	spear,1,6,piercing
        	light-crossbow,1,8,piercing
        	dart,1,4,piercing
        	shortbow,1,6,piercing
        	sling,1,4,bludgeoning
        	battleaxe,1,8,slashing
        	battleaxe-versatile,1,10,slashing
        	flail,1,8,bludgeoning
        	glaive,1,10,slashing
        	greataxe,1,12,slashing
        	greatsword,2,6,slashing
        	halberd,1,10,slashing
        	lance,1,12,piercing
        	longsword,1,8,slashing
        	longsword-versatile,1,10,slashing
        	maul,2,6,bludgeoning
        	morningstar,1,8,piercing
        	pike,1,10,piercing
        	rapier,1,8,piercing
        	scimitar,1,6,slashing
        	shortsword,1,6,piercing
        	trident,1,6,piercing
        	war-pick,1,8,piercing
        	warhammer,1,8,bludgeoning
        	warhammer-versatile,1,10,bludgeoning
        	whip,1,4,slashing
        	blowgun,1,1,piercing
        	hand-crossbow,1,6,piercing
        	heavy-crossbow,1,10,piercing
        	longbow,1,8,piercing

"@ | ConvertFrom-CSV -delimiter ","

	[int]$diceNumber = $weaponList | Where-Object weaponName -eq $weapon | Select-Object -ExpandProperty diceNumber
    
	[int]$diceType = $weaponList | Where-Object weaponName -eq $weapon | Select-Object -ExpandProperty diceType
    
	$damageType = $weaponList | Where-Object weaponName -eq $weapon | Select-Object -ExpandProperty damageType
   	 
    	for ($i=1; $i -le $diceNumber; $i++) {
       	 
        	[int]$diceRoll = get-random -minimum 1 -maximum ($diceType + 1)
       	 
        	$damage = $damage + $diceRoll #This line adds the values from each dice roll in the loop.
       	 
        	}
            $damageTotal = ($damage) + ($modifier) + ($proficency)
       	 
	Write-Host "Your $weapon did $damageTotal $damageType damage!" -foregroundcolor green

}

function Roll-SavingThrow{
	<#
.SYNOPSIS
	This function “rolls” a d20 for a saving throw (Strength,Dexterity,Constitution,Intelligence,Wisdom,or Charisma) and adds the character's
	ability modifier. This is similar to an ability check.

.DESCRIPTION
	Author: Orval Roller (@cysecgunz on the Twitterz)
	License: Open Gaming License v1.0 / GNU General Public License (GPL 3.0)
	Required Dependencies: None
	Optional Dependencies: None

.PARAMETER Ability
	Abilities are STR (Strength), DEX (Dexterity), CON (Constitution), INT (Intelligence), WIS (Wisdom), and CHA (Charisma).

.PARAMETER Modifier
	Ability modifiers are an integer ranging from -5 (minus five) to +10 (plus ten).    

.EXAMPLE
	Roll-AbilityCheck -Ability STR -Modifier 3
    	You rolled 16 on your strength check!
#>
[cmdletbinding()]    
	param(

    	[Parameter(Mandatory=$TRUE, ValueFromPipeline=$TRUE)]
    	[ValidateSet('STR','DEX','CON','INT','WIS','CHA')]
    	[string]
    	$ability,
    	[Parameter(Mandatory=$TRUE, ValueFromPipeline=$TRUE)]
    	[ValidateRange(-5,10)]
    	[int]
    	$modifier
     	)

	$abilityTable = @{
    	"STR" = "strength"
    	"DEX" = "dexterity"
    	"CON" = "constitution"
    	"INT" = "intelligence"
    	"WIS" = "wisdom"
    	"CHA" = "charisma"
	}    
	[string]$abilityFullname = $abilityTable.item("$ability")

	[int]$abilityRoll = get-random -minimum 1 -maximum 21
    
	[int]$savingThrow = $abilityRoll + $modifier

	Write-Host "You rolled $savingThrow on your $abilityFullname saving throw!" -foregroundcolor green
}

function Roll-DeathSave {
	<#
.SYNOPSIS
	This function “rolls” a d20 for a Death Save. This is a special kind of saving throw used when a character has 0 (zero) hit points remaining. If
	the player rolls a natural 1 (one), a "Critical Failure," this constitutes 2 (two) death save failures, 3 (three) death save failures and your
	character dies. If a player rolls a natural 20 (twenty), a "Critical Success," the player's character regains 1 (one) hit point. If the player rolls
	3 (three) successful Death Saves, the player becomes stable (Death Save successes/failures are reset when a character is stable or regains hit
	points). The successes/failures do not need to be consecutive, keep track of both until you collect three of a kind. In 5th Edition
	Dungeons & Dragons, a successful Death Save is 10 (ten) or higher. Additionally, if you take any damage at 0 (zero) hit points you suffer a
	Death Save failure. If the damage is from a critical hit, the player's character suffers 2 (two) Death Save failures. If the damage equals or exeeds
	the character's hit point max, the player's character suffers instant death.  

.DESCRIPTION
	Author: Orval Roller (@cysecgunz on the Twitterz)
	License: Open Gaming License v1.0 / GNU General Public License (GPL 3.0)
	Required Dependencies: None
	Optional Dependencies: None

.EXAMPLE
	Roll-DeathSave
    	You rolled a 10. Death Save success!
#>
	$deathSave = get-random -minimum 1 -maximum 21
    	if($deathSave -eq 20){
        	Write-Host "You rolled a Natural $deathSave for your Deatch Save! Regain 1 Hit Point!" -foregroundcolor green
    	}
    	elseif($deathSave -eq 1){
        	Write-Host "You rolled a Natural $deathSave for your Death Save! That's two Death Save failures for you pal!" -foregroundcolor red
    	}
    	elseif($deathSave -ge 10){
        	Write-Host "You rolled $deathSave for your Death Save! Death Save success! Don't count your chickens before they hatch!" -foregroundcolor green
    	}
    	else
    	{
        	Write-Host "You rolled $deathSave for your Death Save! Death Save failure! Sucks to suck!" -foregroundcolor yellow    
    	}
}

function Roll-ToAttack{
 <#
.SYNOPSIS
	This function “rolls” a d20 for an attack/combat and compares it to the Armor Class (AC) of the target. Modifier and proficiency are also added if necessary. If the d20 lands on 1 (one), "Critical Miss," no modifications
	or proficiency are added as this is miss regardless of the target's AC. If the d20 lands on 20 (twenty), "Critical Hit," no modifications or proficiency
	are added as this is a hit regardless of the target's AC.Tie goes to the attacker.

.DESCRIPTION
	Author: Orval Roller (@cysecgunz on the Twitterz)
	License: Open Gaming License v1.0 / GNU General Public License (GPL 3.0)
	Required Dependencies: None
	Optional Dependencies: None

.PARAMETER Target
	Used to determine the armor class of the target.

.PARAMETER Modifier
	Ability modifiers are an integer ranging from -5 (minus five) to +10 (plus ten)

.PARAMETER Proficiency
	Proficiency in an attack.

.EXAMPLE
	Roll-ToAttack -Target Kobold -Modifier 2 -Proficency 3
    	You rolled 9 against Kobold (AC 12)! Miss!
#>
[cmdletbinding()]    
	param(
   	 
    	[Parameter(Mandatory=$TRUE, ValueFromPipeline=$TRUE)]
    	[ValidateSet('Aarakocra','Abjurer','Aboleth','Abominable-Yeti','Acolyte','Air-Elemental','Alhoon','Allosaurus','Androsphinx','Animated-Armor',`
        'Ankheg','Ankylosaurus','Annis-Hag','Ape','Apprentice-Wizard','Arcanaloth','Archdruid','Archer','Archmage','Assassin','Auroch','Awakened-Shrub',`
        'Awakened-Tree','Axe-Beak','Azer','Babau','Baboon','Badger','Balor','Banderhobb','Bandit','Bandit-Captain','Banshee','Barbed-Devil','Bard',`
        'Barghest','Barlgura','Basilisk','Bat','Bearded-Devil','Behir','Beholder','Beholder-Zombie','Berserker','Bheur-Hag','Black-Bear',`
        'Adult-Black-Dragon','Ancient-Black-Dragon','Wyrmling-Black-Dragon','Young-Black-Dragon','Black-Pudding','Blackguard','Blink-Dog','Blood-Hawk',`
        'Adult-Blue-Dragon','Ancient-Blue-Dragon','Wyrmling-Blue-Dragon','Young-Blue-Dragon','Blue-Slaad','Boar','Bodak','Boggle','Bone-Devil',`
        'Bone-Naga','Adult-Brass-Dragon','Ancient-Brass-Dragon','Wyrmling-Brass-Dragon','Young-Brass-Dragon','Brontosaurus','Adult-Bronze-Dragon',`
        'Ancient-Bronze-Dragon','Wyrmling-Bronze-Dragon','Young-Bronze-Dragon','Brown-Bear','Bugbear','Bugbear-Chief','Bulette','Bullywug','Cambion',`
        'Camel','Carrion-Crawler','Cat','Catoblepas','Cave-Fisher','Centaur','Chain-Devil','Champion','Chasme','Chimera','Chitine','Choldrith','Chuul',`
        'Clay-Golem','Cloaker','Cloud-Giant','Cloud-Giant-Smiling-One','Cockatrice','Commoner','Conjurer','Constrictor-Snake','Adult-Copper-Dragon',`
        'Ancient-Copper-Dragon','Wyrmling-Copper-Dragon','Young-Copper-Dragon','Couatl','Cow','Crab','Cranium-Rat','Crawling-Claw','Crocodile',`
        'Cult-Fanatic','Cultist','Cyclops','Dao','Darkling','Darkmantle','Darling-Elder','Death-Dog','Death-Kiss','Death-Knight','Death-Slaad',`
        'Death-Tyrant','Deep-Scion','Deer','Deinonychus','Demilich','Deva','Devourer','Dimetrodon','Dire-Wolf','Displacer-Beast','Diviner','Djinni',`
        'Dolphin','Doppelganger','Dracolich','Draegloth','Draft-Horse','Dragon-Turtle','Dretch','Drider','Drow','Drow-Elite-Warrior','Drow-Mage',`
        'Drow-Priestess-of-Lolth','Druid','Dryad','Duergar','Duodrone','Dust-Mephit','Eagle','Earth-Elemental','Efreeti','Elder-Brain','Elephant','Elk',`
    	'Empyrean','Enchanter','Erinyes','Ettercap','Ettin','Evoker','Faerie-Dragon','Fire-Elemental','Fire-Giant','Fire-Giant-Dreadnought',`
        'Fire-Snake','Firenewt-Warlock-of-Imix','Firenewt-Warrior','Flail-Snail','Flameskull','Flesh-Golem','Flind','Flumph','Flying-Snake',`
        'Flying-Sword','Fomorian','Frog','Froghemoth','Frost-Giant','Frost-Giant-Everlasting-One','Galeb-Duhr','Gargoyle','Gas-Spore','Gauth','Gazer',`
        'Gelatinous-Cube','Ghast','Ghost','Ghoul','Giant-Ape','Giant-Badger','Giant-Bat','Giant-Boar','Giant-Centipede','Giant-Constrictor-Snake',`
    	'Giant-Crab','Giant-Crocodile','Giant-Eagle','Giant-Elk','Giant-Fire-Beetle','Giant-Frog','Giant-Goat','Giant-Hyena','Giant-Lizard',`
        'Giant-Octopus','Giant-Owl','Giant-Poisonous-Snake','Giant-Rat','Giant-Scorpion','Giant-Sea-Horse','Giant-Shark','Giant-Spider','Giant-Strider',`
        'Giant-Toad','Giant-Vulture','Giant-Wasp','Giant-Weasel','Giant-Wolf-Spider','Gibbering-Mouther','Girallon','Githyanki-Knight',`
        'Githyanki-Warrior','Githzerai-Monk','Githzerai-Zerth','Glabrezu','Gladiator','Gnoll','Gnoll-Fang-of-Yeenoghu','Gnoll-Flesh-Gnawer',`
        'Gnoll-Hunter','Gnoll-Pack-Lord','Gnoll-Witherling','Deep-Gnome','Goat','Goblin','Goblin-Boss','Adult-Gold-Dragon','Ancient-Gold-Dragon',`
        'Wyrmling-Gold-Dragon','Young-Gold-Dragon','Gorgon','Goristro','Gray-Ooze','Gray-Slaad','Adult-Green-Dragon','Ancient-Green-Dragon',`
        'Wyrmling-Green-Dragon','Young-Green-Dragon','Green-Hag','Green-Slaad','Grell','Grick','Grick-Alpha','Griffon','Grimlock','Grung',`
        'Grung-Elite-Warrior','Grung-Wildling','Guard','Guard-Drake','Guardian-Naga','Gynosphinx','Hadrosaurus','Half-Ogre','Half-Red-Dragon-Veteran',`
        'Harpy','Hawk','Hell-Hound','Helmed-Horror','Hezrou','Hill-Giant','Hippogriff','Hobgoblin','Hobgoblin-Captain','Hobgoblin-Devastator',`
        'Hobgoblin-Iron-Shadow','Hobgoblin-Warlord','Homunculus','Hook-Horror','Horned-Devil','Hunter-Shark','Hydra','Hyena','Ice-Devil','Ice-Mephit',`
        'Illusionist','Imp','Intellect-Devourer','Invisible Stalker','Iron-Golem','Jackal','Jackalwere','Kenku','Killer-Whale','Ki-Rin','Knight',`
        'Kobold','Kobold-Dragon-Dragonshield','Kobold-Inventor','Kobold-Scale-Sorcerer','Korred','Kraken','Kraken-Priest','Kuo-Toa','Kuo-Toa-Archpriest',`
    	'Kuo-Toa-Whip','Lamia','Lemure','Leucrotta','Lich','Lion','Lizard','Lizard-King','Lizard-Queen','Lizardfolk','Lizardfolk-Shaman','Mage',`
        'Magma-Mephit','Magmin','Mammoth','Manes','Manticore','Marid','Marilith','Martial-Arts-Adept','Master-Thief','Mastiff','Maw-Demon','Medusa',`
        'Meenlock','Merfolk','Merrow','Mezzoloth','Mimic','Mind-Flayer','Mind-Flayer-Lich','Mindwitness','Minotaur','Minotaur-Skeleton','Monodrone',`
        'Morkoth','Mouth-of-Grolantor','Mud-Mephit','Mule','Mummy','Mummy-Lord','Adult-Myconid','Myconid-Sovereign','Myconid-Sprout','Nalfeshnee',`
        'Necromancer','Needle-Blight','Neogi','Neogi-Hatchling','Neogi-Master','Neothelid','Night-Hag','Nightmare','Nilbog','Noble','Nothic','Nycaloth',`
        'Ochre-Jelly','Octopus','Ogre','Ogre-Zombie','Oni','Orc','Orc-Blade-of-Ilneval','Orc-Claw-of-Luthic','Orc-Eye-of-Gruumsh','Orc-Hand-of-Yurtrus',`
        'Orc-Nurtured-One-of-Yurtrus','Orc-Red-Fang-of-Shargaas','Orc-War-Chief','Orog','Otyugh','Owl','Owlbear','Ox','Panther','Pegasus','Pentadrone',`
        'Peryton','Phase-Spider','Piercer','Pit-Fiend','Pixie','Planetar','Plesiosaurus','Poisonous-Snake','Polar-Bear','Pony','Priest','Pseudodragon',`
        'Pteranodon','Purple-Worm','Quadrone','Quaggoth','Quaggoth-Spore-Servant','Quasit','Quetzalcoatlus','Quickling','Quipper','Rakshasa','Rat',`
    	'Raven','Adult-Red-Dragon','Ancient-Red-Dragon','Wyrmling-Red-Dragon','Young-Red-Dragon','Red-Slaad','Redcap','Reef-Shark','Remorhaz','Revenant',`
        'Rhinoceros','Riding-Horse','Roc','Roper','Rothe','Rug-of-Smothering','Rust-Monster','Saber-Toothed-Tiger','Sahuagin','Sahuagin-Baron',`
        'Sahuagin-Priestess','Salamander','Satyr','Scarecrow','Scorpion','Scout','Sea-Hag','Sea-Horse','Sea-Spawn','Shadow','Shadow-Demon',`
        'Shadow-Dragon','Shadow-Mastiff','Shambling-Mound','Shield-Guardian','Shoosuva','Shrieker','Adult-Silver-Dragon','Ancient-Silver-Dragon',`
    	'Wyrmling-Silver-Dragon','Young-Silver-Dragon','Skeleton','Slaad-Tadpole','Slithering-Tracker','Smoke-Mephit','Solar','Spawn-of-Kyuss',`
        'Spectator','Specter','Spider','Spined-Devil','Spirit-Naga','Sprite','Spy','Steam-Mephit','Stegosaurus','Stench-kow','Stirge','Stone-Giant',`
        'Stone-Giant-Dreamwalker','Stone-Golem','Storm-Giant','Storm-Giant-Quintessent','Succubus','Incubus','Swarm-of-Bats','Swarm-of-Cranium-Rats',`
        'Swarm-of-Insects','Swarm-of-Poisonous-Snakes','Swarm-of-Quippers','Swarm-of-Rats','Swarm-of-Ravens','Swarm-of-Rot-Grubs','Swashbuckler',`
        'Tanarukk','Tarrasque','Thorny','Thri-Kreen','Thug','Tiger','Tlincalli','Transmuter','Trapper','Treant','Tribal-Warrior','Triceratops',`
        'Tridrone','Troglodyte','Troll','Twig-Blight','Tyrannosaurus-Rex','Ulitharid','Ultroloth','Umber-Hulk','Unicorn','Vampire','Vampire-Spawn',`
        'Vargouille','Vegepygmy','Vegepygmy-Chief','Velociraptor','Veteran','Vine-Blight','Violet-Fungus','Vrock','Vulture','War-Priest','Warhorse',`
        'Warhorse-Skeleton','Warlock-of-the-Archfey','Warlock-of-the-Fiend','Warlock-of-the-Great-Old-One','Warlord','Water-Elemental','Water-Weird',`
        'Weasel','Werebear','Wereboar','Wererat','Weretiger','Werewolf','Adult-White-Dragon','Ancient-White-Dragon','Wyrmling-White-Dragon',`
        'Young-White-Dragon','Wight','Will-O-Wisp','Winged-Kobold','Winter-Wolf','Wolf','Wood-Woad','Worg','Wraith','Wyvern','Xorn','Xvart',`
        'Xvart-Warlock-of-Raxivort','Yeth-Hound','Yeti','Yochlol','Young-Remorhaz','Yuan-Ti-Abomination','Yuan-Ti-Anathema','Yuan-Ti-Broodguard',`
        'Yuan-Ti Malison','Yuan-Ti-Mind-Whisperer','Yuan-Ti-Nightmare-Speaker','Yuan-Ti-Pit-Master','Yuan-Ti-Pureblood','Zombie')]
    	[string]
    	$monster,
    	[Parameter(Mandatory=$TRUE, ValueFromPipeline=$TRUE)]
    	[ValidateRange(-5,10)]
    	[int]
    	$modifier,
    	[Parameter(Mandatory=$TRUE, ValueFromPipeline=$TRUE)]
    	[ValidateRange(0,10)]
    	[int]
    	$proficiency
     	)

	$targetList = @"
    	monsterName,armorClass
    	Aarakocra,12
    	Abjurer,12
    	Aboleth,17
    	Abominable-Yeti,15
    	Acolyte,10
    	Air-Elemental,15
    	Alhoon,15
    	Allosaurus,13
    	Androsphinx,17
    	Animated-Armor,18
    	Ankheg,14
    	Ankylosaurus,15
    	Annis-Hag,17
    	Ape,12
    	Apprentice-Wizard,10
    	Arcanaloth,17
    	Archdruid,19
    	Archer,16
    	Archmage,12
    	Assassin,15
    	Auroch,11
    	Awakened-Shrub,9
    	Awakened-Tree,13
    	Axe-Beak,11
    	Azer,17
    	Babau,16
    	Baboon,12
    	Badger,10
    	Balor,19
    	Banderhobb,15
    	Bandit,12
    	Bandit-Captain,15
    	Banshee,12
    	Barbed-Devil,15
    	Bard,15
    	Barghest,17
    	Barlgura,15
    	Basilisk,15
    	Bat,12
    	Bearded-Devil,13
    	Behir,17
    	Beholder,18
    	Beholder-Zombie,15
    	Berserker,13
    	Bheur-Hag,17
    	Black-Bear,11
    	Adult-Black-Dragon,19
    	Ancient-Black-Dragon,22
    	Wyrmling-Black-Dragon,17
    	Young-Black-Dragon,18
    	Black-Pudding,7
    	Blackguard,18
    	Blink-Dog,13
    	Blood-Hawk,12
    	Adult-Blue-Dragon,19
    	Ancient-Blue-Dragon,22
    	Wyrmling-Blue-Dragon,17
    	Young-Blue-Dragon,18
    	Blue-Slaad,15
    	Boar,11
    	Bodak,15
    	Boggle,14
    	Bone-Devil,19
    	Bone-Naga,15
    	Adult-Brass-Dragon,18
    	Ancient-Brass-Dragon,20
    	Wyrmling-Brass-Dragon,16
    	Young-Brass-Dragon,17
    	Brontosaurus,15
    	Adult-Bronze-Dragon,19
    	Ancient-Bronze-Dragon,22
    	Wyrmling-Bronze-Dragon,17
    	Young-Bronze-Dragon,18
    	Brown-Bear,11
    	Bugbear,16
    	Bugbear-Chief,17
    	Bulette,17
    	Bullywug,15
    	Cambion,19
    	Camel,9
    	Carrion-Crawler,13
    	Cat,12
    	Catoblepas,14
    	Cave-Fisher,16
    	Centaur,12
    	Chain-Devil,16
    	Champion,18
    	Chasme,15
    	Chimera,14
    	Chitine,14
    	Choldrith,15
    	Chuul,16
    	Clay-Golem,14
    	Cloaker,14
    	Cloud-Giant,14
    	Cloud-Giant-Smiling-One,15
    	Cockatrice,11
    	Commoner,10
    	Conjurer,12
    	Constrictor-Snake,12
    	Adult-Copper-Dragon,18
    	Ancient-Copper-Dragon,21
    	Wyrmling-Copper-Dragon,16
    	Young-Copper-Dragon,17
    	Couatl,19
    	Cow,10
    	Crab,11
    	Cranium-Rat,12
    	Crawling-Claw,12
    	Crocodile,12
    	Cult-Fanatic,13
    	Cultist,12
    	Cyclops,14
    	Dao,18
    	Darkling,14
    	Darkmantle,11
    	Darling-Elder,15
    	Death-Dog,12
    	Death-Kiss,16
    	Death-Knight,20
    	Death-Slaad,18
    	Death-Tyrant,19
    	Deep-Scion,11
    	Deer,13
    	Deinonychus,13
    	Demilich,20
    	Deva,17
    	Devourer,16
    	Dimetrodon,12
    	Dire-Wolf,14
    	Displacer-Beast,13
    	Diviner,12
    	Djinni,17
    	Dolphin,12
    	Doppelganger,14
    	Dracolich,19
    	Draegloth,15
    	Draft-Horse,10
    	Dragon-Turtle,20
    	Dretch,11
    	Drider,19
    	Drow,15
    	Drow-Elite-Warrior,18
    	Drow-Mage,12
    	Drow-Priestess-of-Lolth,16
    	Druid,11
    	Dryad,11
    	Duergar,16
    	Duodrone,15
    	Dust-Mephit,12
    	Eagle,12
    	Earth-Elemental,17
    	Efreeti,17
    	Elder-Brain,10
    	Elephant,12
    	Elk,10
    	Empyrean,22
    	Enchanter,12
    	Erinyes,18
    	Ettercap,13
    	Ettin,12
    	Evoker,12
    	Faerie-Dragon,15
    	Fire-Elemental,13
    	Fire-Giant,18
    	Fire-Giant-Dreadnought,21
    	Fire-Snake,14
    	Firenewt-Warlock-of-Imix,10
    	Firenewt-Warrior,16
    	Flail-Snail,16
    	Flameskull,13
    	Flesh-Golem,9
    	Flind,16
    	Flumph,12
    	Flying-Snake,14
    	Flying-Sword,17
    	Fomorian,14
    	Frog,11
    	Froghemoth,14
    	Frost-Giant,15
    	Frost-Giant-Everlasting-One,15
    	Galeb-Duhr,16
    	Gargoyle,15
    	Gas-Spore,5
    	Gauth,15
    	Gazer,13
    	Gelatinous-Cube,6
    	Ghast,13
    	Ghost,11
    	Ghoul,12
    	Giant-Ape,12
    	Giant-Badger,10
    	Giant-Bat,13
    	Giant-Boar,12
    	Giant-Centipede,13
    	Giant-Constrictor-Snake,12
    	Giant-Crab,15
    	Giant-Crocodile,14
    	Giant-Eagle,13
    	Giant-Elk,14
    	Giant-Fire-Beetle,13
    	Giant-Frog,11
    	Giant-Goat,11
    	Giant-Hyena,12
    	Giant-Lizard,12
    	Giant-Octopus,11
    	Giant-Owl,12
    	Giant-Poisonous-Snake,14
    	Giant-Rat,12
    	Giant-Scorpion,15
    	Giant-Sea-Horse,13
    	Giant-Shark,13
    	Giant-Spider,14
    	Giant-Strider,14
    	Giant-Toad,11
    	Giant-Vulture,10
    	Giant-Wasp,12
    	Giant-Weasel,13
    	Giant-Wolf-Spider,13
    	Gibbering-Mouther,9
    	Girallon,13
    	Githyanki-Knight,18
    	Githyanki-Warrior,17
    	Githzerai-Monk,14
    	Githzerai-Zerth,17
    	Glabrezu,17
    	Gladiator,16
    	Gnoll,15
    	Gnoll-Fang-of-Yeenoghu,14
    	Gnoll-Flesh-Gnawer,14
    	Gnoll-Hunter,13
    	Gnoll-Pack-Lord,15
    	Gnoll-Witherling,12
    	Deep-Gnome,15
    	Goat,10
    	Goblin,15
    	Goblin-Boss,17
    	Adult-Gold-Dragon,19
    	Ancient-Gold-Dragon,22
    	Wyrmling-Gold-Dragon,17
    	Young-Gold-Dragon,18
    	Gorgon,19
    	Goristro,19
    	Gray-Ooze,8
    	Gray-Slaad,18
    	Adult-Green-Dragon,19
    	Ancient-Green-Dragon,21
    	Wyrmling-Green-Dragon,17
    	Young-Green-Dragon,18
    	Green-Hag,17
    	Green-Slaad,16
    	Grell,12
    	Grick,14
    	Grick-Alpha,18
    	Griffon,12
    	Grimlock,11
    	Grung,12
    	Grung-Elite-Warrior,13
    	Grung-Wildling,13
    	Guard,16
    	Guard-Drake,14
    	Guardian-Naga,18
    	Gynosphinx,17
    	Hadrosaurus,11
    	Half-Ogre,12
    	Half-Red-Dragon-Veteran,18
    	Harpy,11
    	Hawk,13
    	Hell-Hound,15
    	Helmed-Horror,20
    	Hezrou,16
    	Hill-Giant,13
    	Hippogriff,11
    	Hobgoblin,18
    	Hobgoblin-Captain,17
    	Hobgoblin-Devastator,13
    	Hobgoblin-Iron-Shadow,15
    	Hobgoblin-Warlord,20
    	Homunculus,13
    	Hook-Horror,15
    	Horned-Devil,18
    	Hunter-Shark,12
    	Hydra,15
    	Hyena,11
    	Ice-Devil,18
    	Ice-Mephit,11
    	Illusionist,12
    	Imp,13
    	Intellect-Devourer,12
    	Invisible Stalker,14
    	Iron-Golem,20
    	Jackal,12
    	Jackalwere,12
    	Kenku,13
    	Killer-Whale,12
    	Ki-Rin,20
    	Knight,18
    	Kobold,12
    	Kobold-Dragon-Dragonshield,15
    	Kobold-Inventor,12
    	Kobold-Scale-Sorcerer,15
    	Korred,17
    	Kraken,18
    	Kraken-Priest,10
    	Kuo-Toa,13
    	Kuo-Toa-Archpriest,13
    	Kuo-Toa-Whip,11
    	Lamia,13
    	Lemure,7
    	Leucrotta,14
    	Lich,17
    	Lion,12
    	Lizard,10
    	Lizard-King,15
    	Lizard-Queen,15
    	Lizardfolk,15
    	Lizardfolk-Shaman,13
    	Mage,12
    	Magma-Mephit,11
    	Magmin,14
    	Mammoth,13
    	Manes,9
    	Manticore,14
    	Marid,17
    	Marilith,18
    	Martial-Arts-Adept,16
    	Master-Thief,16
    	Mastiff,12
    	Maw-Demon,13
    	Medusa,15
    	Meenlock,15
    	Merfolk,11
    	Merrow,13
    	Mezzoloth,18
    	Mimic,12
    	Mind-Flayer,15
    	Mind-Flayer-Lich,17
    	Mindwitness,15
    	Minotaur,14
    	Minotaur-Skeleton,12
    	Monodrone,15
    	Morkoth,17
    	Mouth-of-Grolantor,14
    	Mud-Mephit,11
    	Mule,10
    	Mummy,11
    	Mummy-Lord,17
    	Adult-Myconid,12
    	Myconid-Sovereign,13
    	Myconid-Sprout,10
    	Nalfeshnee,18
    	Necromancer,12
    	Needle-Blight,12
    	Neogi,15
    	Neogi-Hatchling,11
    	Neogi-Master,15
    	Neothelid,16
    	Night-Hag,17
    	Nightmare,13
    	Nilbog,13
    	Noble,15
    	Nothic,15
    	Nycaloth,18
    	Ochre-Jelly,8
    	Octopus,12
    	Ogre,11
    	Ogre-Zombie,8
    	Oni,16
    	Orc,13
    	Orc-Blade-of-Ilneval,18
    	Orc-Claw-of-Luthic,14
    	Orc-Eye-of-Gruumsh,16
    	Orc-Hand-of-Yurtrus,12
    	Orc-Nurtured-One-of-Yurtrus,9
    	Orc-Red-Fang-of-Shargaas,15
    	Orc-War-Chief,16
    	Orog,18
    	Otyugh,14
    	Owl,11
    	Owlbear,13
    	Ox,10
    	Panther,12
    	Pegasus,12
    	Pentadrone,16
    	Peryton,13
    	Phase-Spider,13
    	Piercer,15
    	Pit-Fiend,19
    	Pixie,15
    	Planetar,19
    	Plesiosaurus,13
    	Poisonous-Snake,13
    	Polar-Bear,12
    	Pony,10
    	Priest,13
    	Pseudodragon,13
    	Pteranodon,13
    	Purple-Worm,18
    	Quadrone,16
    	Quaggoth,13
    	Quaggoth-Spore-Servant,13
    	Quasit,13
    	Quetzalcoatlus,13
    	Quickling,16
    	Quipper,13
    	Rakshasa,16
    	Rat,10
    	Raven,12
    	Adult-Red-Dragon,19
    	Ancient-Red-Dragon,22
    	Wyrmling-Red-Dragon,17
    	Young-Red-Dragon,18
    	Red-Slaad,14
    	Redcap,13
    	Reef-Shark,12
    	Remorhaz,17
    	Revenant,13
    	Rhinoceros,11
    	Riding-Horse,10
    	Roc,15
    	Roper,20
    	Rothe,10
    	Rug-of-Smothering,12
    	Rust-Monster,14
    	Saber-Toothed-Tiger,12
    	Sahuagin,12
    	Sahuagin-Baron,16
    	Sahuagin-Priestess,12
    	Salamander,15
    	Satyr,14
    	Scarecrow,11
    	Scorpion,11
    	Scout,13
    	Sea-Hag,14
    	Sea-Horse,11
    	Sea-Spawn,11
    	Shadow,12
    	Shadow-Demon,13
    	Shadow-Dragon,18
    	Shadow-Mastiff,12
    	Shambling-Mound,15
    	Shield-Guardian,17
    	Shoosuva,14
    	Shrieker,5
    	Adult-Silver-Dragon,19
    	Ancient-Silver-Dragon,22
     	Wyrmling-Silver-Dragon,17
    	Young-Silver-Dragon,18
    	Skeleton,13
    	Slaad-Tadpole,12
    	Slithering-Tracker,14
    	Smoke-Mephit,12
    	Solar,21
    	Spawn-of-Kyuss,10
    	Spectator,14
    	Specter,12
    	Spider,12
    	Spined-Devil,15
    	Spirit-Naga,15
    	Sprite,15
    	Spy,12
    	Steam-Mephit,10
    	Stegosaurus,13
    	Stench-kow,10
    	Stirge,14
    	Stone-Giant,17
    	Stone-Giant-Dreamwalker,18
    	Stone-Golem,17
    	Storm-Giant,16
    	Storm-Giant-Quintessent,12
    	Succubus,15
        Incubus,15
    	Swarm-of-Bats,12
    	Swarm-of-Cranium-Rats,12
    	Swarm-of-Insects,12
    	Swarm-of-Poisonous-Snakes,14
    	Swarm-of-Quippers,13
    	Swarm-of-Rats,10
    	Swarm-of-Ravens,12
    	Swarm-of-Rot-Grubs,8
    	Swashbuckler,17
    	Tanarukk,14
    	Tarrasque,25
    	Thorny,14
    	Thri-Kreen,15
    	Thug,11
    	Tiger,12
    	Tlincalli,15
    	Transmuter,12
    	Trapper,13
    	Treant,16
    	Tribal-Warrior,12
    	Triceratops,13
    	Tridrone,15
    	Troglodyte,11
    	Troll,15
    	Twig-Blight,13
    	Tyrannosaurus-Rex,13
    	Ulitharid,15
    	Ultroloth,19
    	Umber-Hulk,18
    	Unicorn,12
    	Vampire,16
    	Vampire-Spawn,15
    	Vargouille,12
    	Vegepygmy,13
    	Vegepygmy-Chief,14
    	Velociraptor,13
    	Veteran,17
    	Vine-Blight,12
    	Violet-Fungus,5
    	Vrock,15
    	Vulture,10
    	War-Priest,18
    	Warhorse,11
    	Warhorse-Skeleton,13
    	Warlock-of-the-Archfey,11
    	Warlock-of-the-Fiend,12
    	Warlock-of-the-Great-Old-One,12
    	Warlord,18
    	Water-Elemental,14
    	Water-Weird,13
    	Weasel,13
    	Werebear,11
    	Wereboar,11
    	Wererat,12
    	Weretiger,12
    	Werewolf,12
    	Adult-White-Dragon,18
    	Ancient-White-Dragon,20
    	Wyrmling-White-Dragon,16
    	Young-White-Dragon,14
    	Wight,14
    	Will-O-Wisp,19
    	Winged-Kobold,13
    	Winter-Wolf,13
    	Wolf,13
    	Wood-Woad,18
    	Worg,13
    	Wraith,13
    	Wyvern,13
    	Xorn,19
    	Xvart,13
    	Xvart-Warlock-of-Raxivort,12
    	Yeth-Hound,14
    	Yeti,12
    	Yochlol,15
    	Young-Remorhaz,14
    	Yuan-Ti-Abomination,15
    	Yuan-Ti-Anathema,16
    	Yuan-Ti-Broodguard,14
    	Yuan-Ti Malison,12
    	Yuan-Ti-Mind-Whisperer,14
    	Yuan-Ti-Nightmare-Speaker,14
    	Yuan-Ti-Pit-Master,14
    	Yuan-Ti-Pureblood,11
    	Zombie,8
"@ | ConvertFrom-CSV -delimiter ","    
	[int]$armorClass = $targetList | Where-Object monsterName -eq $monster | Select-Object -ExpandProperty armorClass
	[int]$attackRoll = (get-random -Minimum 1 -Maximum 21)
	[int]$attackTotal = ($attackRoll) + ($proficiency) + ($modifier)
    	if($attackRoll -eq 1){
        	Write-Host "You rolled $attackRoll! Critical Miss!" -ForegroundColor Red
    	}
    	elseif($attackRoll -eq 20){
        	Write-Host "You rolled $attackRoll! Critical Hit!" -ForegroundColor Green
    	}
    	else
    	{
        	if($attackTotal -ge $armorClass){
            	Write-Host "You rolled $attackTotal against $monster (AC $armorClass)! Hit!" -ForegroundColor Green
            	}
        	else
            	{
            	Write-Host "You rolled $attackTotal against $monster (AC $armorClass)! Miss!" -ForegroundColor Red
            	}
    	}
}
