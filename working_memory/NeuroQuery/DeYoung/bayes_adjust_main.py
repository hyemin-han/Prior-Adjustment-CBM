import rpy2.robjects as robjects
from subprocess import Popen 
import numpy  
from datetime import datetime
import math
import os
import nibabel as nib
import bayes_correction_split as bcs
import bayes_correction_modlist as bcm
#import shutil

# additional parameter
# if minus = 1, then run Bayes_segment_minus.R for "<" contrast
def bayes_correction_main( mask, lists, cpus, scale , minus = 0, start = 0):
	# declare how many CPUs will be assigned
	processes = cpus

	# if cpus > max cpu in this computer,
	max_cpu = os.cpu_count()

	if processes > max_cpu:
		processes = max_cpu


	print("Current scale: %f" % scale)

	# get X size
	img = nib.load(mask)
	X = img.shape[0]

	# create processes
	process = [None] * processes

	flag = [0] * processes

	# get process list
	task = bcs.bayes_correction_split(mask, processes)

	# modify the list file to take into account relative path
	newfilename = bcm.bayes_correction_modlist(lists)

	# timestamp: start
	tstart = datetime.now()

	for i in range(processes):
		# start work
		current = task[i,0]
		endpoint = task[i,1]
		# minus?
		if (minus == 0):
			process[i] = Popen(['Rscript','--vanilla','Bayes_adjust_segment.R',str(i),str(current),str(endpoint),str(scale),newfilename,mask,str(start)])
		else:
			print('minus contrast!')
			process[i] = Popen(['Rscript','--vanilla','Bayes_adjust_segment_minus.R',str(i),str(current),str(endpoint),str(scale),newfilename,mask,str(start)])

		# print current process info (current to endpoint)
		print("Process ID: ", i," Start: ", current, " End:",endpoint)


	while 1:
		# for loop to monitor all processes
		for x in range(processes):
			# the current x process completed?
			if process[x].poll() is not None:
				if flag[x] == 0:
					print("Process ",str(x), "Done!! / total:", str(processes))
				flag[x] = 1
		# all processes completed? -> product should not be 0
		if numpy.prod(flag) > 0:
			# all done
			print('all done!')
			break	

	# successfully ended all the things
	# then reuturn 1

	# endpoint
	tend = datetime.now()
	elapse = tend - tstart
	print (elapse)

	# move output folder to the folder containing list
	#shutil.copy("./output", os.path.split(os.path.abspath(newfilename))[0]+"/output")

	# integrate all the results
	integrated_result = 0
	r1=robjects.r
	r1.source("integrate_result_adjust.R")
	integrated_result = r1.integrate_result(mask,start)

	# false alarm and hit rate
	# send file names (original file name and bf3_05.nii)

	# delete bf and d files

	return (integrated_result)
