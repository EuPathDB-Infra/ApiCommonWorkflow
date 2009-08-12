package ApiCommonData::Load::WorkflowSteps::SampleSteps;

@ISA = (ApiCommonData::Load::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonData::Load::WorkflowSteps::WorkflowStep;

TEMPLATE
sub run {
  my ($self, $test, $undo) = @_;

  # get parameters

  # get global properties
  my $ = $self->getGlobalConfig('');

  # get step properties
  my $ = $self->getConfig('');

  if ($test) {
  } else {
  }

  if ($undo){
  }else{
   $self->runPlugin($test, '', $args);
  }


}

sub getParamsDeclaration {
  return (
         );
}

sub getConfigDeclaration {
  return (
         # [name, default, description]
         # ['', '', ''],
         );
}

