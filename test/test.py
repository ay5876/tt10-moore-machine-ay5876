import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, FallingEdge

@cocotb.test()
async def test_project(dut):
    dut._log.info("Starting Moore Machine Test")

    # Start the clock
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Initialize inputs
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    
    # 1. Power-on Reset: Long enough for Gate-Level initialization
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)

    # 2. Stimulus Sequence
    x1_sequence = [0, 1, 1, 0, 1]

    for x1 in x1_sequence:
        dut.ui_in[0].value = x1
        
        await RisingEdge(dut.clk)
        # Wait for signals to settle before reading (fixes GL 'X' errors)
        await FallingEdge(dut.clk) 
        
        uo_val = str(dut.uo_out.value)
        dut._log.info(f"Input x1={x1} | uo_out={uo_val}")

    dut._log.info("Finished Moore Machine test successfully")
