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
file_count="0"

while getopts ":d:pvah" opt; do
	case $opt in
		d)
			input_dir=${OPTARG%/}
			;;
		p)
			photo="photo"
			let "argcount++"
			;;
		v)
			video="video"
			let "argcount++"
			;;
		a)
			all="all"
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


if [[ $all = "all" ]]; then
	backup_dir="${input_dir}_bak"
	mkdir $backup_dir
	for file in "$input_dir"/*; do
		cp "$file" $backup_dir
		let "file_count++"
	done
	mode="$all"
fi


if [[ $photo = "photo" ]]; then
	backup_dir="${input_dir}_photos"
	mkdir $backup_dir
	file_regex=".+\.png|.+\.jpg|.+\.jpeg"
	for file in "$input_dir"/*; do
		if [[ -f "$file" && "$file" =~ $file_regex ]]; then
			cp "$file" $backup_dir
			let "file_count++"
		fi
	done
	mode="$photo"
fi


if [[ $video = "video" ]]; then 
	backup_dir="${input_dir}_videos"
	mkdir $backup_dir
	file_regex=".+\.mp4|.+\.mov"
	for file in "$input_dir"/*; do
		if [[ -f "$file" && "$file" =~ $file_regex ]]; then
			cp "$file" $backup_dir
			let "file_count++"
		fi
	done
	mode="$video"
fi

if [[ $file_count = "0" ]]; then
	echo "Error: no files able to be backed up using option $3"
	rm -rf $backup_dir
	exit 1
else
	tar -czf $backup_dir.tar.gz $backup_dir
	rm -rf $backup_dir
	if [[ -f "$backup_dir.tar.gz" ]]; then
		echo "Backup $backup_dir.tar.gz created and compressed successfully using $mode mode."
	else
		echo "Error: unable to create backup"
	fi
fi
