#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ISYS 5103
Fall 2021
Assignment 3A
Questions 1-5 
Question 6 is solved in a second file entitled, "Jeffries_5103_Tkinter_2021-10-27"

Created on: Wed Oct 27 08:54:43 2021
Author: Robby Jeffries
"""

# Print instructions one time at the top of the program
print("\nTo leave the program, type 'exit'\nElse enter a day from Sunday-Saturday")

# Use a while loop to keep the program running until the user quits
while True:
    
    # Get user input
    day = str(input("\nWhat day of the week is it?\n").lower())
 
    # If the user inputs an abbreviation, replace it with the full word
    abb_to_full = {"sun":"sunday", "mon":"monday", "t":"tuesday", "tues":"tuesday", "wed":"wednesday", "th":"thursday", "thur":"thursday", "r":"thursday", "thurs":"thursday", "fri":"friday", "sat":"saturday"}
    
    if day in abb_to_full:
        day = abb_to_full.get(day)
    
    # Store in a list the part of my routine that is the same every day
    reg = ["\nPress snooze :)", "Take a shower", "Get dressed", "Eat breakfast", "Brush teeth"]
    
    # Store in a dictionary the routines for each day of the week
    routine = {"sunday":reg+["Go to church\n"], "monday":reg+["Go to work\n"], "tuesday":reg+["Go to microeconomics\n"], "wednesday":reg+["Go to 5103!\n"], "thursday":reg+["Go to University of Arkansas\n"], "friday":reg+["Go to work (no class today)\n"], "saturday":reg+["Do something fun! It's the weekend!\n"]}    
    
    # Print the routine for the day that the user inputs or exit if the user enters 'exit'
    if day in ("sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"):
        print(*routine[day], sep='\n')
    elif day != "exit": 
        print("\nIs that an actual day?!\nTry again using the format 'Monday' or 'mon'")
    elif day == "exit":
        print("\nThanks for checking your routine! Have a wonderful day!\n")
        break  