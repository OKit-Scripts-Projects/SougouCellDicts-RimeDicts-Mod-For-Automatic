#!/bin/bash

word="成语俗语【官方推荐】/15097/Java【官方推荐】/80764/音乐专业词汇（待完善）/793/艺术专用词汇/513/摄影大全【官方推荐】/20649/全名TV/73884/物理词汇大全【官方推荐】/15203/化学词汇大全/148/农业词汇大全【官方推荐】/15149/医学词汇大全【官方推荐】/15125/地质大词典/14551/地理地质词汇大全【官方推荐】/15208/211院校名单/22223/中国医院大全【官方推荐】/20648/政府机关团体机构大全【官方推荐】/22421/最详细的全国地名大全/1316/中外药品名称大全【官方推荐】/20666/药品名称大全/270/书法词库大全/10289/动物词汇大全/37086/动物词汇大全【官方推荐】/15206/电子计算机通信专业术语/18032/影视歌名库/8582/地理地质词汇大全【官方推荐】/15208/最新流行新歌 新专辑/5/艺术家小辞海/11957/音乐大杂烩/11481/常用植物名/8629/虫蛇类名词/7943/历史名人大全/154/"
#echo $j
OLD_IFS="$IFS"
IFS="/"
array=($word)
declare -p array

#echo ${array[@]}

# val=`expr 2 + 2`
id_dict=()
name_dict=()

i=0
for s in ${array[@]}
do
# val=`expr 2 + 2`
r=$((i%2))
#`expr `
# r=i%2

if [ $r -eq 0 ]; then
	# echo "$s"
	name_dict=("${name_dict[@]}" "\""$s"")
else 
	# echo "$s"
	id_dict=("${id_dict[@]}" ""$s"\"")
fi


i=$(( $i + 1 ))

done


# echo ${#name_dict}
# echo ${#id_dict}
echo ${name_dict[@]}
echo ${id_dict[@]}


IFS="$OLD_IFS"


i=0
for s in ${name_dict[@]}
do
	name=${name_dict[i]}
	id=${id_dict[i]}
	val=$name/$id
	echo $val
	i=$(( $i + 1 ))
done
