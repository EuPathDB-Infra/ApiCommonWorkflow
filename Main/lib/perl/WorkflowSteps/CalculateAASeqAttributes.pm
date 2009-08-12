package ApiCommonData::Load::WorkflowSteps::CalculateAASeqAttributes;

@ISA = (ApiCommonData::Load::WorkflowSteps::WorkflowStep);

use strict;
use ApiCommonData::Load::WorkflowSteps::WorkflowStep;



sub run {
  my ($self, $test,$undo) = @_;

  my $extDbRlsSpec = $self->getParamValue('genomeExtDbRlsSpec');
  my $table = $self->getParamValue('table');
  my $idSql = $self->getParamValue('idSql');

  my ($extDbName, $extDbRlsVer) = $self->getExtDbInfo($test,$extDbRlsSpec);

  my $args = "--extDbRlsName '$extDbName' --extDbRlsVer '$extDbRlsVer' --seqTable $table";

  $args .= " --idSql \"$idSql\"" if $idSql;

  $self->runPlugin($test,$undo, "ApiCommonData::Load::Plugin::CalculateAASeqAttributes",$args);

}

sub getParamsDeclaration {
  return (
	  'genomeExtDbRlsSpec',
	  'table',
	 );
}

sub getConfigDeclaration {
  return (
	 );
}
