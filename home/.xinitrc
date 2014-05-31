# Merge .Xresources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Load fonts
xset +fp /usr/share/fonts/local
xset fp rehash

# Launch bspwm
sxhkd &
compton &
unclutter &

exec bspwm
