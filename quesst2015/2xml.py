#!/usr/bin/python

import xml.etree.cElementTree as ET

stdlist = ET.Element("stdlist", termlist_filename="quesst2015_dev.tlist.xml", indexing_time="1.00", language="mul", index_size="1", system_id="Vagrant STD System")

with open('Example/output/fusion.csv') as f:
    lines = f.read().splitlines()

queries = {}

for hit in lines:
    termid = hit.split()[1]
    if termid in queries:
        queries[termid].append(hit)
    else:
        queries[termid]=[hit]

for query in queries.keys():
    print query

    detected = ET.SubElement(stdlist, "detected_termlist", termid=query, term_search_time="1.00", oov_term_count="1")
    for hit in queries[query]:
        score = float(hit.split()[2])
        if score < -10:
            continue
        elif score > -0.4:
            decision = "YES"
        else:
            decision = "NO"
        term  = ET.SubElement(detected, "term", file=hit.split()[0], channel="1", tbeg="0", dur="10", score="%f" % score, decision=decision)

tree = ET.ElementTree(stdlist)
tree.write("Example/output/quesst2015.stdlist.xml",encoding="UTF-8",xml_declaration=True)
