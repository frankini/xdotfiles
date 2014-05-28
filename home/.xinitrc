# Awesome
# exec awesome

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# bspwm
sxhkd &
urxvt &
compton &
unclutter &

exec bspwm
