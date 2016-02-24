class AppController < ApplicationController

  def index
  
  end
  
  def browseByModels
    (@modelsHash,@cancers,@drugs) = Datafile.getBestModels()
  end
  
  def viewModel
    @models = Datafile.getModel(params[:singleModel],params[:cvModel])
    (@singleModel,@cvModel) = @models.keys[0].split(";")
  end
  
  def browseAllModels
    (@res,@cancers,@drugs) = Datafile.readResTableFile()
  end
  
  def browseByCancerGenes
    
  end

  def showResults
    
  end

end
