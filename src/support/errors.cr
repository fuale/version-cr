class Error
  property message : String
  property cause : Error?

  def initialize(@message, @cause)
  end

  def initialize(@message)
  end

  def to_s(io : IO) : Nil
    io << message
    if c = cause
      io << ": "
      io << c
    end
  end
end
