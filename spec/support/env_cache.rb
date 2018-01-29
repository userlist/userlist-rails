class ENVCache
  class << self
    def start!
      cache.store!
      cache.clear_env!
    end

    def stop!
      cache.clear_env!
      cache.restore!
      cache.reset!
    end

  private

    def cache
      @cache ||= new
    end
  end

  def initialize(pattern = /^USERLIST_/)
    @pattern = pattern
    reset!
  end

  def reset!
    @cache = {}
  end

  def clear_env!
    ENV.keys.grep(pattern).each { |key| ENV.delete(key) }
  end

  def store!
    @cache = ENV.keys.grep(pattern).each_with_object({}) do |key, cache|
      cache[key] = ENV[key]
    end
  end

  def restore!
    @cache.each_pair do |key, value|
      ENV[key] = value
    end
  end

private

  attr_reader :pattern
end
