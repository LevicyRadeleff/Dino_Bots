import sys
import os
from pathlib import Path
import csv

#Process temp file to get all userValue, userID, and dinolist
#pathParent = os.path.dirname(__file__)
#os.chdir(pathParent)

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
userID = int(content[1])
userValue = int(content[2])
addBalFlag = int(content[3]) #0 means do not add bal, 1 means 10k, 2 means add balance of dinos input

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

dinoValueList = list(map(lambda x: int(x[-2:]) if x[-1:].isdigit() else 1, content)) #save owned numbers to a list

content = list(map(lambda x: ''.join([i for i in x if not i.isdigit()]), content)) #get rid of extra numbers
content = list(map(lambda x: x.strip(), content)) #get rid of trailing and leading spaces

dinoValueList = list(map(lambda x: userValue-x if x != userValue else 0, dinoValueList))

dinoContent = list(filter(lambda x: x not in content, dinoContent))

zippedFile = list(zip(content, dinoValueList))

#Begin writing to output file
totalBalAdd = 0

if addBalFlag == 1:
	output.write("!addbal <@" + str(userID) + "> 10000" + '\n')
elif addBalFlag == 2:
    for item in zippedFile:
        for d, c in dinoCostList:
            if d.find(item[0]) != -1:
                totalBalAdd = totalBalAdd + ((userValue - item[1]) * int(c))
                #print(totalBalAdd)
                break
    output.write("!addbal <@" + str(userID) + "> "+ str(totalBalAdd) + '\n')
elif addBalFlag == 4:
	output.write("!addbal <@" + str(userID) + "> 200000" + '\n')


for item in dinoContent:
    output.write("!adddino <@" + str(userID) + "> " + item + " " + str(userValue) + '\n')

if addBalFlag is not 4:
	for item in zippedFile:
	    if item[1] != 0:
	        output.write("!adddino <@" + str(userID) + "> " + item[0] + " " + str(item[1]) + '\n')

output.close()

#Pass this back to autoIT so it can run through it in a for loop and then delete the output.txt
