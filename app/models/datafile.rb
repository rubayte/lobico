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


end