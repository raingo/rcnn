
import sys
import os
import pdb

base_dir = sys.argv[1]

xml_size_path = os.path.join(base_dir, 'xml-size.txt')
real_size_path = os.path.join(base_dir, 'real-size.txt')

xml_size = {}

with open(xml_size_path) as reader:
    for line in reader:
        fields = line.strip().split('\t')
        name = fields[0][len(base_dir):-4]
        name = '/'.join(name.split('/')[1:])
        width = int(fields[1])
        height = int(fields[2])
        xml_size[name] = (width, height)

with open(real_size_path) as reader:
    for line in reader:
        fields = line.strip().split(' ')
        name = fields[0].split('[')[0][len(base_dir):-5]
        name = '/'.join(name.split('/')[1:])

        wh = fields[2].split('x')
        wh = (int(wh[0]), int(wh[1]))

        if name in xml_size and wh != xml_size[name]:
            print name

