class AppController < ApplicationController

  def index
  
  end
  
  def browseByModels
    @cvelt = nil
    @cvegt = nil
    @cancerSelected = ""
    @drugSelected = ""
    if (params[:cancerType] and params[:cancerType] != "Cancer Type")
      @cancerSelected = params[:cancerType]
    end
    if (params[:drug] and params[:drug] != "Drug")
      @drugSelected = params[:drug]
    end
    if (params[:cvelt] and params[:cvelt] != "")
      @cvelt = params[:cvelt]
    end
    if (params[:cvegt] and params[:cvegt] != "")
      @cvegt = params[:cvegt]
    end
    (@modelsHash,@cancers,@drugs) = Datafile.getBestModels(params)
  end
  
  def viewModel
    @models = Datafile.getModel(params[:singleModel],params[:cvModel])
    (@singleModel,@cvModel) = @models.keys[0].split(";")
  end
  
  def viewTestModel
    @drug = "Nutlin-3a"
    (@models,@histData,@modelData,@boxData,@heatmapData,@overallData,@models2) = Datafile.getModelByCancerDrug("PANCAN","Nutlin-3a")
    @singleModel = "Single Model"
    @cvModel = "CV Model"
  end
  
  def browseAllModels
    @cvelt = nil
    @cvegt = nil
    @cancerSelected = ""
    @drugSelected = ""
    if (params[:cancerType] and params[:cancerType] != "Cancer Type")
      @cancerSelected = params[:cancerType]
    end
    if (params[:drug] and params[:drug] != "Drug")
      @drugSelected = params[:drug]
    end
    if (params[:cvelt] and params[:cvelt] != "")
      @cvelt = params[:cvelt]
    end
    if (params[:cvegt] and params[:cvegt] != "")
      @cvegt = params[:cvegt]
    end
    (@res,@cancers,@drugs) = Datafile.readResTableFile(params)
  end
  
  def browseByCancerGenes
    
  end

  def showResults
    
  end

end
