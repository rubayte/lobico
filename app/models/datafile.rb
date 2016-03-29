class Datafile
  
  def self
    
  end
  
  def self.readResTableFile()
    
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
        temp.insert(1,cvm)
        res.push(temp)
      end
    end
    
    return res,cancers,drugs
    
  end
  
  def self.getBestModels()
    
    models = Hash.new()
    cancers = Hash.new()
    drugs = Hash.new()
    fileToRead = Rails.root.join('data','res.tsv')
    File.open(fileToRead,'r') do |file|
      file.each_line do |line|
        temp = line.strip.split("\t")
        cancers[temp[0]] = 1
        drugs[temp[1]] = 1
        key = temp[6] + ";" + temp[7]
        values = temp[0] + ";" + temp[1] + ";" + temp[2] + ";" + temp[3] + ";" + temp[5] + "/" + temp[4] + ";" + temp[8]
        if (models.has_key?(key))
          models[key] = models[key] + "#" + values
        else
          models[key] =  values
        end
      end
    end
    
    return models,cancers,drugs
    
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
    File.open(Rails.root.join('data','Nutlin-3aIN.hist')) do |fl|
      fl.each_line do |line|
        if line !~ /^log/
          histContents = histContents + "\t" + line.strip()
        end
      end
    end
    histContents = histContents[1..-1]
    histData = histContents.split("\t").each_slice(3).map{|s| {logIC50: s[0], Number_of_Cell_lines: s[1], Classification: s[2]} }.to_json

    modelContents = ""
    File.open(Rails.root.join('data','Nutlin-3aIN.models2.tsv')) do |fl|
      fl.each_line do |line|
        if line !~ /^#/
          modelContents = modelContents + "\t" + line.strip()
        end
      end
    end
    modelContents = modelContents[1..-1]
    # modelData = modelContents.split("\t").each_slice(8).map{|s| {Model: s[0], TP: s[1], FP: s[2], FN: s[3], TN: s[4], Specificity: s[5], Precision: s[6], Recall: s[7] }}.to_json
    modelData = modelContents.split("\t").each_slice(7).map{|s| {Model: s[0], Param: s[1], Value: s[2], Param2: s[3], Value2: s[4], Param3: s[5], Value3: s[6]}}.to_json
    
    boxContents = ""
    File.open(Rails.root.join('data','morley.csv')) do |fl|
      fl.each_line do |line|
        if line !~ /^#/
          boxContents = boxContents + "," + line.strip()
        end
      end
    end
    boxContents = boxContents[1..-1]
    boxData = boxContents.split(",").each_slice(3).map{|s| {Expt: s[0], Run: s[1], Speed: s[2]}}.to_json
    
    mutContents = ""
    File.open(Rails.root.join('data','Nutlin-3a.mut')) do |fl|
      fl.each_line do |line|
        if line !~ /^#/
          mutContents = mutContents + "\t" + line.strip()
        end
      end
    end
    mutContents = mutContents[1..-1]
    mutData = mutContents.split("\t").each_slice(3).map{|s| {Cellline: s[0], Input: s[1], Score: s[2]}}.to_json

    tissueContents = ""
    File.open(Rails.root.join('data','Nutlin-3a.tissue')) do |fl|
      fl.each_line do |line|
        if line !~ /^#/
          tissueContents = tissueContents + "\t" + line.strip()
        end
      end
    end
    tissueContents = tissueContents[1..-1]
    tusData = tissueContents.split("\t").each_slice(3).map{|s| {Cellline: s[0], Tissue: s[1], Score: s[2]}}.to_json

    tissueOContents = ""
    File.open(Rails.root.join('data','Nutlin-3a.tissue.overall')) do |fl|
      fl.each_line do |line|
        if line !~ /^#/
          tissueOContents = tissueOContents + "\t" + line.strip()
        end
      end
    end
    tissueOContents = tissueOContents[1..-1]
    #tusOData = tissueOContents.split("\t").each_slice(5).map{|s| {Tissue: s[0], TotalCelllines: s[1], Score: s[2], SensitiveCelllines: s[3], TScore: s[4]}}.to_json
    tusOData = tissueOContents.split("\t").each_slice(4).map{|s| {Param: s[0], Tissue: s[1], TypeCelllines: s[2], Score: s[3]}}.to_json

    mutOContents = ""
    File.open(Rails.root.join('data','Nutlin-3a.mut.overall')) do |fl|
      fl.each_line do |line|
        if line !~ /^#/
          mutOContents = mutOContents + "\t" + line.strip()
        end
      end
    end
    mutOContents = mutOContents[1..-1]
    mutOData = mutOContents.split("\t").each_slice(4).map{|s| {Param: s[0], Input: s[1], CountType: s[2], Count: s[3]}}.to_json
    
    return models,histData,modelData,boxData,mutData,tusData,tusOData,mutOData
    
  end

end