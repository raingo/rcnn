#!/usr/bin/env python

"""
Python source code - replace this with a description of the code and write the code below this text.
"""

import xml.etree.cElementTree as ET

def main():

    import sys

    for line in sys.stdin:
        path = line.strip()
        tree = ET.parse(path)
        root = tree.getroot()
        size = root.find('size')
        width = size.find('width')
        height = size.find('height')
        print '\t'.join(path, width.text, height.text)


    pass

if __name__ == "__main__":
    main()

# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
