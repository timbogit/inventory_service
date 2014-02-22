class Presenter
  delegate :to_json, :to => :hash

  attr_accessor :hash, :version

  def initialize(thing)
    @hash = to_hash(thing)
    @version = self.class.version_number
  end

  def to_hash(thing = nil)
    raise "needs to be implemented in subclass"
  end

  def self.version_number
    name.split('::')[-2][1..-1].to_i rescue 0
  end
end