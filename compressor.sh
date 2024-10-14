function display_usage() {
	echo "Usage - testing"
	echo "line 2"
}

if [ $# -lt 1 ]; then
	display_usage
	exit 1
fi

input_dir=""
photo=""
video=""
all=""
argcount="0"

while getopts ":d:pvauh" opt; do
	case $opt in
		d)
			input_dir=${OPTARG%/}
			;;
		p)
			photo="yes"
			let "argcount++"
			;;
		v)
			video="yes"
			let "argcount++"
			;;
		a)
			all="yes"
			let "argcount++"
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
	echo "Error: missing required option: -d input directory."
	display_usage
	exit 1
fi

if [[ ! -d $input_dir ]]; then
	echo "Error: input directory $input_dir does not exist."
	display_usage
	exit 1
fi

if [[ $argcount != 1 ]]; then
	echo "Error: zero or more than one of -p -v -a were selected."
	display_usage
	exit 1
fi



echo "$input_dir"
echo "$photo"
echo "$video"
echo "$all"
echo "$argcount"

#backup_dir="${input_dir}_bak"
#mkdir $backup_dir

#if [[ $all = "yes" ]]; then
#	cp -r $input_dir/. $backup_dir
#	tar -czf $backup_dir.tar.gz $backup_dir
#	rm -rf $backup_dir
#	echo "Backup $backup_dir.tar.gz of directory $input_dir created and compressed successfully."
#fi
