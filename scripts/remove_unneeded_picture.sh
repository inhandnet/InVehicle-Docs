#!/bin/sh
#

cd ..

used_img=$(find *.md |xargs -I {} grep -E "*.png" {} | tr -d '()' | awk -F/ '{print $NF}' | xargs)
exist_img=$(find images -name *.png | awk -F/ '{print $NF}' | xargs)

for img in ${exist_img}
do
	echo ${used_img} | grep -o ${img} 2>&1 > /dev/null
	if [ "$?" != "0" ]; then
		rm -rf images/${img}
	fi
done
