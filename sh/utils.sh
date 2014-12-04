# Utility.

# =========================================================================
# echo with colors.

red=31
green=32
yellow=33
blue=34

function cecho() {
    local color=$1
    shift
    echo "\033[${color}m$@\033[m"
}

# =========================================================================
# Ask.

function ask(){

	if [ ! -n "`set_conf $1`" ]; then

		while true; do
			cecho $yellow "Are you using $1 in this project? (y/n)"
			read answer
			case $answer in
				y)
					break
					;;
				n)
					set_conf $1 0
					echo "$1 is not used in this project."
					break
					;;
				*)
	            	echo "Cannot understand $answer."
					;;
			esac
		done

	fi

}

# =========================================================================
# configuration.

if [ ! -n "$CONF_FILE" ]; then
	CONF_FILE=.initconf
fi

# Add key value data into ${CONF_FILE}
function set_conf() {
	
	if [ ! -f ${CONF_FILE} ];then
		touch ${CONF_FILE}
	fi

	# Set configure.

	local TMP=.configure.tmp
	local exists=0

	while read line
	do
		local arr=(${line})
		local key=${arr[0]}
		if [ ${key} = $1 ]; then
			echo "$@" >> ${TMP}
			exists=1
		else
			unset arr[0]
			local value=${arr[@]}
			echo "${key} ${value[@]}" >> ${TMP}
		fi
	done < ${CONF_FILE}

	if [ ${exists} -eq 0 ]; then
		echo "$@" >> ${TMP}
	fi

	mv -f ${TMP} ${CONF_FILE}

}

# Get key value data from ${CONF_FILE}
function get_conf() {

	# Return blank if configure file is not exists.

	if [ ! -f ${CONF_FILE} ];then
		return
	fi

	# Read and check lines.

	local exists=0

	while read line
	do
		local arr=(${line})
		local key=${arr[0]}
		if [ ${key} = $1 ]; then
			unset arr[0]
			local value=${arr[@]}
			echo ${value[@]}
			exists=1
			break
		fi
	done < ${CONF_FILE}

	if [ $exists -eq 0 ]; then
		echo ""
	fi

}

# Check key value data exists. And update or set value.
function update_conf() {

	local _conf=`get_conf "$1"`

	if [ -n "$2" ]; then
		local _question=$2
	else
		local _question="Type configure [$1]."
	fi

	if [ -n "$_conf" ]; then
		cecho $yellow "${_question} (${_conf})"
		read answer
		if [ -n "$answer" ]; then
			set_conf $1 ${answer}
		else
			echo $_conf
		fi
	else
		cecho $yellow $_question
		read answer
		set_conf $1 ${answer}
	fi

}