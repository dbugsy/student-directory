
	
rawnameslist = %Q{Steve Musgrave
steve.musgrave@outlook.com
stephanmusgrave

Sroop Sunar
sroopsunar@hotmail.com
sroopsunar

Colin Marshall
colinbfmarshall@gmail.com

Josh Fail-Brown
josh@prrrfectfit.com

Louise Lai
louiselai88@gmail.com
louiselai88

Robin Doble
robindoble@gmail.com
robindoble

Alex Wong
aw12409@my.bristol.ac.uk
mavrm1

Scott Dimmock
scott123454@hotmail.com
scot123454

Muhanad Al-Rubaiee
muhanad40@gmail.com
m.rabbie

Shelley Hope
shelley894@btinternet.com

Will Hall
willhall88@hotmail.com
willhall88

Oliver Delevingne
odelevingne@gmail.com
odelevingne

Nico
nico@nicosaueressig.de
nico.saueressig

Apostolis
appostoliis@gmail.com
apostoliis

Stefania
stafaniaf.cardenas@gmail.com
jennifer_jentle

Robert Leon
llexi@hotmail.com
llexi.leon

Emma Williams
emma_williams1@hotmail.co.uk

Joey Wolf
halfdark000@gmail.com
urbanwolf_uk
@MisterJWolf (twitter)

Julie Walker
julieannwalker@hotmail.com}

def parser(list)
	nameslist = list.split("\n\n")
	parsedList =[]
	nameslist.each do |str|
		x = str.split("\n")
		parsedList.push(x[0])	
	end
	parsedList
end

print parser(rawnameslist)


