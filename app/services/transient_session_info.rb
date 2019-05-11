class TransientSessionInfo
  # @tsi = TransientSessionInfo.new
  @dict = {}

  class << self
    attr_reader :dict

    def self.initialize
      @dict = {}
    end
  end

  def self.[](key1, key2 = nil)
    return @dict[key1] if key2.nil?
    return nil unless @dict[key1]

    @dict[key1][key2]
  end

  def self.[]=(key1, key2=nil, value)
    @dict ||= {}
    @dict[key1] ||= {}
    if key2
      @dict[key1][key2] = value
    else
      @dict[key1] = value
    end
  end
end
