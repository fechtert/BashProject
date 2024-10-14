function display_usage() {
	echo "Usage: $0 -d <input_directory> <mode: -p -v or -a>"
	echo "Options:"
	echo "	-d <input_directory>: specify the input directory where files to be backed up are found."
	echo "	-p: photo mode - will only back up .png .jpg and .jpeg files in the input directory."
	echo "	-v: video mode - will only back up .mp4 and .mov files in the input directory."
	echo "	-a: all mode - will back up all files in the input directory."
	echo "	-h: displays this help information."
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
file_regex=""

while getopts ":d:pvah" opt; do
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


if [[ $all = "yes" ]]; then
	backup_dir="${input_dir}_bak"
	mkdir $backup_dir
	cp -r $input_dir/. $backup_dir
	echo "All files in $input_dir have been added to the backup."
fi


if [[ $photo = "yes" ]]; then
	backup_dir="${input_dir}_photos"
	mkdir $backup_dir
	file_regex=".+\.png|.+\.jpg|.+\.jpeg"
	for file in "$input_dir"/*; do
		if [[ -f "$file" && "$file" =~ $file_regex ]]; then
			cp "$file" $backup_dir
		fi
	done
	echo "All photos in $input_dir have been added to the backup."
fi


if [[ $video = "yes" ]]; then 
	backup_dir="${input_dir}_videos"
	mkdir $backup_dir
	file_regex=".+\.mp4|.+\.mov"
	for file in "$input_dir"/*; do
		if [[ -f "$file" && "$file" =~ $file_regex ]]; then
			cp "$file" $backup_dir
		fi
	done
	echo "All videos in $input_dir have been added to the backup."
fi

tar -czf $backup_dir.tar.gz $backup_dir
#rm -rf $backup_dir
echo "Backup $backup_dir.tar.gz of directory $input_dir created and compressed successfully."

