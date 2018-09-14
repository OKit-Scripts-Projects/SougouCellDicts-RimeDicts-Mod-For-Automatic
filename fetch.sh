#!/bin/bash
# i=0
sourceAllFiles() {
for file in $1/*
do
if [ -d $file ]; then
sourceAllFiles $file
else
# echo $file
source $file
# i=$(( $i + 1 ))
fi
done
}

source ./config
sourceAllFiles ./conf.d
# echo $i

# assemble dicts

# echo ${DICT_CELL[@]}


i=0
# while [ "xa${DICT_CELL[i]}" != "xa" ]; do
for s in ${DICT_CELL[@]};do
	echo $i
	id=${DICT_CELL[i]}
    source ./conf.d/$id
	
	dict_name=${id}${DICT_CELL_SUFFIX}

	#echo "${var}"
	dict=(`eval echo '$'{"$dict_name"[@]}`)
	#echo $dict
	#echo ${dict[@]}
	#echo ${DICT_POETRY[@]}
	
	j=0
	#echo ${#dict[@]}
	#echo ${#DICT_POETRY[@]}
	while [ "m${dict[j]}" != "m" ]; do
		word=${dict[j]}
		#echo $j
		OLD_IFS="$IFS"
		IFS="/"
		ARR=($word)
		declare -p ARR 

		#echo ${ARR[1]}
		DICT_IDS=("${DICT_IDS[@]}" ${ARR[1]})
		DICT_NAMES=("${DICT_NAMES[@]}" ${ARR[0]})

		short=${ARR[0]}
		a='/Users/Prolospro/Downloads/scel-rime-master/s2c '${short}
		# b=`$a`
		b=$short
		# b=${b:1:$[${#b}-1]}
		#echo $b
		DICT_SHORTS=("${DICT_SHORTS[@]}" ${id}.${b})
		
		IFS="$OLD_IFS"
		
		j=$(( $j + 1 ))
	done
	

	
	# for s in ${DICT_SHORTS[@]}
	# do
	# echo "$s"
	# done
	#
	# for s in ${DICT_NAMES[@]}
	# do
	# echo "$s"
	# done
	
	i=$(( $i + 1 ))
done

# Clear the output directory
rm -rf out

# Create necessary directories
mkdir -p out/scel
mkdir -p out/rime

date=$(date +%Y.%m.%d)
master_header="---\nname: ${DICT_PREFIX}.${DICT_MASTER_NAME}\nversion: \"${date}\"\nsort: by_weight\nuse_preset_vocabulary: true\nimport_tables:\n  - luna_pinyin\n"
import_headers=""

# Loop over all the dictionaries
i=0
while [ "x${DICT_IDS[i]}" != "x" ]; do
  id=${DICT_IDS[i]}
  name=${DICT_NAMES[i]}
  name=${name/\(/(}
  name=${name/\)/)}
  echo $name
  shortname=${DICT_SHORTS[i]}
  master_header+="  - ${DICT_PREFIX}.${shortname}\n"
  import_headers+="  - $SUB_DIR/${DICT_PREFIX}.${shortname}\\\\n"
  echo "Fetching ${id}: ${name}"
  curl -L "http://pinyin.sogou.com/d/dict/download_cell.php?id=${id}&name=${name}&f=detail" > out/scel/$id.scel
  python3 ./scel2txt.py ./out/scel/$id.scel ./out/scel/$id.txt
  txt=$(cat out/scel/$id.txt)
  header="---\nname: ${DICT_PREFIX}.${shortname}\nversion: \"${date}\"\nsort: by_weight\nuse_preset_vocabulary: true\n...\n\n"
  echo -e "$header${txt}" > out/rime/${FILE_PREFIX}.${shortname}.dict.yaml
  i=$(( $i + 1 ))
done
  # exit
master_header+="...\n\n"

#echo -e "$master_header" > out/rime/${DICT_PREFIX}.${DICT_MASTER_NAME}.dict.yaml



if [[ ! -z "$HOOK_AFTER" ]]; then
  $HOOK_AFTER
fi

#echo ${cell_pattern}${import_headers}
$GNU_SED '/luna_pinyin.cell/d' -i  $EXT_PATH

cell_pattern="/cells_section/a\\\\"
ccommand="\"${cell_pattern}${import_headers}"
ccommand=${ccommand:0:$[${#ccommand}-3]}
ccommand+="\""
#echo ${cell_pattern}${import_headers}
echo "$GNU_SED $ccommand -i $EXT_PATH" > runtime
bash ./runtime
rm ./runtime

if [[ ! -z "$RIME_PATH" ]]; then
  cp out/rime/* "$RIME_PATH" 
fi