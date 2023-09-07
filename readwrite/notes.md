---
output: 
  html_document: 
    theme: journal
    fig_caption: yes
---
# Notes on how to design a flexible statistical analysis pipeline

## What matters from the computer's architecture perspective

Data are streamed from the disk to main memory, from memory to caches, and from caches to CPU registers.
Modern CPUs (i.e., processors) have multiple cores.
Each core has its own `register file`, `memory management unit`, `L1 data`, and `L1 instruction` caches.
Every computer program has this structure:

1. load
2. transform
3. store

Data must be loaded from disk to registers in order to transform them and persistently store the results to ensure they will be available for subsequent analysis steps.
This ensures it is not necessary to run again all the expensive computations performed on the raw data.
It's especially important if we are dealing with huge files that do not fit in memory all at once.
In this scenario, the critical point is to identify the operations that must be carried out on the data.
This and the research question(s) help to figure out how to identify the `minimal batch size` for manipulation.

## Batch mode and streaming

Once determined the minimal batch size, data can be loaded in batches.
This necessarily means that the data constitutes a `stream of bytes` from disk to memory, caches, and registers.

## Data structure as interface

Data are streamed in order to be manipulated.
The input data have a specific structure.
The `structure` of the data is what makes possible for them to actually become `information` instead of just raw bytes without any meaning.
The set of transformations determines the optimal data structure that must be used in order for our program to be `fast` and `efficient`.
The `output data structure` determines the `interface` to which any program must adhere in order to manipulate data outputted by the program.

## Fetching raw data

This is the `entry point` in a statistical analysis pipeline.
Raw data can be acquired in multiple ways depending on the computing infrastructure *(e.g., database on remote servers)*.
The important thing to note is that the format of the raw data is **NOT UNDER OUR CONTROL**.
This means that if for any reason in the future a file format changes, our program will no longer be able to recognize the raw data and manipulate them properly.
It's `crucial` to isolate the step of fetching the raw data in our pipeline.

## Factors that influence the pipeline's design

The type and format of the raw data have a very important impact on the design of our statistical analysis pipeline.
Certain data are provided for each individual.
For example, the genome sequence of one individual, the transcriptome sequence of one individual, the variant calling file of one individual, etc.
This inevitably affects our statistical analysis pipeline.

## The most important question

`What is the goal of our analysis?`

Let's suppose that we are going to compute some feature of interest for each `individual`.
This means that we are going to run the `same` analysis on *EVERY* individual in our study.
As well, this means that the program will generates an output for each individual.
This makes possible to obtain *(ideally)* a lighter file with the results of the individual analysis.
The output can be stored in a directory *(e.g., output_individual_analysis/)* and this makes it very portable across different machines.

## How many files for each individual

This depends on what should be done in the next step of the pipeline.
If there is just one single way for the data towards the pipeline, there will be one file for each individual, otherwise more than one.
The important point of the individual analysis is to generate the results of the statistical analysis carried out on each individual from the raw data.
The goal is to make the next steps down in the pipeline faster and decoupled from the huge raw data file.

## From individual to aggregate analysis

The next step to take into the analysis also depends on our research question(s).
Typically the goal is to understand if individuals with similar traits *(among those extracted from the individual data analysis)* relate to the outcome of interest.
This means that the input to such `aggregate` analysis requires an intermediate step.

## Intermediate

Storing the output from each individual analysis in an isolated file gives the flexibility to create other files for the subsequent aggregate analysis.
If multiple analysis must be carried out, then it is possible to aggregate in multiple ways the files of each individual accordingly into an `aggregate file`.

For example, suppose there is an interest in studying specific genomic regions in multiple populations of subjects.
It is possible to create a file that contains on the rows the `subject ID` and on the columns all the `features of interest` extracted from the individual analysis *(e.g., start position of a gene on a chromosome, or number of SNPs in one genomic region, etc.)*.

## Aggregate analysis

The `aggregation file` defines the input interface to the aggregate analysis step.
This time there will be an output file for each investigated subgroup.

## Graphical analysis

This is the last step in the analysis.
In the pipeline there can be multiple graphical analysis carried out on multiple data.
This can be isolated and the graphical results stored in a dedicated directory.
Further, isolating the creation of the graphs makes the analysis more efficient since it does not require to draw graphs every time.
A `step` can be executed only when needed.

## Miscellaneous

Splitting the pipeline into multiple steps gives much more flexibility to customize each step.
Different stages may have custom configuration parameters and custom loggers.
This is one big advantage of a good pipeline design.
