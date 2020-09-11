all: data output_data

data: input/data.csv

input/data.csv: scripts/get_data.sh
	bash $<

output_data: scripts/format_data.R
	Rscript $<


