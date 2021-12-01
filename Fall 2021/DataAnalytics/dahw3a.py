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
    
    # Quit the program if the user types 'quit'
    if day == "quit":
        program_active = False
        print("\nThanks for checking your routine! Have a wonderful day!")
    
    # If the user inputs an abbreviation, replace it with the full word
    if day == "sun":
        day = "sunday"
    if day == "mon":
        day = "monday"
    if day == "tues":
        day = "tuesday"
    if day == "wed":
        day = "wednesday"
    if day == "thurs":
        day = "thursday"
    if day == "fri":
        day = "friday"  
    if day == "sat":
        day = "saturday"
    
    # Store the days of the week in an array
    days_of_week = ("sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday")
    
    # Store the part of my routine that is the same every day
    reg = "\npress snooze :)\ntake a shower\nget dressed\neat breakfast\nbrush teeth"
    
    # Print the morning routine for each day
    if day in days_of_week:
        if day == "sunday":
            print(reg, "\ngo to church")
        if day == "monday":
            print(reg, "\ngo to work")
        if day == "tuesday":
            print(reg, "\ngo to microeconomics")
        if day == "wednesday":
            print(reg, "\ngo to 5103!")
        if day == "thursday":
            print(reg, "\ngo to University of Arkansas")
        if day == "friday":
            print(reg, "\ngo to work (no class today)")  
        if day == "saturday":
            print(reg, "\ndo something fun! It's the weekend!")
    elif day != "quit": 
        print("\nIs that an actual day?!\nTry using the format 'Monday' or 'mon'")
            
    