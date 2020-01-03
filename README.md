# osu-dmenu-skin-elements-changer
Really dirty script (the first one that I've made in my life, actually), but hey, it works! 


Showcase of what it's capable of in it's current state:https://www.youtube.com/watch?v=i9sa8LTaiTA (in Russian, but all the menus are in English)

**Dependencies:**
- dmenu
- Probably any Notification Manager in existence, tested with **dunstify**

**Capabilities**
- Chaging Defaults/Cursors/FollowPoints on the Fly! (also changes HitCircleOverlap and AnimationFramerate)
- Backing up previous configuration and Restoring to it later (Restore)
- Works with assets that are not in the root skin directory. F.E. $SKIN/Assets/defaults/default-1.png

**Get Started** 
1. git clone https://github.com/l3lackShark/osu-dmenu-skin-elements-changer.git
2. cd osu-dmenu-skin-elements-changer
3. chmod +x skin.sh
4. change the 4th and 7th line to match your configuration
4. ./skin.sh

Feel free to submit any issues or PR's to clean up some of the dirtiness that I've made!
