


1.Run AlignPools.sh to trim reads and align the to the reference
2.Run Samsort.sh to create a .sort file\
3.Run picard_indel.sh to to soft-clip alignments beyond the end of reference sequences and to set the mapping quality to 0 for unmapped reads and to target and realign reads around indels.
4. Run Samsort2.sh 
5. Run mpileup_script.sh  script to convert the .sort files to .mpileup files for each pool
6. Run make_masters.sh  run make_masters.sh to create a master mpileup file and a master sync file

