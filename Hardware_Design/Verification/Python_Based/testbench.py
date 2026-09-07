import cocotb
from cocotb.triggers import Timer
import random 
import pandas as pd

# Clock;
def clock(clk):
    if(clk==0):
        clk = 1
    else:
        clk = 0
    
    return clk

@cocotb.test()
async def GELU(dut):
    # Initial values:-
    clk = 1

    i=-512
    while(i<=512):
        # Input signals:-
        clk = clock(clk)
        num = i

        # Ports:-
        dut.clk.value = clk
        dut.In.value = num

        await Timer(5,unit='ps')

        out = dut.out.value
        print("input=",num," Output=",out)
        i=i+1




