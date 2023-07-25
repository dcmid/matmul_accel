WORK_DIR := work

project: | $(WORK_DIR)
	vivado -mode batch -log work/vivado.log -jou work/vivado.jou -source build_scripts/set_up_project.tcl

build: | project $(WORK_DIR)
	vivado -mode batch -log work/vivado.log -jou work/vivado.jou -source build_scripts/compile.tcl

$(WORK_DIR):
	mkdir $(WORK_DIR)

clean:
	rm -rf ./$(WORK_DIR)/*

.PHONY: kcu105 edu etu stph9 gps_block_kcu105 gps_block_mini clean