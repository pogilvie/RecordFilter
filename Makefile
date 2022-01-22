
push:
	sfdx force:source:push -u recordfilter

force:
	sfdx force:source:push  -f -u recordfilter

pull:
	sfdx force:source:pull -u recordfilter

open:
	sfdx force:org:open -b chrome -u recordfilter 

scratch:
	sfdx force:org:create -f config/scratch.json -a recordfilter -v dev

list: 
	sfdx force:org:list

character:
	sfdx force:apex:execute -f scripts/apex/character.apex -u dev


