#Read all TextGrid files in a folder
Create Strings as file list: "gridlist", "./*.TextGrid"

select Strings gridlist
n = Get number of strings

for i from 1 to n
	select Strings gridlist
	grid$ = Get string: i
	csv$ = grid$- ".TextGrid" + "_duration.csv"
	Read from file: "./'grid$'"
	Down to Table: "no", 6, "yes", "no"
	Append difference column: "tmax", "tmin", "Duration"
	Save as comma-separated file: "./'csv$'"
endfor
