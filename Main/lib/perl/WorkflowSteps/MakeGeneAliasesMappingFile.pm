package ApiCommonWorkflow::Main::WorkflowSteps::MakeGeneAliasesMappingFile;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test, $undo) = @_;

  my $outputFile = $self->getParamValue('outputFile');
  my $genomeExtDbRlsSpec = $self->getParamValue('genomeExtDbRlsSpec');
  my $apiSiteFilesDir = $self->getSharedConfig('apiSiteFilesDir');

  my $cmd = "getGeneAliases --extDbSpec '$genomeExtDbRlsSpec' --outfile $apiSiteFilesDir/$outputFile";

  if ($undo) {
    $self->runCmd(0, "rm -f $apiSiteFilesDir/$outputFile");
  } else {
      if ($test) {
	  $self->runCmd(0,"echo test > $apiSiteFilesDir/$outputFile");
      }else{
	  $self->runCmd($test,$cmd);
      }
  }
}

sub getParamsDeclaration {
  return (
          'outputFile',
          'genomeExtDbRlsSpec',
         );
}

sub getConfigDeclaration {
  return (
         # [name, default, description]
         # ['', '', ''],
         );
}


