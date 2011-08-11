package ApiCommonWorkflow::Main::WorkflowSteps::MakeAnnotatedTranscriptsDownloadFile;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::DownloadFileMaker);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::DownloadFileMaker;



sub getDownloadFileCmd {
  my ($self, $downloadFileName, $test) = @_;

  # get parameters
  my $organismSource = $self->getParamValue('organismSource');
  my $deprecated = ($self->getBooleanParamValue('isDeprecatedGenes') eq 'true') ? 1 :0;
  my $genomeExtDbRlsSpec = $self->getParamValue('genomeExtDbRlsSpec');
  my $soTermIdsOrNames = $self->getParamValue('soTermIdsOrNames');

  $downloadFileName =~ s/\.fasta/-deprecatedGenes.fasta/ if $deprecated;

  my (@dbnames,@dbvers);
  my ($name,$ver) = $self->getExtDbInfo($test, $genomeExtDbRlsSpec) if $genomeExtDbRlsSpec;
  push (@dbnames,$name);
  push (@dbvers,$ver);
#  ($name,$ver) = $self->getExtDbInfo($test, $self->getParamValue('genomeVirtualSeqsExtDbRlsSpec')) if $self->getParamValue('genomeVirtualSeqsExtDbRlsSpec');
  push (@dbnames,$name);
  push (@dbvers,$ver);
  my $names = join (",",map{"'$_'"} @dbnames);
  my $vers = join (",",map{"'$_'"} @dbvers);
  my $soIds =  $self->getSoIds($test, $soTermIdsOrNames) if $soTermIdsOrNames;

  my $sql = <<"EOF";
     SELECT '$organismSource'
                ||'|'||
            gf.source_id
                || decode(gf.is_deprecated, 1, ' | deprecated=true', '')
                ||' | organism='||
            replace( gf.organism, ' ', '_')
                ||' | product='||
            gf.product
                ||' | location='||
            fl.sequence_source_id
                ||':'||
            fl.start_min
                ||'-'||
            fl.end_max
                ||'('||
            decode(fl.is_reversed, 1, '-', '+')
                ||') | length='||
            snas.length
            as defline,
            snas.sequence
           FROM ApidbTuning.GeneAttributes gf,
                dots.transcript t,
                dots.splicednasequence snas,
                ApidbTuning.FeatureLocation fl,
                dots.nasequence ns
      WHERE gf.na_feature_id = t.parent_id
        AND ns.na_sequence_id = fl.na_sequence_id
        AND t.na_sequence_id = snas.na_sequence_id
        AND gf.na_feature_id = fl.na_feature_id
        AND gf.so_term_name != 'repeat_region'
        AND gf.external_db_name in ($names)
        AND gf.external_db_version in ($vers)
        AND fl.is_top_level = 1
        AND gf.is_deprecated = $deprecated
EOF

  $sql .= " and ns.sequence_ontology_id in ($soIds)" if $soIds;

  my $cmd = "gusExtractSequences --outputFile $downloadFileName  --idSQL \"$sql\" --verbose";
}

