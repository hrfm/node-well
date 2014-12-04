# =========================================================================
# Check and install sass command.

cecho $green "\nChecking sass"

if [ ! -n "`get_conf \"sass\"`" ]; then

	# Ask use sass in this project.
	
	ask sass

	echo "`get_conf \"sass\"`"

	# Check scss command available in this OS.

	if [ "`get_conf \"sass\"`" != "0" ]; then

		if ! type sass > /dev/null 2>&1; then

			while true; do
				cecho $yellow "Intall scss from gem install. OK? (y/n)"
				read answer
				case $answer in
					y)
						echo "sudo gem install sass --no-rdoc"
						sudo gem install sass --no-rdoc
						break
						;;
					n)
						cecho $yellow "You need to install sass by yourself."
						exit 0
						;;
					*)
		            	echo "Cannot understand $answer."
						;;
				esac
			done

		else

			echo "sass is available."
			echo `sass -v`

		fi

		set_conf sass 1

	fi

elif [ "`get_conf \"sass\"`" == "0" ]; then

	echo "sass is not used in this project."

else

	echo "sass is available."
	echo `sass -v`

fi

# =========================================================================
# Check and install compass command.

cecho $green "\nChecking compass."

if [ ! -n "`get_conf \"compass\"`" ]; then

	# Ask use compass in this project.
	
	ask compass

	if [ "`get_conf \"compass\"`" != "0" ]; then

		if ! type compass > /dev/null 2>&1; then

			while true; do
				cecho $yellow "Intall compass from gem install. OK? (y/n)"
				read answer
				case $answer in
					y)
						echo "sudo gem install compass"
						sudo gem install compass
						;;
					n)
						cecho $yellow "You need to install compass by yourself."
						exit 0
						;;
					*)
		            	echo "Cannot understand $answer."
						;;
				esac
			done

		else

			echo "compass is available."
			echo `compass -v`

		fi

		set_conf compass 1

	fi

elif [ "`get_conf \"sass\"`" == "0" ]; then

	echo "compass is not used in this project."
	
else

	echo "compass is available."
	echo `compass -v`

fi
