import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, FallingEdge

@cocotb.test()
async def test_project(dut):
    dut._log.info("Starting Moore Machine Test")

    # Start the clock (Changed 'units' to 'unit' to satisfy warning)
    clock = Clock(dut.clk, 10, unit="us")
    cocotb.start_soon(clock.start())

    # Initialize inputs
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    
    # 1. Power-on Reset
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)

    # 2. Stimulus Sequence
    x1_sequence = [0, 1, 1, 0, 1]

    for x1 in x1_sequence:
        # FIX: Drive the whole 8-bit bus to avoid "Packed objects cannot be indexed"
        # x1 is placed at bit 0: ui_in[0]
        dut.ui_in.value = x1 
        
        await RisingEdge(dut.clk)
        await FallingEdge(dut.clk) 
        
        uo_val = str(dut.uo_out.value)
        dut._log.info(f"Input x1={x1} | uo_out={uo_val}")

    dut._log.info("Finished Moore Machine test successfully")
