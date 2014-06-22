# Merge .Xresources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Load fonts
xset +fp ~/.fonts
xset +fp /usr/share/fonts/local
xset fp rehash

# Launch bspwm
sxhkd &
compton &
unclutter &
#dropboxd &

# Set wallpaper
#sleep 5
#/home/steven/bin/setwall &

exec bspwm
