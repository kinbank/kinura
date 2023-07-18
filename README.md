Kinura
============================


[![DOI](https://zenodo.org/badge/379448021.svg)](https://zenodo.org/badge/latestdoi/379448021)


This repository contains kinship terminology from the Kinura project. 


To add a new language:
----------------------
1.	Add metadata describing the language to ./etc/languages.csv
2.  Create a new csv file with the headings: `parameter, word, ipa, description, alternative, source_raw, source_bibtex, comment`
3.	Save the csv file created in 2. into ./raw
4.	Add a bibtex formatted reference into ./raw/sources.bib
5.	Regenerate the CLDF dataset 

*Notes for creating a new datafile*

*Reference Identifier*

Before adding the csv file into ./raw/ please pay attention to the format in which the reference info is given in the source_bibtex column. The identifier used in the data file connects the raw data tothe correct reference in ./raw/sources.bib file (step 4). The identifier in source_bibtex column should not contain spaces or special characters and not be the same as any other identifier already in Kinbank. Commonly, we use the format surname_year, but this is not mandatory. Many reference managers will create a suitable identifier automatically. Please put page numbers (if applicable) in the comments column. 

*Reference format for ./raw/sources.bib*

The format of the reference should be in BibTex format. A simple way to receive a reference in BibTeX format is to extract it from a reference manager. Each manager will have their own peculiarities, but in general, right clicking a reference and choosing "Export" should provide a BibTex option. Paste the BibTex reference into ./raw/sources.bib file. 

After the first curly brackets and before the first comma there is the identification term. This is the term that needs to match with the term in the source_bibtex column created in 2. 

To Generate a CLDF dataset:
---------------------------

The shell utility [make](https://www.gnu.org/software/make/) and the programming language [python (v3.6+)](https://www.python.org/) are required. 
If you don't have access to these tools, contact an administrator of the repository about regenerating the CLDF formatted data. 

**CLDF compiling is necessary for the data to be pushed through the pipeline and to apprea in the main dataset and website.**

1. Install the python requirements:

The libraries needed for the python merge script are [cldfbench](https://pypi.org/project/cldfbench/0.2.0/) and [pylexibank](https://pypi.org/project/pylexibank/). These will be
installed into a virtual environment using this command:

```shell
make install
```

2. Generate CLDF:

```shell
make cldf
```
