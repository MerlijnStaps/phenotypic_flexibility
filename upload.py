import subprocess

print("Uploading Julia files ...")
subprocess.call(["rsync -av --progress *jl mstaps@della9.princeton.edu:/scratch/gpfs/CTARNITA/mstaps/flex/"],shell=True)

print("Uploading CSV files ...")
subprocess.call(["rsync -av --progress *csv mstaps@della9.princeton.edu:/scratch/gpfs/CTARNITA/mstaps/flex/"],shell=True)
