#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
ISYS 5103
Fall 2021
Assignment 3A

Created on Wed Oct 27 08:54:43 2021

@author: robbyjeffries
"""

# Set an initial condition
program_active = True

# Set up the while loop to keep the program running until the user exits
while program_active:
    
    # Get user input
    day = str(input("What day of the week is it? \n(Type 'quit' to exit the program): ").lower())
 
    # If the user inputs an abbreviation, replace it with the full word
    abb_to_full = {"sun":"sunday", "mon":"monday", "tues":"tuesday", "wed":"wednesday", "thurs":"thursday", "fri":"friday", "sat":"saturday"}
    
    if day in abb_to_full:
        day = abb_to_full.get(day)
    
    # Store the part of my routine that is the same every day in a list
    reg = ["\npress snooze :)", "take a shower", "get dressed", "eat breakfast", "brush teeth"]
    
    # Store the routines for each day of the week in a dictionary
    routine = {"sunday":reg+["go to church"], "monday":reg+["go to work"], "tuesday":reg+["go to microeconomics"], "wednesday":reg+["go to 5103!"], "thursday":reg+["go to University of Arkansas"], "friday":reg+["go to work (no class today)"], "saturday":reg+["do something fun! It's the weekend!"]}    
    
    # Print the routine for the day that the user inputs
    if day in ("sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"):
        print(*routine[day], sep='\n')
    elif day != "quit": 
        print("\nIs that an actual day?!\nTry using the format 'Monday' or 'mon'")
    
    # Quit the program if the user types 'quit'
    if day == "quit":
        program_active = False
        print("\nThanks for checking your routine! Have a wonderful day!")