@echo off& python -x "%~f0" %* &goto :eof
from subprocess import call
call("hugo")
import webbrowser
webbrowser.open("http://localhost:1313/", new=1, autoraise=True)
call("hugo server --disableFastRender")
