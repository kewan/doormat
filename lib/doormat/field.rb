module Doormat
  class Field

    attr_accessor :to
    
    VALID_TYPES = {
      :string  => :to_s,
      :integer => :to_i,
      :float   => :to_f
    }

    def initialize(to, from, type=:string, default='', &conversion)
      @to = to.to_s
      @from = from
      @type = type
      @default = default
      @conversion = conversion  
    end

    def map(data)
      
      if(data.has_key? @from)
        return convert_value(data[@from])
      else
        return @default;
      end

    end

    private

      def convert_value(raw_value)

        if(@conversion)
          return @conversion.call(raw_value)
        end

        value = raw_value.to_s
        if VALID_TYPES.has_key?(@type)
          value.send(VALID_TYPES[@type])
        end
      end
    
  end
end