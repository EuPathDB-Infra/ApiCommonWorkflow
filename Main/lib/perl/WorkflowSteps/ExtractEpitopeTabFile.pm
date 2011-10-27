package ApiCommonWorkflow::Main::WorkflowSteps::ExtractEpitopeTabFile;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  my $outputFile = $self->getParamValue('outputFile');
  my $organismAbbrev = $self->getParamValue('organismAbbrev');

  my $speciesTaxonId = $self->getOrganismInfo($test, $organismAbbrev)->getSpeciesTaxonId();

  my $taxonIdList = $self->getOrganismInfo($test, $organismAbbrev)->getTaxonIdList($speciesTaxonId);

  my $workflowDataDir = $self->getWorkflowDataDir();

  if ($undo) {
    $self->runCmd(0, "rm -rf $workflowDataDir/$outputFile");
  } else {
    if ($test) {
      $self->runCmd(0,"echo test > $workflowDataDir/$outputFile");
    }
    $self->runCmd($test,"extractEpitopesTabFile $workflowDataDir/$outputFile $taxonIdList");
  }
}

sub getConfigDeclaration {
  return (
	  # [name, default, description]
	 );
}

