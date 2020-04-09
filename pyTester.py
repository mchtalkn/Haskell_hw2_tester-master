import pexpect
import sys
from subprocess import Popen, PIPE, STDOUT
import time
from sys import stdin

REPL_PS = str('>')
LOOPS = 100
test_input= open("test_input.txt","r")
test_out=open("test_output.txt","r")
output_file=open("output_file.txt","w+")
custom_out_txt=open("custom_output.txt","w+")
repl = pexpect.spawnu('ghci tester.hs')
def proces_input(repl,test_input,output_file,test_out):
    repl.expect(REPL_PS)
    inp_lines = test_input.readlines()
    out_lines =[]
    for inp in inp_lines:
        if(inp=="end" or inp=="end\n"):
            return
        out=test_out.readline()
        if( inp[:3]=="ass"):
            repl.sendline("tester' " "("+inp[:-1]+")"+" "+"("+out[:-1]+")\n")
        else:
            repl.sendline("("+inp[:-1]+")"+"=="+"("+out[:-1]+")\n")
        _, haskell_output = repl.readline(), repl.readline()
        haskell_output=haskell_output[7:]
        #for unix
        #if(haskell_output!="True\n"):
        if(haskell_output!="True\r\n"):
            repl.expect(">")
            repl.expect(">")
            repl.sendline(inp)
            _, wrong_out = repl.readline(), repl.readline()
            print("input:"+inp[:]+"expected:"+out+"given:"+wrong_out[7:])
            output_file.write("input:"+inp[:]+"expected:"+out+"given:"+wrong_out[7:])
        repl.expect(">")
        repl.expect(">")
        inp=test_input.readline()
    repl.sendline(":q")


def generate_output(repl,input_file,output_file):
    repl.expect(REPL_PS)
    inp_lines = input_file.readlines()
    out_lines =[]
    for inp in inp_lines:
        if(inp=="end"):
            break
        out=test_out.readline()
        repl.sendline(inp)
        _, haskell_output = repl.readline(), repl.readline()
        haskell_output=haskell_output[7:]
        #for unix
        #if(haskell_output!="True\n"):

        output_file.write(haskell_output)
        repl.expect(">")
        repl.expect(">")
        inp=input_file.readline()
    output_file.write("end\n")
proces_input(repl,test_input,output_file,test_out)
test_input.close()
input_file= open("custom_input.txt","r")
repl = pexpect.spawnu('ghci HW2.hs')
generate_output(repl,input_file,custom_out_txt)
