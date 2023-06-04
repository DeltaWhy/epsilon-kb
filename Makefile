.PHONY: all clean svg

all: gerbers epsilon-kb-gerbers.zip svg epsilon-kb.board.step epsilon-kb.assembly.step

svg: epsilon-kb.top.svg epsilon-kb.bottom.svg

clean:
	rm -rf gerbers epsilon-kb.top.svg epsilon-kb.bottom.svg

gerbers: gerbers/epsilon-kb-job.gbrjob gerbers/epsilon-kb.drl

%.assembly.step: epsilon-kb.kicad_pcb
	kicad-cli pcb export step -o $@ --subst-models $<

%.board.step: epsilon-kb.kicad_pcb
	kicad-cli pcb export step -o $@ --min-distance 0.1 --board-only $<

%.gbrjob: epsilon-kb.kicad_pcb
	mkdir -p gerbers
	kicad-cli pcb export gerbers -o gerbers $<

%.drl: epsilon-kb.kicad_pcb
	mkdir -p gerbers
	kicad-cli pcb export drill -o gerbers/ $<

epsilon-kb-gerbers.zip: gerbers
	rm -f $@
	zip -r $@ $<

%.svg: gerbers
	npx @tracespace/cli -L gerbers/*{Cuts,Cu,Mask,Paste,Silkscreen,.drl}* -b.color.sm="rgba(00,00,00,0.85)" -b.outlineGapFill=0.01
