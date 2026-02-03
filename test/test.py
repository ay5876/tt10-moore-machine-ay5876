import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge

@cocotb.test()
async def test_project(dut):
    dut._log.info("Start Moore Machine Test")

    # Start a clock
    cocotb.start_soon(Clock(dut.clk, 10, units="us").start())

    # Required for Tiny Tapeout
    if hasattr(dut, "ena"):
        dut.ena.value = 1

    # Initialize inputs
    dut.ui_in.value = 0
    dut.uio_in.value = 0

    # Reset active-low
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 2)

    dut.rst_n.value = 1
    await RisingEdge(dut.clk)

    # x1 sequence like manual
    x1_sequence = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0]

    for x1 in x1_sequence:
        # SAFEST way (avoids packed-bus indexing issues):
        current = dut.ui_in.value.integer
        dut.ui_in.value = (current & ~1) | (x1 & 1)

        await RisingEdge(dut.clk)

        # Log outputs: uo_out[0]=z1, uo_out[1..3]=y bits
        dut._log.info(f"x1={x1} uo_out={dut.uo_out.value.binstr}")

    await ClockCycles(dut.clk, 5)
    dut._log.info("Finished Moore Machine Test")
