package ApiCommonData::Load::WorkflowSteps::CreateExtDbAndDbRls;

@ISA = (ApiCommonData::Load::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonData::Load::WorkflowSteps::WorkflowStep;

sub run {
    my ($self, $test, $undo) = @_;

    # get parameters
    my $syntenyExtDbRlsSpec = $self->getParamValue('syntenyExtDbRlsSpec');
    my ($extDbName,$extDbRlsVer) = $self->getExtDbInfo($test,$syntenyExtDbRlsSpec);

    my $dbPluginArgs = "--name '$extDbName' ";
    
    $self->runPlugin($test, 0, "GUS::Supported::Plugin::InsertExternalDatabase", $dbPluginArgs);

    my $releasePluginArgs = "--databaseName '$extDbName' --databaseVersion '$extDbRlsVer'";

    $self->runPlugin($test, 0, "GUS::Supported::Plugin::InsertExternalDatabaseRls", $releasePluginArgs);
}


sub getParamsDeclaration {
    return (
            'syntenyExtDbRlsSpec'
           );
}

sub getConfigDeclaration {
    return (
           # [name, default, description]
           );
}



