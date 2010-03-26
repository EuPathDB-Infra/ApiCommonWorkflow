package ApiCommonWorkflow::Main::WorkflowSteps::SnpMummerToGff;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  # get parameters
  my $inputFile = $self->getParamValue('inputFile');
  my $gffFile = $self->getParamValue('gffFile');
  my $outputFile = $self->getParamValue('outputFile');
  my $strain = $self->getParamValue('strain');

  my $workflowDataDir = $self->getWorkflowDataDir();

  my $cmd = "snpFastaMUMmerGff --gff_file $workflowDataDir/$gffFile --mummer_file $workflowDataDir/$inputFile --output_file $workflowDataDir/$outputFile --reference_strain $strain --gff_format gff2 --skip_multiple_matches --error_log step.err";


  if ($undo) {
    $self->runCmd(0, "rm -f $workflowDataDir/$outputFile");
  } else {
      if ($test) {
	  $self->testInputFile('inputFile', "$workflowDataDir/$inputFile");
	  $self->testInputFile('gffFile', "$workflowDataDir/$gffFile");
	  $self->runCmd(0, "echo test > $workflowDataDir/$outputFile");
      }else{
	  $self->runCmd($test, $cmd);
      }
  }

}

sub getParamsDeclaration {
  return (
          'inputFile',
          'gffFile',
          'outputFile',
          'strain',
         );
}

sub getConfigDeclaration {
  return (
         # [name, default, description]
         # ['', '', ''],
         );
}


