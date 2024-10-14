function display_usage() {
	echo "Usage - testing"
	echo "line 2"
}

if [ $# -lt 1 ]; then
	display_usage
	exit 1
fi

input_dir=""

while getopts ":d:h" opt; do
	case $opt in
		d)
			input_dir=$OPTARG
			;;
		h)
			echo "help option"
			display_usage
			exit 0
			;;
		\?)
			echo "Invalid option: -$OPTARG"
			display_usage
			exit 1
			;;
		: )
			echo "Option -$OPTARG requires an argument"
			display_usage
			exit 1
			;;
	esac
done

if [[ -z $input_dir ]]; then
	echo "Error: missing required option(s)."
	display_usage
	exit 1
fi

if [[ ! -d $input_dir ]]; then
	echo "Error: input directory $input_dir does not exist."
	display_usage
	exit 1
fi

echo $input_dir
