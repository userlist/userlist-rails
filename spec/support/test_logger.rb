class TestLogger < Logger
  def initialize
    super(io)
    self.level = :debug
  end

  def messages
    io.string
  end

private

  def io
    @io ||= StringIO.new
  end
end
