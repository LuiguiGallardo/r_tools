#!/usr/bin/env python3
__title__="plotter_regions.py"
__purpose__="Creates a plot with AAR and pred information."
__author__="Luigui Gallardo-Becerra (bfllg77@gmail.com)"
__date__="03.05.2022"

# Import libraries
import argparse
import matplotlib.pyplot as plt

# Arguments input:
parser=argparse.ArgumentParser()

parser.add_argument('-1', '--aar',
    required=True,
    type=argparse.FileType('r'),
    help="AAR input file")

parser.add_argument('-2', '--pred',
    required=True,
    type=argparse.FileType('r'),
    help="Pred input file")

parser.add_argument('-o', '--output',
    required=True,
    help="Output figure")

parser.add_argument('-t', '--title',
    help="Title.")

parser.add_argument('-f', '--figure',
    help="Type of figure (1 or 2)")

args=parser.parse_args()

# Beginning: 
class Plotter:
    def __init__(self, aar, pred, output, title):
        self.aar = aar
        self.pred = pred
        self.output = output
        self.title = title

    def cleaner_aar(self):
        aar_cleansed = ''
        for line in self.aar:
            pointer = line.strip()
            if pointer.startswith(".") or pointer.startswith("E"):
                aar_cleansed += line.rstrip()

        return aar_cleansed

    def cleaner_pred(self):
        pred_cleansed = ''
        for line in self.pred:
            pointer = line.strip()
            if not pointer.startswith("#"):
                pred_cleansed += line.rstrip()
        
        return pred_cleansed

    def merged(self):
        aar_cleansed = Plotter.cleaner_aar(self)
        pred_cleansed = Plotter.cleaner_pred(self)
        merged_table = {"aminoacid_position": [s for s in range(len(aar_cleansed))], "aar_result": list(aar_cleansed), "pred_result": list(pred_cleansed)}
        return merged_table

    def plot1(self):
        merged = Plotter.merged(self)

        plt.figure()
        plt.subplot(211)
        plt.suptitle(self.title)
        plt.plot(merged["aminoacid_position"], merged["aar_result"])
        plt.ylabel('AAR result')
        plt.xticks([])

        plt.subplot(212)
        plt.plot(merged["aminoacid_position"], merged["pred_result"], 'orange')
        plt.ylabel('Pred result')
        plt.xlabel('Aminoacid position')

        plt.savefig(self.output)

    def plot2(self):
        merged = Plotter.merged(self)
        
        fig, ax1 = plt.subplots()

        color = 'tab:orange'
        ax1.set_xlabel('Aminoacid position')
        ax1.set_ylabel('AAR result', color=color)
        ax1.plot(merged["aminoacid_position"], merged["aar_result"], color=color)
        ax1.tick_params(axis='y', labelcolor=color)

        ax2 = ax1.twinx()

        color = 'tab:blue'
        ax2.set_ylabel('Pred result', color=color)
        ax2.plot(merged["aminoacid_position"], merged["pred_result"], color=color)
        ax2.tick_params(axis='y', labelcolor=color)

        fig.tight_layout()

        plt.savefig(self.output)

# The end!

# Execution
def main():
    plotter = Plotter(args.aar, args.pred, args.output, args.title)
    print(args.figure)
    if args.figure == "2":
        plotter.plot2()
    else:
        plotter.plot1()


if __name__ == "__main__":
    main()
