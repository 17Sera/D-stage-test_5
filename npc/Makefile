MODULE = ysyxSoCFull
#   ysyx_25080202
# CSRCS = $(shell find $(abspath ./csrc) -name "*.cpp")
# VSRCS = $(shell find $(abspath ./vsrc) -name "*.v")		
VSRCS = $(shell find $(abspath ./) -name "*.v")		
VSRCS += $(shell find $(abspath ../patch/ysyxSoC/ready-to-run/D-stage/*) -name "*.v")
VSRCS += $(shell find $(abspath ../patch/ysyxSoC/perip/*) -name "*.v")	


YSYXSOC_PATH = $(NPC_HOME)/../patch/ysyxSoC
YSYXSOC_PERIP_PATH = $(YSYXSOC_PATH)/perip
YSYXSOC_UART_PATH = $(YSYXSOC_PERIP_PATH)/uart16550/rtl/
YSYXSOC_SPI_PATH = $(YSYXSOC_PERIP_PATH)/spi/rtl/

# INC_PATH = $(NPC_HOME)/include/	
LIBS = -lreadline   # 链接的库文件 link the <readline> lib
LIBS += -ldl        # 链接的库文件 link the <dlfcn> lib
LIBS += $(shell llvm-config-11 --libs)	
CXXFLAGS += $(shell llvm-config-11 --cxxflags) -fPIE

# LDFLAGS += "-lSDL2 -lLLVM-11 -ldl"	#指定链接器

VERILATOR_FLAGS += -Wno-STMTDLY -Wno-MODDUP	# -O3 # 忽略某些语句的延迟警告，忽略重复模块重复定义的警告
VERILATOR_FLAGS += --trace
VERILATOR_FLAGS += --timescale "1ns/1ns"
VERILATOR_FLAGS += --no-timing
VERILATOR_FLAGS += --top-module $(MODULE) -cc $(VSRCS) --exe $(CSRCS)
VERILATOR_FLAGS += -I$(YSYXSOC_UART_PATH) -I$(YSYXSOC_SPI_PATH)
# VERILATOR_FLAGS += -I$(INC_PATH) -I$(YSYXSOC_UART_PATH) -I$(YSYXSOC_SPI_PATH)
VERILATOR_FLAGS += --prof-c --prof-cfuncs --prof-exec # 启用C代码性能分析
VERILATOR_FLAGS += --autoflush	#自动刷新输出缓冲区
# VERILATOR_FLAGS += --x-assign fast --x-initial fast	# 提高仿真速度
# VERILATOR_FLAGS += +define+USING_DPI_C


DIFF_REF_PATH = $(NEMU_HOME)
DIFF_REF_SO = $(DIFF_REF_PATH)/build/riscv32-nemu-interpreter-so
ARGS_DIFF = --diff=$(DIFF_REF_SO)


.PHONY:gtkw
gtkw: wave.gtkw	
	@echo
	@echo "### WAVES ###"
	gtkwave wave.gtkw


.PHONY:sim
sim: waveform.vcd


.PHONY:waves
waves: waveform.vcd
	@echo
	@echo "### WAVES ###"
	gtkwave waveform.vcd


.PHONY:waveform.vcd
waveform.vcd: ./obj_dir/V$(MODULE)
	@echo
	@echo "### SIMULATING ###"
	@./obj_dir/V$(MODULE) #+verilator+rand+reset+2


# loaded by AM Makefile (npc.mk)
IMG ?=
ARGSFLAGE += --log=./log/npc-log.txt
ARGSFLAGE += $(ARGS_DIFF)
ARGSFLAGE += $(ARGS)
# ifdef CONFIG_DIFFTEST
# override ARGSFLAGE += $(ARGS_DIFF)	
# endif
BINARY := ./obj_dir/V$(MODULE)
NEMU_EXEC := $(BINARY) $(ARGSFLAGE) $(IMG) 


.PHONY:run-env
ifdef CONFIG_DIFFTEST			
run-env: $(BINARY) $(DIFF_REF_SO)
else
run-env: $(BINARY) #$(DIFF_REF_SO)
endif


.PHONY:run
run: run-env
	$(NEMU_EXEC)


.PHONY:gdb								
gdb: run-env
	gdb -s $(BINARY) --args $(NEMU_EXEC)


.PHONY:build
build: $(BINARY)

#----------------------------------------------------------------------------------

./obj_dir/V$(MODULE): .zhong.verilate
	@echo
	@echo "------------- BUILDING SIM -------------"
	make -C obj_dir -f V$(MODULE).mk V$(MODULE)


.PHONY:verilate
verilate: .zhong.verilate


# # --------------------------------------------------------------------------------
# # -Wno-MODDUP 避免“Duplicate declaration”报错
# # --top-module $(MODULE) 确定底层模块，否则会将$(VSRCS)中的第一个文件前缀当成顶层模块
#----------------------------------------------------------------------------------	
.zhong.verilate: $(VSRCS) $(CSRCS)	
	@echo
	@echo "-------------- VERILATING --------------"
	verilator  $(VERILATOR_FLAGS) 	#-LDFLAGS $(LDFLAGS)

	@echo "LIBS +=$(LIBS)" >> ./obj_dir/V$(MODULE).mk 
	@touch .zhong.verilate


# #make lint目标调用 Verilator 并使用 --lint-only 选项，可以快速解析.v文件并检查问题
#----------------------------------------------------------------------------------
.PHONY:lint
lint: $(MODULE).v
#-lint-only- 告诉 Verilator 进行 lint 但不生成任何仿真输出
	verilator --lint-only $(MODULE).v


.PHONY: clean
clean:
	rm -rf .zhong.* || true
	rm -rf ./obj_dir || true
	rm -f waveform.vcd || true
	rm -f waveform.vcd.hier || true
	rm ./log/*  || true