@echo off
rem This work is licensed under the Creative Commons
rem Attribution-Noncommercial-Share Alike 3.0 Unported
rem License. To view a copy of this license, visit
rem http://creativecommons.org/licenses/by-nc-sa/3.0/
rem or send a letter to Creative Commons,
rem 171 Second Street, Suite 300, San Francisco,
rem California, 94105, USA.

echo ^<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"^> > webpage.html
xmlpatterns webpage.xq %* >> webpage.html
