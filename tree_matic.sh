#!/bin/bash
#       Name of Script:         tree_o_matic.sh
#       Purpose of Script:      Creating phylogenetic trees from protein or DNA sequences
#       Author's Name:          Maria G. Hinojosa, Graduate Student
#       Affiliation:            TAMIU
#       Date created:           Sun Apr 30 16:23:54 CDT 2017
#       Date modified:

# Usage notes:

read -p "Please input unzipped fasta name of protein or nucleotide w/o file extension: " Fname
#echo $Fname
read -p "Does $Fname file contain a protein or nucleotide sequence?: " seq_type
#echo $seq_type
read -p "Input resulting directory which will contain file for that sequence: " Dname

prot_blast ()
{
        mkdir ${Dname}
        mv ${Fname} ${Dname}
        cd ${Dname}
        blastp -query "$Fname" -db swissprot -out "$Fname"_o.txt -max_target_seqs 50 -outfmt 6 -remote
        awk '$2 >=30.0' "$Fname"_o.txt > "$Fname".30.txt
        cut -f2 "$Fname".30.txt > "$Fname".ids.txt
        a_id=( $( cat "$Fname".ids.txt ))
#       echo "${a_id[*]}"

        for i in ${a_id[@]} ; do
                efetch -db protein -format fasta -id $i > ${i}_${Fname}
        done
}

MSA_f ()
{
        a_msa=( $( ls *.faa ))

        for i in ${a_msa[@]} ; do
                cat $i >> aseqs${Fname}
        done
        mafft --localpair --maxiterate 2 aseqs${Fname} > ${Fname}1.msa
        mafft --retree 0 --treeout ${Fname}1.msa > ${Fname}.phy
        rm *.faa

}






if [ -f $Fname ] && [ -s $Fname ] && [ ! -z $Fname ] ; then
        echo "File exists and is not empty"
        if [ "$seq_type" == "protein" ] ; then
                prot_blast
                MSA_f
        elif [ $seq_type == "nucleotide" ] ; then
                nuc_blast
        else
                echo "Wrong sequence type inputted. Try again."
                exit 1
        fi
else
        echo "Either no file was inputted or file was empty. Try again."
        exit 1
