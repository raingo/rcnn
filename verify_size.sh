#!/bin/sh
# vim ft=sh


base_dir=`pwd`/datasets/ILSVRC2014/

find $base_dir -name '*.JPEG' | xargs identify > $base_dir/real-size.txt
find $base_dir -name '*.xml' | python parse_xml.py > $base_dir/xml-size.txt

python verify_second_half.py $base_dir
echo $0[`hostname -s`] | mail -s "done" yli
