AM_SRCS := riscv/npc/start.S \
           riscv/npc/trm.c \
           riscv/npc/ioe.c \
           riscv/npc/timer.c \
           riscv/npc/input.c \
           riscv/npc/cte.c \
           riscv/npc/trap.S \
           platform/dummy/vme.c \
           platform/dummy/mpe.c

CFLAGS    += -fdata-sections -ffunction-sections
LDSCRIPTS += $(AM_HOME)/scripts/linker.ld
LDFLAGS   += --defsym=_pmem_start=0x80000000 --defsym=_entry_offset=0x0
LDFLAGS   += --gc-sections -e _start

MAINARGS_MAX_LEN = 64
MAINARGS_PLACEHOLDER = the_insert-arg_rule_in_Makefile_will_insert_mainargs_here
CFLAGS += -DMAINARGS_MAX_LEN=$(MAINARGS_MAX_LEN) -DMAINARGS_PLACEHOLDER=$(MAINARGS_PLACEHOLDER)

insert-arg: image
	@python $(AM_HOME)/tools/insert-arg.py $(IMAGE).bin $(MAINARGS_MAX_LEN) $(MAINARGS_PLACEHOLDER) "$(mainargs)"

# image: image-dep
# 	@$(OBJDUMP) -d $(IMAGE).elf > $(IMAGE).txt
# 	@echo + OBJCOPY "->" $(IMAGE_REL).bin
# 	@$(OBJCOPY) -S --set-section-flags .bss=alloc,contents -O binary $(IMAGE).elf $(IMAGE).bin


image: image-dep
	@$(OBJDUMP) -d $(IMAGE).elf > $(IMAGE).txt
	@echo + OBJCOPY "->" $(IMAGE_REL).bin
	@$(OBJCOPY) -S --set-section-flags .bss=alloc,contents -O binary $(IMAGE).elf $(IMAGE).bin

ELF_OFFSET := 370432

HELLO_TEMPLATE := $(YSYX_HOME)/ysyxSoC/ready-to-run/D-stage/hello-minirv-ysyxsoc.bin

IMAGE_BIN := $(IMAGE).bin

$(IMAGE_BIN): $(IMAGE).elf $(HELLO_TEMPLATE)
	@echo "  PATCH  $@"
	@cp $(HELLO_TEMPLATE) $@.tmp
	@dd if=$< of=$@.tmp bs=1 seek=$(ELF_OFFSET) conv=notrunc 2>/dev/null
	@mv $@.tmp $@


image: $(IMAGE_BIN)
	@$(OBJDUMP) -d $(IMAGE).elf > $(IMAGE).txt

run: insert-arg
	$(MAKE) -C $(NPC_HOME) clean-trace
	$(MAKE) -C $(NPC_HOME) clean
	$(MAKE) -C $(NPC_HOME) ISA=$(ISA) run IMG=$(IMG) ELF=$(ELF)
	$(info [DEBUG] IMG = $(IMG))


# run: insert-arg
# 	echo "TODO: add command here to run simulation"

.PHONY: insert-arg
