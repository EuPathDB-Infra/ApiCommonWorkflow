package ApiCommonWorkflow::Main::WorkflowSteps::InsertFastaSubset;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $extDbRlsSpec = $self->getParamValue('extDbRlsSpec');
  my $fastaFile = $self->getParamValue('fastaFile');
  my $idsFile = $self->getParamValue('idsFile');

  my ($extDbName,$extDbRlsVer) = $self->getExtDbInfo($test,$extDbRlsSpec);

  my $localDataDir = $self->getLocalDataDir();

  my $args = "--externalDatabaseName $extDbName --externalDatabaseVersion $extDbRlsVer --sequenceFile $localDataDir/$fastaFile --sourceIdsFile  $localDataDir/$idsFile --regexSourceId  '>gi\\|(\\d+)\\|' --regexDesc '^>(gi\\|\\d+\\|\\w+\\|\\w+\\.?\\w+\\|)' --regexNcbiTaxId '\\|(\\d+)\\|\$' --tableName DoTS::ExternalAASequence";

  if ($test) {
    $self->testInputFile('fastaFile', "$localDataDir/$fastaFile");
    $self->testInputFile('idsFile', "$localDataDir/$idsFile");
  }

  $self->runPlugin($test,$undo, "GUS::Supported::Plugin::LoadFastaSequences",$args);

}

sub getParamDeclaration {
  return (
	  'idsFile',
	  'extDbRlsSpec',
	  'fastaFile',
	 );
}


sub getConfigDeclaration {
  return ();
}


