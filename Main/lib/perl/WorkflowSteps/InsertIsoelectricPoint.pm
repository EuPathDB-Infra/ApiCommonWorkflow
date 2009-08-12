package ApiCommonData::Load::WorkflowSteps::InsertIsoelectricPoint;

@ISA = (ApiCommonData::Load::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonData::Load::WorkflowSteps::WorkflowStep;


sub run {
  my ($self, $test) = @_;

  my $extDbRlsSpec = $self->getParamValue('genomeExtDbRlsSpec');
  my $table = $self->getParamValue('table');

  my ($extDbName, $extDbRlsVer) = $self->getExtDbInfo($test,$extDbRlsSpec);

  my $args = "--extDbRlsName '$extDbName' --extDbRlsVer '$extDbRlsVer' --seqTable $table";

  $self->runPlugin($test,0, "ApiCommonData::Load::Plugin::CalculateAASequenceIsoelectricPoint",$args);

}

sub getParamsDeclaration {
  return (
     'genomeExtDbRlsSpec',
     'table',
    );
}

sub getConfigDeclaration {
  return (
	  # [name, default, description]
	 );
}


