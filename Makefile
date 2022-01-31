
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

debug:
	sfdx force:apex:log:tail -u recordfilter | grep DEBUG

create:
	sfdx force:package:create \
		--name RecordFilter \
		--packagetype Unlocked \
		--path src \
		-v dev

# https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4N000000GkWvQAK
version:
	sfdx force:package:version:create \
		--package RecordFilter \
		--installationkeybypass \
		--wait 20 \
		-v dev
