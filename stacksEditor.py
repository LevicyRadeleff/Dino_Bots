import sys
import os
from pathlib import Path
import csv

tempText = open('tempFile.txt', 'r+')
content = tempText.readlines()
tempText.close()

#assign the dino text file holding all dinos to the dinoContent var
fp = open('dino.csv', 'r')
#Parse this into dinoCostList & dinoContent (dinoCostList is zipped file with dino / cost), dinoContent is just the dinos
file = csv.DictReader(fp)

dinoContent = []
dinoCost = []
dinoType = []
dinoCreation = []

for col in file:
	dinoContent.append(col['dino'])
	dinoCost.append(col['cost'])
	dinoType.append(col['type'])
	dinoCreation.append(col['creation'])

fp.close()

#zip into dinoCostList
dinoCostList = list(zip(dinoContent, dinoCost))

#assign userID & total numver of dinos
userID = int(content[0])

#filePath = Path('userInfo.txt')
fp = open('userInfo.txt', 'r+')
#filePath = Path('output.txt')
content = fp.readlines() #content for parsing into output.txt
fp.close() ##No longer need file open now

output = open('output.txt', 'w')

content = list(map(lambda x: x.replace("[",''), content)) #get rid of all brackets
content = list(map(lambda x: x.replace("]",''), content))
content = list(map(lambda x: x.replace(",",''), content))
content = list(map(lambda x: x.replace(":female_sign:", "female"), content)) #replace gender signs with genders
content = list(map(lambda x: x.replace(":male_sign:", "male"), content))
content = list(map(lambda x: x[:-1], content)) #get rid of training \n

dinoValueList = list(map(lambda x: int(x[-3:]) if x[-3:].isdigit() else int(x[-2:] if x[-1:].isdigit() else 1), content)) #save owned numbers to a list
dinoValueList = list(map(lambda x: -1 * int(x), dinoValueList))

content = list(map(lambda x: ''.join([i for i in x if not i.isdigit()]), content)) #get rid of extra numbers
content = list(map(lambda x: x.strip(), content)) #get rid of trailing and leading spaces

dinoContent = list(filter(lambda x: x not in content, dinoContent))

zippedFile = list(zip(content, dinoValueList))

output.write("!addbal <@" + str(userID) + "> 200000" + '\n')

for item in zippedFile:
	if item[1] != 0:
		output.write("!adddino <@" + str(userID) + "> " + item[0] + " " + str(item[1]) + '\n')

output.close()

#Pass this back to autoIT so it can run through it in a for loop and then delete the output.txt
