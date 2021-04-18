library(oro.nifti)

# load ALE file
ALE <- oro.nifti::readNIfTI('speech_brainmap_ALE.nii')
ALE.img <- oro.nifti::img_data(ALE)

# load thresholded file
THRES <- oro.nifti::readNIfTI('speech_brainmap_C01_1k_ALE.nii')
THRES.img <- oro.nifti::img_data(THRES)

# mask (zeros -> no data)
mask <- ALE.img != 0
mask[mask==0]<-NA

# how many voxels to be considered?
voxels <- sum(!is.na(mask))

# calculate standard deviation
SD <- sd(mask*ALE.img,na.rm = T)

# calculate the mean signal strength in significant voxels
THRES.0 <- mask*THRES.img
mean.1 <- mean(ALE.img[THRES.0!=0],na.rm=T)
# calculate the mean signal strength in non-significant voxels
mean.0 <- mean(ALE.img[THRES.0==0],na.rm=T)

# calculate ratio
R <- sum(THRES.0 !=0, na.rm=T)/voxels

# calculate mean contrast
C <- mean.1-mean.0

# calculate factor
F <- C/SD*R

# print results
print(sprintf('ratio = %f',R))
print(sprintf('contrast = %f',C))
print(sprintf('noise in SD = %f',SD))
print(sprintf('X = %f',F))
