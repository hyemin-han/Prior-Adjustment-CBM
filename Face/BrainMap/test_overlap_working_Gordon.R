library(oro.nifti)
library(imager)
library(reticulate)

# calculate overlap index
calc_overlap<-function(original, target){
  # same size?
  if (sum(dim(original)==dim(target))<3){
    # different. error!
    return(-1)
  }
  # calculate overlap index
  V_overlap<-0
  V_original<-0
  V_target<-0
  img_size<-dim(original)
  # loop
  for (x in 1:img_size[1]){
    for (y in 1:img_size[2]){
      for (z in 1:img_size[3]){
        # na?
        if (is.na(original[x,y,z])){
          next
        }
        if (is.na(target[x,y,z])){
          next
        }

        # original
        if (original[x,y,z]>0){
          V_original<-V_original+1
        }
        # target
        if (target[x,y,z]>0){
          V_target<-V_target+1
        }
        #overlap
        if ( (original[x,y,z]*target[x,y,z]>0)){
          V_overlap<-V_overlap+1
        }
      }
    }
  }
  return(c(V_overlap*V_overlap/V_original/V_target/(V_overlap/V_original+V_overlap/V_target),
           V_overlap,V_original,V_target))
}

# python module for conversion


# HCP related files should be converted
reticulate::source_python('convert_nii_one.py')
convert_nii('./Gordon/face_gordon_fwe.nii')
convert_nii('./face_association-test_z_FDR_0.01.nii')
convert_nii('./face_neuroquery.nii')
convert_nii('./face_brainmap_C01_1k_ALE.nii')
convert_nii('./Gordon/BFs_80.nii')
convert_nii('./Gordon/BFs_85.nii')
convert_nii('./Gordon/BFs_90.nii')
convert_nii('./Gordon/BFs_95.nii')
#convert_nii('./Bayes_meta.hdr')
convert_nii('./Gordon/Bayes_707.nii')

# compare bayesmeta and all
bayes_adjusted<-img_data(readNIfTI('./Gordon/transformed_BFs_90.nii'))>=3
bayes_707 <-img_data(readNIfTI('./Gordon/transformed_Bayes_707.nii'))>=3
fwe<-img_data(readNIfTI('./Gordon/transformed_face_gordon_fwe.nii'))
#bayes_meta<-img_data(readNIfTI('./transformed_Bayes_meta.hdr'))

# neurosynth
neurosynth<-img_data(readNIfTI('./transformed_face_association-test_z_FDR_0.01.nii'))
neurosynth[abs(neurosynth)<1e-4]<-0
result_neurosynth<-as.matrix(c(
  calc_overlap(neurosynth,bayes_adjusted)[1],
  calc_overlap(neurosynth,bayes_707)[1],
  calc_overlap(neurosynth,fwe)[1]
))
# brainmap
brainmap<-drop(img_data(readNIfTI('./transformed_face_brainmap_C01_1k_ALE.nii')))
brainmap[abs(brainmap)<1e-4]<-0
result_brainmap<-as.matrix(c(
  calc_overlap(brainmap,bayes_adjusted)[1],
  calc_overlap(brainmap,bayes_707)[1],
  calc_overlap(brainmap,fwe)[1]
))
# neuroquery
# needs size up -> do rescale
neuroquery<-img_data(readNIfTI('./transformed_face_neuroquery.nii'))
neuroquery[abs(neuroquery)<1e-4]<-0
#neuroquery<-ifelse(neuroquery==0,NA,neuroquery)
result_neuroquery<-as.matrix(c(
  calc_overlap(neuroquery>=3,bayes_adjusted)[1],
  calc_overlap(neuroquery>=3,bayes_707)[1],
  calc_overlap(neuroquery>=3,fwe)[1]
))
# merge
result90<-data.frame(result_neurosynth,result_brainmap,result_neuroquery)
rownames(result90)<-c('bayes_adjusted_90','bayes_707','fwe')
colnames(result90)<-c('neurosynth','brainmap','neuroquery')


# compare bayesmeta and all 80%
bayes_adjusted<-img_data(readNIfTI('./Gordon/transformed_BFs_80.nii'))>=3

# neurosynth
result_neurosynth<-as.matrix(c(
  calc_overlap(neurosynth,bayes_adjusted)[1]
))
# brainmap
result_brainmap<-as.matrix(c(
  calc_overlap(brainmap,bayes_adjusted)[1]
))
# neuroquery
# needs size up -> do rescale
neuroquery<-ifelse(neuroquery==0,NA,neuroquery)
result_neuroquery<-as.matrix(c(
  calc_overlap(neuroquery>=3,bayes_adjusted)[1]
))
# merge
result80<-data.frame(result_neurosynth,result_brainmap,result_neuroquery)
rownames(result80)<-c('bayes_adjusted_80')
colnames(result80)<-c('neurosynth','brainmap','neuroquery')



# compare bayesmeta and all 85%
bayes_adjusted<-img_data(readNIfTI('./Gordon/transformed_BFs_85.nii'))>=3

# neurosynth
result_neurosynth<-as.matrix(c(
  calc_overlap(neurosynth,bayes_adjusted)[1]
))
# brainmap
result_brainmap<-as.matrix(c(
  calc_overlap(brainmap,bayes_adjusted)[1]
))
# neuroquery
# needs size up -> do rescale
result_neuroquery<-as.matrix(c(
  calc_overlap(neuroquery>=3,bayes_adjusted)[1]
))
# merge
result85<-data.frame(result_neurosynth,result_brainmap,result_neuroquery)
rownames(result85)<-c('bayes_adjusted_85')
colnames(result85)<-c('neurosynth','brainmap','neuroquery')


# compare bayesmeta and all 95%
bayes_adjusted<-img_data(readNIfTI('./Gordon/transformed_BFs_95.nii'))>=3

# neurosynth
result_neurosynth<-as.matrix(c(
  calc_overlap(neurosynth,bayes_adjusted)[1]
))
# brainmap
result_brainmap<-as.matrix(c(
  calc_overlap(brainmap,bayes_adjusted)[1]
))
# neuroquery
# needs size up -> do rescale
result_neuroquery<-as.matrix(c(
  calc_overlap(neuroquery>=3,bayes_adjusted)[1]
))
# merge
result95<-data.frame(result_neurosynth,result_brainmap,result_neuroquery)
rownames(result95)<-c('bayes_adjusted_95')
colnames(result95)<-c('neurosynth','brainmap','neuroquery')

results<-rbind(result80,result85,result90,result95)


write.csv(results,'face_BrainMap_Gordon.csv')

# wide to long
library(reshape2)
long_results<-results
long_results$method<-rownames(long_results)
long_results<-melt(long_results,id.vars=c('method'),
                   variable.name = 'template',value.name='index')
long_results$data<-'face_Gordon'
long_results$origin<-'BrainMap'
write.csv(long_results,'long_face_BrainMap_Gordon.csv')