#!/usr/bin/env nextflow
This is an invalid file
Channel
    .fromPath(params.bamfile)
    .into{ flagstat_bamfile; bamqc_bamfile}

process flagstat {
    input:
    val bamfile from flagstat_bamfile

    output:
    file 'flagstat.json' into flagstat_result

    """
    ${params.samtools} flagstat ${bamfile} | ${params.flagstat_to_json} > 'flagstat.json'
    """
}

bedfile_channel = Channel.fromPath(params.bedfile)

process bamqc {
    input:
    val bamfile from bamqc_bamfile
    val bedfile from bedfile_channel
    val xtra_json from flagstat_result
    file outjson from params.outjson

    output:
    file "${outjson}" into bamqc_output_channel

    """
    ${params.samtools} view  ${bamfile} | perl ${params.bamqc_pl} -r ${bedfile} -j ${xtra_json} > ${outjson}
    """
}
