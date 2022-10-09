#!/usr/bin/env python3
# author: SwallowYourDreams | https://github.com/SwallowYourDreams
# modified: duracell80 | https://github.com/duracell80
# - removed autostart and moved that desktop file to cinnamon .config/autostart with delay of zero
# - added pause and play buttons

import sys
import os
import getpass
import configparser
from PyQt5 import QtWidgets, QtGui, uic
from PyQt5.QtWidgets import QFileDialog
from PyQt5.QtGui import QIcon


class MainWindow(QtWidgets.QMainWindow):
    def __init__(self, verbose=False):
        # Inherited class __init__ method
        super(MainWindow, self).__init__()
        # Variables
        self.scriptDir = os.path.dirname(os.path.realpath(__file__)) + "/"
        self.configDir = "/home/" + getpass.getuser() + "/.config/video-wallpaper"
        self.name = "video-wallpaper"
        self.shellScript = self.scriptDir.replace(" ", "\ ") + self.name + ".sh"
        self.dependencies = ["mpv", "pcregrep", "xrandr"]
        self.missingDependencies = self.checkDependencies()
        
        # Load external .ui file
        uic.loadUi(self.scriptDir + "video-wallpaper.ui", self)
        self.show()
        # Parse config
        self.parser = configparser.RawConfigParser()
        configFile = self.configDir + "/settings.conf"
        if os.path.isfile(configFile):
            try:
                self.parser.read(configFile)
                lastFile = self.parser.get(
                    self.name + " settings", "lastfile").replace('"', '')
                if len(lastFile) > 0:
                    self.directory.setText(lastFile)
            except:
                print("Configuration file could not be read: " + configFile)
        # UI functionality
        self.button_browse.clicked.connect(self.selectFile)
        self.button_start.clicked.connect(self.start)
        self.button_stop.clicked.connect(self.stop)
        self.button_pause.clicked.connect(self.pause)
        self.button_play.clicked.connect(self.play)
        # Startup
        if len(self.missingDependencies) > 0:
            self.statusbar.showMessage("Error: missing dependencies: " + str(
                self.missingDependencies) + ". Please run the installer again.")
            print("Missing dependencies: " + str(self.missingDependencies))
            self.button_start.setEnabled(False)
            self.button_stop.setEnabled(False)
            self.button_pause.setEnabled(False)
            self.button_play.setEnabled(False)
        else:
            print("All dependencies fulfilled.")

    # Handles all video file selection
    def selectFile(self, event):
        dialogue = QFileDialog(self)
        dialogue.setFileMode(QFileDialog.ExistingFile)
        if len(self.directory.text()) > 0:
            dialogue.setDirectory(self.directory.text())
        file = dialogue.getOpenFileName(self, "Select video file")
        # If new file is selected...
        if len(file[0]) > 0:
            # ...set text in input mask
            self.directory.setText(file[0])
            
    # Starts video wallpaper playback
    def start(self):
        if(self.fileSelected()):
            exitcode = os.system(self.shellScript +
                                 ' --start "' + self.directory.text() + '"')
            if exitcode > 0:
                self.statusbar.showMessage("Error: could not start playback.")
            else:
                self.statusbar.showMessage("Playback is running.")

    # Stops video wallpaper playback
    def stop(self):
        os.system(self.shellScript + " --stop")
        self.statusbar.showMessage("Playback stopped.")

    # Pause video wallpaper playback
    def pause(self):
        os.system(self.shellScript + " --pause")
        self.statusbar.showMessage("Playback paused.")

    # Play video wallpaper playback
    def play(self):
        os.system(self.shellScript + " --play")
        self.statusbar.showMessage("Playback resumed.")

    # Returns whether there is currently a video file selected
    def fileSelected(self):
        path = self.directory.text()
        if len(path) > 0 and os.path.isfile(path):
            return True
        else:
            self.statusbar.showMessage("No video file selected.")
            return False

    # Checks for missing dependencies
    def checkDependencies(self):
        missingDependencies = []
        print("Checking for missing dependencies:")
        for d in self.dependencies:
            missing = os.system("which " + d)
            if missing:
                missingDependencies.append(d)
        print("./xwinwrap")
        if not os.path.isfile(self.scriptDir + "/xwinwrap"):
            missingDependencies.append("xwinwrap")
        return missingDependencies


# Main method
if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    # Main window
    w = MainWindow()
    sys.exit(app.exec_())
