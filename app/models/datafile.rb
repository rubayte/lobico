class Datafile
  
  def self
    
  end
  
  def self.readResTableFile(params)
    
    cancer = nil
    drug = nil
    cvelt = nil
    cvegt = nil
    if params[:cancerType] != "Cancer Type"
      cancer = params[:cancerType]
    end
    if params[:drug] != "Drug"
      drug = params[:drug]
    end
    if params[:cvelt] != ""
      cvelt = params[:cvelt]
    end  
    if params[:cvegt] != ""
      cvegt = params[:cvegt]
    end  

    res = Array.new()
    cancers = Hash.new()
    drugs = Hash.new()
    fileToRead = Rails.root.join('data','res.tsv')
    File.open(fileToRead,'r') do |file|
      file.each_line do |line|
        temp = line.strip.split("\t")
        cancers[temp[0]] = 1
        drugs[temp[1]] = 1
        temp.pop
        sm = temp.delete_at(6)
        temp.insert(0,sm)
        cvm = temp.delete_at(7)
        temp.insert(0,cvm)
        if (cancer == temp[2] or cancer == nil)
          if (drug == temp[3] or drug == nil)
             if (cvelt == nil or  temp[8].to_f < cvelt.to_f)
               if (cvegt == nil or cvegt.to_f < temp[8].to_f)
                temp2 = temp[0..3]
                temp2.push(temp[8])
                res.push(temp2)
               end
             end
          end
        end      
        ## end filters
      end
    end
    
    return res,cancers.keys,drugs.keys
    
  end
  
  def self.getBestModels(params)
    
    cancer = nil
    drug = nil
    drugid = nil
    dataset = nil
    cvelt = nil
    cvegt = nil
    st = nil
    if params[:cancerType] != "Cancer Type"
      cancer = params[:cancerType]
    end
    if params[:dataset] != "DataSet"
      dataset = params[:dataset]
    end
    if params[:drug] != "Drug"
      drug = params[:drug]
    end
    if params[:cvelt] != ""
      cvelt = params[:cvelt]
    end  
    if params[:cvegt] != ""
      cvegt = params[:cvegt]
    end 
    if params[:msearch] != "" or params[:msearch] != nil
      st = params[:msearch]
    end 
    if params[:drugid] != "" or params[:drugid] != nil or params[:drugid] != "NA"
      drugid = params[:drugid]
    end
       
    models = Hash.new()
    modelsST = Hash.new()
    cancers = Hash.new()
    drugs = Hash.new()
    datasets = Hash.new()
    fileToRead = Rails.root.join('data','res.tsv')
    File.open(fileToRead,'r') do |file|
      file.each_line do |line|
        temp = line.strip.split("\t")
        #if (not(temp[0].match(/^Cancer/)))
         cancers[temp[0]] = 1
         drugs[temp[1]] = 1
         datasets[temp[10]] = 1
         key = temp[6] + ";" + temp[7]
         values = temp[0] + ";" + temp[1] + ";" + temp[2] + ";" + temp[3] + ";" + temp[5] + "/" + temp[4] + ";" + temp[8] + ";" + temp[9] + ";" + temp[10] + ";" + temp[11]
         if (dataset == temp[10] or dataset == nil)
           if (cancer == temp[0] or cancer == nil)
             if (drug == temp[1] or drug == nil)
              if (drugid == temp[11] or drugid == nil)
                 if (cvelt == nil or  temp[8].to_f < cvelt.to_f)
                   if (cvegt == nil or cvegt.to_f < temp[8].to_f)
                     if(st and (st == temp[0] or st == temp[1]))
                       if (modelsST.has_key?(key))
                         modelsST[key] = modelsST[key] + "#" + values
                       else
                         modelsST[key] =  values
                       end
                     else
                       if (models.has_key?(key))
                         models[key] = models[key] + "#" + values
                       else
                         models[key] =  values
                       end
                     end
                     ## end if st    
                   end
                 end
              end
             end  
           end
         else
           ## do nothing
         end  
        #end
      end
    end
    
    if (st)
      models = modelsST
    end
    
    return models,cancers.keys,drugs.keys,datasets.keys
    
  end  
  
  def self.getModel(smodel,cvmodel)
    
    models = Hash.new()
    fileToRead = Rails.root.join('data','res.tsv')
    File.open(fileToRead,'r') do |file|
      file.each_line do |line|
        temp = line.strip.split("\t")
        if temp[6] == smodel and temp[7] == cvmodel
          key = temp[6] + ";" + temp[7]
          values = temp.join(";")
          if (models.has_key?(key))
            models[key] = models[key] + "#" + values
          else
            models[key] =  values
          end
        end
      end
    end
    
    return models
    
  end

  def self.getModelByCancerDrug(cancer,drug)
    
    ## prepare files
    histFile = cancer + "_" + drug + ".hist"
    modelsFile = cancer + "_" + drug + ".models"
    boxFile = cancer + "_" + drug + ".box"
    heatmapsFile = cancer + "_" + drug + ".heatmaps"
    overallsFile = cancer + "_" + drug + ".overalls"
    
    minR = 1000
    maxS = -1000

    models = Hash.new()
    models2 = Hash.new()
    fileToRead = Rails.root.join('data','res.tsv')
    File.open(fileToRead,'r') do |file|
      file.each_line do |line|
        temp = line.strip.split("\t")
        if temp[0] == cancer and temp[1] == drug
          key = temp[6] + ";" + temp[7]
          values = temp.join(";")
          if (models.has_key?(key))
            models[key] = models[key] + "#" + values
          else
            models[key] =  values
          end
        end
      end
    end  
    
    totalCellLines = 0
    highestPeak = 0
    histContents = ""
    File.open(Rails.root.join('data',histFile)) do |fl|
      fl.each_line do |line|
        if line !~ /^log/
          histContents = histContents + "\t" + line.strip()
          temp = line.split("\t")
          totalCellLines += temp[1].to_i
          if (temp[1].to_i > highestPeak)
            highestPeak = temp[1].to_i
          end
          if (temp[2] =~ /RES/)
            if (temp[0].to_f < minR)
              minR = temp[0].to_f
            end
          end
          if (temp[2] =~ /SEN/)
            if (temp[0].to_f > maxS)
              maxS = temp[0].to_f
            end
          end
        end
      end
    end
    histContents = histContents[1..-1]
    histData = histContents.split("\t").each_slice(3).map{|s| {logIC50: s[0].to_f, Number_of_Cell_lines: s[1], Classification: s[2]} }.to_json

    highestPredCounts = -10
    
    modelContents = ""
    File.open(Rails.root.join('data',modelsFile)) do |fl|
      fl.each_line do |line|
        if line !~ /^#/
          modelContents = modelContents + "\t" + line.strip()
          temp = line.split("\t")
          models2[temp[0]] = temp[1]
          if (temp[3].to_i > highestPredCounts)
            highestPredCounts = temp[3].to_i
          end
        end
      end
    end
    modelContents = modelContents[1..-1]
    # modelData = modelContents.split("\t").each_slice(8).map{|s| {Model: s[0], TP: s[1], FP: s[2], FN: s[3], TN: s[4], Specificity: s[5], Precision: s[6], Recall: s[7] }}.to_json
    modelData = modelContents.split("\t").each_slice(6).map{|s| {Model: s[0], MD: s[1], Count: s[2], CountValues: s[3], Stats: s[4], StatsValues: s[5]}}.to_json
    
    boxContents = ""
    modelNames = ""
    i = 0
    File.open(Rails.root.join('data',boxFile)) do |fl|
      fl.each_line do |line|
        if i == 0
          modelNames = modelNames + "\t" + line.strip()
          i = i + 1
        else  
          boxContents = boxContents + "\t" + line.strip()
        end
      end
    end
    modelNames = modelNames[1..-1]
    boxContents = boxContents[1..-1]
    boxData = boxContents.split("\t").each_slice(4).map{|s| {Model: s[0], Prediction: s[1], Cellline: s[2], logIC50: s[3].to_f}}.to_json
    #boxData = boxContents.split("\t").each_slice(16).map{|s| {Q1: s[0], Q2: s[1], Q3: s[2],Q4: s[3], Q5: s[4], Q6: s[5], Q7: s[6], Q8: s[7], Q9: s[8], Q10: s[9], Q11: s[10], Q12: s[11],Q13: s[12], Q14: s[13], Q15: s[14], Q16: s[15]}}.to_json
    modelNameData = modelNames.split("\t").each_slice(16).map{|s| {Q1: s[0], Q2: s[1], Q3: s[2],Q4: s[3], Q5: s[4], Q6: s[5], Q7: s[6], Q8: s[7], Q9: s[8], Q10: s[9], Q11: s[10], Q12: s[11],Q13: s[12], Q14: s[13], Q15: s[14], Q16: s[15]}}.to_json

    heatmapContents = ""
    File.open(Rails.root.join('data',heatmapsFile)) do |fl|
      fl.each_line do |line|
        if line !~ /^#/
          heatmapContents = heatmapContents + "\t" + line.strip()
        end
      end
    end
    heatmapContents = heatmapContents[1..-1]
    heatmapData = heatmapContents.split("\t").each_slice(5).map{|s| {Cellline: s[0], Input: s[1], Mutated?: s[2], Tissue: s[3], Origin?: s[4]}}.to_json
    
    
    overallContents = ""
    colortypeI = ""
    colortypeT = ""
    File.open(Rails.root.join('data',overallsFile)) do |fl|
      fl.each_line do |line|
        if line !~ /^#/
          overallContents = overallContents + "\t" + line.strip()
          temp = line.split("\t")
          if (temp[0] == "Input")
            if (temp[1].to_f > 0)
              colortypeI = colortypeI + "R"
            elsif (temp[1].to_f < 0)
              colortypeI = colortypeI + "G"
            else
              colortypeI = colortypeI + "W"
            end
          else
            if (temp[1].to_f > 0)
              colortypeT = colortypeT + "R"
            elsif (temp[1].to_f < 0)
              colortypeT = colortypeT + "G"
            else
              colortypeT = colortypeT + "W"
            end
          end    
        end
      end
    end
    overallContents = overallContents[1..-1]
    overallData = overallContents.split("\t").each_slice(7).map{|s| {Param: s[0], OddsRatio: s[1], InputType: s[2], xSR: s[3], SR: s[4], OM: s[5], Count: s[6]}}.to_json

    
    diff = minR - maxS
    cutoffIc50 = maxS + (diff/2)
    
    return models,histData,modelData,boxData,heatmapData,overallData,models2,modelNameData,totalCellLines,highestPredCounts,cutoffIc50,colortypeT,colortypeI,highestPeak+1
    
  end

end