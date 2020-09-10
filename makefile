data: input/data.csv

input/data.csv: scripts/get_data.sh
	bash $<
