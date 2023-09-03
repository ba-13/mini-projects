import tkinter as tk
from tkinter import messagebox
from tkinter import ttk
import tkinter.font as tkFont
import pickle
import argparse
import random
import sys
import os

parser = argparse.ArgumentParser(
    description="Applet that helps you learn words using flashcards"
)
parser.add_argument(
    "-file",
    type=str,
    help="pickle file containing dictionary of {words:defintions}",
    default="baron333.pickle",
)
args = parser.parse_args()

dictionary = {
    "apple": "A fruit that grows on trees and is usually red or green.",
    "banana": "A long, curved fruit that grows in clusters and is usually yellow.",
    "cat": "A small domesticated carnivorous mammal with soft fur.",
}


def load_pickle_file(pickle_file_name):
    try:
        if getattr(sys, "frozen", False):  # Check if running as a bundled executable
            pickle_path = (
                sys._MEIPASS + f"/{pickle_file_name}"
            )  # Get the extracted path
        else:
            pickle_path = f"./{pickle_file_name}"  # Path when running as a script

        with open(pickle_path, "rb") as file:
            data = pickle.load(file)
        return data
    except Exception as e:
        print("Error loading pickle file:", e)
        return None


words_dict = load_pickle_file(args.file)
dictionary = {**dictionary, **words_dict}
dictionary_keys = list(dictionary.keys())
intro_message = "press `Lookup` to start"


def lookup_word(word):
    return dictionary.get(word.lower(), False)


def show_definition(event=None):
    word = entry_word.cget("text")
    if word == intro_message:
        entry_word["font"] = custom_word_font
        update_word()
        return
    definition = lookup_word(word)
    title = "Definition"
    if not definition:
        messagebox.showerror(title, "Word not found!")
    else:
        messagebox.showinfo(title, definition)
    update_word()


def update_word():
    word = random.choice(dictionary_keys)
    entry_word["text"] = word


def quit_app(event=None):  # Add event=None as a parameter
    app.quit()


# Create the main application window
app = tk.Tk()
app.title(os.path.basename(args.file).split(".")[0])

# Modern theme for Entry and Button widgets
style = ttk.Style()
style.configure("TButton", padding=5, relief="flat")
style.configure("TEntry", padding=5)

# Styling
app_width = 400
app_height = 200

# Calculate the screen width and height
screen_width = app.winfo_screenwidth()
screen_height = app.winfo_screenheight()

# Calculate the window position to center it on the screen
x = (screen_width - app_width) // 2
y = (screen_height - app_height) // 2

# Set the window size and position
app.geometry(f"{app_width}x{app_height}+{x}+{y}")
app.configure(bg="#f0f0f0")

# Create a custom font for the label
custom_font = tkFont.Font(family="Constantia", size=12)
custom_intro_font = tkFont.Font(family="Arial", size=18, weight="bold")
custom_word_font = tkFont.Font(family="Arial", size=20, weight="bold")

# Create a frame to hold the label and entry widgets
frame = ttk.Frame(app)
frame.pack(pady=10)

# Create and configure widgets
label = tk.Label(app, text="This means?", bg="#f0f0f0", font=custom_font)
entry_word = tk.Label(app, text=intro_message, bg="#f0f0f0", font=custom_intro_font)
lookup_button = ttk.Button(app, text="Lookup", command=show_definition)
entry_word.focus_set()  # Set the focus on the entry widget

# Bind Enter key to the lookup function
entry_word.bind("<Return>", show_definition)
# Bind Ctrl+W to quit the app
app.bind("<Control-w>", quit_app)

# Padding and layout
label.pack(pady=10)
entry_word.pack(pady=5)
lookup_button.pack(pady=10)

# Start the Tkinter main loop
app.mainloop()
