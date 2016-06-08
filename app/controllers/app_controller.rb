class AppController < ApplicationController

  def index
    (@modelsHash,canlist,druglist) = Datafile.getBestModels(params)
    @cancers = canlist.to_json
    @drugs = druglist.to_json
  end
  
  def indexCancerJson
    (@modelsHash,@cancers,@drugs) = Datafile.getBestModels(params)
    render json: @cancers
  end
  
  def indexDrugsJson
    (@modelsHash,@cancers,@drugs) = Datafile.getBestModels(params)
    render json: @drugs
  end


  def browseByModels
    @searchTerm = nil
    @cvelt = nil
    @cvegt = nil
    @cancerSelected = ""
    @drugSelected = ""
    if (params[:msearch] and params[:msearch] != "")
      @searchTerm = params[:msearch]
    end
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
  
  def viewTestlot
    @totalCelllines = "836"
    @drug = "Nutlin-3a"
    @cancer = "PANCAN"
    (@models,@histData,@modelData,@boxData,@heatmapData,@overallData,@models2,@mnData) = Datafile.getModelByCancerDrug(params[:cancer],params[:drug])
    @singleModel = "Single Model"
    @cvModel = "CV Model"
  end
  
  def viewTestModel
    @drug = "Nutlin-3a"
    (@models,@histData,@modelData,@boxData,@heatmapData,@overallData,@models2) = Datafile.getModelByCancerDrug("PANCAN","Nutlin-3a")
    @singleModel = "Single Model"
    @cvModel = "CV Model"
  end

  def viewTestModel2
    @totalCelllines = "836"
    @drug = params[:drug]#"Nutlin-3a"
    @cancer = params[:cancer]
    (@models,@histData,@modelData,@boxData,@heatmapData,@overallData,@models2,@mnData) = Datafile.getModelByCancerDrug(params[:cancer],params[:drug])
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
