Connect-Ucs <ucs server> -Credential (Get-Credential)
# Getting UCS Processor Info
Get-UcsProcessorunit

# Should somehow be able to pull up info about an object via distinguised name.  need to investigate some more
#Dn                  : sys/rack-unit-9/board/cpu-2

# Deploy SP from Template
Get-UcsServiceProfile -Name Nova-Server-no-ephemeral -Org org-root | Add-UcsServiceProfileFromTemplate -NewName @("svl-cc-nova1-0101") -DestinationOrg org-root