package ApiCommonData::Load::WorkflowSteps::MakeInterproTaskInputDir;

@ISA = (ApiCommonData::Load::WorkflowSteps::WorkflowStep);
use strict;
use ApiCommonData::Load::WorkflowSteps::WorkflowStep;

sub run {
  my ($self, $test, $undo) = @_;

  # get parameters
  my $taskInputDir = $self->getParamValue('taskInputDir');
  my $proteinsFile = $self->getParamValue('proteinsFile');

  # get global properties
  my $email = $self->getGlobalConfig('email');

  # get properties
  my $taskSize = $self->getConfig('taskSize');
  my $applications = $self->getConfig('applications');

  my $computeClusterDataDir = $self->getComputeClusterDataDir();
  my $localDataDir = $self->getLocalDataDir();

  if ($undo) {
    $self->runCmd(0,"rm -rf $localDataDir/$taskInputDir");
  }else {
      if ($test) {
	  $self->testInputFile('proteinsFile', "$localDataDir/$proteinsFile");
      }
      
      $self->runCmd(0,"mkdir -p $localDataDir/$taskInputDir");
      # make controller.prop file
      $self->makeClusterControllerPropFile($taskInputDir, 2, $taskSize,
				       "DJob::DistribJobTasks::IprscanTask");
      # make task.prop file
      my $taskPropFile = "$localDataDir/$taskInputDir/task.prop";
      open(F, ">$taskPropFile") || die "Can't open task prop file '$taskPropFile' for writing";
      print F
"seqfile=$computeClusterDataDir/$proteinsFile
outputfile=iprscan_out.xml
seqtype=p
appl=$applications
email=$email
crc=false
";

       #&runCmd($test, "chmod -R g+w $localDataDir/similarity/$queryName-$subjectName");
  }
}

sub getParamsDeclaration {
  return (
          'taskInputDir',
          'proteinsFile',
         );
}

sub getConfigDeclaration {
  return (
         # [name, default, description]
         # ['', '', ''],
         );
}


