package ApiCommonWorkflow::Main::WorkflowSteps::runMercatorMavid;

@ISA = (ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonWorkflow::Main::WorkflowSteps::WorkflowStep;

TEMPLATE
sub run {
  my ($self, $test) = @_;

  # get parameters
  my $outputDir = $self->getParamValue('outputDir');

  # get global properties
  my $ = $self->getSharedConfig('');

  # get step properties
  my $ = $self->getConfig('');

  my $workflowDataDir = $self->getWorkflowDataDir();

  if ($test) {
  } else {
  }

  $self->runPlugin($test, '', $args);

}

sub getParamsDeclaration {
  return (
          'outputDir',
         );
}

sub getConfigDeclaration {
  return (
         # [name, default, description]
         # ['', '', ''],
         );
}

sub restart {
}

sub undo {

}

sub getDocumentation {
}
