package ApiCommonWorkflow::Main::WorkflowSteps::MakeAssemblySeqs;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $organismAbbrev = $self->getParamValue('organismAbbrev');
  my $useTaxonHierarchy = $self->getParamValue('useTaxonHierarchy');
#  my $predictedTranscriptsExtDbRlsSpec = $self->getParamValue('predictedTranscriptsExtDbRlsSpec');
  my $predictedTranscriptsExtDbRlsSpec = "FIX THIS see redmine #4306"

  my $vectorFile = $self->getConfig('vectorFile');
  my $phrapDir = $self->getConfig('phrapDir');

  my $taxonId = $self->getOrganismInfo($test, $organismAbbrev)->getSpeciesTaxonId();
  my $taxonIdList = $self->getTaxonIdList($test, $taxonId, $useTaxonHierarchy);

  my $args = "--taxon_id_list '$taxonIdList' --repeatFile $vectorFile --phrapDir $phrapDir";

  if($predictedTranscriptsExtDbRlsSpec){
      
      my ($extDbName, $extDbVer) = $self->getExtDbInfo($test,$predictedTranscriptsExtDbRlsSpec);

      my $sql = "SELECT e.na_sequence_id 
               from dots.ExternalNASequence e, sres.sequenceontology s,
                    sres.externalDatabase d, sres.externalDatabaseRelease r
              where e.taxon_id in($taxonIdList)
                and e.external_database_release_id = r.external_database_release_id
                and r.external_database_id = d.external_database_id
                and r.version = '$extDbVer'
                and d.name ='$extDbName'
                and s.term_name IN ('transcript')
                and e.sequence_ontology_id = s.sequence_ontology_id
                and e.na_sequence_id not in
                    (select a.na_sequence_id from dots.AssemblySequence a)";

      $args .= " --idSQL \"$sql\"";

}


  $self->runPlugin($test, $undo, "DoTS::DotsBuild::Plugin::MakeAssemblySequences", $args);

}

sub getConfigDeclaration {
  return (
	  # [name, default, description]
	  ['vectorFile', "", ""],
	  ['phrapDir', "", ""],
	 );
}


