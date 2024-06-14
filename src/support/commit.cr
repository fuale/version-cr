require "./errors"

COMMIT_TYPES = {
  "fix"      => "Fixes",
  "feat"     => "Features",
  "refactor" => "Refactors",
  "perf"     => "Performance",
  "test"     => "Tests",
  "doc"      => "Docs",
  "docs"     => "Docs",
  "style"    => "Styles",
  "chore"    => "Chores",
  "ci"       => "Continuous Integration",
  "build"    => "Build",
}

class CommitNotValidError < Error
  def initialize
    super("Not a valid commit")
  end
end

struct Commit
  property hash : String
  property type : String
  property scope : String?
  property subject : String
  getter pretty_type : String
  getter breaking : Bool

  def initialize(@hash, @type, @scope, @subject, @breaking)
    @pretty_type = COMMIT_TYPES[@type]? || @type
  end

  def self.from_s(h : String, s : String) : (self | Error)
    return CommitNotValidError.new unless s.includes? ':'

    m = /(\w+)(!)?(?:\((\w+)\))?(?::\s(.*))?/i.match(s)

    return CommitNotValidError.new if m.nil?

    case {type = m[1]?, scope = m[3]?, subject = m[4]?}
    when {String, String, String}
      new h, type, scope, subject, m[2]? ? true : false
    when {String, Nil, String}
      new h, type, nil, subject, m[2]? ? true : false
    else
      CommitNotValidError.new
    end
  end

  def summary
    "#{scope}: #{subject}"
  end
end
