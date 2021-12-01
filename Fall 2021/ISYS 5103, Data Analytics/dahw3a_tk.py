#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 27 18:36:04 2021

@author: robbyjeffries
"""

import tkinter as tk

# Create the window
window = tk.Tk()

# Add a widget
greeting = tk.Label(text="Which day is it?")
greeting.pack()

# Define function for the buttons to run
def callback(day):

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
        exit()

# Create buttons for each day and a button to exit the program
sunday = tk.Button(
    window,
    text="Sunday",
    width=25,
    height=5, 
    command=lambda m="sunday": callback(m)
)
monday = tk.Button(
    text="Monday",
    width=25,
    height=5, 
    command=lambda m="monday": callback(m)
)
tuesday = tk.Button(
    text="Tuesday",
    width=25,
    height=5, 
    command=lambda m="tuesday": callback(m)
)
wednesday = tk.Button(
    text="Wednesday",
    width=25,
    height=5, 
    command=lambda m="wednesday": callback(m)
)
thursday = tk.Button(
    text="Thursday",
    width=25,
    height=5, 
    command=lambda m="thursday": callback(m)
)
friday = tk.Button(
    text="Friday",
    width=25,
    height=5, 
    command=lambda m="friday": callback(m)
)
saturday = tk.Button(
    text="Saturday",
    width=25,
    height=5, 
    command=lambda m="saturday": callback(m)
)
exit_button = tk.Button(
    text="Exit",
    width=25,
    height=5, 
    command=lambda m="exit": callback(m)
)

# Pack all of the GUI elements into the window
sunday.pack()
monday.pack()
tuesday.pack()
wednesday.pack()
thursday.pack()
friday.pack()
saturday.pack()
exit_button.pack()

# Display the window
window.mainloop()