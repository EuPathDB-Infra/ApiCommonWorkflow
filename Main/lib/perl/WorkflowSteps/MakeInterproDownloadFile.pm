package ApiCommonWorkflow::Main::WorkflowSteps::MakeInterproDownloadFile;

@ISA = (ApiCommonWorkflow::Main::Util::DownloadFileMaker);
use strict;
use ApiCommonWorkflow::Main::Util::DownloadFileMaker;


sub getDownloadFileCmd {
    my ($self, $downloadFileName, $test) = @_;

  my $genomeDbRlsId = $self->getExtDbRlsId($test,$self->getParamValue('genomeExtDbRlsSpec'));
  my $interproDbRlsId = $self->getExtDbRlsId($test,$self->getParamValue('interproExtDbRlsSpec'));
  my $soIds =  $self->getSoIds($test, $self->getParamValue('soTermIdsOrNames')) if $self->getParamValue('soTermIdsOrNames');

  my $sql = <<"EOF";
  SELECT gf.source_id
           || chr(9) ||
         xd1.name
           || chr(9) ||
         dr.primary_identifier
           || chr(9) ||
         dr.secondary_identifier
           || chr(9) ||
         al.start_min
           || chr(9) ||
         al.end_min
           || chr(9) ||
         to_char(df.e_value,'9.9EEEE')
  FROM
    dots.aalocation al,
    sres.dbref dr,
    dots.DbRefAAFeature draf, 
    dots.domainfeature df, 
    dots.genefeature gf,
    dots.transcript t, 
    dots.translatedaafeature taf,
    dots.translatedaasequence tas,
    sres.externaldatabase xd1,
    sres.externaldatabaserelease xdr1,
    dots.nasequence ns,
    apidb.featurelocation fl
  WHERE
   gf.external_database_release_id = $genomeDbRlsId
     AND gf.na_feature_id = t.parent_id 
     AND gf.na_feature_id = fl.na_feature_id
     AND fl.na_sequence_id = ns.na_sequence_id
     AND t.na_feature_id = taf.na_feature_id 
     AND taf.aa_sequence_id = tas.aa_sequence_id 
     AND tas.aa_sequence_id = df.aa_sequence_id 
     AND df.aa_feature_id = draf.aa_feature_id  
     AND draf.db_ref_id = dr.db_ref_id 
     AND df.aa_feature_id = al.aa_feature_id 
     AND df.external_database_release_id =  $interproDbRlsId
     AND xdr1.external_database_id = xd1.external_database_id 
     AND xdr1.external_database_release_id =  $interproDbRlsId
EOF

    $sql .= " and ns.sequence_ontology_id in ($soIds)" if $soIds;
    my $cmd = " makeFileWithSql --outFile $downloadFileName --sql \"$sql\" ";
    return $cmd;
}


