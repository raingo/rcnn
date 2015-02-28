#!/usr/bin/env python

"""
Python source code - replace this with a description of the code and write the code below this text.
"""

import sys
sys.path.append('/homes/ycli/caffe/data/coco/')
from MyCOCO import *
import xml.etree.cElementTree as ET
from xml.dom import minidom

def prettify(elem):
    """Return a pretty-printed XML string for the Element.
    """
    rough_string = ET.tostring(elem, 'utf-8')
    reparsed = minidom.parseString(rough_string)
    return reparsed.toprettyxml(indent="\t")

def create_xml(ann_list, image_info, output_dir):

    filename = image_info['file_name']
    xml_fn, _ = os.path.splitext(filename)
    xml_fn += '.xml'

    folder = os.path.basename(output_dir)
    if not folder:
        folder = os.path.basename(os.path.dirname(output_dir))

    root = ET.Element("annotation")

    ET.SubElement(root, "folder").text = folder
    ET.SubElement(root, "filename").text = filename
    source = ET.SubElement(root, "source")
    ET.SubElement(source, "database").text = "coco"
    size = ET.SubElement(root, "size")
    ET.SubElement(size, 'width').text = str(image_info['width'])
    ET.SubElement(size, 'height').text = str(image_info['height'])

    for cat_id, bbox, _ in ann_list:
        object = ET.SubElement(root, "object")
        ET.SubElement(object, "name").text = "cat-%d" % cat_id
        bndbox = ET.SubElement(object, "bndbox")
        ET.SubElement(bndbox, "xmin").text = str(bbox[0])
        ET.SubElement(bndbox, "ymin").text = str(bbox[1])
        ET.SubElement(bndbox, "xmax").text = str(bbox[0] + bbox[2])
        ET.SubElement(bndbox, "ymax").text = str(bbox[1] + bbox[3])

    with open(os.path.join(output_dir, xml_fn), 'w') as writer:
        writer.write(prettify(root))


def create_bbox_xml(coco, output_dir):

    for coco_id, image_info in coco.coco.images.items():
        ann_list = []
        for ann in coco.coco.loadAnnotations(params = {'im_id_list':[coco_id]}):
            cat_id = ann['category_id']
            bbox = ann['bbox']
            area = ann['area']
            ann_list.append((cat_id, bbox, area))

        create_xml(ann_list, image_info, output_dir)


def dump_cls_mapper(coco, save_path):
    with open(save_path, 'w') as writer:
        for cat_id, cat_uid in coco.label_map.items():
            writer.write('%d\tcat-%d\t%s\n' % (cat_uid, cat_id, coco.coco.categories[cat_id]['name']))

def write_list(src, save_path):
    with open(save_path, 'w') as writer:
        for item in src:
            writer.write(item + '\n')

def create_per_class_list(coco, save_dir, prefix):
    all_imgIds = set(coco.coco.getImageIds())

    def cocoId2imgName(coco_id):
        image_info = coco.coco.images[coco_id]
        image_fn = image_info['file_name']
        imgName, _ = os.path.splitext(image_fn)
        return imgName

    all_names = ['%s %d' % (cocoId2imgName(coco_id), idx + 1) for idx, coco_id in enumerate(all_imgIds)]
    write_list(all_names, os.path.join(save_dir, '%s.txt' % prefix))

    for cat_id, cat_uid in coco.label_map.items():

        pos_ids = coco.coco.getImageIds(params = {'cat_id':cat_id})
        neg_ids = all_imgIds - set(pos_ids)

        pos_names = [cocoId2imgName(coco_id) for coco_id in pos_ids]
        neg_names = [cocoId2imgName(coco_id) for coco_id in neg_ids]

        write_list(pos_names, os.path.join(save_dir, '%s_pos_%d.txt' % (prefix, cat_uid)))
        write_list(neg_names, os.path.join(save_dir, '%s_neg_%d.txt' % (prefix, cat_uid)))

def main():
    ann_json = sys.argv[1]
    output_dir = sys.argv[2]
    mode = sys.argv[3]
    meta_dir = sys.argv[4]

    coco = MyCOCO(ann_json)
    create_bbox_xml(coco, output_dir)

    dump_cls_mapper(coco, os.path.join(meta_dir, 'meta-det.txt'))
    create_per_class_list(coco, os.path.join(meta_dir, 'det_lists'), mode)

    pass

if __name__ == "__main__":
    main()

# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
