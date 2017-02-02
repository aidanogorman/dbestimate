// Script to estimate the memory usage of a process based on supplied table schemas and table counts
/
Usage: Call script and pass in a schema file as comandline parameter
    e.g. q memusage.q path/to/schema.q -distincts x -avgsl y

Once loaded inspect the memsage dictionary for an estimate of memory usage for each table
    q)memusage[]
    quote| 596
    trade| 53
\

// Defining command line parameters. Inputs are the schema of tables to estimate, number of distinct values
// and the average string length of string/untyped columns
params:.Q.def[(`schema`distincts`avgsl)!(`schema.q; 10000; 15)].Q.opt .z.x

// Load schema file
system"l ",string params[`schema];

// Global Guesstimates

// The number of distinct values in any columns with a g attribute
// assumption here is that grouping will be on sym only
distincts:params[`distincts]

// The average length of a string field
// all untyped () columns are strings
avgstrlength:params[`avgsl]

// (16 bytes + attribute overheads + raw size) to the nearest power of 2
// c = row count
// s = element size
// a = attribute overhead
calcsize:{[c;s;a] `long$2 xexp ceiling 2 xlog 16+a+s*c};

// Function to calculate the overhead of the grouped attribute
// All other attributes are assumed to have zero overhead
attrsize:{$[`g=attr x;sum (calcsize[distincts;typesize x;0];calcsize[distincts;8;0];distincts * vectorsize[8;ceiling y%distincts]);0]};

// Determine column type. If 0h, calculate total pointer size and column size using
// the assumed avgstrlength value
vectorsize:{$[0h=type x; calcsize[y;8;0] + y*calcsize[avgstrlength;1;0];calcsize[y;typesize x;attrsize[x;y]]]};

// Raw size of atoms according to type, type 20h->76h have 4 bytes pointer size
typesize:{4^0N 1 16 0N 1 2 4 8 4 8 1 8 8 4 4 8 8 4 4 4 abs type x};

tablesize:{[t;c] vectorsize[cols t;count cols t] + sum vectorsize[;c] each value flip t:0!t};

// Calculate table sizes
dbestimate:{
	-1"\nSize per table in MB:"; 
	show r:(key counts)!`long$(tablesize'[value each key counts;value counts])%2 xexp 20;
	
	-1"Total size in MB:";
	show sum r;}

dbestimate[]
