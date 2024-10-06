PDFLATEX = pdflatex

all: report.pdf

report.pdf: report.tex
	$(PDFLATEX) $<
	$(PDFLATEX) $<

clean:
	rm -f *.aux *.log *.pdf *.out *.toc

.PHONY: all clean help
