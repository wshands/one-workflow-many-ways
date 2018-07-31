#!/usr/bin/env nextflow

params.bamfile = 'file.bam'
params.bedfile = 'file.bed'
params.outjson = 'bamqc_output.json'

bamfile_channel = Channel.fromPath(params.bamfile)
bedfile_channel = Channel.fromPath(params.bedfile)

process flagstat {
    input:
    file flagstat_to_json
    file bamfile from bedfile_channel

    output:
    file flagstat_json into flagstat_result

    """
    ${env.samtools} flagstat ${bamfile} | ${env.flagstat_to_json} > 'flagstat.json'
    """
}

process bamqc {
    input:
    file bamfile from bamfile_channel
    file bedfile from bedfile_channel
    file xtra_json from flagstat_result

    output:
    file outputfile

    """
    eval '${env.samtools} view  ${bamfile} | perl ${env.bamqc_pl} -r ${bedfile} -j ${xtra_json} > ${params.outjson}'
    """
}