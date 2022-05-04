#!/usr/bin/env python3
__title__="venngi.py"
__purpose__="Creates Venn diagrams plots."
__author__="Luigui Gallardo-Becerra (bfllg77@gmail.com)"
__date__="15.08.2021"

# Import libraries
import argparse
from matplotlib import pyplot
from matplotlib_venn import venn2, venn2_unweighted, venn3, venn3_unweighted

# Arguments input:
parser=argparse.ArgumentParser()
parser.add_argument('-1', '--input1',
    required=True,
    type=argparse.FileType('r'),
    help="First input file.")
parser.add_argument('-2', '--input2',
    required=True,
    type=argparse.FileType('r'),
    help="Second input file.")
parser.add_argument('-3', '--input3',
    type=argparse.FileType('r'),
    help="Third input file.")
parser.add_argument('-o', '--output',
    required=True,
    help="Output files prefix.")
parser.add_argument('-t', '--title',
    help="Title.")

args=parser.parse_args()

# Beginning of the script
class Venn:
    def __init__(self, file1, file2, figure, title, file3=None):
        self.file1=file1
        self.file2=file2
        self.file3=file3
        self.figure=figure
        self.title=title

    def list(self, file):
        items=[]
        for item in file:
            if item.strip() not in items:
                pass
            else:
                items.append(item.strip())

    def venn2_svg(self):
        items1=list(self.file1)
        items2=list(self.file2)
        items1_2=[]
        for item1 in items1:
            if item1 in items2:
                items1_2.append(item1)
        
        # Creation of Venn Diagram 
        venn2_unweighted(subsets=(
            (len(items1)-len(items1_2)),
            (len(items2)-len(items1_2)),
            len(items1_2)),
            set_labels=(name_file1, name_file2))
        pyplot.title(self.title)
        pyplot.savefig(self.figure)

        # Creation of files
        items1_2_file = open("shared_group1_group2.txt", "x")
        items1_2_file.writelines(items1_2)
        items1_2_file.close() 

    def venn3_svg(self):
        items1=list(self.file1)
        items2=list(self.file2)
        items3=list(self.file3)
        items1_2=[]
        items1_3=[]
        items2_3=[]
        items1_2_3=[]

        for item1 in items1:
            if item1 in items2:
                items1_2.append(item1)

        for item1 in items1:
            if item1 in items3:
                items1_3.append(item1)

        for item2 in items2:
            if item2 in items3:
                items2_3.append(item2)

        for item1_2 in items1_2:
            if item1_2 in items3:
                items1_2_3.append(item1_2)

        # Creation of Venn Diagram
        venn3_unweighted(subsets=(
            (len(items1)-len(items1_2)-len(items1_3)+len(items1_2_3)),
            (len(items2)-len(items1_2)-len(items2_3)+len(items1_2_3)),
            (len(items1_2)-len(items1_2_3)),
            (len(items3)-len(items1_3)-len(items2_3)+len(items1_2_3)),
            (len(items1_3)-len(items1_2_3)),
            (len(items2_3)-len(items1_2_3)),
            len(items1_2_3)),
            set_labels=(name_file1, name_file2, name_file3))
        pyplot.savefig(self.figure)

        # Creation of files
        items1_2_file = open("shared_group1_group2.txt", "x")
        items1_2_file.writelines(items1_2)
        items1_2_file.close()

        items1_3_file = open("shared_group1_group3.txt", "x")
        items1_3_file.writelines(items1_3)
        items1_3_file.close()

        items2_3_file = open("shared_group2_group3.txt", "x")
        items2_3_file.writelines(items2_3)
        items2_3_file.close()

        items1_2_3_file = open("shared_allgroups.txt", "x")
        items1_2_3_file.writelines(items1_2_3)
        items1_2_3_file.close()

        


if args.input3 != None:
    name_file1=str(args.input1.name).replace(".txt", "")
    name_file2=str(args.input2.name).replace(".txt", "")
    name_file3=str(args.input3.name).replace(".txt", "")
    venn=Venn(args.input1, args.input2, args.output, args.input3)
    venn.venn3_svg()
else:
    name_file1=str(args.input1.name).replace(".txt", "")
    name_file2=str(args.input2.name).replace(".txt", "")
    venn=Venn(args.input1, args.input2, args.output, args.title)
    venn.venn2_svg()

# The end!