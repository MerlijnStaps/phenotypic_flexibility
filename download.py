import os, subprocess

dir = os.getcwd().split("/")[-1]

if dir == "results":
    print("Please move back to the main folder first")
else:
    print("Downloading all results ...")
    subprocess.call(["rsync -av --progress 'mstaps@della9.princeton.edu:/scratch/gpfs/CTARNITA/mstaps/flex/results/*csv' results"],shell=True)
    subprocess.call(["rsync -av --progress 'mstaps@della9.princeton.edu:/scratch/gpfs/CTARNITA/mstaps/flex/results/*gz' results"],shell=True)
    subprocess.call(["rsync -av --progress 'mstaps@della9.princeton.edu:/scratch/gpfs/CTARNITA/mstaps/flex/sims/*csv' sims"],shell=True)
