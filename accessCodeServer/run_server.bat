set ipv4_address=192.168.43.22
@start /b cmd /c @python "accessCodeServer.py" %ipv4_address%
@start /b cmd /c start "" http://%ipv4_address%:8080
@pause > nul