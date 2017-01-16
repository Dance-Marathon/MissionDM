MissionDM
===========

MissionDM is based on the popular [Assassins](http://en.wikipedia.org/wiki/Assassin_(game)) game, a live action game where players are assigned a target to takedown with Silly String™.

Each game of MissionDM is played with multiple players targeting each other. The game continues until a chosen numbe of DM Agents are left standing!

This webapp is based on the original application by Matthew Gerstman, merely updated for usage by the Dance Marathon at the Univeristy of Florida organization.

You can checkout the original application at [playassassins.org](http://playassassins.org) and the original repository [here](https://github.com/mattgerstman/DMAssassins).

---
## Setup

Make sure to download the necessary [libraries](https://app.box.com/s/xa611uadha6a7r6jiprivqyucpdzdwop). This is because the app will not work with the updated libraries and needs these deprecated versions to function.

In the application root folder (the one with `src/`), you will need to move the `pkg'/` and `bin/` folders from the above Box link.   
You will then have to move the `code.github.com/` and `github.com/` dirs into the `src/` folder.     

Once these are in place, you will need to make sure that the `src/app/webapp/js` folder has a `config.js` file, and the `src/app/missiondm_server` folder has a `config.json` file. The variables in these files are important as they contain the keys for the APIs that we are using. __Do not upload these files to github as they are secret.__    

## Running MissionDM

Now that you have setup all of the above dirs and configuration files, you can run the scripts to quickly install the necessary npm packages and build the go executables.     

If this is the first time running this, use `. ./setup.sh` to install all the packages and build the executables.     

Else, you can run both the grunt server and the go API with `. ./run_missiondm.sh`
