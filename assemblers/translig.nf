process TransLiG {

    publishDir "results/assembler/$sampleName", mode: 'copy'

    input:
    path reads_left
    path reads_right
    val sampleName

    output:
    path "trans-lig_contigs.fa", emit: contigs

    //this tool is a bit crappy, one needs to move in the directory of the tool
    //for some reason, this will cause pathing problems when trying to move the workflow to another machine 
    script:
    """
    # Save the current directory
    ORIG_DIR=\$(pwd)

    # Change to the TransLiG directory
    TRANSLIG_DIR=/vol/jlab/tlin/software/assemblers/TransLiG_1.3 
    cd \$TRANSLIG_DIR

    # Run the TransLiG binary with all provided arguments
    ./TransLiG -s fq -p pair -l \$ORIG_DIR/$reads_left -r \$ORIG_DIR/$reads_right -o \$ORIG_DIR/translig_results

    # Change back to the original directory
    cd \$ORIG_DIR
    mv translig_results/TransLiG.fa trans-lig_contigs.fa
    """
}
