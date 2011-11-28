package ApiCommonWorkflow::Main::WorkflowSteps::InsertSimpleRadAnalysisFromConfig;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $analysisWorkingDir = $self->getParamValue('inputDir');

  my $configFile = $self->getParamValue('configFile');

  my $analysisResultView =  $self->getParamValue('analysisResultView');

  my $naFeatureView =  $self->getParamValue('naFeatureView');

  my $useSqlLdr =  $self->getParamValue('useSqlLdr');

#  my $profileSetNames =  $self->getParamValue('profileSetNames'); # see redmine issue 4257
  my $profileSetNames =  "";

  my $workflowDataDir = $self->getWorkflowDataDir();
      
  my $args = "--inputDir '$workflowDataDir/$analysisWorkingDir' --configFile '$workflowDataDir/$configFile' --analysisResultView $analysisResultView  --naFeatureView $naFeatureView";

  $args.=" --useSqlLdr" if($useSqlLdr eq "true"); 

  if ($test) {
    $self->testInputFile('inputDir', "$workflowDataDir/$analysisWorkingDir");
    $self->testInputFile('configFile', "$workflowDataDir/$configFile");
  }

  $self->runPlugin($test, $undo, "ApiCommonData::Load::Plugin::InsertAnalysisResult", $args);

}

sub getParamDeclaration {
  return (
	  'analysisWorkingDir',
	  'analysisResultView',
	  'naFeatureView',
	  'useSqlLdr',
	 );
}

sub getConfigDeclaration {
  return (
	  # [name, default, description]
	 );
}

