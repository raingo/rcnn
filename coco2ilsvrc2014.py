#!/usr/bin/env python

"""
Python source code - replace this with a description of the code and write the code below this text.
"""

import sys
sys.path.append('/homes/ycli/ycli-data/coco/caffe/')
from MyCOCO import *
import xml.etree.cElementTree as ET
from xml.dom import minidom
import math

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


def segm2bbox(segm):

    segm_x = [segm[i] for i in range(0, len(segm), 2)]
    segm_y = [segm[i + 1] for i in range(0, len(segm), 2)]

    x_min = math.floor(min(segm_x))
    y_min = math.floor(min(segm_y))

    width = math.ceil(max(segm_x) - x_min)
    height = math.ceil(max(segm_y) - y_min)

    return (x_min, y_min, width, height)

def create_bbox_xml(coco, output_dir):

    for coco_id in coco.coco.getImgIds():
        image_info = coco.coco.loadImgs([coco_id])[0]
        ann_list = []
        annIds = coco.coco.getAnnIds(imgIds = coco_id)
        for ann in coco.coco.loadAnns(annIds):
            cat_id = ann['category_id']
            bbox = ann['bbox']
            area = ann['area']
            segm_list = ann['segmentation']
            isCrowd = ann['iscrowd']

            if isCrowd or len(segm_list) > 1:
                continue

            ann_list.append((cat_id, bbox, area))
            continue

            for segm in segm_list:
                bbox = segm2bbox(segm)
                if bbox[2] * bbox[3] > 20:
                    ann_list.append((cat_id, bbox, area))

        create_xml(ann_list, image_info, output_dir)


def dump_cls_mapper(coco, save_path):
    with open(save_path, 'w') as writer:
        for cat_id, cat_uid in coco.label_map.items():
            writer.write('%d\tcat-%d\t%s\n' % (cat_uid, cat_id, coco.catid2name[cat_id]))

def write_list(src, save_path):
    with open(save_path, 'w') as writer:
        for item in src:
            writer.write(item + '\n')

def create_per_class_list(coco, save_dir, prefix):
    all_imgIds = set(coco.coco.getImgIds())

    def cocoId2imgName(coco_id):
        image_info = coco.coco.loadImgs([coco_id])[0]
        image_fn = image_info['file_name']
        imgName, _ = os.path.splitext(image_fn)
        return imgName

    all_names = ['%s %d' % (cocoId2imgName(coco_id), idx + 1) for idx, coco_id in enumerate(all_imgIds)]
    write_list(all_names, os.path.join(save_dir, '%s.txt' % prefix))

    for cat_id, cat_uid in coco.label_map.items():

        pos_ids = coco.coco.getImgIds(catIds = [cat_id])
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

    dump_cls_mapper(coco, os.path.join(meta_dir, 'meta-det.txt'))
    create_per_class_list(coco, os.path.join(meta_dir, 'det_lists'), mode)

    create_bbox_xml(coco, output_dir)

    pass

if __name__ == "__main__":
    main()

# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
