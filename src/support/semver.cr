struct SemVer
  include Comparable(self)

  property major : Int32
  property minor : Int32
  property patch : Int32

  def initialize(@major, @minor, @patch)
  end

  def self.from_s(s : String) : (self | Error)
    return Error.new("Must Start with `v`") unless s = s.lchop? 'v'

    parts = s.split('.')

    return Error.new("Must be exactly 3 parts") if parts.size != 3

    new(parts[0].to_i, parts[1].to_i, parts[2].to_i)
  end

  def <=>(other : self)
    [self.major, self.minor, self.patch] <=> [other.major, other.minor, other.patch]
  end

  def to_s(io : IO) : Nil
    io << "v"
    io << self.major
    io << "."
    io << self.minor
    io << "."
    io << self.patch
  end

  enum Bump
    Major
    Minor
    Patch
  end

  def bump(b : Bump)
    case b
    when .major?
      self.class.new(self.major + 1, 0, 0)
    when .minor?
      self.class.new(self.major, self.minor + 1, 0)
    when .patch?
      self.class.new(self.major, self.minor, self.patch + 1)
    end
  end
end
