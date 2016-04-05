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
       
    models = Hash.new()
    cancers = Hash.new()
    drugs = Hash.new()
    fileToRead = Rails.root.join('data','res.tsv')
    File.open(fileToRead,'r') do |file|
      file.each_line do |line|
        temp = line.strip.split("\t")
        #if (not(temp[0].match(/^Cancer/)))
         cancers[temp[0]] = 1
         drugs[temp[1]] = 1
         key = temp[6] + ";" + temp[7]
         values = temp[0] + ";" + temp[1] + ";" + temp[2] + ";" + temp[3] + ";" + temp[5] + "/" + temp[4] + ";" + temp[8]
         if (cancer == temp[0] or cancer == nil)
           if (drug == temp[1] or drug == nil)
             if (cvelt == nil or  temp[8].to_f < cvelt.to_f)
               if (cvegt == nil or cvegt.to_f < temp[8].to_f)
                 if (models.has_key?(key))
                   models[key] = models[key] + "#" + values
                 else
                   models[key] =  values
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
    
    return models,cancers.keys,drugs.keys
    
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
    
    histContents = ""
    File.open(Rails.root.join('data','Nutlin-3a.hist')) do |fl|
      fl.each_line do |line|
        if line !~ /^log/
          histContents = histContents + "\t" + line.strip()
        end
      end
    end
    histContents = histContents[1..-1]
    histData = histContents.split("\t").each_slice(3).map{|s| {logIC50: s[0], Number_of_Cell_lines: s[1], Classification: s[2]} }.to_json

    modelContents = ""
    File.open(Rails.root.join('data','outfile.models')) do |fl|
      fl.each_line do |line|
        if line !~ /^#/
          modelContents = modelContents + "\t" + line.strip()
          temp = line.split("\t")
          models2[temp[0]] = temp[1]
        end
      end
    end
    modelContents = modelContents[1..-1]
    # modelData = modelContents.split("\t").each_slice(8).map{|s| {Model: s[0], TP: s[1], FP: s[2], FN: s[3], TN: s[4], Specificity: s[5], Precision: s[6], Recall: s[7] }}.to_json
    modelData = modelContents.split("\t").each_slice(6).map{|s| {Model: s[0], MD: s[1], Count: s[2], CountValues: s[3], Stats: s[4], StatsValues: s[5]}}.to_json
    
    boxContents = ""
    File.open(Rails.root.join('data','outfile.box')) do |fl|
      fl.each_line do |line|
        if line !~ /^#/
          boxContents = boxContents + "\t" + line.strip()
        end
      end
    end
    boxContents = boxContents[1..-1]
    boxData = boxContents.split("\t").each_slice(3).map{|s| {Model: s[0], Q1: s[1], Q2: s[2]}}.to_json
    
    heatmapContents = ""
    File.open(Rails.root.join('data','Nutlin-3a.heatmaps')) do |fl|
      fl.each_line do |line|
        if line !~ /^#/
          heatmapContents = heatmapContents + "\t" + line.strip()
        end
      end
    end
    heatmapContents = heatmapContents[1..-1]
    heatmapData = heatmapContents.split("\t").each_slice(5).map{|s| {Cellline: s[0], Input: s[1], Mutated?: s[2], Tissue: s[3], Origin?: s[4]}}.to_json
    
    
    overallContents = ""
    File.open(Rails.root.join('data','Nutlin-3a.overalls')) do |fl|
      fl.each_line do |line|
        if line !~ /^#/
          overallContents = overallContents + "\t" + line.strip()
        end
      end
    end
    overallContents = overallContents[1..-1]
    overallData = overallContents.split("\t").each_slice(6).map{|s| {Param: s[0], OddsRatio: s[1], InputType: s[2], SR: s[3], OM: s[4], Count: s[5]}}.to_json

    
    return models,histData,modelData,boxData,heatmapData,overallData,models2
    
  end

end