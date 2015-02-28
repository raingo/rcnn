#!/usr/bin/env python

"""
Python source code - replace this with a description of the code and write the code below this text.
"""

def main():

    import sys, os

    bk_fn = sys.argv[1]
    list_fn = sys.argv[2]

    bk_set = set()

    if os.path.exists(bk_fn):
        with open(bk_fn) as reader:
            for line in reader:
                fields = line.strip().split(' ')
                bk_set.add(fields[0])

    with open(list_fn) as reader:
        for line in reader:
            fields = line.strip().split(' ')
            if fields[1] not in bk_set:
                print fields[0]

    pass

if __name__ == "__main__":
    main()

# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
