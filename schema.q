// Defining a typical quotes table
quote:([] time:`timestamp$(); `g#sym:`symbol$(); src:`symbol$(); bid:`float$(); ask:`float$(); bsize:`int$(); asize:`int$());

// Defining a typical trade table
trade:([] time:`timestamp$(); `g#sym:`symbol$(); src:`symbol$(); price:`float$(); amount:`int$(); side:`symbol$());

// Defining the table t to compare estimated values to -22! and \ts calculated values
t:([]date:`date$(); size:`long$(); price:`float$(); side:`long$());

// A dictionary of tables and counts.
counts:(!) . flip (	(`trade;1000000);
			(`quote;10000000);
			(`t;1000000))

// Display table names, schemas and counts in the output
f:{-1"Loading schema for quote (10 million rows):\n"; show x;-1"\ntrade (1 million rows): \n"; show y; -1"\nand the table t that we defined above.\n"; show z; -1"Assuming 100000 distinct values.";}[quote;trade;t]
f[]

