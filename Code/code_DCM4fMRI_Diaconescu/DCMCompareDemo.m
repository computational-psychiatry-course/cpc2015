Generate2RegionDCM_4Comp;


cd('/Users/drea/Documents/TNU_Courses/CPCourse_2015/');
DCM.Y.y=Y.yData;

DCMInput=DCM;
DCMInput.a=[1 0;1 1];
DCMInput.b=zeros(2,2,2);
DCMInput.c=[1 0;0 0];
DCM=spm_dcm_estimate(DCMInput);
save DCMnomod DCM;

% DCMInput.c=[1 0;0 1];
% DCM=spm_dcm_estimate(DCMInput);
% save DCMmodc22 DCM;

DCMInput.c=[1 0;0 0];
DCMInput.b(2,1,2)=1;
DCM=spm_dcm_estimate(DCMInput);
save DCMmodb21 DCM;

DCMInput.c=[1 0;0 0];
DCMInput.b(2,1,2)=0;
DCMInput.b(2,2,2)=1;
DCM=spm_dcm_estimate(DCMInput);
save DCMmodb22 DCM;

% load batch for comparison
load compareBatch
spm_jobman('interactive',matlabbatch);