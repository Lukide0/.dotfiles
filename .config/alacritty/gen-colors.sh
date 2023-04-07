#!/usr/bin/env bash

alacritty_colors_file="$HOME/.config/alacritty/colors.yml"
readonly colors=(black red green yellow blue magenta cyan white)

xrdb_get()
{
    xrdb -get $1
}

# check if the config with colors exist
if [[ -f $alacritty_colors_file ]]; then
    while true; do
        read -p "Alacritty config with colors already exists. Do you want to override it? (y/n) " -n 1 -r
        echo

        case $REPLY in
            [Yy]* )
                # remove config
                rm $alacritty_colors_file
                break;;

            [Nn]* )
                exit;;
            * ) echo "Please answer [y]es or [n]o.";;
        esac
    done
fi

# create empty file
touch $alacritty_colors_file

# Begin of the alacritty config
{

cat << EOF
colors:

  primary:
    background: "$(xrdb_get background)"
    foreground: "$(xrdb_get foreground)"
  
  normal:
EOF

# normal colors
for i in "${!colors[@]}"; do
    printf '    %s: "%s"\n' "${colors[$i]}" "$(xrdb_get color$i)"
done

# bright colors
printf "\n  bright:\n"
for i in "${!colors[@]}"; do
    printf '    %s: "%s"\n' "${colors[$i]}" "$(xrdb_get color$(expr $i + 8))"
done

} > $alacritty_colors_file