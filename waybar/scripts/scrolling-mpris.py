import subprocess
import time
import json
import sys

# Customization settings (easy to modify)
GLYPH_FONT_FAMILY="JetbrainsMono Nerd Font" # Set to your desired symbols font
# Those are glyphs that will be always visible at left side of module.
GLYPHS = {
    "paused": "",
    "playing": "",
    "stopped": ""
}
DEFAULT_GLYPH = ""  # Glyph when status is unknown or default
TEXT_WHEN_STOPPED = "Nothing playing right now"  # Text to display when nothing is playing
SCROLL_TEXT_LENGTH = 40  # Length of the song title part (excludes glyph and space)
REFRESH_INTERVAL = 0.4  # How often the script updates (in seconds)
PLAYERCTL_PATH = "/usr/bin/playerctl" # Path to playerctl, use which playerctl to find yours.

# Function to get player status using playerctl
def get_player_status():
    try:
        result = subprocess.run([PLAYERCTL_PATH, 'status'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        status = result.stdout.decode('utf-8').strip().lower()
        if result.returncode != 0 or not status:
            return "stopped"  # Default to stopped if no status
        return status
    except Exception as e:
        return "stopped"

# Function to get currently playing song and artist using playerctl
def get_current_song_and_artist():
    try:
        title_result = subprocess.run([PLAYERCTL_PATH, 'metadata', 'title'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        artist_result = subprocess.run([PLAYERCTL_PATH, 'metadata', 'artist'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        song_title = title_result.stdout.decode('utf-8').strip()
        artist = artist_result.stdout.decode('utf-8').strip()
        if title_result.returncode != 0 or not song_title:
            return None  # Return None if no song is playing or an error occurred
        if artist_result.returncode != 0 or not artist:
            return song_title  # If no artist, just return title
        return f"{song_title} - {artist}"
    except Exception as e:
        return None

# Function to get player name using playerctl
def get_player_name():
    try:
        result = subprocess.run([PLAYERCTL_PATH, 'metadata', 'playerName'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        player = result.stdout.decode('utf-8').strip().lower()
        if result.returncode != 0 or not player:
            return "default"
        # Some players may return e.g. 'firefox.instance1234', so just take the base name
        return player.split(".")[0]
    except Exception:
        return "default"

# Function to generate scrolling text with fixed length
def scroll_text(text, length=SCROLL_TEXT_LENGTH):
    text = text.ljust(length)  # Ensure the text is padded to the desired length
    scrolling_text = text + ' | ' + text[:length]  # Add separator and repeat start for scrolling effect
    
    for i in range(len(scrolling_text) - length):
        yield scrolling_text[i:i + length]  # Use a generator to yield scrolling parts

if __name__ == "__main__":
    scroll_generator = None
    
    while True:
        output = {}
        
        try:
            # Get the player status and song+artist
            status = get_player_status()
            song_artist = get_current_song_and_artist()

            # Icon logic: always use glyphs for play/pause/stop
            if status == "paused":
                icon = GLYPHS["paused"]
            elif status == "stopped":
                icon = GLYPHS["stopped"]
            else:
                icon = GLYPHS["playing"]

            if song_artist:
                if len(song_artist) > SCROLL_TEXT_LENGTH:
                    if scroll_generator is None:
                        scroll_generator = scroll_text(song_artist)
                    try:
                        song_text = next(scroll_generator)
                    except StopIteration:
                        scroll_generator = scroll_text(song_artist)
                        song_text = next(scroll_generator)
                else:
                    song_text = song_artist
                    scroll_generator = None
            else:
                song_text = TEXT_WHEN_STOPPED

            # Combine icon and song text with a fixed space
            output['text'] = f"<span font_family='{GLYPH_FONT_FAMILY}'>{icon}</span> {song_text}"

        except Exception as e:
            output['text'] = f" Error: {str(e)}".ljust(SCROLL_TEXT_LENGTH + 2)

        # Print the JSON-like output
        print(json.dumps(output), end='\n')
        time.sleep(REFRESH_INTERVAL)
