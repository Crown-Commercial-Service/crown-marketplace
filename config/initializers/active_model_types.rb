module Type
  class ArrayType < ActiveModel::Type::Value
    def type
      :array
    end

    def cast(value)
      Array.wrap(value)
    end
  end

  class NumericType < ActiveModel::Type::Value
    def type
      :numeric
    end

    def cast(value)
      return value if value.is_a?(Numeric)

      return nil if value.blank?

      begin
        if value.to_s.include?('.')
          Float(value)
        else
          Integer(value, 10)
        end
      rescue ArgumentError, TypeError
        nil
      end
    end
  end
end

ActiveModel::Type.register(:array, Type::ArrayType)
ActiveModel::Type.register(:numeric, Type::NumericType)
