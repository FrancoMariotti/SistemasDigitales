import numpy as np
import csv

A_MULT_SIZE = 30
B_MULT_SIZE = 30
A_MULT_MAX = 30
B_MULT_MAX = 30

A_ADD_SIZE = 100
B_ADD_SIZE = 100
A_ADD_MAX = 50
A_ADD_MIN = -50
B_ADD_MAX = 100

N = 8


def generate_multiplier_test_file():
	a = np.arange(A_MULT_MAX)
	b = np.arange(B_MULT_MAX)

	with open('multiplier.csv', 'w') as file:
	    writer = csv.writer(file, delimiter=' ')
	    for i in range(1,A_MULT_SIZE):
	    	for j in range(1,B_MULT_SIZE):
	    		writer.writerow([a[i],b[j],a[i]*b[j]])

def generate_adder_test_file():
	a = np.arange(A_ADD_MIN,A_ADD_MAX)
	b = np.arange(B_ADD_MAX)

	with open('adder.csv', 'w') as file:
	    writer = csv.writer(file, delimiter=' ')
	    for i in range(A_ADD_SIZE):
	    	for j in range(B_ADD_SIZE):
	    		a_file = a[i]
	    		b_file = b[j]
	    		z_file = a[i] + b[j]
	    		#if (a_file < 0):
	    		#	a_file = a_file + (2**N)
	    		#if (z_file < 0):
	    		#	z_file = z_file + (2**N)
	    		writer.writerow([a_file,b_file,z_file])


def main():
	generate_adder_test_file();
	generate_multiplier_test_file();


main();
