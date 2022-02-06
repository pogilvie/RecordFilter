
DEVHUB = dev
installTarget = recordfilter

push:
	sfdx force:source:push -u $(installTarget)

force:
	sfdx force:source:push  -f $(installTarget)

pull:
	sfdx force:source:pull $(installTarget)

open:
	sfdx force:org:open -b chrome $(installTarget)

scratch:
	sfdx force:org:create -f config/scratch.json -a recordfilter -v $(DEVHUB)

list: 
	sfdx force:org:list

character:
	sfdx force:apex:execute -f scripts/apex/character.apex -u $(DEVHUB)

debug:
	sfdx force:apex:log:tail -u recordfilter | grep DEBUG

create:
	sfdx force:package:create \
		--name RecordFilter \
		--packagetype Unlocked \
		--path src \
		-v $(DEVHUB)

install:
	sfdx force:package:install \
		--package RecordFilter@1.0.0-1 \
		--wait 20 -b 20 \
		-u $(installTarget)


# https://login.salesforce.com/packaging/installPackage.apexp?p0=04t4N000000GkX5QAK
version:
	sfdx force:package:version:create \
		--package RecordFilter \
		--installationkeybypass \
		--wait 20 \
		-v dev
