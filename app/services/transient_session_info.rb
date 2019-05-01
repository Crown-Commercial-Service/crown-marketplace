class TransientSessionInfo
  @tsi = TransientSessionInfo.new

  class << self
    attr_reader :tsi
  end

  def initialize
    @dict = {}
  end

  def [](key1, key2 = nil)
    return @dict[key1] if key2.nil?
    return nil unless @dict[key1]

    @dict[key1][key2]
  end

  def []=(key1, key2, value)
    @dict ||= {}
    @dict[key1] ||= {}
    @dict[key1][key2] = value
  end
end
