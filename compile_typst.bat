:: Compile typst documents
@ECHO OFF

ECHO Compiling assignment 1 presentation...
typst compile assignment_1/presentation/main.typ assignment_1_presentation.pdf

ECHO Compiling assignment 1 report...
typst compile assignment_1/report/main.typ assignment_1_report.pdf

ECHO Done.